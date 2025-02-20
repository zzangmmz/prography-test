//
//  HomeViewModel.swift
//  prography-test
//
//  Created by 이명지 on 2/20/25.
//

final class HomeViewModel {
    private let movieRepository: MovieRepositoryProtocol
    
    private(set) var nowPlayingMovies = [Movie]()
    private(set) var popularMovies = [Movie]()
    private(set) var topRatedMovies = [Movie]()
    
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
