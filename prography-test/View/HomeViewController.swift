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
