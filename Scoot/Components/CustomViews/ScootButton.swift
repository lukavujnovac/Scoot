//
//  ScootButton.swift
//  Scoot
//
//  Created by Profico on 20.07.2022..
//

import UIKit

class ScootButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Coder not implemented")
    }
    
    init(backgruondColor: UIColor, title: String, titleColor: UIColor) {
        super.init(frame: .zero)
        
        self.backgroundColor = backgruondColor
        self.setTitle(title, for: .normal)
        self.setTitleColor(titleColor, for: .normal)
        
        configure()
    }
    
    private func configure() {
        layer.cornerRadius = 8
        layer.borderColor = UIColor.black.cgColor
    }

}
