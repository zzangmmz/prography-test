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
    func fetchMovies(of category: MovieCategory, page: Int) -> Single<MovieResponse>
    func fetchMovieDetail(id: Int) -> Single<MovieDetail>
    func fetchMoviePoster(path: String) -> Single<URL>
}

final class MovieRepository: MovieRepositoryProtocol {
    private var provider = MoyaProvider<MovieAPI>()
    
    init(provider: MoyaProvider<MovieAPI> = MoyaProvider<MovieAPI>()) {
        self.provider = provider
    }
    
    func fetchMovies(of category: MovieCategory, page: Int = 1) -> Single<MovieResponse> {
        let endpoint: MovieAPI
        
        switch category {
        case .nowPlaying:
            endpoint = .nowPlaying(page: page)
        case .popular:
            endpoint = .popular(page: page)
        case .topRated:
            endpoint = .topRated(page: page)
        }
        
        return provider.rx.request(endpoint)
            .map(MovieResponse.self)
    }
    
    func fetchMovieDetail(id: Int) -> Single<MovieDetail> {
        provider.rx.request(.movie(id: id))
            .map(MovieDetail.self)
    }
    
    func fetchMoviePoster(path: String) -> Single<URL> {
        provider.rx.request(.poster(path: path))
            .map(URL.self)
    }
}
