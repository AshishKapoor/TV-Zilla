//
//  SOMoviesTVCell.swift
//  swiftobjc
//
//  Created by Ashish Kapoor on 07/02/17.
//  Copyright © 2017 Ashish Kapoor. All rights reserved.
//

import UIKit

class SOMoviesTVCell: UITableViewCell {

    @IBOutlet weak var moviesImageView:         UIImageView!
    @IBOutlet weak var movieNameLabel:          UILabel!
    @IBOutlet weak var moviePlotLabel:          UILabel!
    @IBOutlet weak var movieYearLabel:          UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.movieNameLabel?.text        = kLoadingStateText
        self.movieYearLabel?.text        = kLoadingStateText
        self.moviePlotLabel?.text        = kLoadingStateText
        self.moviesImageView?.image      = kDefaultMovieImage
        roundedCornersForStudentPhoto()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

    func roundedCornersForStudentPhoto () -> Void {
        // Changing image view corners
        moviesImageView.layer.cornerRadius = 8.0
        moviesImageView.clipsToBounds = true
    }
    
}
