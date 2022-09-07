//
//  FavoritesViewModel.swift
//  MVP Movie
//
//  Created by Dan-George Apostu on 07.09.2022.
//

import Foundation
import RealmSwift

class FavoritesViewModel {

    // MARK: - Public Properties

    var results: Results<MovieEntity>
    var numberOfRows: Int {
        results.count
    }

    // MARK: - Private Properties

    private(set) var localStore: LocalStore

    // MARK: - Initializer(s)

    init(localStore: LocalStore) {
        self.localStore = localStore
        results = localStore.getFavorites()
    }

    // MARK: - Public Method(s)

    func movie(at indexPath: IndexPath) -> MovieEntity? {
        guard indexPath.row < results.count else {
            return nil
        }
        return results[indexPath.row]
    }

}
