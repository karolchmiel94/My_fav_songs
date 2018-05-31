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
        let filters = FiltersContent.init()
        
        return filters
    }()
    
    private let possibleSongKeys = [SongKeys.artistName,
                            SongKeys.trackName,
                            SongKeys.primaryGenreName]
    private var selectedKey: SongKeys
    private var inputValue: String
    private var isDescending: Bool
    private var view: SongsFiltersView
    
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
    
    func getPossibleSongKeys() -> [SongKeys] {
        return possibleSongKeys
    }
    
    func getSongKeyAt(_ index: Int) -> SongKeys {
        return possibleSongKeys[index]
    }
    
    func getSelectedKey() -> SongKeys {
        return selectedKey
    }
    
    func getSelcetedKeyIndex() -> Int {
        if let index = possibleSongKeys.index(of: selectedKey) {
            return index
        }
        return 0
    }
    
    func getVisibleView() -> SongsFiltersView {
        return view
    }
    
    func setVisibleView(_ view: SongsFiltersView) {
        self.view = view
    }
    
    func setKey(forKeyAt index: Int) {
        selectedKey = possibleSongKeys[index]
        print("selected key: \(selectedKey.rawValue)")
    }
    
    func setIsDescending(_ isOn: Bool) {
        isDescending = isOn
    }
    
    func getIsDescending() -> Bool {
        return isDescending
    }

    func getInputValue() -> String {
        return inputValue
    }
    
}
