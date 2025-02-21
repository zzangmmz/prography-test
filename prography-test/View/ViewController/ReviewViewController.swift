//
//  ReviewViewController.swift
//  prography-test
//
//  Created by 이명지 on 2/21/25.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

final class ReviewViewController: UIViewController {
    private var movieID: Int
    private let viewModel: ReviewViewModel
    private var disposeBag = DisposeBag()
    private var isPlaceholderShowing = true
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        return view
    }()
    
    private let posterView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.backgroundColor = .clear
        return imageView
    }()
    
    private let rateView = RateView()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Pretendard-Bold", size: 30)
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
        label.textColor = .onSurfaceVariant
        label.textAlignment = .left
        label.numberOfLines = 0
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 24
        
        let attributedString = NSAttributedString(
            string: "",
            attributes: [
                .paragraphStyle: paragraphStyle,
                .font: UIFont(name: "Pretendard-Regular", size: 16),
                .foregroundColor: UIColor.onSurfaceVariant
            ]
        )
        
        label.attributedText = attributedString
        return label
    }()
    
    private lazy var movieStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [titleStackView, genreStackView, overviewLabel])
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.alignment = .leading
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
    
    private let reviewContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    private let existingReviewView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 8
        view.backgroundColor = .commentPink
        view.isHidden = true
        return view
    }()
    
    private let reviewTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont(name: "Pretendard-Medium", size: 16)
        textView.textColor = .teriary
        textView.layer.cornerRadius = 8
        textView.layer.borderWidth = 1
        textView.layer.borderColor = UIColor.highlightRed.cgColor
        textView.isHidden = true
        textView.textContainerInset = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
        textView.isScrollEnabled = true
        textView.backgroundColor = .clear
        return textView
    }()
    
    private let placeholderLabel: UILabel = {
        let label = UILabel()
        label.text = "후기를 작성해주세요."
        label.font = UIFont(name: "Pretendard-Regular", size: 16)
        label.textColor = .teriary
        label.backgroundColor = .clear
        return label
    }()
    
    private let reviewLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Pretendard-Medium", size: 16)
        label.textColor = .default
        label.numberOfLines = 0
        return label
    }()
    
    private let reviewedDateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Pretendard-Regular", size: 11)
        label.textColor = .default
        label.textAlignment = .right
        return label
    }()
    
    private lazy var commentStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [commentTitleLabel, reviewContainerView])
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
        setupUI()
        setupConstraints()
        bindViewModel()
        setupTextView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        posterView.addGradientShadow(
            alpha: 0.1,
            location: 0.7,
            spacing: 0.15
        )
    }
    
    // MARK: - Setup
    private func setupNavigationBar() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.shadowColor = .clear
        
        appearance.backButtonAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.clear]
        
        let backButtonImage = UIImage(named: "NavigationButton")?.withRenderingMode(.alwaysOriginal)
        appearance.setBackIndicatorImage(backButtonImage, transitionMaskImage: backButtonImage)
        
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 144, height: 24))
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "logo")?.withRenderingMode(.alwaysOriginal)
        navigationItem.titleView = imageView
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        [
            posterView,
            rateView,
            movieStackView,
            commentStackView
        ].forEach { contentView.addSubview($0) }
        
        [
            existingReviewView,
            reviewTextView,
            placeholderLabel
        ].forEach {
            reviewContainerView.addSubview($0)
        }
        
        [
            reviewLabel,
            reviewedDateLabel
        ].forEach {
            existingReviewView.addSubview($0)
        }
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        scrollView.addGestureRecognizer(tapGesture)
    }
    
    private func setupConstraints() {
        scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        contentView.snp.makeConstraints {
            $0.edges.equalTo(scrollView.contentLayoutGuide)
            $0.width.equalTo(scrollView.frameLayoutGuide)
        }
        
        posterView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.top.equalToSuperview()
            $0.height.lessThanOrEqualTo(247)
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
            $0.top.equalTo(rateView.snp.bottom)
            $0.height.lessThanOrEqualTo(300)
        }
        
        commentStackView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.top.equalTo(movieStackView.snp.bottom).offset(16)
            $0.bottom.equalToSuperview().offset(-16)
        }
        
        reviewContainerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.height.equalTo(80)
        }
        
        existingReviewView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.height.equalTo(80)
        }
        
        reviewTextView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.height.equalTo(80)
        }
        
        placeholderLabel.snp.makeConstraints {
            $0.leading.equalTo(reviewTextView).offset(16)
            $0.top.equalTo(reviewTextView.snp.top).offset(16)
            $0.horizontalEdges.equalTo(placeholderLabel).inset(4)
        }
        
        reviewLabel.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(16)
        }
        
        reviewedDateLabel.snp.makeConstraints {
            $0.trailing.bottom.equalToSuperview().inset(8)
        }
    }
    
    private func setupTextView() {
        reviewTextView.delegate = self
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissKeyboard))
        toolbar.items = [flexSpace, doneButton]
        reviewTextView.inputAccessoryView = toolbar
    }
    
    private func bindViewModel() {
        viewModel.movieDetail
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] movie in
                guard let movie = movie else { return }
                self?.updateMovieUI(with: movie)
            })
            .disposed(by: disposeBag)
        
        viewModel.userReview
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] review in
                self?.updateReviewUI(with: review)
            })
            .disposed(by: disposeBag)
    }
    
    private func updateMovieUI(with movie: MovieDetail) {
        titleLabel.text = movie.title
        overviewLabel.text = movie.overview
        posterView.kf.setImage(with: URL(string: "https://image.tmdb.org/t/p/original\(movie.poster)"))
        
        genreStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        movie.genres.forEach {
            let genreName = Genre.getGenreName(for: $0.id)
            let genreTagLabel = createGenreTagLabel(text: genreName)
            genreTagLabel.snp.makeConstraints {
                $0.size.equalTo(CGSize(width: 40, height: 16))
            }
            genreStackView.addArrangedSubview(genreTagLabel)
        }
    }
    
    private func updateReviewUI(with review: Review?) {
        rateView.setRateValue(review?.myRate ?? 0)
        
        if let review = review, let comment = review.comment, !comment.isEmpty {
            existingReviewView.isHidden = false
            reviewTextView.isHidden = true
            placeholderLabel.isHidden = true
            
            reviewLabel.text = comment
            if let date = review.savedDate {
                reviewedDateLabel.text = DateFormatter.localizedString(from: date, dateStyle: .medium, timeStyle: .none)
            }
        } else {
            existingReviewView.isHidden = true
            reviewTextView.isHidden = false
            placeholderLabel.isHidden = false
            reviewTextView.text = nil
            isPlaceholderShowing = true
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
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension ReviewViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        placeholderLabel.isHidden = true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        placeholderLabel.textColor = .teriary
        if textView.text.isEmpty {
            isPlaceholderShowing = true
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if textView.text.isEmpty && !isPlaceholderShowing {
            placeholderLabel.isHidden = false
            isPlaceholderShowing = true
        } else if !textView.text.isEmpty && isPlaceholderShowing {
            placeholderLabel.isHidden = true
            isPlaceholderShowing = false
        }
    }
}
