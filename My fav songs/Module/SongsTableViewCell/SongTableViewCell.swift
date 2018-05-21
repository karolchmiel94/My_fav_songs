//
//  SongTableViewCell.swift
//  My fav songs
//
//  Created by Karol Ch on 15/05/2018.
//  Copyright © 2018 Karol Chmiel. All rights reserved.
//

import UIKit

class SongTableViewCell: UITableViewCell {
    
    @IBOutlet weak var artworkImageView: UIImageView!
    @IBOutlet weak var artistNameLabel: UILabel!
    @IBOutlet weak var songTitleLabel: UILabel!
    @IBOutlet weak var songGenreLabel: UILabel!
    @IBOutlet weak var songButton: UIButton!
    
    // Please remove all empty overrides
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

// Consider moving this to a separate file
struct SongListCellViewModel {
    let artistNameText: String
    let songTitleText: String
    let artworkUrl: String
    let genreText: String
}
