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
        collectionView.register(ReviewCell.self, forCellWithReuseIdentifier: String(describing: ReviewCell.self))
        return collectionView
    }()
    
    private lazy var ratesButton: UIButton = {
        let button = UIButton()
        button.configuration = createConfiguration()
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    init() {
        self.viewModel = MyViewModel()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSubviews() {
        [
            collectionView
        ].forEach {
            view.addSubview($0)
        }
    }
    
    private func setupConstraints() {
        
    }
}

// MARK: - Layout
extension MyViewController {
    private func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 121, height: 240)
        layout.minimumLineSpacing = 16
        layout.minimumInteritemSpacing = 16
        layout.sectionInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        return layout
    }
}

extension MyViewController {
    private func createConfiguration() -> UIButton.Configuration {
        var config = UIButton.Configuration.plain()
        config.attributedTitle = AttributedString(
            "All",
            attributes: AttributeContainer(
                [
                    .font: UIFont(name: "Pretendard-Bold",
                                  size: 16)!
                ]
            ))
        config.baseBackgroundColor = .clear
        config.baseForegroundColor = .black
        config.background.strokeColor = .highlightRed
        config.background.strokeWidth = 1
        config.background.cornerRadius = 12
        return config
    }
}
