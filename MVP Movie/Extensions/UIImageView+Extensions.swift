//
//  UIImageView+Extensions.swift
//  MVP Movie
//
//  Created by Dan-George Apostu on 06.09.2022.
//

import UIKit

enum ImageError: Error {
    case badURL
    case badImage
}

extension UIImageView {

    func download(from urlString: String,
                  contentMode mode: UIView.ContentMode = .scaleAspectFill,
                  placeholder: UIImage? = UIImage(systemName: "photo")) async throws {
        await MainActor.run {
            contentMode = .scaleAspectFit
            image = placeholder
        }

        guard let url = URL(string: urlString) else {
            throw ImageError.badURL
        }

        let (data, _) = try await URLSession.shared.data(for: URLRequest(url: url))
        guard let image = UIImage(data: data) else {
            throw ImageError.badImage
        }

        await MainActor.run {
            self.image = image
        }
    }

}
