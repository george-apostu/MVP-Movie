//
//  MovieViewModel.swift
//  MVP Movie
//
//  Created by Dan-George Apostu on 07.09.2022.
//

import Foundation
import Combine

class MovieViewModel {

    // MARK: Public Properties

    @Published var isLoading = false
    var title: String {
        movie.title
    }

    // MARK: Private Properties

    private(set) var movie: MovieEntity
    private var omdbStore: OMDBStore
    private var localStore: LocalStore

    // MARK: - Initializers

    init(movie: MovieEntity, localStore: LocalStore, omdbStore: OMDBStore) {
        self.movie = movie
        self.localStore = localStore
        self.omdbStore = omdbStore
    }

    // MARK: - Public Method(s)

    @MainActor
    func fetchDetails() async {
        do {
            isLoading = true
            let remoteMovie = try await omdbStore.detailsFor(imdbID: movie.imdbID)
            remoteMovie.isFavorite = movie.isFavorite
            remoteMovie.isRecent = movie.isRecent
            remoteMovie.dateViewed = movie.dateViewed
            remoteMovie.isPopular = movie.isPopular
            movie = localStore.getRealmMovie(movie: remoteMovie)
            isLoading = false
        } catch {
            print(error)
        }
    }

    func toggleFavorite() {
        if movie.isFavorite {
            localStore.removeFavorite(movie: movie)
        } else {
            localStore.addFavorite(movie: movie)
        }
        movie.realm?.refresh()
        isLoading = false

    }
}
