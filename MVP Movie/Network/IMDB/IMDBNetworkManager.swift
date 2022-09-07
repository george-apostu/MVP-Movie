//
//  IMDBNetworkManager.swift
//  MVP Movie
//
//  Created by Dan-George Apostu on 07.09.2022.
//

import Foundation
import SwiftyJSON

struct IMDBNetworkManager {

    // MARK: - Static Properties

    static let shared = IMDBNetworkManager()

    // MARK: - Private Properties

    private(set) var baseURLString: String

    // MARK: - Init

    init(baseURLString: String = IMDB.baseURLString) {
        self.baseURLString = baseURLString
    }

    // MARK: - Public method(s)

    @discardableResult
    func dataTask(completion: @escaping MovieNetworkCompletion) -> URLSessionDataTask {
        var urlComponents = URLComponents(string: baseURLString)!
        urlComponents.scheme = "https"

        var request = URLRequest(url: urlComponents.url!)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = HTTPMethod.get.rawValue

        let sessionTask = URLSession(configuration: .default).dataTask(with: request) { (data, urlResponse, error) in
            guard let urlResponse = urlResponse as? HTTPURLResponse, urlResponse.statusCode == 200, let data = data else {
                completion(.failure(.unknown("Network Error")))
                return
            }

            do {
                let json = try JSON(data: data)

                let errorMessage = json[IMDB.ResponseKey.error.rawValue].stringValue
                guard errorMessage.isEmpty else {
                    completion(.failure(.api(errorMessage)))
                    return
                }

                let results: [MovieEntity]
                if let responseMovies = json[IMDB.ResponseKey.root.rawValue].array {
                    results = responseMovies.map { MovieEntity(imdbJson: $0) }
                } else {
                    results = [MovieEntity(imdbJson: json)]
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
