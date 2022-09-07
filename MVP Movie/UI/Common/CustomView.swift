//
//  CustomView.swift
//  MVP Movie
//
//  Created by Dan-George Apostu on 01.09.2022.
//

import UIKit

class CustomView: UIView {
    @IBOutlet private weak var contentView: UIView!

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    func commonInit() {
        let className = String(describing: nibNameFor(type(of: self))).pathExtension
        Bundle.main.loadNibNamed(className, owner: self, options: nil)
        contentView.pinInView(self)
    }

    private func nibNameFor(_ theClass: AnyClass) -> String {
        let className = String.describing(class: theClass)
        guard Bundle.main.path(forResource: className, ofType: "nib") != nil else {
            guard let superClass = theClass.superclass() else {
                fatalError("Xib doesn't exist")
            }
            return nibNameFor(superClass)
        }
        return className
    }
}

extension String {
    var pathExtension: String {
        components(separatedBy: ".").last ?? self
    }

    static func describing(class theClass: AnyClass) -> String {
        String(describing: theClass).pathExtension
    }
}

extension UIView {
    func pinInView(_ containerView: UIView?) {
        guard let container = containerView else {
            return
        }
        translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(self)

        NSLayoutConstraint(item: self, attribute: .leading, relatedBy: .equal, toItem: container, attribute: .leading, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: container, attribute: .trailing, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: container, attribute: .top, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: container, attribute: .bottom, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .centerX, relatedBy: .equal, toItem: container, attribute: .centerX, multiplier: 1.0, constant: 0).isActive =  true
    }
}
