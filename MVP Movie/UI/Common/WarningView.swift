//
//  WarningView.swift
//  MVP Movie
//
//  Created by Dan-George Apostu on 01.09.2022.
//

import UIKit

enum WarningType: Int, CustomStringConvertible {
    case noInternet = 101
    case apiError
    case emptyFavorites
    case emptySearchResults

    var systemIconName: String {
        switch self {
        case .noInternet:
            return "wifi.slash"
        case .apiError:
            return "circle.slash"
        case .emptyFavorites:
            return "star.slash"
        case .emptySearchResults:
            return "square.3.layers.3d.down.right.slash"
        }
    }

    var description: String {
        switch self {
        case .noInternet:
            return "No Internet Connection"
        case .apiError:
            return "API Error"
        case .emptyFavorites:
            return "No Favorite Movies"
        case .emptySearchResults:
            return "No Results"
        }
    }
}

class WarningView: CustomView {

    // MARK: - IBOutlet(s)

    @IBOutlet private weak var warningImageView: UIImageView!
    @IBOutlet private weak var warningLabel: UILabel!

    // MARK: - Initializer(s)

    init(type: WarningType) {
        super.init(frame: .zero)
        warningLabel.text = type.description
        warningImageView.image = UIImage(systemName: type.systemIconName)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
