//
//  ResultData.swift
//  My fav songs
//
//  Created by Karol Ch on 16/05/2018.
//  Copyright © 2018 Karol Chmiel. All rights reserved.
//

import Foundation

struct ResultData: Decodable {
    let resultCount: Int
    let results: [Song]
}
