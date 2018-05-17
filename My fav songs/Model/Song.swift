//
//  E.swift
//  My fav songs
//
//  Created by Karol Ch on 16/05/2018.
//  Copyright © 2018 Karol Chmiel. All rights reserved.
//

import Foundation

struct Song: Decodable {
    let artistName: String
    let trackName: String
    let artworkUrl100: String
    let primaryGenreName: String
}

enum SongKeys {
    case artistName, trackName, artworkUrl100, primaryGenreName
    func stringValue() -> String {
        switch self {
        case .artistName:
            return "artistName"
        case .trackName:
            return "trackName"
        case .artworkUrl100:
            return "artworkUrl100"
        case .primaryGenreName:
            return "primaryGenreName"
        }
    }
}
