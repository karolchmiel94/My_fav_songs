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
    let coreDataService: CoreDataProtocol
    
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
    
    var savingSong: Bool = false {
        didSet {
            self.saveSongModal?()
        }
    }
    
    var numberOfCells: Int {
        return cellViewModels.count
    }
    
    var selectedSong: Song?
    
    var reloadTableViewClosure: (()->())?
    var showAlertClosure: (()->())?
    var updateLoadingStatus: (()->())?
    var saveSongModal: (()->())?
    
    init(apiService: APIProtocol = WebService(), appDelegate: AppDelegate) {
        self.apiService = apiService
        self.coreDataService = CoreDataService(with: appDelegate)
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
        for song in data.results {
            vms.append(createCellViewModel(song: song))
        }
        self.cellViewModels = vms
    }
}

extension SongsSearchViewModel {
    func saveSong(at indexPath: Int) {
        let song = self.data.results[indexPath]
        self.selectedSong = song
        self.savingSong = true
        coreDataService.saveSong(song, onSuccess: { (isSuccess) in
            self.savingSong = false
        }) { (error) in
            print(error)
        }
    }
}
