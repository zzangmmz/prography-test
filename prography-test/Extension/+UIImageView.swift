//
//  +UIImageView.swift
//  prography-test
//
//  Created by 이명지 on 2/20/25.
//

import UIKit

extension UIImageView {
    func addGradientShadow() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        
        gradientLayer.colors = [
            UIColor.clear.cgColor,
            UIColor.black.withAlphaComponent(0.3).cgColor,
            UIColor.black.withAlphaComponent(0.9).cgColor
        ]
        
        gradientLayer.locations = [0.4, 0.7, 1.0]
        
        clipsToBounds = false
        
        layer.sublayers?.forEach { layer in
            if layer is CAGradientLayer {
                layer.removeFromSuperlayer()
            }
        }
        
        layer.addSublayer(gradientLayer)
    }
}
