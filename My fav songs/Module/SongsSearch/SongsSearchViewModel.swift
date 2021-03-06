//
//  SongsSearchViewModel.swift
//  My fav songs
//
//  Created by Karol Ch on 17/05/2018.
//  Copyright © 2018 Karol Chmiel. All rights reserved.
//

import Foundation

// Just like in SavedSongsVM, I got rid of unnecessary properties replacing them with closures.
class SongsSearchViewModel {
    
    private var data: ResultData
    private let apiService: APIProtocol
    private let coreDataService: CoreDataOperationsProtocol
    
    private var cellViewModels: [SongListCellViewModel] = [SongListCellViewModel]() {
        didSet {
            self.reloadTableViewClosure?()
        }
    }
    
    var selectedSong: Song?
    
    var reloadTableViewClosure: (()->())?
    var showAlertClosure: ((Error)->Void)?
    var showLoadingStatus: ((Bool)->(Void))?
    var saveSongModal: (()->())?
    
    init(apiService: APIProtocol = WebService(), appDelegate: AppDelegate) {
        self.apiService = apiService
        self.coreDataService = CoreDataService(with: appDelegate)
        self.data = ResultData(resultCount: Int(), results: [Song]())
    }
    
    func searchForSongs(_ query: String) {
        self.showLoadingStatus?(true)
        apiService.fetchSongs(query: query, onSuccess: { (resultData) in
            self.processFetchedSongs(resultData)
            self.showLoadingStatus?(false)
        }, onFailure: { (error) in
            self.showAlertClosure?(error)
        })
    }
    
    func getCellViewModel(at indexPath: IndexPath) -> SongListCellViewModel {
        return cellViewModels[indexPath.row]
    }
    
    func getNumberOfCells() -> Int {
        return cellViewModels.count
    }
    
    private func createCellViewModel(song: Song) -> SongListCellViewModel {
        return SongListCellViewModel(artistNameText: song.artistName,
                                     songTitleText: song.trackName,
                                     artworkUrl: song.artworkUrl100,
                                     genreText: "Genre: \(song.primaryGenreName)")
    }
    
    private func processFetchedSongs(_ data: ResultData) {
        self.data = data
        self.cellViewModels = data.results.map({createCellViewModel(song: $0)})
    }
}

extension SongsSearchViewModel {
    func saveSong(at indexPath: Int) {
        let song = self.data.results[indexPath]
        self.selectedSong = song
        self.saveSongModal?()
        coreDataService.saveSong(song, onSuccess: { (isSuccess) in
        }) { (error) in
            self.showAlertClosure?(error)
        }
    }
}
