//
//  HomeViewController.swift
//  prography-test
//
//  Created by 이명지 on 2/19/25.
//

import UIKit

private enum Section: Int {
    case mainCarousel
    case movieTable
}

final class HomeViewController: UIViewController {
    private var viewModel: HomeViewModel
    private var carouselView = CarouselView()
    
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
        setupSubviews()
//        bind()
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
            carouselView
        ].forEach {
            view.addSubview($0)
        }
    }
    
//    private func bind() {
//        collectionView.rx.itemSelected
//            .map { indexPath -> MovieSectionType in
//                return MovieSectionType.allCases[indexPath.row]
//            }
//            .bind(onNext: { [weak self] type in
//                self?.viewModel.selectMovieType(type)
//            })
//            .disposed(by: disposeBag)
//        
//        viewModel.currentMovies
//            .observe(on: MainScheduler.instance)
//            .subscribe(onNext: { [weak self] movies in
//                print("데이터 로드됨: \(movies.count)개")  // 디버그 프린트 추가
//                self?.collectionView.reloadData()
//            })
//            .disposed(by: disposeBag)
//        
//        viewModel.error
//            .observe(on: MainScheduler.instance)
//            .subscribe(onNext: { [weak self] error in
//                print("에러 발생: \(error.localizedDescription)")
//                self?.showAlert(title: "데이터를 불러오는데 실패했습니다")
//            })
//            .disposed(by: disposeBag)
//        
//        viewModel.fetchNowPlayingMovies()
//        viewModel.fetchPopularMovies()
//        viewModel.fetchTopRatedMovies()
//    }
//}
//
//// MARK: - UICollectionViewDataSource
//extension HomeViewController: UICollectionViewDataSource {
//    func numberOfSections(in collectionView: UICollectionView) -> Int {
//        return 2
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        guard let section = Section(rawValue: section) else { return 0 }
//        
//        let movies = viewModel.currentMovies.value
//        
//        switch section {
//        case .mainCarousel:
//            return min(movies.count, 10)  // 메인 캐러셀은 최대 10개
//        case .movieTable:
//            return movies.count  // 테이블 섹션은 전체 표시
//        }
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        guard let section = Section(rawValue: indexPath.section) else {
//            return UICollectionViewCell()
//        }
//        
//        let movies = viewModel.currentMovies.value
//        let movie = movies[indexPath.item]
//        
//        switch section {
//        case .mainCarousel:
//            let cell = collectionView.dequeueReusableCell(
//                withReuseIdentifier: String(describing: CarouselViewCell.self),
//                for: indexPath
//            ) as! CarouselViewCell
//            cell.configure(with: movie)
//            return cell
//            
//        case .movieTable:
//            let cell = collectionView.dequeueReusableCell(
//                withReuseIdentifier: String(describing: MovieCell.self),
//                for: indexPath
//            ) as! MovieCell
//            cell.configure(with: movie)
//            return cell
//        }
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
//        guard kind == UICollectionView.elementKindSectionHeader,
//              let section = Section(rawValue: indexPath.section) else {
//            return UICollectionReusableView()
//        }
//        
//        let headerView = collectionView.dequeueReusableSupplementaryView(
//            ofKind: kind,
//            withReuseIdentifier: String(describing: SectionHeaderView.self),
//            for: indexPath
//        ) as! SectionHeaderView
//        
//        if section == .movieTable {
//            headerView.configure(with: viewModel.selectedType.value.title)
//        }
//        
//        return headerView
//    }
}

extension HomeViewController: UICollectionViewDelegate {
    
}

extension HomeViewController {
    private func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { [weak self] sectionIndex, layoutEnvironment -> NSCollectionLayoutSection? in
            guard let self = self else { return nil }
            
            let section = Section(rawValue: sectionIndex)
            switch section {
            case .mainCarousel:
                return self.createMainCarouselSection()
            case .movieTable:
                return self.createMovieTableSection()
            case .none:
                return nil
            }
        }
        return layout
    }
    
    // 메인 캐러셀뷰 섹션
    private func createMainCarouselSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.93),
            heightDimension: .fractionalHeight(0.7)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPaging
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 20, trailing: 16)
        section.interGroupSpacing = 10
        
        return section
    }
    
    // 영화 테이블뷰 섹션
    private func createMovieTableSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(150)
        )
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16)
        
        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(44)
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

extension HomeViewController {
    private func showAlert(title: String) {
        let alert = UIAlertController(
            title: title,
            message: nil,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "확인", style: .destructive))
        present(alert, animated: true)
    }
}
