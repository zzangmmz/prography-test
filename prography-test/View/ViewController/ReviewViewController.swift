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
    private var disposeBag = DisposeBag()
    private var movieID: Int
    private var review: Review?
    
    init(movieID: Int) {
        self.movieID = movieID
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
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
}
