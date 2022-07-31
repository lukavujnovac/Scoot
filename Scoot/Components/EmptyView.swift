//
//  EmptyView.swift
//  Scoot
//
//  Created by Profico on 29.07.2022..
//
import UIKit
import SnapKit

class EmptyView: UIView {
    let label: UILabel = {
        let label = UILabel()
        label.text = "Vehicles unavailable"
        label.textAlignment = .center
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(label)

    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder: has not been implemented")
    }
    
    private func layout() {
        layoutLabel()
    }
    
    
    private func layoutLabel() {
        label.frame = CGRect(x: 0, y: 0, width: 224, height: 32)
        label.center = self.center
    }
}
