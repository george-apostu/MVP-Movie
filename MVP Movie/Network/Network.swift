//
//  Network.swift
//  MVP Movie
//
//  Created by Dan-George Apostu on 07.09.2022.
//

import Foundation

enum HTTPMethod: String {
    case get
    case post
}

enum NetworkError: LocalizedError {
    case unknown(String)
    case api(String)
    case notFound(String)

    var errorDescription: String? {
        switch self {
        case .unknown(let message):
            return message
        case .api(let message):
            return message
        case .notFound(let message):
            return message
        }
    }
}

typealias MovieNetworkCompletion = (Result<[MovieEntity], NetworkError>) -> Void
