//
//  SavedSongsViewModel.swift
//  My fav songs
//
//  Created by Karol Ch on 17/05/2018.
//  Copyright © 2018 Karol Chmiel. All rights reserved.
//

import Foundation

// We have a couple of doubts about the architecture of this VM.
// What you're doing here is, using example of alertMessage:
// - create a mutable non-private String property, which runs optional `showAlertClosure` on state changes
// - inside the VC, `showAlertClosure` is configured to read the value of `alertMessage` and show the alert with it.
// This seems both a bit overcomplicated and not 100% safe.
// Consider refactoring this in a way to remove mutable state or at least make it private, and taking bigger advantage
// of closures.
// Using example of `alertMessage`, you could:
// - remove `alertMessage` property
// - change `showAlertClosure` type to ((Error) -> Void)?
// - assign showing alert to this closure from the VC
// - change all lines `self.alertMessage = error as? String` to `self.showAlertClosure(error)`
// However, if you feel that the solution we're proposing is for some reason worse that the one here, feel free to explain to us why :)
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
            // Use error.localizedDescription
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
        
        // Try to fit the lines below into one line with some of Swift's magic ;)
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
