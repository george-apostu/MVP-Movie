//
//  MovieViewController.swift
//  MVP Movie
//
//  Created by Dan-George Apostu on 06.09.2022.
//

import UIKit
import RealmSwift
import Combine

class MovieViewController: UIViewController {

    // MARK: - IBOutlet(s)

    @IBOutlet private weak var addToFavoriteButton: UIButton!
    @IBOutlet private weak var posterImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var genreLabel: UILabel!
    @IBOutlet private weak var typeLabel: UILabel!
    @IBOutlet private weak var releasedLabel: UILabel!
    @IBOutlet private weak var ratingLabel: UILabel!
    @IBOutlet private weak var headlineStackView: UIStackView!
    @IBOutlet private weak var plotStackView: UIStackView!
    @IBOutlet private weak var plotLabel: UILabel!
    @IBOutlet private weak var actorsLabel: UILabel!
    @IBOutlet private weak var writerLabel: UILabel!
    @IBOutlet private weak var directorLabel: UILabel!
    @IBOutlet private weak var runtimeLabel: UILabel!
    @IBOutlet private weak var countryLabel: UILabel!
    @IBOutlet private weak var awardsLabel: UILabel!

    // MARK: - Private Properties

    private var bag = Set<AnyCancellable>()

    // MARK: - Public Properties

    var viewModel: MovieViewModel?

    // MARK: - IBAction(s)

    @IBAction private func addToFavorite(_ sender: UIButton) {
        viewModel?.toggleFavorite()
    }

    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        Task {
            await self.viewModel?.fetchDetails()
        }

        updateMainUI()
        configureBindings()
    }

    // MARK: - Private Methods

    private func updateMainUI() {
        if let urlString = viewModel?.movie.poster {
            Task {
                do {
                    try await posterImageView.download(from: urlString)
                } catch {
                    print(error)
                }
            }
        }
        titleLabel.text = viewModel?.movie.title
    }

    private func updateUI() {
        guard let movie = viewModel?.movie else {
            return
        }
        genreLabel.text = movie.genre
        typeLabel.text = movie.type.description
        releasedLabel.text = movie.released
        ratingLabel.text = "⭐️ \(movie.imdbRating ?? "")"

        plotLabel.text = movie.plot

        actorsLabel.text = movie.actors
        writerLabel.text = movie.writer
        directorLabel.text = movie.director
        runtimeLabel.text = movie.runtime
        countryLabel.text = movie.country
        awardsLabel.text = movie.awards
        addToFavoriteButton.configuration?.image = UIImage(systemName: movie.isFavorite ? "star.fill" : "star")
    }

    private func configureBindings() {
        viewModel?.$isLoading
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in self?.updateUI() }
            .store(in: &bag)
    }
}
