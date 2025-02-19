//
//  HomeViewController.swift
//  prography-test
//
//  Created by 이명지 on 2/19/25.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

private enum Section: Int {
    case mainCarousel
    case movieTable
}

final class HomeViewController: UIViewController {
    private var disposebag = DisposeBag()
    private var viewModel: HomeViewModel
    private var collectionView = UICollectionView()
    
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
        setupCompositionalLayout()
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
    
    // MARK: - 컴포지셔널 레이아웃
    private func setupCompositionalLayout() {
        collectionView = UICollectionView(
            frame: view.bounds,
            collectionViewLayout: createLayout()
        )
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .systemBackground
        view.addSubview(collectionView)
        
        registerCells()
    }
    
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
    
    private func registerCells() {
        collectionView.register(
            CarouselViewCell.self,
            forCellWithReuseIdentifier: String(describing: CarouselViewCell.self)
        )
        collectionView.register(
            MovieCell.self,
            forCellWithReuseIdentifier: String(describing: Movie.self)
        )
        collectionView.register(
            SectionHeaderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: String(describing: SectionHeaderView.self)
        )
    }
    
    private lazy var dataSource = RxCollectionViewSectionedReloadDataSource<MovieSection>(
        configureCell: { [weak self] dataSource, collectionView, indexPath, movie in
            switch Section(rawValue: indexPath.section) {
            case .mainCarousel:
                let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: String(describing: CarouselViewCell.self),
                    for: indexPath
                ) as! CarouselViewCell
                cell.configure(with: movie)
                return cell
            case .movieTable:
                let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: String(describing: MovieCell.self),
                    for: indexPath
                ) as! MovieCell
                cell.configure(with: movie)
                return cell
            case .none:
                return UICollectionViewCell()
            }
        },
        configureSupplementaryView: { [weak self] dataSource, collectionView, kind, indexPath in
            guard kind == UICollectionView.elementKindSectionHeader else {
                return UICollectionReusableView()
            }
            
            let headerView = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: String(describing: SectionHeaderView.self),
                for: indexPath
            ) as! SectionHeaderView
            
            if indexPath.section == Section.movieTable.rawValue {
                headerView.configure(with: "Now Playing")
            }
            
            return headerView
        }
    )
}
