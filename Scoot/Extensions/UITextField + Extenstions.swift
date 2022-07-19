//
//  UiTextField+Extenstions.swift
//  Scoot
//
//  Created by Profico on 19.07.2022..
//

import UIKit

extension UITextField {
    func setRightView(_ view: UIView, padding: CGFloat) {
        view.translatesAutoresizingMaskIntoConstraints = true

        let outerView = UIView()
        outerView.translatesAutoresizingMaskIntoConstraints = false
        outerView.addSubview(view)

        outerView.frame = CGRect(
            origin: .zero,
            size: CGSize(
                width: view.frame.size.width + padding,
                height: view.frame.size.height + padding
            )
        )

        view.center = CGPoint(
            x: outerView.bounds.size.width / 2,
            y: outerView.bounds.size.height / 2
        )

        rightViewMode = .always
        rightView = outerView
    }
    
    func setLeftPadding(padding: CGFloat) {
        leftViewMode = .always
        leftView = UIView(frame: CGRect(x: 0, y: 0, width: padding, height: 0))
    }
}
