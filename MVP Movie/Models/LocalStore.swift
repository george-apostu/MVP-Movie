//
//  LocalStore.swift
//  MVP Movie
//
//  Created by Dan-George Apostu on 01.09.2022.
//

import Foundation
import RealmSwift

protocol LocalStore {
    func getRealmMovie(movie: MovieEntity) -> MovieEntity
    func addRecent(movie: MovieEntity)
    func getPopular() -> Results<MovieEntity>
    func getRecents() -> Results<MovieEntity>
    func getFavorites() -> Results<MovieEntity>
    func addFavorite(movie: MovieEntity)
    func updatePopular(movies: [MovieEntity])
    func removeFavorite(movie: MovieEntity)
    func clearAll()
}
