//
//  OMDBNetworkManager.swift
//  MVP Movie
//
//  Created by Dan-George Apostu on 01.09.2022.
//

import Foundation
import SwiftyJSON

struct OMDBNetworkManager {

    // MARK: - Static Properties

    static let shared = OMDBNetworkManager()

    // MARK: - Private Properties

    private(set) var baseURLString: String

    // MARK: - Init

    init(baseURLString: String = OMDB.baseURLString) {
        self.baseURLString = baseURLString
    }

    // MARK: - Public method(s)

    @discardableResult
    func dataTask(method: HTTPMethod = .get,
                  queryParams: [String: String] = [:],
                  completion: @escaping MovieNetworkCompletion) -> URLSessionDataTask {
        var queryParams = queryParams
        queryParams[OMDB.QueryKey.apiKey.rawValue] = OMDB.apiKey

        return requestResource(method: method,
                               queryParams: queryParams,
                               completion: completion)
    }

    // MARK: - Private method(s)

    private func requestResource(method: HTTPMethod,
                                 queryParams: [String: String],
                                 completion: @escaping MovieNetworkCompletion) -> URLSessionDataTask {
        var urlComponents = URLComponents(string: baseURLString)!
        urlComponents.scheme = "https"
        urlComponents.queryItems = queryParams.map { URLQueryItem(name: $0.key, value: $0.value) }

        var request = URLRequest(url: urlComponents.url!)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = method.rawValue

        let sessionTask = URLSession(configuration: .default).dataTask(with: request) { (data, urlResponse, error) in
            guard let urlResponse = urlResponse as? HTTPURLResponse, urlResponse.statusCode == 200, let data = data else {
                completion(.failure(.unknown("Network Error")))
                return
            }

            do {
                let json = try JSON(data: data)

                guard json[OMDB.ResponseKey.response.rawValue].boolValue else {
                    let apiErrorMessage = json[OMDB.ResponseKey.error.rawValue].string ?? "API Error"
                    if apiErrorMessage == "Movie not found!" {
                        completion(.failure(.notFound(apiErrorMessage)))
                    } else {
                        completion(.failure(.api(apiErrorMessage)))
                    }
                    return
                }

                let results: [MovieEntity]
                if let responseMovies = json[OMDB.ResponseKey.root.rawValue].array {
                    results = responseMovies.map { MovieEntity(json: $0) }
                } else {
                    results = [MovieEntity(json: json)]
                }

                completion(.success(results))
            } catch {
                completion(.failure(.unknown(error.localizedDescription)))
            }
        }

        sessionTask.resume()
        return sessionTask
    }
}
