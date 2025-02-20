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
        
    }
    
    func fetchPopularMovies() {
        
    }
    
    func fetchTopRatedMovies() {
        
    }
}
