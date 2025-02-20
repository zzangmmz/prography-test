//
//  SectionHeaderView.swift
//  prography-test
//
//  Created by 이명지 on 2/20/25.
//

import UIKit

final class SectionHeaderView: UICollectionReusableView {
    var categorySelected: ((MovieCategory) -> Void)?
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        return stackView
    }()
    
    private var categoryButtons: [UIButton] = []
    private var bottomBorders: [CALayer] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        addSubview(stackView)
        
        stackView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(48)
            $0.centerY.equalToSuperview()
        }
        
        let categories = [MovieCategory.nowPlaying, .popular, .topRated]
        categories.forEach { category in
            let button = UIButton()
            button.setTitle(category.title, for: .normal)
            button.titleLabel?.font = .systemFont(ofSize: 14, weight: .bold)
            button.setTitleColor(.onSurfaceVariant, for: .normal)
            button.tag = categories.firstIndex(of: category) ?? 0
            button.addTarget(self, action: #selector(categoryButtonTapped(_:)), for: .touchUpInside)
            
            let border = CALayer()
            border.backgroundColor = UIColor.clear.cgColor
            bottomBorders.append(border)
            button.layer.addSublayer(border)
            
            stackView.addArrangedSubview(button)
            categoryButtons.append(button)
        }
    }
    
    @objc private func categoryButtonTapped(_ sender: UIButton) {
        let categories = [MovieCategory.nowPlaying, .popular, .topRated]
        // selectedCategory를 선택된 카테고리로 업데이트
        categorySelected?(categories[sender.tag])
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        for (index, button) in categoryButtons.enumerated() {
            let border = bottomBorders[index]
            border.frame = CGRect(x: 0,
                                y: button.frame.size.height - 2,
                                width: button.frame.size.width,
                                height: 2)
        }
    }
    
    func configureWithCategories(_ selectedCategory: MovieCategory) {
        for (index, button) in categoryButtons.enumerated() {
            let isSelected = button.title(for: .normal) == selectedCategory.title
            button.setTitleColor(isSelected ? .highlightRed : .onSurfaceVariant, for: .normal)
            bottomBorders[index].backgroundColor = isSelected ? UIColor.highlightRed.cgColor : UIColor.clear.cgColor
        }
    }
}
