//
//  Constants.swift
//  prography-test
//
//  Created by 이명지 on 2/18/25.
//

import Foundation

struct Constants {
    static let accessToken: String = {
        guard let accessToken = Bundle.main.infoDictionary?["AccessToken"] as? String else {
            fatalError("Info.plist에서 Access Token을 읽어오지 못했습니다.")
        }
        return accessToken
    }()
}
