//
//  Item.swift
//  My fav songs
//
//  Created by Karol Ch on 24/05/2018.
//  Copyright © 2018 Karol Chmiel. All rights reserved.
//

import UIKit
import CoreData

class SongMO: NSManagedObject {
    @NSManaged var artistName: String?
    @NSManaged var trackName: String?
    @NSManaged var artworkUrl100: String?
    @NSManaged var primaryGenreName: String?
}
