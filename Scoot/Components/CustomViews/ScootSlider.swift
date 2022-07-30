//
//  ScootSlider.swift
//  Scoot
//
//  Created by Luka Vujnovac on 27.07.2022..
//

import UIKit

class ScootSlider: UISlider {
    
    private var imageName: String?
    var isDone: Bool = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("fatal error scoot slider")
    }
    
    private let baseLayer = CALayer()
    private let trackLayer = CAGradientLayer()
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        setup()
    }
    
    private func setup() {
        clear()
        createBaseLayer()
        createThumbImageView()
        configureTrackLayer()
        addTarget(self, action: #selector(valueChanged(_:)), for: .valueChanged)
        self.value = 0.025
    }
    
    @objc private func valueChanged(_ sender: UISlider) {
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        let thumbRectA = thumbRect(forBounds: bounds, trackRect: trackRect(forBounds: bounds), value: value)
        trackLayer.frame = .init(x: 0, y: frame.height / 4 - 20, width: thumbRectA.maxX + 8 , height: frame.height  )
        
//        print(value)
        
        if value == 1.0 {
            imageName = "checkmark"
            createThumbImageView()
            isDone = true
        }else {
            imageName = "arrow.right"
            createThumbImageView()
            isDone = false
        }
        
        
        CATransaction.commit()
    }
    
    private func clear() {
        tintColor = .clear
        maximumTrackTintColor = .clear
        backgroundColor = .clear
        thumbTintColor = .clear
    }
    
    private func createBaseLayer() {
        baseLayer.borderWidth = 1
        baseLayer.borderColor = UIColor.lightGray.cgColor
        baseLayer.masksToBounds = true
        baseLayer.backgroundColor = UIColor.white.cgColor
        baseLayer.frame = .init(x: 0, y: frame.height / CGFloat(Float.greatestFiniteMagnitude), width: frame.width, height: frame.height )
        baseLayer.cornerRadius = baseLayer.frame.height / 2
        layer.insertSublayer(baseLayer, at: 0)
    }
    
    private func createThumbImageView() {
        let thumbSize = (frame.height) - 16
        let thumbView = ThumbView(imageName: isDone ? "checkmark" : "arrow.right", isDone: isDone, frame: .init(x: 0, y: 0, width: thumbSize, height: thumbSize))
        thumbView.layer.cornerRadius = thumbSize / 2
        let thumbSnapshot = thumbView.snapshot
        setThumbImage(thumbSnapshot, for: .normal)
        setThumbImage(thumbSnapshot, for: .highlighted)
        setThumbImage(thumbSnapshot, for: .application)
        setThumbImage(thumbSnapshot, for: .disabled)
        setThumbImage(thumbSnapshot, for: .focused)
        setThumbImage(thumbSnapshot, for: .reserved)
        setThumbImage(thumbSnapshot, for: .selected)
    }
    
    private func configureTrackLayer() {
        let firstColor = UIColor.scootLoginGreen!.cgColor
        let secondColor = UIColor.systemGreen.cgColor
        trackLayer.colors = [firstColor, secondColor]
        trackLayer.startPoint = .init(x: 0, y: 0.5)
        trackLayer.endPoint = .init(x: 1, y: 0.5)
        trackLayer.frame = .init(x: 0, y: 0, width: 0, height: frame.height )
        trackLayer.cornerRadius = trackLayer.frame.height / 2
        layer.insertSublayer(trackLayer, at: 1)
    }
}

final class ThumbView: UIView {
    
    var imageName: String?
    var isDone: Bool = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    init(imageName: String, isDone: Bool, frame: CGRect) {
        super.init(frame: frame)
        self.imageName = imageName
        self.isDone = isDone
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        backgroundColor = isDone ? .systemBackground : .scootLoginGreen
        let image = UIImageView(image: UIImage(systemName: imageName ?? ""))
        image.tintColor = isDone ? .scootLoginGreen : .systemBackground  
        image.frame = .init(x: frame.midX - 12, y: frame.midY - 12, width: 24, height: 24)
        
        addSubview(image)
    }
}
