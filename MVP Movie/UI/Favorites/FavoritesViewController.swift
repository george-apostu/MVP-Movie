//
//  FavoritesViewController.swift
//  MVP Movie
//
//  Created by Dan-George Apostu on 06.09.2022.
//

import Foundation
import UIKit
import RealmSwift

class FavoritesViewController: UITableViewController {

    // MARK: - Private Properties

    private var viewModel: FavoritesViewModel?
    private var notificationToken: NotificationToken?

    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.rightBarButtonItem = editButtonItem
        configureTableView()

        do {
            viewModel = FavoritesViewModel(localStore: LocalAPI(realm: try Realm()))
        } catch {
            print(error)
        }

        configureBindings()
    }

    // MARK: - UITableView

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel?.numberOfRows ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let movie = viewModel?.movie(at: indexPath),
                let cell = tableView.dequeueReusableCell(withIdentifier: "MovieTableViewCell", for: indexPath) as? MovieTableViewCell else {
            return UITableViewCell()
        }

        cell.config(with: movie)
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let movie = viewModel?.movie(at: indexPath),
              let localStore = viewModel?.localStore,
              let movieViewController: MovieViewController = UIStoryboard.instantiateViewController() else {
            return
        }

        movieViewController.viewModel = MovieViewModel(movie: movie, localStore: localStore, omdbStore: OMDBAPI())
        present(movieViewController, animated: true)
    }

    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        .delete
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete,
              let movie = viewModel?.movie(at: indexPath) else {
            return
        }

        viewModel?.localStore.removeFavorite(movie: movie)
    }

    // MARK: - Private Methods

    private func configureTableView() {
        tableView.register(UINib(nibName: "MovieTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "MovieTableViewCell")
    }

    private func configureBindings() {
        notificationToken = viewModel?.results.observe { [weak self] (changes: RealmCollectionChange) in
            guard let tableView = self?.tableView else { return }
            switch changes {
            case .initial:
                // Results are now populated and can be accessed without blocking the UI
                tableView.reloadData()
            case .update(_, let deletions, let insertions, let modifications):
                // Query results have changed, so apply them to the UITableView
                tableView.performBatchUpdates({
                    // Always apply updates in the following order: deletions, insertions, then modifications.
                    // Handling insertions before deletions may result in unexpected behavior.
                    tableView.deleteRows(at: deletions.map({ IndexPath(row: $0, section: 0)}),
                                         with: .automatic)
                    tableView.insertRows(at: insertions.map({ IndexPath(row: $0, section: 0) }),
                                         with: .automatic)
                    tableView.reloadRows(at: modifications.map({ IndexPath(row: $0, section: 0) }),
                                         with: .automatic)
                }, completion: { _ in
                    // ...
                })
            case .error(let error):
                // An error occurred while opening the Realm file on the background worker thread
                fatalError("\(error)")
            }
        }
    }

}
