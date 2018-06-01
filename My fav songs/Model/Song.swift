//
//  E.swift
//  My fav songs
//
//  Created by Karol Ch on 16/05/2018.
//  Copyright © 2018 Karol Chmiel. All rights reserved.
//

import Foundation
import CoreData

class Song: Decodable {
    let artistName: String
    let trackName: String
    let artworkUrl100: String
    let primaryGenreName: String
    
    init(_ artistName: String, trackName: String, artworkUrl: String, primaryGenreName: String) {
        self.artistName = artistName
        self.trackName = trackName
        self.artworkUrl100 = artworkUrl
        self.primaryGenreName = primaryGenreName
    }
    
    init(from song: Songs) {
        self.artistName = song.artistName ?? ""
        self.trackName = song.trackName ?? ""
        self.artworkUrl100 = song.artworkUrl100 ?? ""
        self.primaryGenreName = song.primaryGenreName ?? ""
    }
}

enum SongKeys: String {
    case artistName, trackName, artworkUrl100, primaryGenreName
    
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
