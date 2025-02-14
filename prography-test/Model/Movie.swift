//
//  Movie.swift
//  prography-test
//
//  Created by 이명지 on 2/15/25.
//

struct Movie: Decodable {
    let id: String
    let title: String
    let originalTitle: String
    let poster: String
    let overview: String
    let rate: Double
    let genres: [String]
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case originalTitle = "original_title"
        case poster = "poster_path"
        case overview
        case rate = "vote_average"
        case genres = "genre_ids"
    }
}
