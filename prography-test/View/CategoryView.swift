//
//  CategoryView.swift
//  prography-test
//
//  Created by 이명지 on 2/20/25.
//

import UIKit

final class CategoryView: UICollectionView {
    private var categories = MovieCategory.allCases
    
    private(set) lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isPrefetchingEnabled = false
        collectionView.register(CategoryViewCell.self, forCellWithReuseIdentifier: String(describing: CategoryViewCell.self))
        
        return collectionView
    }()
}
