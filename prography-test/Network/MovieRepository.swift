//
//  MovieRepository.swift
//  prography-test
//
//  Created by 이명지 on 2/18/25.
//

import Foundation
import Moya
import RxMoya
import RxSwift

protocol MovieRepositoryProtocol {
    func fetchMovies(of endPoint: MovieAPI) -> Single<MovieResponse>
    func fetchMovieDetail(id: Int) -> Single<Movie>
    func fetchMoviePoster(path: String) -> Single<URL>
}

final class MovieRepository: MovieRepositoryProtocol {
    private var provider = MoyaProvider<MovieAPI>()
    
    init(provider: MoyaProvider<MovieAPI> = MoyaProvider<MovieAPI>()) {
        self.provider = provider
    }
    
    func fetchMovies(of endPoint: MovieAPI) -> Single<MovieResponse> {
        provider.rx.request(endPoint)
            .map(MovieResponse.self)
    }
    
    func fetchMovieDetail(id: Int) -> Single<Movie> {
        provider.rx.request(.movie(id: id))
            .map(Movie.self)
    }
    
    func fetchMoviePoster(path: String) -> Single<URL> {
        provider.rx.request(.poster(path: path))
            .map(URL.self)
    }
}
