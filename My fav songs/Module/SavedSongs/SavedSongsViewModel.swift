//
//  SavedSongsViewModel.swift
//  My fav songs
//
//  Created by Karol Ch on 17/05/2018.
//  Copyright © 2018 Karol Chmiel. All rights reserved.
//

import Foundation

class SavedSongsViewModel {
    
    private var data: ResultData
    
    private var cellViewModels: [SongTableViewCell] = [SongTableViewCell]() {
        didSet {
//            self.reloadTableViewClosure?()
        }
    }
    
    var alertMessage: String? {
        didSet {
//            self.showAlertClosure?()
        }
    }
    
    var numberOfCells: Int {
        return cellViewModels.count
    }
    
    var selectedCell: Song?
    
    var reloadTableViewClosure: (()->())?
    var showAlertClosure: (()->())?
    var updateLoadingStatus: (()->())?
    
    init() {
        self.data = ResultData(resultCount: 1, results: [Song]())
    }
}
