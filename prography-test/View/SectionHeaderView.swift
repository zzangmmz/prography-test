//
//  SectionHeaderView.swift
//  prography-test
//
//  Created by 이명지 on 2/20/25.
//

import UIKit

final class SectionHeaderView: UICollectionReusableView {
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .bold)
        label.textColor = .onSurfaceVariant
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func configure(with title: String, isSelected: Bool = false) {
        titleLabel.text = title
        titleLabel.textColor = isSelected ? .highlightRed : .onSurfaceVariant
    }
}
