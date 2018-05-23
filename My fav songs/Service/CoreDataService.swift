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
    func sortSongsBy(_ songDataType: SongKeys, _ ascending: Bool, onSuccess: @escaping([Song]) -> Void, onFailure: @escaping(Error) -> Void)
    func searchSongsFor(_ key: String, _ songDataType: SongKeys, onSuccess: @escaping([Song]) -> Void, onFailure: @escaping(Error) -> Void)
    func deleteSong(_ song: Song, onSuccess: @escaping(Bool) -> Void, onFailure: @escaping(Error) -> Void)
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
    
    func fetchRequest() -> NSFetchRequest<NSManagedObject> {
        return NSFetchRequest<NSManagedObject>(entityName: ENTITY_NAME)
    }
    
    func fetchSongs(onSuccess: @escaping ([Song]) -> Void, onFailure: @escaping (Error) -> Void) {
        let fetchRequest = self.fetchRequest()
        do {
            let result = try context.fetch(fetchRequest)
            var songs = [Song]()
            for song in result {
                songs.append(parseSongData(song))
            }
            onSuccess(songs)
        } catch let error {
            print(error)
            onFailure(error)
        }
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
        } catch let error {
            print(error)
            onFailure(error)
        }
    }
    
    func sortSongsBy(_ songDataType: SongKeys, _ ascending: Bool, onSuccess: @escaping ([Song]) -> Void, onFailure: @escaping (Error) -> Void) {
        let fetchRequest = self.fetchRequest()
        let sort = NSSortDescriptor(key: songDataType.stringValue(), ascending: ascending)
        fetchRequest.sortDescriptors = [sort]
        do {
            let result = try context.fetch(fetchRequest)
            var songs = [Song]()
            for song in result {
                songs.append(parseSongData(song))
            }
            onSuccess(songs)
        } catch let error {
            onFailure(error)
        }
    }
    
    func searchSongsFor(_ key: String, _ songDataType: SongKeys, onSuccess: @escaping ([Song]) -> Void, onFailure: @escaping (Error) -> Void) {
        let fetchRequest = self.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "\(songDataType.stringValue()) CONTAINS[cd] %@", key)
        do {
            let results = try context.fetch(fetchRequest)
            var songs = [Song]()
            for song in results {
                songs.append(parseSongData(song))
            }
            onSuccess(songs)
        } catch let error {
            onFailure(error)
        }
    }
    
    
    func deleteSong(_ song: Song, onSuccess: @escaping (Bool) -> Void, onFailure: @escaping (Error) -> Void) {
        let fetchRequest = self.fetchRequest()
        let namePredicate = NSPredicate(format: "\(SongKeys.artistName.stringValue()) = %@", song.artistName)
        let titlePredicate = NSPredicate(format: "\(SongKeys.trackName.stringValue()) = %@", song.trackName)
        fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [namePredicate, titlePredicate])
        do {
            let results = try context.fetch(fetchRequest)
            for object in results {
                context.delete(object)
            }
            try context.save()
            onSuccess(true)
        } catch {
            onFailure(error)
        }
    }
}

extension CoreDataService {
    func parseSongData(_ song: NSManagedObject) -> Song {
        return Song(artistName: song.value(forKey: SongKeys.artistName.stringValue()) as! String,
             trackName: song.value(forKey: SongKeys.trackName.stringValue()) as! String,
             artworkUrl100: song.value(forKey: SongKeys.artworkUrl100.stringValue()) as! String,
             primaryGenreName: song.value(forKey: SongKeys.primaryGenreName.stringValue()) as! String)
    }
}
