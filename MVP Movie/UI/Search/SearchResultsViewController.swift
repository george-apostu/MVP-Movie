//
//  SearchResultsViewController.swift
//  MVP Movie
//
//  Created by Dan-George Apostu on 06.09.2022.
//

import UIKit
import Combine
import RealmSwift
import Reachability

class SearchResultsViewController: UITableViewController {

    // MARK: - Public Properties

    var viewModel: SearchResultsViewModel?
    @Published var searchText: String = ""

    // MARK: - Private Properties

    private var bag = Set<AnyCancellable>()
    private var reachability: Reachability?

    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        configureTableView()
        configureBindings()
        handleReachability()
    }

    // MARK: - UITableView

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel?.numberOfRows ?? 0
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        (viewModel?.isShowingRecents ?? false) ? "Recent" : nil
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return (viewModel?.isShowingRecents ?? false) ? 40.0 : 0.0
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
              let omdbStore = viewModel?.omdbStore,
              let movieViewController: MovieViewController = UIStoryboard.instantiateViewController() else {
            return
        }

        if !movie.isRecent {
            localStore.addRecent(movie: movie)
        }

        movieViewController.viewModel = MovieViewModel(movie: movie, localStore: localStore, omdbStore: omdbStore)
        present(movieViewController, animated: true)
    }

    // MARK: - Private Methods

    private func configureTableView() {
        tableView.register(UINib(nibName: "MovieTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "MovieTableViewCell")
    }

    private func configureBindings() {
        $searchText
            .dropFirst()
            .filter { $0.count > 2 }
            .throttle(for: .milliseconds(500), scheduler: RunLoop.main, latest: true)
            .sink { [weak self] searchTitle in
                self?.viewModel?.isShowingRecents = false
                Task {
                    await self?.viewModel?.search(title: searchTitle)
                    self?.tableView.reloadData()
                }
            }
            .store(in: &bag)

        viewModel?.$errorMessage
            .receive(on: RunLoop.main)
            .sink { [weak self] message in
                if message.isEmpty {
                    self?.hideWarning(.apiError)
                } else {
                    self?.showWarning(.apiError)
                }
            }
            .store(in: &bag)

        $searchText
            .filter { $0.count < 3 }
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                self?.viewModel?.errorMessage = ""
                self?.viewModel?.isShowingRecents = true
                self?.tableView.reloadData()
            }
            .store(in: &bag)
    }

    private func handleReachability() {
        do {
            reachability = try Reachability()
        } catch {
            print(error)
        }
        reachability?.whenReachable = { [weak self] _ in
            print("Reachable")
            self?.hideWarning(.noInternet)
        }
        reachability?.whenUnreachable = { [weak self] _ in
            print("Not reachable")
            self?.showWarning(.noInternet)
        }

        do {
            try reachability?.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
    }
}
