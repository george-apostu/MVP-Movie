//
//  UIViewController+Extensions.swift
//  MVP Movie
//
//  Created by Dan-George Apostu on 06.09.2022.
//

import UIKit

extension UIViewController {

    func showWarning(_ type: WarningType) {
        let warningView = WarningView(type: type)
        warningView.tag = type.rawValue
        warningView.pinInView(view)
    }

    func hideWarning(_ type: WarningType) {
        guard let warningView = view.subviews.first(where: { $0.tag == type.rawValue }) else {
            return
        }
        warningView.removeFromSuperview()
    }

}
