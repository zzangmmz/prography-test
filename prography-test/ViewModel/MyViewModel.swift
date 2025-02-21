//
//  MyViewModel.swift
//  prography-test
//
//  Created by 이명지 on 2/21/25.
//

import RxSwift
import RxCocoa
import CoreData

final class MyViewModel {
    private let context = CoreDataManager.shared.context
    private var disposeBag = DisposeBag()
    private let movieRepository: MovieRepositoryProtocol
    
    private var reviewsRelay = BehaviorRelay<[Review]>(value: [])
    
    var reviews: Observable<[Review]> {
        return reviewsRelay.asObservable()
    }
    
    init(movieRepository: MovieRepositoryProtocol = MovieRepository()) {
        self.movieRepository = movieRepository
        테스트데이터()
    }
    
    func fetchReviews() {
        let request: NSFetchRequest<ReviewEntity> = ReviewEntity.fetchRequest()
        
        do {
            let entities = try context.fetch(request)
            let reviews = entities.map { entity in
                Review(
                    movieID: Int(entity.movieID),
                    movieTitle: entity.movieTitle,
                    poster: entity.poster,
                    overview: entity.overview,
                    myRate: Int(entity.myRate),
                    comment: entity.comment ?? "",
                    savedDate: entity.savedDate
                )
            }
            reviewsRelay.accept(reviews)
        } catch {
            print("리뷰 Fetch Failed: \(error.localizedDescription)")
        }
    }
}

extension MyViewModel {
    private func 테스트데이터() {
        movieRepository.fetchMovies(of: .nowPlaying, page: 1)
            .observe(on: MainScheduler.instance)
            .subscribe(
                onSuccess: { [weak self] response in
                    let reviews = response.results.map { movie in
                        Review(
                            movieID: movie.id,
                            movieTitle: movie.title,
                            poster: movie.poster ?? "",
                            overview: movie.overview,
                            myRate: Int.random(in: 1...5),
                            comment: "테스트 리뷰입니다......",
                            savedDate: Date()
                        )
                    }
                    self?.reviewsRelay.accept(reviews)
                },
                onFailure: { error in
                    print("🚨 테스트 데이터 불러오기 오류:", error)
                }
            )
            .disposed(by: disposeBag)
    }
    
    func 테스트페치() {
        테스트데이터()
    }
}
