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
    
    // If you make enum "inherit" from String, you can simply use `rawValue` to achieve the same what you did in this method.
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
    
    func prettyDescription() -> String {
        switch self {
        case .artistName:
            return "Artist Name"
        case .trackName:
            return "Track Name"
        case .artworkUrl100:
            return "Artwork url"
        case .primaryGenreName:
            return "Music Genre"
        }
    }
}
