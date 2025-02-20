//
//  CategoryCell.swift
//  prography-test
//
//  Created by 이명지 on 2/20/25.
//

import UIKit

final class CategoryCell: UICollectionViewCell {
    private let title: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .bold)
        label.textAlignment = .center
        label.textColor = .onSurfaceVariant
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupSubviews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSubviews() {
        [
            title
        ].forEach {
            contentView.addSubview($0)
        }
    }
    
    private func setupConstraints() {
        title.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func configure(with title: String) {
        self.title.text = title
    }
}
