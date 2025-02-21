//
//  +UIImageView.swift
//  prography-test
//
//  Created by 이명지 on 2/20/25.
//

import UIKit

extension UIImageView {
    func addGradientShadow(alpha: CGFloat, location: CGFloat, spacing: CGFloat) {
        let baseAlpha = alpha
        let baselocation = location
        let spacing = spacing
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        
        gradientLayer.colors = [
            UIColor.clear.cgColor,
            UIColor.black.withAlphaComponent(baseAlpha).cgColor,
            UIColor.black.withAlphaComponent(baseAlpha + spacing * 2).cgColor
        ]
        
        gradientLayer.locations = [
            NSNumber(value: Float(baselocation)),
            NSNumber(value: Float(baselocation + spacing)),
            NSNumber(value: Float(baselocation + spacing * 2))
        ]
        
        clipsToBounds = false
        
        layer.sublayers?.forEach { layer in
            if layer is CAGradientLayer {
                layer.removeFromSuperlayer()
            }
        }
        
        layer.addSublayer(gradientLayer)
    }
}
