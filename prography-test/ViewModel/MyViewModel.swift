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
