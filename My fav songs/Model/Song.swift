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
