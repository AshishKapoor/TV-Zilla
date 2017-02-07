//
//  SOMoviesTVC.swift
//  swiftobjc
//
//  Created by Ashish Kapoor on 07/02/17.
//  Copyright © 2017 Ashish Kapoor. All rights reserved.
//

import UIKit
import TMDBSwift
import Kingfisher

class SOMoviesTVC: UITableViewController {
    
    var movies = [Movies]()
    var status:LoadingStatus? = nil

    @IBOutlet weak var typeButton: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "SwiftObjc"
        // Uncomment the following line to preserve selection between presentations
        self.clearsSelectionOnViewWillAppear = false
        // Refresh control
        self.refreshControl?.addTarget(self, action: #selector(SOMoviesTVC.refreshMoviesList), for: UIControlEvents.valueChanged)

        loadMovies()
        self.tableView.backgroundColor = kTableViewBackgroundColor
    }
    
    func loadMovies() {
        setType(type: .nowPlaying)
    }
    
    func refreshMoviesList() {
        print("refreshing...")
        self.tableView.reloadData()
        self.refreshControl?.endRefreshing()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func typeButtonPressed(_ sender: Any) {
        showAlertSheet()
    }
    
    func showAlertSheet () -> Void {
        // Create the AlertController and add its actions like button in ActionSheet
        let actionSheetController = UIAlertController(title: "Please select movie lists type", message: "", preferredStyle: .actionSheet)
        
        let nowPlayingButton = UIAlertAction(title: "Now Playing", style: .default) { action -> Void in
            self.setType(type: .nowPlaying)
        }
        actionSheetController.addAction(nowPlayingButton)
        
        let upcomingButton = UIAlertAction(title: "Upcoming", style: .default) { action -> Void in
            self.setType(type: .upcoming)
        }
        actionSheetController.addAction(upcomingButton)
        
        let topRatedButton = UIAlertAction(title: "Top Rated", style: .default) { action -> Void in
            self.setType(type: .topRated)
        }
        actionSheetController.addAction(topRatedButton)
        
        let popularButton = UIAlertAction(title: "Popular", style: .default) { action -> Void in
            self.setType(type: .popular)
        }
        actionSheetController.addAction(popularButton)
        
        let cancleActionButton = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in
            print("Do nothing")
        }
        actionSheetController.addAction(cancleActionButton)
        
        self.present(actionSheetController, animated: true, completion: nil)
    }
    
    func setType(type: typeOfMovies) -> Void {
        if self.movies.count > 0 {
            self.movies.removeAll()
        }
        switch type {
        case .topRated:
            MovieMDB.toprated(apikey, language: "en", page: 1) {
                data, topRatedMovies in
                if let movie = topRatedMovies{
                    self.title = "Top Rated Movies"
                    self.movies.append(Movies(id: movie[0].id!, posterPath: movie[0].poster_path!,
                                              title: movie[0].title!, overview: movie[0].overview!,
                                              release_date: movie[0].release_date!)
                    )
                    self.tableView.reloadData()
                    self.status = LoadingStatus.StatusLoaded
                }
            }
            break
        case .nowPlaying:
            MovieMDB.nowplaying(apikey, language: "en", page: 2) {
                data, nowPlaying in
                if let movie = nowPlaying{
                    self.title = "Now Playing"
                    self.movies.append(Movies(id: movie[0].id!, posterPath: movie[0].poster_path!,
                                              title: movie[0].title!, overview: movie[0].overview!,
                                              release_date: movie[0].release_date!)
                    )
                    self.tableView.reloadData()
                    self.status = LoadingStatus.StatusLoaded
                }
            }
            break
        case .upcoming:
            MovieMDB.upcoming(apikey, page: 1, language: "en") {
                data, upcomingMovies in
                if let movie = upcomingMovies{
                    self.title = "Upcoming Movies"
                    self.movies.append(Movies(id: movie[0].id!, posterPath: movie[0].poster_path!,
                                              title: movie[0].title!, overview: movie[0].overview!,
                                              release_date: movie[0].release_date!)
                    )
                    self.tableView.reloadData()
                    self.status = LoadingStatus.StatusLoaded
                }
            }
            break
        case .popular:
            MovieMDB.popular(apikey, language: "en", page: 1) {
                data, popularMovies in
                if let movie = popularMovies {
                    self.title = "Popular Movies"
                    self.movies.append(Movies(id: movie[0].id!, posterPath: movie[0].poster_path!,
                                              title: movie[0].title!, overview: movie[0].overview!,
                                              release_date: movie[0].release_date!)
                    )
                    self.tableView.reloadData()
                    self.status = LoadingStatus.StatusLoaded
                }
            }
            break
        }
    }

    @IBAction func filterButtonPressed(_ sender: Any) {
        print("filter button pressed")
    }
}


extension SOMoviesTVC {
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.movies.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Configure the cell...
        let cellIdentifier = "soMoviesTVCID"
        guard let cell = tableView.dequeueReusableCell (withIdentifier: cellIdentifier, for: indexPath) as? SOMoviesTVCell else { return UITableViewCell() }
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        
        if self.status == LoadingStatus.StatusLoading {
            cell.movieNameLabel?.text        = kLoadingStateText
            cell.movieYearLabel?.text        = kLoadingStateText
            cell.moviePlotLabel?.text        = kLoadingStateText
            cell.moviesImageView?.image      = kDefaultMovieImage
        } else if self.status == LoadingStatus.StatusLoaded {
            cell.movieNameLabel?.text        = self.movies[indexPath.row].title
            cell.movieYearLabel?.text        = self.movies[indexPath.row].releaseDate
            cell.moviesImageView.kf.setImage(with: self.movies[indexPath.row].getPosterURL())
            cell.moviePlotLabel.text = self.movies[indexPath.row].overview
        }
        
        return cell
    }
}
