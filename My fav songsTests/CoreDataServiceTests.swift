//
//  CoreDataServiceTests.swift
//  My fav songsTests
//
//  Created by Karol Ch on 20/05/2018.
//  Copyright © 2018 Karol Chmiel. All rights reserved.
//

import XCTest
import CoreData
@testable import My_fav_songs

class CoreDataServiceTests: XCTestCase {
    
    var sut: CoreDataService!
    lazy var mockPersistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "My_fav_songs", managedObjectModel: managedObjectModel)
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        description.shouldAddStoreAsynchronously = false
        
        container.persistentStoreDescriptions = [description]
        container.loadPersistentStores(completionHandler: { (description, error) in
            precondition(description.type == NSInMemoryStoreType) //check if data is in memory
            if let error = error { //does something went wrong ?
                fatalError("Create an in-mem coordinator failed \(error)")
            }
        })
        return container
    }()
    lazy var managedObjectModel: NSManagedObjectModel = {
        let managedObjectModel = NSManagedObjectModel.mergedModel(from: [Bundle(for: type(of: self))])!
        return managedObjectModel
    }()
    
    func initStubs() {
        func insertSongWith(artistName: String, songTitle: String, musicGenre: String) -> NSManagedObject {
            let obj = NSEntityDescription.insertNewObject(forEntityName: "Songs", into: mockPersistentContainer.viewContext)
            obj.setValue(artistName, forKey: SongKeys.artistName.stringValue())
            obj.setValue(songTitle, forKey: SongKeys.trackName.stringValue())
            obj.setValue(musicGenre, forKey: SongKeys.primaryGenreName.stringValue())
            obj.setValue("", forKey: SongKeys.artworkUrl100.stringValue())
            return obj
        }
        
        let data = insertSongWith(artistName: "Steve Wonder", songTitle: "Superstition", musicGenre: "Funky pop")
        let data2 = insertSongWith(artistName: "Krawczyk", songTitle: "Parostatek", musicGenre: "Pop")
        
        do {
            try mockPersistentContainer.viewContext.save()
        } catch {
            print("Created failed with error: \(error)")
        }
    }
    
    
    func destroyData(){
        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest<NSFetchRequestResult>(entityName: "Songs")
        let objs = try! mockPersistentContainer.viewContext.fetch(fetchRequest)
        for case let obj as NSManagedObject in objs {
            mockPersistentContainer.viewContext.delete(obj)
            print("Deleting test data")
        }
        try! mockPersistentContainer.viewContext.save()
    }
    
    override func setUp() {
        super.setUp()
        initStubs()
        sut = CoreDataService(with: AppDelegate())
        
    }
    
    override func tearDown() {
        destroyData()
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func test_create_song() {
        let artist = "Joshua"
        let songName = "uuuuuaaaaaa"
        let genre = "asd"
        let song = Song(artistName: artist,
                        trackName: songName,
                        artworkUrl100: "",
                        primaryGenreName: genre)
        let saveSong = sut.saveSong(song, onSuccess: {(thing) in }, onFailure: {(badThing) in })
        
        XCTAssertNotNil(saveSong)
    }
    
    func test_fetch_songs() {
        let expect = XCTestExpectation(description: "callback")
        sut.fetchSongs(onSuccess: { (songs) in
            XCTAssert(songs.count > 0)
            expect.fulfill()
            for song in songs {
                XCTAssertNotNil(song.artistName)
            }
        }) { (error) in
            print(error)
        }
        wait(for: [expect], timeout: 2.0)
    }
    
    func deleteSong() {
        
    }
    
    
}
