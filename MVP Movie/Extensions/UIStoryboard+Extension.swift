//
//  UIStoryboard+Extension.swift
//  MVP Movie
//
//  Created by Dan-George Apostu on 06.09.2022.
//

import UIKit

extension UIStoryboard {

    static var main: UIStoryboard {
        UIStoryboard(name: "Main", bundle: nil)
    }

    static func instantiateViewController<T: UIViewController>() -> T? {
        let identifier = String.describing(class: T.self)
        return main.instantiateViewController(withIdentifier: identifier) as? T
    }

}
