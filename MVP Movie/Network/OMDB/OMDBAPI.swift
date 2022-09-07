//
//  OMDBAPI.swift
//  MVP Movie
//
//  Created by Dan-George Apostu on 01.09.2022.
//

import Foundation
import BackgroundTasks

class OMDBAPI: OMDBStore {

    private var previousDataTask: URLSessionDataTask?

    func search(title: String) async throws -> [MovieEntity] {
        previousDataTask?.cancel()
        return try await withCheckedThrowingContinuation({ (continuation: CheckedContinuation<[MovieEntity], Error>) in
            let searchString = title.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed)
            let queryParams = [OMDB.QueryKey.titleSearch.rawValue: searchString!]
            previousDataTask = OMDBNetworkManager.shared.dataTask(queryParams: queryParams) { result in
                continuation.resume(with: result)
            }
        })
    }

    func detailsFor(imdbID: String) async throws -> MovieEntity {
        previousDataTask?.cancel()
        return try await withCheckedThrowingContinuation({ (continuation: CheckedContinuation<MovieEntity, Error>) in
            let queryParams = [OMDB.QueryKey.titleID.rawValue: imdbID]
            previousDataTask = OMDBNetworkManager.shared.dataTask(queryParams: queryParams) { result in
                let mappedResult = result.map { $0.first! }
                continuation.resume(with: mappedResult)
            }
        })
    }
}
