//
//  SearchViewController.swift
//  MVP Movie
//
//  Created by Dan-George Apostu on 01.09.2022.
//

import UIKit
import RealmSwift

class SearchViewController: UITableViewController {

    // MARK: - Private Properties

    private var viewModel: SearchViewModel?
    private var notificationToken: NotificationToken?

    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        configureTableView()
        configureSearchResults()
        configureBindings()
    }

    // MARK: - Private Method(s)

    private func configureTableView() {
        tableView.register(UINib(nibName: "MovieTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "MovieTableViewCell")
    }

    private func configureSearchResults() {
        let resultsViewController = UIStoryboard.main.instantiateViewController(withIdentifier: "SearchResultsViewController") as? SearchResultsViewController
        do {
            let localStore = LocalAPI(realm: try Realm())
            let omdbStore = OMDBAPI()
            let searchRestultsViewModel = SearchResultsViewModel(localStore: localStore, omdbStore: omdbStore)
            resultsViewController?.viewModel = searchRestultsViewModel

            viewModel = SearchViewModel(localStore: localStore, imdbStore: IMDBAPI())
        } catch {
            print(error)
        }

        let searchController = UISearchController(searchResultsController: resultsViewController)
        searchController.searchResultsUpdater = self

        navigationItem.searchController = searchController
    }

    // MARK: - UITableView

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel?.numberOfRows ?? 0
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        "Popular Movies"
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        40.0
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

        if !movie.isRecent {
            localStore.addRecent(movie: movie)
        }

        movieViewController.viewModel = MovieViewModel(movie: movie, localStore: localStore, omdbStore: OMDBAPI())
        present(movieViewController, animated: true)
    }

    // MARK: - Private Method(s)

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
            if (self?.viewModel?.results.isEmpty) ?? false {
                self?.showWarning(.emptyFavorites)
            } else {
                self?.hideWarning(.emptyFavorites)
            }
        }
    }
}

// MARK: - UISearchResultsUpdating

extension SearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text,
              let resultsViewController = searchController.searchResultsController as? SearchResultsViewController else {
            return
        }
        resultsViewController.searchText = text
    }
}
