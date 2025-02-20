//
//  CarouselCell.swift
//  prography-test
//
//  Created by 이명지 on 2/20/25.
//

import UIKit
import Kingfisher

final class CarouselCell: UICollectionViewCell {
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Pretendard-Bold", size: 16)
        label.textColor = .white
        label.textAlignment = .left
        return label
    }()
    
    private let overviewLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Pretendard-SemiBold", size: 11)
        label.textColor = .white
        label.textAlignment = .left
        label.numberOfLines = 1
        return label
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.addGradientShadow()
    }
    
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
            contentView.addSubview($0)
        }
    }
    
    private func setupConstraints() {
        self.clipsToBounds = true
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
            $0.bottom.equalTo(overviewLabel.snp.top).offset(-8)
        }
    }
    
    func configure(with movie: Movie) {
        self.imageView.kf.setImage(with: URL(string: "https://image.tmdb.org/t/p/original\(movie.poster!)"))
        self.titleLabel.text = movie.title
        self.overviewLabel.text = movie.overview
    }
}
