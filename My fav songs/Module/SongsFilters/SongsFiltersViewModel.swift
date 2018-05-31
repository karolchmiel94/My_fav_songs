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
                             songFilters.getInputValue(),
                             songFilters.getIsDescending(),
                             songFilters.getVisibleView().hashValue)
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
        return songFilters.getPossibleSongKeys()[index]
    }
    
    func getSelectedComponent() -> SongKeys {
        return songFilters.getSelectedKey()
    }
    
    func numberOfPickerComponents() -> Int {
        return songFilters.getPossibleSongKeys().count
    }
    
    func setSelectedKey(at index: Int) {
        songFilters.setKey(forKeyAt: index)
    }
    
}
