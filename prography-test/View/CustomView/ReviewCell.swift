//
//  ReviewCell.swift
//  prography-test
//
//  Created by 이명지 on 2/21/25.
//

import UIKit

final class ReviewCell: UICollectionViewCell {
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 16
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Pretendard-SemiBold", size: 14)
        label.textAlignment = .center
        label.textColor = .black
        return label
    }()
    
    private let rateView = RateView()
    
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
            rateView
        ].forEach {
            contentView.addSubview($0)
        }
    }
    
    private func setupConstraints() {
        imageView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.top.equalToSuperview()
            $0.height.equalTo(180)
        }
        
        titleLabel.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.top.equalTo(imageView.snp.bottom).offset(8)
            $0.height.equalTo(20)
        }
        
        rateView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(4)
            $0.bottom.equalToSuperview().offset(-8)
            $0.height.equalTo(16)
            $0.width.equalTo(100)
            $0.centerX.equalToSuperview()
        }
    }
    
    func configure(with review: Review) {
        self.titleLabel.text = review.movieTitle
        self.imageView.kf.setImage(with: URL(string: "https://image.tmdb.org/t/p/original\(review.poster)"))
        self.rateView.setRateValue(review.myRate ?? 0)
    }
}
