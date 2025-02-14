//
//  Genre.swift
//  prography-test
//
//  Created by 이명지 on 2/15/25.
//

struct GenreResponse: Decodable {
    let genres: [Genre]
}

struct Genre: Decodable {
    let id: Int
    let name: String
}
