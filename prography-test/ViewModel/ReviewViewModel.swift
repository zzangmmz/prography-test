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
    let movieDetail = BehaviorRelay<MovieDetail?>(value: nil)
    let userReview = BehaviorRelay<Review?>(value: nil)
    let error = PublishRelay<Error>()
    
    let reviewStateChanged = PublishRelay<Void>()
    
    init(movieID: Int, movieRepository: MovieRepositoryProtocol = MovieRepository()) {
        self.movieID = movieID
        self.movieRepository = movieRepository
        
        fetchMovieData()
        fetchUserReview()
        setupReviewStateBinding()
    }
    
    private func setupReviewStateBinding() {
        reviewStateChanged
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                self?.fetchUserReview()
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: - TMDB API
    private func fetchMovieData() {
        movieRepository.fetchMovieDetail(id: movieID)
            .observe(on: MainScheduler.instance)
            .subscribe(
                onSuccess: { [weak self] movie in
                    self?.movieDetail.accept(movie)
                },
                onFailure: { [weak self] error in
                    self?.error.accept(error)
                }
            )
            .disposed(by: disposeBag)
    }
    
    // MARK: - CoreData
    func fetchUserReview() {
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
                    comment: reviewEntity.comment,
                    savedDate: reviewEntity.savedDate
                )
                userReview.accept(review)
            } else {
                // 리뷰가 없는 경우 nil!!
                userReview.accept(nil)
            }
        } catch {
            self.error.accept(error)
        }
    }
    
    // TODO: - 리뷰 수정/삭제
}
