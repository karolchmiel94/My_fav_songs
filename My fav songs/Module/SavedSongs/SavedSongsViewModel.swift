//
//  SavedSongsViewModel.swift
//  My fav songs
//
//  Created by Karol Ch on 17/05/2018.
//  Copyright © 2018 Karol Chmiel. All rights reserved.
//

import Foundation

class SavedSongsViewModel {
    
    private var data = [Song]()
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
    
    var deletingSong: Bool = false {
        didSet {
            self.deleteSongModal?()
        }
    }
    
    var numberOfCells: Int {
        return cellViewModels.count
    }
    
    var selectedSong: Song?
    
    var reloadTableViewClosure: (()->())?
    var showAlertClosure: (()->())?
    var updateLoadingStatus: (()->())?
    var deleteSongModal: (()->())?
    
    init(appDelegate: AppDelegate) {
        self.coreDataService = CoreDataService(with: appDelegate)
    }
    
    func fetchSongs() {
        self.isLoading = true
        coreDataService.fetchSongs(onSuccess: { (songs) in
            self.processFetchedSongs(songs)
            self.isLoading = false
        }) { (error) in
            self.alertMessage = error as? String
        }
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
    
    private func processFetchedSongs(_ data: [Song]) {
        self.data = data
        var vms = [SongListCellViewModel]()
        for song in data {
            vms.append(createCellViewModel(song: song))
        }
        self.cellViewModels = vms
    }
}

extension SavedSongsViewModel {
    func deleteSong(at indexPath: Int) {
        let song = self.data[indexPath]
        self.selectedSong = song
        self.deletingSong = true
        coreDataService.deleteSong(song, onSuccess: { (success) in
            self.deletingSong = false
        }) { (error) in
            self.alertMessage = error as? String
        }
    }
    
}

extension SavedSongsViewModel: DataDelegate {
    func filterSongsBy(_ songDataType: SongKeys, _ ascending: Bool) {
        self.isLoading = true
        coreDataService.sortSongsBy(songDataType, ascending, onSuccess: { (songs) in
            self.processFetchedSongs(songs)
            self.isLoading = false
        }) { (error) in
            self.alertMessage = error as? String
        }
    }
    
    func searchSongBy(_ text: String, _ songDataType: SongKeys) {
        self.isLoading = true
        coreDataService.searchSongsFor(text, songDataType, onSuccess: { (songs) in
            self.processFetchedSongs(songs)
            self.isLoading = false
        }) { (error) in
            self.alertMessage = error as? String
        }
    }
    
}
