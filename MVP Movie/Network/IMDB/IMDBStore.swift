//
//  IMDBStore.swift
//  MVP Movie
//
//  Created by Dan-George Apostu on 07.09.2022.
//

import Foundation

protocol IMDBStore {
    func popularMovies() async throws -> [MovieEntity]
}
