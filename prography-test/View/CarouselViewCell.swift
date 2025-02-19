//
//  CarouselViewCell.swift
//  prography-test
//
//  Created by 이명지 on 2/20/25.
//

import UIKit
import Kingfisher

final class CarouselViewCell: UICollectionViewCell {
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.textColor = .white
        label.textAlignment = .left
        return label
    }()
    
    private let overviewLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 11, weight: .semibold)
        label.textColor = .white
        label.textAlignment = .left
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
            imageView,
            titleLabel,
            overviewLabel
        ].forEach {
            addSubview($0)
        }
    }
    
    private func setupConstraints() {
        self.layer.cornerRadius = 28
        
        imageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        overviewLabel.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().inset(16)
        }
        
        titleLabel.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.bottom.equalTo(overviewLabel.snp.top).offset(4)
        }
    }
    
    func configure(with movie: Movie) {
        self.imageView.kf.setImage(with: URL(string: movie.poster))
        self.titleLabel.text = movie.title
        self.overviewLabel.text = movie.overview
    }
}
