//
//  MovieCell.swift
//  prography-test
//
//  Created by 이명지 on 2/20/25.
//

import UIKit
import SnapKit

final class MovieCell: UICollectionViewCell {
    private let posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 16
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 22, weight: .bold)
        return label
    }()
    
    private let overViewLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.numberOfLines = 2
        return label
    }()
    
    private let rateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        label.textColor = .systemGray
        return label
    }()
    
    private let genreStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 2
        return stackView
    }()
    
    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [titleLabel, overViewLabel, rateLabel, genreStackView])
        stackView.axis = .vertical
        stackView.spacing = 4
        stackView.distribution = .equalCentering
        return stackView
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
            posterImageView,
            contentStackView
        ].forEach {
            contentView.addSubview($0)
        }
    }
    
    private func setupConstraints() {
        posterImageView.snp.makeConstraints {
            $0.height.equalToSuperview()
            $0.width.equalTo(120)
        }
        
        contentStackView.snp.makeConstraints {
            $0.height.equalToSuperview()
            $0.leading.equalTo(posterImageView.snp.trailing).offset(16)
            $0.trailing.equalToSuperview()
        }
    }
    
    func configure(with movie: Movie) {
        self.posterImageView.kf.setImage(with: URL(string: movie.poster))
        self.titleLabel.text = movie.title
        self.overViewLabel.text = movie.overview
        self.rateLabel.text = String(describing: movie.rate)
        
        self.genreStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        movie.genres.forEach {
            let genreTagLabel = createGenreTagLabel(text: $0)
            genreStackView.addArrangedSubview(genreTagLabel)
        }
    }
    
    private func createGenreTagLabel(text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = .systemFont(ofSize: 11, weight: .semibold)
        label.textColor = .systemGray
        label.layer.cornerRadius = 8
        label.layer.borderWidth = 1
        label.layer.borderColor = UIColor.onSurfaceVariant.cgColor
        label.textAlignment = .center
        return label
    }
}
