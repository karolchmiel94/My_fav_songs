//
//  FiltersContent.swift
//  My fav songs
//
//  Created by Karol Ch on 30/05/2018.
//  Copyright © 2018 Karol Chmiel. All rights reserved.
//

import Foundation

enum SongsFiltersView {
    case search, filter
}

class FiltersContent {
    private static let sharedFiltersContent: FiltersContent = {
        return FiltersContent.init()
    }()
    
    let possibleSongKeys = [SongKeys.artistName,
                            SongKeys.trackName,
                            SongKeys.primaryGenreName]
    private(set) var selectedKey: SongKeys
    private(set) var inputValue: String
    private(set) var isDescending: Bool
    private(set) var view: SongsFiltersView
    
    private init() {
        self.selectedKey = possibleSongKeys[0]
        self.inputValue = ""
        self.isDescending = true
        self.view = .search
    }
    
    class func shared() -> FiltersContent {
        return sharedFiltersContent
    }
    
    func setInputValue(_ inputValue: String) {
        self.inputValue = inputValue
    }
    
    func getSongKeyAt(_ index: Int) -> SongKeys {
        return possibleSongKeys[index]
    }

    func getSelcetedKeyIndex() -> Int {
        if let index = possibleSongKeys.index(of: selectedKey) {
            return index
        }
        return 0
    }
    
    func setVisibleView(_ view: SongsFiltersView) {
        self.view = view
    }
    
    func setKey(forKeyAt index: Int) {
        selectedKey = possibleSongKeys[index]
    }
    
    func setIsDescending(_ isOn: Bool) {
        isDescending = isOn
    }
    
}
