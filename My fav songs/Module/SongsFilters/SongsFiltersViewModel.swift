//
//  SongsFiltersViewModel.swift
//  My fav songs
//
//  Created by Karol Ch on 24/05/2018.
//  Copyright © 2018 Karol Chmiel. All rights reserved.
//

import Foundation

class SongsFiltersViewModel {
    
    private let pickerComponents = [SongKeys.artistName,
                                              SongKeys.trackName,
                                              SongKeys.primaryGenreName]
    
    private var selectedComponent: SongKeys
    private var songFilters = FiltersContent.shared()
    
    init() {
        self.selectedComponent = pickerComponents[0]
        print(songFilters)
    }
    
    var loadPickerComponentsClosure: (([SongKeys])-> Void)?
    
    func fetchPickerComponents() {
        self.loadPickerComponentsClosure!(pickerComponents)
    }
    
    func getPickerComponent(at index: Int) -> SongKeys {
        return pickerComponents[index]
    }
    
    func getSelectedComponent() -> SongKeys {
        return selectedComponent
    }
    
    func numberOfPickerComponents() -> Int {
        return pickerComponents.count
    }
    
    func setSelectedKey(at index: Int) {
        selectedComponent = pickerComponents[index]
    }
}
