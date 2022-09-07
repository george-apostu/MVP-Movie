//
//  MovieTableViewCell.swift
//  MVP Movie
//
//  Created by Dan-George Apostu on 06.09.2022.
//

import UIKit
import BackgroundTasks

class MovieTableViewCell: UITableViewCell {

    // MARK: - Private Properties

    private var task: Task<(), Never>?

    // MARK: - IBOutlet(s)

    @IBOutlet private weak var posterImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var typeLabel: UILabel!
    @IBOutlet private weak var lengthLabel: UILabel!
    @IBOutlet private weak var ratingLabel: UILabel!
    @IBOutlet private weak var yearLabel: UILabel!
    @IBOutlet private weak var isFavoriteImageView: UIImageView!

    // MARK: - Initializer(s)

    override func prepareForReuse() {
        super.prepareForReuse()
        task?.cancel()
        posterImageView.image = UIImage(systemName: "photo")
        titleLabel.text = ""
        typeLabel.text = ""
        lengthLabel.text = ""
        lengthLabel.isHidden = false
        ratingLabel.text = ""
        ratingLabel.isHidden = false
        yearLabel.text = ""
        yearLabel.isHidden = false
        isFavoriteImageView.isHidden = true
    }

    // MARK: - Config

    func config(with movie: MovieEntity) {
        if let urlString = movie.poster {
            task = Task.detached(priority: .background, operation: {
                do {
                    try await self.posterImageView.download(from: urlString)
                } catch {
                    print(error)
                }
            })

        }
        titleLabel.text = movie.title
        typeLabel.text = movie.type.description
        lengthLabel.text = movie.runtime
        lengthLabel.isHidden = (movie.runtime ?? "").isEmpty
        if let rating = movie.imdbRating {
            ratingLabel.text = "⭐️ \(rating)"
            ratingLabel.isHidden = false
        }
        yearLabel.text = movie.year
        yearLabel.isHidden = (movie.year ?? "").isEmpty
        isFavoriteImageView.isHidden = !movie.isFavorite
    }

}
