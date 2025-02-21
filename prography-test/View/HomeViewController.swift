//
//  HomeViewController.swift
//  prography-test
//
//  Created by 이명지 on 2/19/25.
//

import UIKit
import RxSwift
import RxCocoa

private enum Section: Int, CaseIterable {
    case carousel
    case movies
}

final class HomeViewController: UIViewController {
    private var viewModel: HomeViewModel
    private var disposeBag = DisposeBag()
    
    private var collectionView: UICollectionView = {
        let layout = UICollectionViewLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .systemBackground
        collectionView.isPrefetchingEnabled = false
        return collectionView
    }()
    
    init(viewModel: HomeViewModel = HomeViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        setupUI()
        setupCollectionView()
        setupConstraints()
        addSwipeGestures()
        bind()
        fetchMovies()
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
    
    private func setupUI() {
        view.backgroundColor = .white
    }
    
    private func setupCollectionView() {
        collectionView.setCollectionViewLayout(createLayout(), animated: false)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(CarouselCell.self, forCellWithReuseIdentifier: String(describing: CarouselCell.self))
        collectionView.register(MovieCell.self, forCellWithReuseIdentifier: String(describing: MovieCell.self))
        collectionView.register(SectionHeaderView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: String(describing: SectionHeaderView.self))
        
        view.addSubview(collectionView)
        collectionView.frame = view.bounds
        collectionView.backgroundColor = .white
    }
    
    private func setupConstraints() {
        collectionView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.verticalEdges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func bind() {
        // 새 영화 데이터가 들어올 때
        Observable.combineLatest(
            viewModel.nowPlayingMovies.asObservable(),
            viewModel.popularMovies.asObservable(),
            viewModel.topRatedMovies.asObservable()
        )
        .observe(on: MainScheduler.instance)
        .subscribe(onNext: { [weak self] _ in
            self?.collectionView.reloadData()
        })
        .disposed(by: disposeBag)
        
        // 카테고리 변경 시
        viewModel.selectedCategory
            .distinctUntilChanged()
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                self?.collectionView.reloadData()
            })
            .disposed(by: disposeBag)
    }
    
    private func fetchMovies() {
        viewModel.fetchNowPlayingMovies()
        viewModel.fetchPopularMovies()
        viewModel.fetchTopRatedMovies()
    }
    
    private func getMoviesForCurrentCategory() -> [Movie] {
        switch viewModel.selectedCategory.value {
        case .nowPlaying:
            return viewModel.nowPlayingMovies.value
        case .popular:
            return viewModel.popularMovies.value
        case .topRated:
            return viewModel.topRatedMovies.value
        }
    }
}

extension HomeViewController {
    private func createLayout() -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout { [weak self] sectionIndex, _ -> NSCollectionLayoutSection? in
            guard let section = Section(rawValue: sectionIndex) else { return nil }
            
            switch section {
            case .carousel:
                return self?.createCarouselSection()
            case .movies:
                return self?.createMovieSection()
            }
        }
    }
    
    private func createCarouselSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(1)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.8),
            heightDimension: .fractionalHeight(0.3)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPagingCentered
        section.interGroupSpacing = 16
        section.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16)
        
        return section
    }
    
    private func createMovieSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .absolute(160)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .absolute(160)
        )
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: groupSize,
            subitems: [item]
        )
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 16
        section.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 16, bottom: 32, trailing: 16)
        
        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .estimated(64)
        )
        let header = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
        section.boundarySupplementaryItems = [header]
        
        return section
    }
}

extension HomeViewController: UICollectionViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let screenHeight = scrollView.frame.height
        
        // 스크롤이 하단에서 100포인트 남았을 때 추가 로드
        if offsetY > contentHeight - screenHeight - 100 {
            viewModel.loadMoreMovies()
        }
    }
}

extension HomeViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return Section.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let section = Section(rawValue: section) else { return 0 }
        
        switch section {
        case .carousel:
            return getMoviesForCurrentCategory().count
        case .movies:
            return getMoviesForCurrentCategory().count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let section = Section(rawValue: indexPath.section) else {
            return UICollectionViewCell()
        }
        
        let movies = getMoviesForCurrentCategory()
        
        switch section {
        case .carousel:
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: String(describing: CarouselCell.self),
                for: indexPath
            ) as! CarouselCell
            cell.configure(with: movies[indexPath.item])
            return cell
        case .movies:
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: String(describing: MovieCell.self),
                for: indexPath
            ) as! MovieCell
            cell.configure(with: movies[indexPath.row])
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                       viewForSupplementaryElementOfKind kind: String,
                       at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader,
              let section = Section(rawValue: indexPath.section) else {
            return UICollectionReusableView()
        }
        
        let header = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: String(describing: SectionHeaderView.self),
            for: indexPath
        ) as! SectionHeaderView
        
        switch section {
        case .carousel:
            break
        case .movies:
            header.configureWithCategories(viewModel.selectedCategory.value)
            header.categorySelected = { [weak self] category in
                // selectedCategory에 선택된 카테고리 업데이트
                UIView.transition(with: collectionView, duration: 0.25, options: .transitionCrossDissolve, animations: { [weak self] in
                    self?.viewModel.selectedCategory.accept(category)
                })
            }
        }
        
        return header
    }
}

extension HomeViewController {
    private func addSwipeGestures() {
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
        leftSwipe.direction = .left
        
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
        rightSwipe.direction = .right
        
        view.addGestureRecognizer(leftSwipe)
        view.addGestureRecognizer(rightSwipe)
    }
    
    @objc private func handleSwipe(_ gesture: UISwipeGestureRecognizer) {
        let categories: [MovieCategory] = [.nowPlaying, .popular, .topRated]
        guard let currentIndex = categories.firstIndex(of: viewModel.selectedCategory.value) else { return }
        
        var newIndex: Int
        switch gesture.direction {
        case .left:
            newIndex = min(currentIndex + 1, categories.count - 1)
        case .right:
            newIndex = max(currentIndex - 1, 0)
        default:
            return
        }
        
        let newCategory = categories[newIndex]
        
        UIView.transition(with: collectionView, duration: 0.25, options: .transitionCrossDissolve, animations: { [weak self] in
            self?.viewModel.selectedCategory.accept(newCategory)
        })
    }
}
