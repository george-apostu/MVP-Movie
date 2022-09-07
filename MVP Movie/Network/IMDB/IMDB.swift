//
//  IMDB.swift
//  MVP Movie
//
//  Created by Dan-George Apostu on 07.09.2022.
//

import Foundation

struct IMDB {
    // swiftlint:disable:next force_cast
    static let baseURLString: String = Bundle.main.object(forInfoDictionaryKey: "IMDB_BASE_URL") as! String

    enum ResponseKey: String {
        case root = "items"
        case error = "errorMessage"
    }

    enum MovieKey: String {
        case imdbID = "id"
        case title
        case year
        case poster = "image"
        case imdbRating = "imDbRating"
        case rank
    }
}
