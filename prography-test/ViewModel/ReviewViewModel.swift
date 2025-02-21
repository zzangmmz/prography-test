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
        
        fetchMovieData()
        fetchUserReview()
    }
    
    // MARK: - TMDB API
    private func fetchMovieData() {
        movieRepository.fetchMovieDetail(id: movieID)
            .observe(on: MainScheduler.instance)
            .subscribe(
                onSuccess: { [weak self] movie in
                    self?.movie.accept(movie)
                },
                onFailure: { [weak self] error in
                    self?.error.accept(error)
                }
            )
            .disposed(by: disposeBag)
    }
    
    // MARK: - CoreData
    private func fetchUserReview() {
        let request: NSFetchRequest<ReviewEntity> = ReviewEntity.fetchRequest()
        request.predicate = NSPredicate(format: "movieID == %d", movieID)
        
        do {
            if let reviewEntity = try context.fetch(request).first {
                let review = Review(
                    movieID: Int(reviewEntity.movieID),
                    movieTitle: reviewEntity.movieTitle,
                    poster: reviewEntity.poster,
                    overview: reviewEntity.overview,
                    myRate: Int(reviewEntity.myRate),
                    comment: reviewEntity.comment ?? "",
                    savedDate: reviewEntity.savedDate
                )
                userReview.accept(review)
            }
        } catch {
            self.error.accept(error)
        }
    }
}
