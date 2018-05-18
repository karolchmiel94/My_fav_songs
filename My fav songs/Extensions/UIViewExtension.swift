//
//  UIViewExtension.swift
//  My fav songs
//
//  Created by Karol Ch on 18/05/2018.
//  Copyright © 2018 Karol Chmiel. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    func roundCorners(with radius: CGFloat) {
        self.layer.masksToBounds = true
        self.clipsToBounds = true
        self.layer.cornerRadius = radius
    }
}
