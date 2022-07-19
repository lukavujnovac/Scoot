//
//  PaddingTextField.swift
//  Scoot
//
//  Created by Profico on 19.07.2022..
//

import UIKit

class PaddingTextField: UITextField {
    let leftPadding = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("coder not implemented")
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: leftPadding)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: leftPadding)
    }
}
