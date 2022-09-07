//
//  IMDBAPI.swift
//  MVP Movie
//
//  Created by Dan-George Apostu on 07.09.2022.
//

import Foundation

class IMDBAPI: IMDBStore {
    func popularMovies() async throws -> [MovieEntity] {
        return try await withCheckedThrowingContinuation({ (continuation: CheckedContinuation<[MovieEntity], Error>) in
            IMDBNetworkManager.shared.dataTask { result in
                continuation.resume(with: result)
            }
        })
    }
}
