//
//  SOMoviesDetailVC.swift
//  swiftobjc
//
//  Created by Ashish Kapoor on 07/02/17.
//  Copyright © 2017 Ashish Kapoor. All rights reserved.
//

import UIKit

class SOMoviesDetailVC: UIViewController {

    @IBOutlet var backgroundImageView: UIImageView!
    var moviePosterURL: String   = String()
    var movieReleaseDate: String = String()
    var movieTitle: String       = String()
    var movieOverview: String    = String()
    var movieID: Int             = Int()
    
    
    @IBOutlet weak var movieIDLabel: UILabel!
    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var movieOverviewLabel: UILabel!
    @IBOutlet weak var movieReleaseYearLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadReceivedValues()
    }
    
    func loadReceivedValues() {
        backgroundImageView.kf.setImage(with: getTMDBUrl(posterPath: moviePosterURL))
        movieIDLabel.text           = String(movieID)
        movieTitleLabel.text        = movieTitle
        movieOverviewLabel.text     = movieOverview
        movieReleaseYearLabel.text  = movieReleaseDate
    }

}
