//
//  ReviewViewModel.swift
//  prography-test
//
//  Created by 이명지 on 2/21/25.
//

import Foundation
import RxSwift
import RxCocoa
import CoreData

final class ReviewViewModel {
    private let movieRepository: MovieRepositoryProtocol
    private let disposeBag = DisposeBag()
    private let context = CoreDataManager.shared.context
    
    let movieID: Int
    
    let movie = BehaviorRelay<Movie?>(value: nil)
    let userReview = BehaviorRelay<Review?>(value: nil)
    let error = PublishRelay<Error>()
    
    init(movieID: Int, movieRepository: MovieRepositoryProtocol = MovieRepository()) {
        self.movieID = movieID
        self.movieRepository = movieRepository
        
    }
}
