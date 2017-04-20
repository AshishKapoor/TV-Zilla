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
    var moviePosterURL: String      = String()
    var movieReleaseDate: String    = String()
    var movieTitle: String          = String()
    var movieOverview: String       = String()
    var movieID: Int                = Int()
    
    @IBOutlet weak var movieIDLabel: UILabel!
    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var movieOverviewLabel: UILabel!
    @IBOutlet weak var movieReleaseYearLabel: UILabel!
    @IBOutlet weak var backgroundImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // This function loads all the received values from the abstract list view.
        loadReceivedValues()
        title = movieTitle
    }
    
    func loadReceivedValues() {
        movieIDLabel.text           = String(movieID)
        movieTitleLabel.text        = movieTitle
        movieOverviewLabel.text     = movieOverview
        movieReleaseYearLabel.text  = movieReleaseDate
        backgroundImage.kf.setImage(with: getTMDBUrl(posterPath: moviePosterURL))
        backgroundImageView.kf.setImage(with: getTMDBUrl(posterPath: moviePosterURL),
                                        placeholder: kDefaultMovieImage, options: nil,
                                        progressBlock: nil, completionHandler: nil)
    }

}
