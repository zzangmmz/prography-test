//
//  HomeViewModel.swift
//  prography-test
//
//  Created by 이명지 on 2/20/25.
//

import RxSwift
import RxRelay

final class HomeViewModel {
    private var disposeBag = DisposeBag()
    private let movieRepository: MovieRepositoryProtocol
    
    private(set) var movies = BehaviorRelay<[Movie]>(value: [])
    private(set) var error = PublishRelay<Error>()
    
    init(movieRepository: MovieRepositoryProtocol = MovieRepository()) {
        self.movieRepository = movieRepository
    }
    
    func fetchNowPlayingMovies() {
        movieRepository.fetchMovies(of: .nowPlaying)
            .subscribe(
                onSuccess: { [weak self] response in
                    self?.movies.accept(response.results)
                },
                onFailure: { [weak self] error in
                    self?.error.accept(error)
                }
            )
            .disposed(by: disposeBag)
    }
    
    func fetchPopularMovies() {
        movieRepository.fetchMovies(of: .popular)
            .subscribe(
                onSuccess: { [weak self] response in
                    self?.movies.accept(response.results)
                },
                onFailure: { [weak self] response in
                    self?.error.accept(response)
                }
            )
            .disposed(by: disposeBag)
    }
    
    func fetchTopRatedMovies() {
        movieRepository.fetchMovies(of: .topRated)
            .subscribe(
                onSuccess: { [weak self] response in
                    self?.movies.accept(response.results)
                },
                onFailure: { [weak self] response in
                    self?.error.accept(response)
                }
            )
            .disposed(by: disposeBag)
    }
}
