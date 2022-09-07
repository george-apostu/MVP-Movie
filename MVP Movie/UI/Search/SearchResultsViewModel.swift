//
//  SearchResultsViewModel.swift
//  MVP Movie
//
//  Created by Dan-George Apostu on 07.09.2022.
//

import Foundation
import RealmSwift
import Combine

@MainActor
class SearchResultsViewModel {

    // MARK: - Private Properties

    private(set) var omdbStore: OMDBStore
    private(set) var localStore: LocalStore
    private var results: [MovieEntity] = []
    private var recents: Results<MovieEntity>

    // MARK: - Public Properties

    var isShowingRecents: Bool = false

    @Published var errorMessage: String = ""
    @Published var isLoading: Bool = false

    var numberOfRows: Int {
        isShowingRecents ? recents.count : results.count
    }

    // MARK: - Initializers

    init(localStore: LocalStore, omdbStore: OMDBStore) {
        self.localStore = localStore
        self.omdbStore = omdbStore
        self.recents = localStore.getRecents()
    }

    // MARK: - Public Methods

    func search(title: String) async {
        do {
            errorMessage = ""
            self.results = try await omdbStore.search(title: title)
            filterResultsIfNeeded()
        } catch {
            self.results = []
            errorMessage = error.localizedDescription
        }
    }

    func movie(at indexPath: IndexPath) -> MovieEntity? {
        if isShowingRecents {
            guard indexPath.row < recents.count else {
                return nil
            }
            return recents[indexPath.row]
        }

        guard indexPath.row < results.count else {
            return nil
        }
        return results[indexPath.row]
    }

    // MARK: - Private Methods

    private func filterResultsIfNeeded() {
        guard UserDefaults.standard.bool(forKey: UserDefaultKeys.hideFavorites) else {
            return
        }
        let favorites = localStore.getFavorites().map { $0.imdbID }
        results = results.filter { !favorites.contains($0.imdbID) }
    }

}
