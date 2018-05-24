//
//  CoreDataService.swift
//  My fav songs
//
//  Created by Karol Ch on 17/05/2018.
//  Copyright © 2018 Karol Chmiel. All rights reserved.
//

import Foundation
import CoreData

protocol CoreDataOperationsProtocol {
    func fetchSongs(onSuccess: @escaping([Song]) -> Void, onFailure: @escaping(Error) -> Void)
    func saveSong(_ song: Song, onSuccess: @escaping(Bool) -> Void, onFailure: @escaping(Error) -> Void)
    func sortSongsBy(_ songDataType: SongKeys, _ ascending: Bool, onSuccess: @escaping([Song]) -> Void, onFailure: @escaping(Error) -> Void)
    func searchSongsFor(_ key: String, _ songDataType: SongKeys, onSuccess: @escaping([Song]) -> Void, onFailure: @escaping(Error) -> Void)
    func deleteSong(_ song: Song, onSuccess: @escaping(Bool) -> Void, onFailure: @escaping(Error) -> Void)
}

class CoreDataService: CoreDataOperationsProtocol {
    
    private let ENTITY_NAME = "Songs"

    private let appDelegate: AppDelegate
    private var context: NSManagedObjectContext
    private let entity: NSEntityDescription

    init(with appDelegate: AppDelegate) {
        self.appDelegate = appDelegate
        self.context = appDelegate.persistentContainer.viewContext
        self.entity = NSEntityDescription.entity(forEntityName: ENTITY_NAME, in: self.context)!
    }
    
    func fetchRequest() -> NSFetchRequest<NSManagedObject> {
        // Please use NSManagedObject.fetchRequest
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
        let entity = NSEntityDescription.entity(forEntityName: "Songs", in: self.context)
        let record = SongMO(entity: entity!, insertInto: self.context)
        record.artistName = song.artistName
        record.trackName = song.trackName
        record.artworkUrl100 = song.artworkUrl100
        record.primaryGenreName = song.primaryGenreName
    }
    
    func sortSongsBy(_ songDataType: SongKeys, _ ascending: Bool, onSuccess: @escaping ([Song]) -> Void, onFailure: @escaping (Error) -> Void) {
        let fetchRequest = self.fetchRequest()
        let sort = NSSortDescriptor(key: songDataType.rawValue, ascending: ascending)
        fetchRequest.sortDescriptors = [sort]
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
    
    func searchSongsFor(_ key: String, _ songDataType: SongKeys, onSuccess: @escaping ([Song]) -> Void, onFailure: @escaping (Error) -> Void) {
        let fetchRequest = self.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "\(songDataType.rawValue) CONTAINS[cd] %@", key)
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
        let namePredicate = NSPredicate(format: "\(SongKeys.artistName.rawValue) = %@", song.artistName)
        let titlePredicate = NSPredicate(format: "\(SongKeys.trackName.rawValue) = %@", song.trackName)
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
    // Use Songs class instead of the superclass.
    func parseSongData(_ song: NSManagedObject) -> Song {
        return Song(artistName: song.value(forKey: SongKeys.artistName.rawValue) as! String,
             trackName: song.value(forKey: SongKeys.trackName.rawValue) as! String,
             artworkUrl100: song.value(forKey: SongKeys.artworkUrl100.rawValue) as! String,
             primaryGenreName: song.value(forKey: SongKeys.primaryGenreName.rawValue) as! String)
    }
}
