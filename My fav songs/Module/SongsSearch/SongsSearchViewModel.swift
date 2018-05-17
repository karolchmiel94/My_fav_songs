//
//  SongsSearchViewModel.swift
//  My fav songs
//
//  Created by Karol Ch on 17/05/2018.
//  Copyright © 2018 Karol Chmiel. All rights reserved.
//

import Foundation

class SongsSearchViewModel {
    
    private var data: ResultData
    let apiService: APIProtocol
    
    private var cellViewModels: [SongListCellViewModel] = [SongListCellViewModel]() {
        didSet {
            self.reloadTableViewClosure?()
        }
    }
    
    var isLoading: Bool = false {
        didSet {
            self.updateLoadingStatus?()
        }
    }
    
    var alertMessage: String? {
        didSet {
            self.showAlertClosure?()
        }
    }
    
    var numberOfCells: Int {
        return cellViewModels.count
    }
    
    var selectedSong: Song?
    
    var reloadTableViewClosure: (()->())?
    var showAlertClosure: (()->())?
    var updateLoadingStatus: (()->())?
    
    init(apiService: APIProtocol = WebService()) {
        self.apiService = apiService
        self.data = ResultData(resultCount: Int(), results: [Song]())
    }
    
    func searchForSongs(_ query: String) {
        self.isLoading = true
        apiService.fetchSongs(query: query, onSuccess: { (resultData) in
            self.processFetchedSongs(resultData)
            self.isLoading = false
        }, onFailure: { (error) in
            self.alertMessage = error as? String
        })
    }
    
    func getCellViewModel(at indexPath: IndexPath) -> SongListCellViewModel {
        return cellViewModels[indexPath.row]
    }
    
    func createCellViewModel(song: Song) -> SongListCellViewModel {
        return SongListCellViewModel(artistNameText: song.artistName,
                                     songTitleText: song.trackName,
                                     artworkUrl: song.artworkUrl100,
                                     genreText: "Genre: \(song.primaryGenreName)")
    }
    
    private func processFetchedSongs(_ data: ResultData) {
        self.data = data
        var vms = [SongListCellViewModel]()
        for song in data.results! {
            vms.append(createCellViewModel(song: song))
        }
        self.cellViewModels = vms
    }
}

extension SongsSearchViewModel {
    func saveSong(at indexPath: Int) {
        let song = self.data.results![indexPath]
        self.selectedSong = song
        print(song.artistName + ": " + song.trackName + " saved.")
        // Save song in local database
    }
}

struct SongListCellViewModel {
    let artistNameText: String
    let songTitleText: String
    let artworkUrl: String
    let genreText: String
}
