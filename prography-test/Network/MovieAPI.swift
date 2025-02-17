//
//  MovieAPI.swift
//  prography-test
//
//  Created by 이명지 on 2/17/25.
//

import Moya
import Foundation

enum MovieAPI {
    case nowPlaying
    case popular
    case topRated
    case movie(id: Int)
    case poster(path: String)
}

extension MovieAPI: TargetType {
    var baseURL: URL {
        switch self {
        case .nowPlaying, .popular, .topRated, .movie:
            guard let url = URL(string: "https://api.themoviedb.org/3/movie") else {
                fatalError("base URL이 올바르지 않습니다.")
            }
            return url
        case .poster:
            guard let url = URL(string: "https://image.tmdb.org/t/p/original") else {
                fatalError("이미지 base URL이 올바르지 않습니다.")
            }
            return url
        }
    }
    
    var path: String {
        switch self {
        case .nowPlaying:
            return "/now_playing"
        case .popular:
            return "/popular"
        case .topRated:
            return "/top_rated"
        case .movie(let id):
            return "/\(id)"
        case .poster(let path):
            return "/\(path)"
        }
    }
    
    var method: Moya.Method {
        return .get
    }
    
    var task: Moya.Task {
        switch self {
        case .nowPlaying, .popular, .topRated, .movie:
            let parameters: [String: Any] = [
                "language": "ko-KR",
                "page": 1
            ]
            return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
        case .poster:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        switch self {
        default:
            return [
                "Authorization": "Bearer \(Constants.accessToken)",
                "accept": "application/json"
            ]
        }
    }
}
