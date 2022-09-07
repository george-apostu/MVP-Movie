//
//  OMDB.swift
//  MVP Movie
//
//  Created by Dan-George Apostu on 06.09.2022.
//

import Foundation

struct OMDB {
    // swiftlint:disable:next force_cast
    static let apiKey: String = Bundle.main.object(forInfoDictionaryKey: "OMDB_API_KEY") as! String
    // swiftlint:disable:next force_cast
    static let baseURLString: String = Bundle.main.object(forInfoDictionaryKey: "OMDB_BASE_URL") as! String

    enum QueryKey: String {
        case apiKey
        case titleID = "i"
        case titleSearch = "s"
    }

    enum ResponseKey: String {
        case root = "Search"
        case response = "Response"
        case error = "Error"
    }

    enum MovieKey: String {
        case title = "Title"
        case year = "Year"
        case imdbID
        case type = "Type"
        case poster = "Poster"
        case released = "Released"
        case plot = "Plot"
        case imdbRating
        case actors = "Actors"
        case genre = "Genre"
        case writer = "Writer"
        case director = "Director"
        case runtime = "Runtime"
        case country = "Country"
        case awards = "Awards"
    }
}
