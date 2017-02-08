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
        let url = URL(string: "https://image.tmdb.org/t/p/w500\(moviePosterURL)")
        backgroundImageView.kf.setImage(with: url)
        movieIDLabel.text           = String(movieID)
        movieTitleLabel.text        = movieTitle
        movieOverviewLabel.text     = movieOverview
        movieReleaseYearLabel.text  = movieReleaseDate
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
