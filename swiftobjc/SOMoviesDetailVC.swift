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
    var itemPopularity: Double     = Double()
    
    @IBOutlet weak var movieIDLabel: UILabel!
    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var movieOverviewLabel: UILabel!
    @IBOutlet weak var movieReleaseYearLabel: UILabel!
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var ratingLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // This function loads all the received values from the abstract list view.
        loadReceivedValues()
        title = itemTitle
        let menu_button_ = UIBarButtonItem(image: UIImage(named: "share-icon"),
                                       style: UIBarButtonItemStyle.plain,
                                       target: self, action: #selector(buttonTapped))
        self.navigationItem.rightBarButtonItem = menu_button_
    }

    func buttonTapped(sender: UIButton) {
        let textToShare = "Check out! \(itemTitle), About: \(itemOverview)"
        
        if let myWebsite = NSURL(string: "https://image.tmdb.org/t/p/w500\(itemPosterURL)") {
            let objectsToShare = [textToShare, myWebsite] as [Any]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            
            activityVC.popoverPresentationController?.sourceView = sender
            self.present(activityVC, animated: true, completion: nil)
        }
    }
    
    func loadReceivedValues() {
        movieIDLabel.text           = String(itemID)
        ratingLabel.text            = String(itemPopularity)
        movieTitleLabel.text        = itemTitle
        movieOverviewLabel.text     = itemOverview
        movieReleaseYearLabel.text  = itemReleaseDate
        backgroundImage.kf.setImage(with: getTMDBUrl(posterPath: itemPosterURL))
        backgroundImageView.kf.setImage(with: getTMDBUrl(posterPath: itemPosterURL),
                                        placeholder: kDefaultMovieImage, options: nil,
                                        progressBlock: nil, completionHandler: nil)
    }
}
