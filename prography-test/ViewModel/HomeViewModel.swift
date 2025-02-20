//
//  HomeViewModel.swift
//  prography-test
//
//  Created by 이명지 on 2/20/25.
//

import RxSwift
import RxCocoa

final class HomeViewModel {
    private var disposeBag = DisposeBag()
    private let movieRepository: MovieRepositoryProtocol
    
    private(set) var nowPlayingMovies = BehaviorRelay<[Movie]>(value: [])
    private(set) var popularMovies = BehaviorRelay<[Movie]>(value: [])
    private(set) var topRatedMovies = BehaviorRelay<[Movie]>(value: [])
    private(set) var selectedCategory = BehaviorRelay<MovieCategory>(value: .nowPlaying)
    
    init(movieRepository: MovieRepositoryProtocol = MovieRepository()) {
        self.movieRepository = movieRepository
    }
    
    func fetchNowPlayingMovies() {
        movieRepository.fetchMovies(of: .nowPlaying)
            .map { $0.results }
            .subscribe(
                onSuccess: { [weak self] movies in
                    self?.nowPlayingMovies.accept(movies)
                },
                onFailure: { error in
                    print("🚨 now playing 불러오기 오류:")
                    print(error)
                }
            )
            .disposed(by: disposeBag)
    }
    
    func fetchPopularMovies() {
        movieRepository.fetchMovies(of: .popular)
            .map { $0.results }
            .subscribe(
                onSuccess: { [weak self] movies in
                    self?.popularMovies.accept(movies)
                },
                onFailure: { error in
                    print("🚨 popular 불러오기 오류:")
                    print(error)
                }
            )
            .disposed(by: disposeBag)
    }
    
    func fetchTopRatedMovies() {
        movieRepository.fetchMovies(of: .topRated)
            .map { $0.results }
            .subscribe(
                onSuccess: { [weak self] movies in
                    self?.topRatedMovies.accept(movies)
                },
                onFailure: { error in
                    print("🚨 topRated 불러오기 오류:")
                    print(error)
                }
            )
            .disposed(by: disposeBag)
    }
    
    func updateSelectedCategory(_ category: MovieCategory) {
        selectedCategory.accept(category)
    }
}
