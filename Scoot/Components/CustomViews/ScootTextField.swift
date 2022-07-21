//
//  ScootTextField.swift
//  Scoot
//
//  Created by Profico on 20.07.2022..
//

import UIKit

class ScootTextField: UITextField {
    required init?(coder: NSCoder) {
        fatalError("init(coder: ) had not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    init(placeholderText: String, type: TFType) {
        super.init(frame: .zero)
        
//        self.placeholder = placeholderText
        self.attributedPlaceholder = NSAttributedString(
            string: placeholderText,attributes: [ NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14, weight: .regular)])
        
        self.isSecureTextEntry = type == .emailField ? false : true
        configure()
    }
    
    enum TFType {
        case emailField
        case passwordField
        
    }
    
    private func configure() {
        layer.cornerRadius = 8
        layer.borderWidth = 1
        layer.borderColor = UIColor.systemGray.cgColor
        autocorrectionType = .no
        autocapitalizationType = .none
        setLeftPadding(padding: 16)
    }
}
