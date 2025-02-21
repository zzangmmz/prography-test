//
//  Movie.swift
//  prography-test
//
//  Created by 이명지 on 2/15/25.
//

struct MovieResponse: Decodable {
    let dates: DateRange?
    let page: Int
    let results: [Movie]
    let totalPages: Int
    
    enum CodingKeys: String, CodingKey {
        case dates
        case page
        case results
        case totalPages = "total_pages"
    }
}

struct DateRange: Decodable {
    let maximum: String
    let minimum: String
}

struct Movie: Decodable {
    let id: Int
    let title: String
    let originalTitle: String
    let poster: String?
    let overview: String
    let rate: Double
    let genres: [Int]
    
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
