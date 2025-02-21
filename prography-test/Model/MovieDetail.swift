//
//  MovieDetail.swift
//  prography-test
//
//  Created by 이명지 on 2/21/25.
//

struct MovieDetail: Decodable {
    let id: Int
    let title: String
    let originalTitle: String
    let poster: String
    let overview: String
    let rate: Double
    let genres: [Genre]
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case originalTitle = "original_title"
        case poster = "poster_path"
        case overview
        case rate = "vote_average"
        case genres
    }
}
