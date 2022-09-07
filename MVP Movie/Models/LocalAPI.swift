//
//  LocalAPI.swift
//  MVP Movie
//
//  Created by Dan-George Apostu on 01.09.2022.
//

import Foundation
import RealmSwift

class LocalAPI: LocalStore {
    var realm: Realm

    func getRealmMovie(movie: MovieEntity) -> MovieEntity {
        do {
            try realm.write {
                realm.add(movie, update: .all)
            }
            return movie
        } catch {
            print(error)
        }
        return movie
    }

    func addRecent(movie: MovieEntity) {
        update(movie: movie, isRecent: true)
    }

    func getRecents() -> Results<MovieEntity> {
        return realm
            .objects(MovieEntity.self)
            .where { $0.isRecent == true }
            .sorted(by: \.dateViewed, ascending: false)
    }

    func getFavorites() -> Results<MovieEntity> {
        return realm
            .objects(MovieEntity.self)
            .where { $0.isFavorite == true }
    }

    func getPopular() -> Results<MovieEntity> {
        return realm
            .objects(MovieEntity.self)
            .where { $0.isPopular == true }
            .sorted(by: \.rank)
    }

    func addFavorite(movie: MovieEntity) {
        update(movie: movie, isFavorite: true)
    }

    func updatePopular(movies: [MovieEntity]) {
        do {
            let oldPopular = getPopular()
            try realm.write {
                realm.delete(oldPopular)
                realm.add(movies)
            }
        } catch {
            print(error)
        }
    }

    func removeFavorite(movie: MovieEntity) {
        update(movie: movie, isFavorite: false)
    }

    func clearAll() {
        do {
            let allMovies = realm.objects(MovieEntity.self)
            try realm.write {
                realm.delete(allMovies)
            }
        } catch {
            print(error)
        }
    }

    init(realm: Realm) {
        self.realm = realm
    }

    private func update(movie: MovieEntity, isFavorite: Bool? = nil, isRecent: Bool? = nil) {
        let objExists = realm.object(ofType: MovieEntity.self, forPrimaryKey: movie.imdbID) != nil
        do {
            try realm.write {
                if let isFavorite = isFavorite {
                    movie.isFavorite = isFavorite
                }
                if let isRecent = isRecent {
                    movie.isRecent = isRecent
                    movie.dateViewed = Date()
                }
                if !objExists {
                    self.realm.add(movie)
                }
            }
        } catch {
            print(error)
        }
    }
}
