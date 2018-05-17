//
//  CoreDataService.swift
//  My fav songs
//
//  Created by Karol Ch on 17/05/2018.
//  Copyright © 2018 Karol Chmiel. All rights reserved.
//

import Foundation
import CoreData

protocol CoreDataProtocol {
    func fetchSongs(onSuccess: @escaping([Song]) -> Void, onFailure: @escaping(Error) -> Void)
    func saveSong(_ song: Song, onSuccess: @escaping(Bool) -> Void, onFailure: @escaping(Error) -> Void)
}

class CoreDataService: CoreDataProtocol {
    
    let ENTITY_NAME = "Songs"

    let appDelegate: AppDelegate
    var context: NSManagedObjectContext
    let entity: NSEntityDescription

    init(with appDelegate: AppDelegate) {
        self.appDelegate = appDelegate
        self.context = appDelegate.persistentContainer.viewContext
        self.entity = NSEntityDescription.entity(forEntityName: ENTITY_NAME, in: self.context)!
    }
    
    
    func fetchSongs(onSuccess: @escaping ([Song]) -> Void, onFailure: @escaping (Error) -> Void) {
        //
        
        onSuccess([Song]())
    }
    
    func saveSong(_ song: Song, onSuccess: @escaping (Bool) -> Void, onFailure: @escaping (Error) -> Void) {
        let newSong = NSManagedObject(entity: self.entity, insertInto: self.context)
        newSong.setValue(song.artistName, forKey: SongKeys.artistName.stringValue())
        newSong.setValue(song.trackName, forKey: SongKeys.trackName.stringValue())
        newSong.setValue(song.artworkUrl100, forKey: SongKeys.artworkUrl100.stringValue())
        newSong.setValue(song.primaryGenreName, forKey: SongKeys.primaryGenreName.stringValue())
        do {
            try context.save()
            onSuccess(true)
        } catch {
            onFailure(error)
        }
    }
}
