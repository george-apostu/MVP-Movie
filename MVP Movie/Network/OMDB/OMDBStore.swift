//
//  OMDBStore.swift
//  MVP Movie
//
//  Created by Dan-George Apostu on 01.09.2022.
//

import Foundation

protocol OMDBStore {
    func search(title: String) async throws -> [MovieEntity]
    func detailsFor(imdbID: String) async throws -> MovieEntity
}
