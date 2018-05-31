//
//  FiltersContent.swift
//  My fav songs
//
//  Created by Karol Ch on 30/05/2018.
//  Copyright © 2018 Karol Chmiel. All rights reserved.
//

import Foundation

class FiltersContent {
    private static let sharedFiltersContent: FiltersContent = {
        let filters = FiltersContent.init()
        
        return filters
    }()
    
    private let possibleSongKeys = [SongKeys.artistName,
                            SongKeys.trackName,
                            SongKeys.primaryGenreName]
    private var selectedKey: SongKeys
    private var inputValue: String
    private var isDescending: Bool
    
    private init() {
        self.selectedKey = possibleSongKeys[0]
        self.inputValue = ""
        self.isDescending = true
    }
    
    class func shared() -> FiltersContent {
        return sharedFiltersContent
    }
}

