//
//  SavedSongsViewModel.swift
//  My fav songs
//
//  Created by Karol Ch on 17/05/2018.
//  Copyright © 2018 Karol Chmiel. All rights reserved.
//

import Foundation

// Cosidering your propositions, I have removed dumb and useless alertMessage, isLoading and deleteModal properties.
// I have created closures for them which provide data to VC.
class SavedSongsViewModel {
    
    private var data = [Song]()
    private let coreDataService: CoreDataOperationsProtocol
    
    private var cellViewModels: [SongListCellViewModel] = [SongListCellViewModel]() {
        didSet {
            self.reloadTableViewClosure?()
        }
    }
    
    private var selectedSong: Song?
    
    var reloadTableViewClosure: (()->())?
    var showAlertClosure: ((Error)->Void)?
    var showLoadingStatus: ((Bool)->Void)?
    var deleteSongModal: (()->())?
    
    init(appDelegate: AppDelegate) {
        self.coreDataService = CoreDataService(with: appDelegate)
    }
    
    func fetchSongs() {
        self.showLoadingStatus?(true)
        coreDataService.fetchSongs(onSuccess: { (songs) in
            self.processFetchedSongs(songs)
            self.showLoadingStatus?(false)
        }) { (error) in
            self.showAlertClosure?(error)
        }
    }
    
    func getCellViewModel(at indexPath: IndexPath) -> SongListCellViewModel {
        return cellViewModels[indexPath.row]
    }
    
    func getNumberOfCells() -> Int {
        return cellViewModels.count
    }
    
    func createCellViewModel(song: Song) -> SongListCellViewModel {
        return SongListCellViewModel(artistNameText: song.artistName,
                                     songTitleText: song.trackName,
                                     artworkUrl: song.artworkUrl100,
                                     genreText: "Genre: \(song.primaryGenreName)")
    }
    
    private func processFetchedSongs(_ data: [Song]) {
        self.data = data
        
        // Try to fit the lines below into one line with some of Swift's magic ;)
        // I've tried to find that solution on web but had no idea what term to look for
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
        self.deleteSongModal?()
        coreDataService.deleteSong(song, onSuccess: { (success) in
        }) { (error) in
            self.showAlertClosure?(error)
        }
    }
    
}

extension SavedSongsViewModel: SongsFiltersDelegate {
    func filterSongsBy(_ songDataType: SongKeys, _ ascending: Bool) {
        self.showLoadingStatus?(true)
        coreDataService.sortSongsBy(songDataType, ascending, onSuccess: { (songs) in
            self.processFetchedSongs(songs)
            self.showLoadingStatus?(false)
        }) { (error) in
            self.showAlertClosure?(error)
        }
    }
    
    func searchSongBy(_ text: String, _ songDataType: SongKeys) {
        self.showLoadingStatus?(true)
        coreDataService.searchSongsFor(text, songDataType, onSuccess: { (songs) in
            self.processFetchedSongs(songs)
            self.showLoadingStatus?(false)
        }) { (error) in
            self.showAlertClosure?(error)
        }
    }
    
}
