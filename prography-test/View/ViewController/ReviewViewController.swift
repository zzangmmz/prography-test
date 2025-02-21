//
//  ReviewViewController.swift
//  prography-test
//
//  Created by 이명지 on 2/21/25.
//

import UIKit
import RxSwift
import RxCocoa

final class ReviewViewController: UIViewController {
    private var movieID: Int
    private var review: Review?
    
    private let viewModel: ReviewViewModel
    private var disposeBag = DisposeBag()
    
    private let posterView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = .clear
        return imageView
    }()
    
    private let rateView = RateView()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Pretendard-Bold", size: 40)
        label.textColor = .black
        label.numberOfLines = 1
        label.textAlignment = .left
        label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        return label
    }()
    
    private let rateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Pretendard-SemiBold", size: 16)
        label.textColor = .black
        label.numberOfLines = 1
        label.textAlignment = .left
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        return label
    }()
    
    private lazy var titleStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [titleLabel, rateLabel])
        stackView.axis = .horizontal
        stackView.spacing = 4
        stackView.alignment = .bottom
        return stackView
    }()
    
    private let genreStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 4
        return stackView
    }()
    
    private let overviewLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Pretendard-Regular", size: 16)
        label.textColor = .onSurfaceVariant
        label.textAlignment = .left
        label.setLineSpacing(6)
        return label
    }()
    
    private lazy var movieStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [titleStackView, genreStackView,overviewLabel])
        stackView.axis = .vertical
        stackView.spacing = 8
        return stackView
    }()
    
    private let commentTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Comment"
        label.font = UIFont(name: "Pretendard-Bold", size: 16)
        label.textColor = .black
        label.textAlignment = .left
        return label
    }()
    
    private let commentView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 8
        view.layer.backgroundColor = UIColor.commentPink.cgColor
        return view
    }()
    
    private let commentLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Pretendard-Medium", size: 16)
        label.textColor = .default
        label.textAlignment = .left
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Pretendard-Regular", size: 11)
        label.textColor = .default
        label.textAlignment = .right
        return label
    }()
    
    private let commentTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "후기를 작성해주세요."
        textField.textColor = UIColor.teriary
        textField.font = UIFont(name: "Pretendard-Medium", size: 16)
        textField.layer.cornerRadius = 8
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.highlightRed.cgColor
        return textField
    }()
    
    private lazy var commentStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [commentTitleLabel, commentView, commentTextField])
        stackView.axis = .vertical
        stackView.spacing = 8
        return stackView
    }()
    
    init(movieID: Int) {
        self.movieID = movieID
        self.viewModel = ReviewViewModel(movieID: movieID)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupSubviews()
        setupConstraints()
    }
    
    private func setupNavigationBar() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.shadowColor = .clear
        
        let backButtonImage = UIImage(named: "NavigationButton")?.withRenderingMode(.alwaysOriginal)
        appearance.setBackIndicatorImage(backButtonImage, transitionMaskImage: backButtonImage)
        
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 144, height: 24))
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "logo")
        
        let resizedImage = imageView.image?.withRenderingMode(.alwaysOriginal)
        imageView.image = resizedImage
        
        navigationItem.titleView = imageView
        
        navigationItem.rightBarButtonItem?.image = UIImage(named: "eclipse")
    }
    
    private func setupSubviews() {
        [
            commentLabel,
            dateLabel
        ].forEach {
            commentView.addSubview($0)
        }
        
        [
            posterView,
            rateView,
            movieStackView,
            commentStackView
        ].forEach {
            view.addSubview($0)
        }
    }
    
    private func setupConstraints() {
        posterView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.height.greaterThanOrEqualTo(247)
        }
        
        rateView.snp.makeConstraints {
            $0.top.equalTo(posterView.snp.bottom)
            $0.height.equalTo(60)
            $0.centerX.equalToSuperview()
        }
        
        titleStackView.snp.makeConstraints {
            $0.height.equalTo(44)
        }
        
        movieStackView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.top.equalTo(rateView.snp.bottom).offset(16)
            $0.height.lessThanOrEqualTo(300)
        }
        
        commentStackView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.top.equalTo(movieStackView.snp.bottom).offset(16)
            $0.height.greaterThanOrEqualTo(130)
        }
    }
}
