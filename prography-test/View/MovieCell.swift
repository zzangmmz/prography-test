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
        label.font = UIFont(name: "Pretendard-Bold", size: 22)
        label.textColor = .black
        return label
    }()
    
    private let overViewLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Pretendard-Medium", size: 16)
        label.textColor = .onSurfaceVariant
        label.numberOfLines = 2
        label.setLineSpacing(6)
        return label
    }()
    
    private let rateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Pretendard-SemiBold", size: 14)
        label.textColor = .onSurfaceVariant
        return label
    }()
    
    private let genreStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 4
        return stackView
    }()
    
    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [titleLabel, overViewLabel, rateLabel, genreStackView])
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.alignment = .leading
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
            $0.leading.equalToSuperview()
        }
        
        contentStackView.snp.makeConstraints {
            $0.leading.equalTo(posterImageView.snp.trailing).offset(16)
            $0.trailing.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
    }
    
    func configure(with movie: Movie) {
        self.posterImageView.kf.setImage(with: URL(string: "https://image.tmdb.org/t/p/original\(movie.poster!)"))
        self.titleLabel.text = movie.title
        self.overViewLabel.text = movie.overview
        self.rateLabel.text = movie.rate.toOneDecimalString
        
        self.genreStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        movie.genres.forEach {
            let genreName = Genre.getGenreName(for: $0)
            let genreTagLabel = createGenreTagLabel(text: genreName)
            genreTagLabel.snp.makeConstraints {
                $0.size.equalTo(CGSize(width: 40, height: 16))
            }
            genreStackView.addArrangedSubview(genreTagLabel)
        }
    }
    
    private func createGenreTagLabel(text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = UIFont(name: "Pretendard-SemiBold", size: 11)
        label.textColor = .onSurfaceVariant
        label.layer.cornerRadius = 8
        label.layer.borderWidth = 1
        label.layer.borderColor = UIColor.highlightRed.cgColor
        label.textAlignment = .center
        return label
    }
}
