//
//  SOMoviesDetailVC.swift
//  swiftobjc
//
//  Created by Ashish Kapoor on 07/02/17.
//  Copyright © 2017 Ashish Kapoor. All rights reserved.
//

import UIKit

class SOMoviesDetailVC: UIViewController {
    
    // Outlets and properties
    @IBOutlet var backgroundImageView: UIImageView!
    var itemPosterURL: String      = String()
    var itemReleaseDate: String    = String()
    var itemTitle: String          = String()
    var itemOverview: String       = String()
    var itemID: Int                = Int()
    
    @IBOutlet weak var movieIDLabel: UILabel!
    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var movieOverviewLabel: UILabel!
    @IBOutlet weak var movieReleaseYearLabel: UILabel!
    @IBOutlet weak var backgroundImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // This function loads all the received values from the abstract list view.
        loadReceivedValues()
        title = itemTitle
    }

    func loadReceivedValues() {
        movieIDLabel.text           = String(itemID)
        movieTitleLabel.text        = itemTitle
        movieOverviewLabel.text     = itemOverview
        movieReleaseYearLabel.text  = itemReleaseDate
        backgroundImage.kf.setImage(with: getTMDBUrl(posterPath: itemPosterURL))
        backgroundImageView.kf.setImage(with: getTMDBUrl(posterPath: itemPosterURL),
                                        placeholder: kDefaultMovieImage, options: nil,
                                        progressBlock: nil, completionHandler: nil)
    }
}
