//
//  MovieEntity.swift
//  MVP Movie
//
//  Created by Dan-George Apostu on 01.09.2022.
//

import Foundation
import SwiftyJSON
import RealmSwift

enum MovieType: StringLiteralType, CustomStringConvertible, Equatable, PersistableEnum {
    case movie
    case series
    case episode

    var description: String {
        rawValue.capitalized
    }
}

class MovieEntity: Object {
    @Persisted var isFavorite: Bool = false
    @Persisted var isRecent: Bool = false
    @Persisted var isPopular: Bool = false
    @Persisted var dateViewed: Date?

    @Persisted var title: String
    @Persisted(primaryKey: true) var imdbID: String
    @Persisted var type: MovieType

    @Persisted var year: String?
    @Persisted var poster: String?
    @Persisted var genre: String?
    @Persisted var released: String?
    @Persisted var imdbRating: String?
    @Persisted var plot: String?
    @Persisted var actors: String?
    @Persisted var writer: String?
    @Persisted var director: String?
    @Persisted var runtime: String?
    @Persisted var country: String?
    @Persisted var awards: String?
    @Persisted var rank: Int = 0

    // MARK: - Initializer(s)

    convenience init(json: JSON) {
        self.init()
        self.title = json[OMDB.MovieKey.title.rawValue].stringValue
        self.imdbID = json[OMDB.MovieKey.imdbID.rawValue].stringValue
        self.type = MovieType(rawValue: json[OMDB.MovieKey.type.rawValue].stringValue) ?? .movie
        self.year = json[OMDB.MovieKey.year.rawValue].stringValue.optioNAl
        self.poster = json[OMDB.MovieKey.poster.rawValue].stringValue.optioNAl
        self.genre = json[OMDB.MovieKey.year.rawValue].stringValue.optioNAl
        self.released = json[OMDB.MovieKey.released.rawValue].stringValue.optioNAl
        self.imdbRating = json[OMDB.MovieKey.imdbRating.rawValue].stringValue.optioNAl
        self.plot = json[OMDB.MovieKey.plot.rawValue].stringValue.optioNAl
        self.actors = json[OMDB.MovieKey.actors.rawValue].stringValue.optioNAl
        self.writer = json[OMDB.MovieKey.writer.rawValue].stringValue.optioNAl
        self.director = json[OMDB.MovieKey.director.rawValue].stringValue.optioNAl
        self.runtime = json[OMDB.MovieKey.runtime.rawValue].stringValue.optioNAl
        self.country = json[OMDB.MovieKey.country.rawValue].stringValue.optioNAl
        self.awards = json[OMDB.MovieKey.awards.rawValue].stringValue.optioNAl
    }

    convenience init(imdbJson json: JSON) {
        self.init()
        self.imdbID = json[IMDB.MovieKey.imdbID.rawValue].stringValue
        self.title = json[IMDB.MovieKey.title.rawValue].stringValue
        self.year = json[IMDB.MovieKey.year.rawValue].string
        self.poster = json[IMDB.MovieKey.poster.rawValue].string
        self.imdbRating = json[IMDB.MovieKey.imdbRating.rawValue].string
        self.rank = json[IMDB.MovieKey.rank.rawValue].intValue
        self.isPopular = true
    }
}

private extension String {
    var optioNAl: String? {
        self == "N/A" ? nil : self
    }
}
