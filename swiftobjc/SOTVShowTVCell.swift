//
//  SOTVShowTVCell.swift
//  swiftobjc
//
//  Created by Ashish Kapoor on 19/05/17.
//  Copyright © 2017 Ashish Kapoor. All rights reserved.
//

import UIKit

class SOTVShowTVCell: UITableViewCell {

    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var tvShowTitle: UILabel!
    @IBOutlet weak var tvShowDescription: UILabel!
    @IBOutlet weak var tvShowAirDate: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
