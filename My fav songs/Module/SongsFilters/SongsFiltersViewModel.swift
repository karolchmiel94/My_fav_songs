//
//  SongsFiltersViewModel.swift
//  My fav songs
//
//  Created by Karol Ch on 24/05/2018.
//  Copyright © 2018 Karol Chmiel. All rights reserved.
//

import Foundation

class SongsFiltersViewModel {
    
    private var songFilters = FiltersContent.shared()
    
    var restoreFilters: ((Int,String,Bool,Int)->Void)?
    
    func fetchPickerComponents() {
        self.restoreFilters?(songFilters.getSelcetedKeyIndex(),
                             songFilters.inputValue,
                             songFilters.isDescending,
                             songFilters.view.hashValue)
    }
    
    func saveSearch(_ term: String) {
        songFilters.setInputValue(term)
    }
    
    func saveSwitchChange(_ isOn: Bool) {
        songFilters.setIsDescending(isOn)
    }
    
    func saveCurrentView(_ view: SongsFiltersView) {
        songFilters.setVisibleView(view)
    }
    
    func getPickerComponent(at index: Int) -> SongKeys {
        return songFilters.possibleSongKeys[index]
    }
    
    func getSelectedComponent() -> SongKeys {
        return songFilters.selectedKey
    }
    
    func numberOfPickerComponents() -> Int {
        return songFilters.possibleSongKeys.count
    }
    
    func setSelectedKey(at index: Int) {
        songFilters.setKey(forKeyAt: index)
    }
    
}
