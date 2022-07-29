//
//  UIView + Extensions.swift
//  Scoot
//
//  Created by Luka Vujnovac on 28.07.2022..
//

import UIKit

extension UIView {
    
    var snapshot: UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        let capturedImage = renderer.image { context in
            layer.render(in: context.cgContext)
        }
        return capturedImage
    }
}
