//
//  MovieSection.swift
//  prography-test
//
//  Created by 이명지 on 2/20/25.
//

import Differentiator

struct MovieSection {
    var header: String
    var items: [Movie]
}

extension MovieSection: SectionModelType {
    init(original: MovieSection, items: [Movie]) {
        self = original
        self.items = items
    }
}
