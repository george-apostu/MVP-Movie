//
//  SettingsViewController.swift
//  MVP Movie
//
//  Created by Dan-George Apostu on 07.09.2022.
//

import Foundation
import UIKit
import RealmSwift

struct UserDefaultKeys {
    static let hideFavorites = "hideFavoritesFromSearchResults"
    static let lastFetchedPopularMovies = "lastFetchedPopularMovies"
}

class SettingsViewController: UITableViewController {

    // MARK: - Private Properties

    private let userDefaults: UserDefaults = .standard

    // MARK: - IBOutlet(s)

    @IBOutlet private weak var hideFavoritesSwitch: UISwitch!

    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        hideFavoritesSwitch.isOn = userDefaults.bool(forKey: UserDefaultKeys.hideFavorites)
    }

    // MARK: - IBAction(s)

    @IBAction private func valueChanged(_ sender: UISwitch) {
        userDefaults.set(sender.isOn, forKey: UserDefaultKeys.hideFavorites)
        userDefaults.synchronize()
    }

    @IBAction func resetApp(_ sender: Any) {

        let alertController = UIAlertController(title: "Reset App",
                                                message: "Are you sure you want to reset the app?",
                                                preferredStyle: .alert)
        let resetAction = UIAlertAction(title: "Reset", style: .destructive) { [weak self] _ in
            do {
                let localAPI = LocalAPI(realm: try Realm())
                localAPI.clearAll()
            } catch {
                print(error)
            }
            guard let self = self else { return }
            self.hideFavoritesSwitch.isOn = false
            self.valueChanged(self.hideFavoritesSwitch)
        }

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)

        alertController.addAction(resetAction)
        alertController.addAction(cancelAction)

        present(alertController, animated: true)
    }
}
