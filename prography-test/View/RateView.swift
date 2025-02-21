//
//  RateView.swift
//  prography-test
//
//  Created by 이명지 on 2/21/25.
//

import UIKit

final class RateView: UIView {
    private var rateValue: Int
    private var isInteractiveMode: Bool
    
    private var stars = [UIButton]()
    
    private lazy var rateStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 4
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    init(value: Int = 0, isInteractiveMode: Bool = false) {
        self.rateValue = value
        self.isInteractiveMode = isInteractiveMode
        super.init(frame: .zero)
        
        setupUI()
        setupRate()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        addSubview(rateStackView)
        
        rateStackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    private func setupRate() {
        Range(1 ... 5).forEach { _ in
            let star = UIButton()
            star.contentMode = .scaleAspectFill
            star.clipsToBounds = true
            star.setImage(UIImage(named: "Star"), for: .normal)
            star.setImage(UIImage(named: "StarRed"), for: .selected)
            star.isUserInteractionEnabled = self.isInteractiveMode
            
            stars.append(star)
            rateStackView.addArrangedSubview(star)
        }
    }
    
    func setRateValue(_ value: Int) {
        stars.enumerated().forEach { index, star in
            star.isSelected = index < value
        }
    }
    
    func onEditMode() {
        stars.forEach {
            $0.isUserInteractionEnabled = true
        }
    }
    
    func offEditMode() {
        stars.forEach {
            $0.isUserInteractionEnabled = false
        }
    }
}
