//
//  CustomNavigationBar.swift
//  prography-test
//
//  Created by 이명지 on 2/19/25.
//

import UIKit

final class CustomNavigationBar: UINavigationBar {
    private var customHeight: CGFloat = 56
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        var newSize = super.sizeThatFits(size)
        newSize.height = customHeight
        return newSize
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        frame = CGRect(x: frame.origin.x,
                       y: frame.origin.y,
                       width: frame.width,
                       height: customHeight)
        
        for subview in subviews {
            if NSStringFromClass(subview.classForCoder).contains("UINavigationBarContentView") {
                subview.frame = CGRect(x: 0,
                                       y: 0,
                                       width: frame.width,
                                       height: customHeight)
            }
        }
    }
}
