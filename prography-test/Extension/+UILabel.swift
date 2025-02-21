//
//  +UILabel.swift
//  prography-test
//
//  Created by 이명지 on 2/20/25.
//

import UIKit

extension UILabel {
    func setLineSpacing(_ spacing: CGFloat) {
        guard let text = self.text else { return }
        
        let attributedString = NSMutableAttributedString(string: text)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = spacing
        
        attributedString.addAttribute(.paragraphStyle,
                                    value: paragraphStyle,
                                    range: NSRange(location: 0, length: attributedString.length))
        
        self.attributedText = attributedString
    }
}
