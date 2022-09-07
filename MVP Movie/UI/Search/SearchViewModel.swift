//
//  SearchViewModel.swift
//  MVP Movie
//
//  Created by Dan-George Apostu on 06.09.2022.
//

import Foundation
import RealmSwift

@MainActor
class SearchViewModel {

    // MARK: - Private Properties

    private(set) var imdbStore: IMDBStore
    private(set) var localStore: LocalStore
    private(set) var results: Results<MovieEntity>

    // MARK: - Initializer(s)

    init(localStore: LocalStore, imdbStore: IMDBStore) {
        self.localStore = localStore
        self.imdbStore = imdbStore
        self.results = localStore.getPopular()
        self.updatePopularMoviesIfNeeded()
    }

    // MARK: - Public Properties

    var numberOfRows: Int {
        results.count
    }

    // MARK: - Public Method(s

    func movie(at indexPath: IndexPath) -> MovieEntity? {
        guard indexPath.row < results.count else {
            return nil
        }
        return results[indexPath.row]
    }

    // MARK: - Private Method(s)

    private func updatePopularMoviesIfNeeded() {
        let lastFetched = (UserDefaults.standard.value(forKey: UserDefaultKeys.lastFetchedPopularMovies) as? Date) ?? Date()
        if lastFetched.timeIntervalSinceNow < -604800 {
            Task {
                do {
                    let popularMovies = try await imdbStore.popularMovies()
                    localStore.updatePopular(movies: popularMovies)
                    UserDefaults.standard.setValue(Date(), forKey: UserDefaultKeys.lastFetchedPopularMovies)
                    UserDefaults.standard.synchronize()
                } catch {
                    print(error)
                }
            }
        }
    }

}
