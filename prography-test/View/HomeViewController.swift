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
    private var collectionView = UICollectionView()
    
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
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
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
}
