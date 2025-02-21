//
//  MovieCategory.swift
//  prography-test
//
//  Created by 이명지 on 2/20/25.
//

enum MovieCategory: Int, CaseIterable {
    case nowPlaying
    case popular
    case topRated
    
    var title: String {
        switch self {
        case .nowPlaying:
            return "Now Playing"
        case .popular:
            return "Popular"
        case .topRated:
            return "Top Rated"
        }
    }
}
