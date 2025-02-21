//
//  MyViewController.swift
//  prography-test
//
//  Created by 이명지 on 2/19/25.
//

import UIKit
import RxSwift
import RxCocoa

final class MyViewController: UIViewController {
    
    private let viewModel: MyViewModel
    private var disposeBag = DisposeBag()
    
    private lazy var collectionView: UICollectionView = {
        let layout = createLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(ReviewCell.self, forCellWithReuseIdentifier: String(describing: ReviewCell.self))
        return collectionView
    }()
    
    private var ratesButton: UIButton = {
        let button = UIButton()
        button.setTitle("All", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.contentHorizontalAlignment = .left
        button.titleLabel?.font = UIFont(name: "Pretendard-Bold", size: 16)
        button.backgroundColor = .clear
        return button
    }()
    
    private var listButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "list"), for: .normal)
        button.tintColor = .onSurfaceVariant
        button.backgroundColor = .clear
        return button
    }()
    
    private var filterView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.layer.cornerRadius = 12
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.highlightRed.cgColor
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupSubviews()
        setupConstraints()
        bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.fetchReviews()
    }
    
    init() {
        self.viewModel = MyViewModel()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupNavigationBar() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.shadowColor = .clear
        
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 144, height: 24))
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "logo")
        
        let resizedImage = imageView.image?.withRenderingMode(.alwaysOriginal)
        imageView.image = resizedImage
        
        navigationItem.titleView = imageView
    }
    
    private func setupSubviews() {
        [
            ratesButton,
            listButton
        ].forEach {
            filterView.addSubview($0)
        }
        
        [
            filterView,
            collectionView
        ].forEach {
            view.addSubview($0)
        }
    }
    
    private func setupConstraints() {
        ratesButton.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.centerY.equalToSuperview()
            $0.height.equalTo(40)
            $0.width.equalToSuperview().multipliedBy(0.3)
        }
        
        listButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-8)
            $0.centerY.equalToSuperview()
            $0.size.equalTo(40)
        }
        
        filterView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(16)
            $0.height.equalTo(64)
        }
        
        collectionView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.top.equalTo(filterView.snp.bottom).offset(16)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-8)
        }
    }
    
    private func bind() {
        viewModel.reviews
            .observe(on: MainScheduler.instance)
            .bind(to: collectionView.rx.items(
                cellIdentifier: String(describing: ReviewCell.self),
                cellType: ReviewCell.self
            )) { (index, review, cell) in
                cell.configure(with: review)
            }
            .disposed(by: disposeBag)
        
        collectionView.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                // 리뷰 뷰컨으로 이동
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - Layout
extension MyViewController {
    private func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        
        let spacing: CGFloat = 8
        let availableWidth = UIScreen.main.bounds.width - spacing * 4
        let itemWidth = (availableWidth - spacing * 2) / 3  // 남은 공간 3등분
        
        layout.itemSize = CGSize(width: itemWidth, height: itemWidth * 2) // 높이 = 너비*2
        layout.minimumLineSpacing = spacing * 2
        layout.minimumInteritemSpacing = spacing
        return layout
    }
}

