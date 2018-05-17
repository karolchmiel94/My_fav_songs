//
//  UIImageViewExtension.swift
//  My fav songs
//
//  Created by Karol Ch on 17/05/2018.
//  Copyright © 2018 Karol Chmiel. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView {
    func downloadFrom(url: URL, contentMode mode: UIViewContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() {
                self.image = image
            }
        }.resume()
    }
    
    func loadImageFrom(url: String, contentMode mode: UIViewContentMode = .scaleAspectFit) {
        guard let url = URL(string: url) else { return }
        downloadFrom(url: url, contentMode: mode)
    }
}
