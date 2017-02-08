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
    
    var movies                  = [Movies]()
    var status: LoadingStatus?  = nil
    var pageNumber: Int         = Int()
    var fromReleaseYear         = String()
    var tillReleaseYear         = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "SwiftObjc"
        pageNumber = 1

        setupRefreshControl()
        loadMovies()
        setupTableView()
    }
    
    func setupRefreshControl() {
        // Refresh control
        self.refreshControl?.addTarget(self,
                                       action: #selector(SOMoviesTVC.refreshMoviesList),
                                       for: UIControlEvents.valueChanged
        )
        self.refreshControl?.tintColor = UIColor.black
    }
    
    func loadMovies() {
        setType(type: .nowPlaying)
    }
    
    func refreshMoviesList() {
        self.tableView.reloadData()
        self.refreshControl?.endRefreshing()
    }
    
    func setupTableView() {
        // Uncomment the following line to preserve selection between presentations
        self.clearsSelectionOnViewWillAppear = false
        self.tableView.backgroundColor = kTableViewBackgroundColor
        // to remove the unwanted cells from footer.
        self.tableView.tableFooterView = UIView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func typeButtonPressed(_ sender: Any) {
        showAlertSheet()
    }
    
    func clearOldList() {
        if self.movies.count > 0 {
            self.movies.removeAll()
        }
    }
    
    func showAlertSheet () -> Void {
        // Create the AlertController and add its actions like button in ActionSheet
        let actionSheetController = UIAlertController(
            title: nil, message: nil,
            preferredStyle: .actionSheet
        )
        
        let nowPlayingButton = UIAlertAction(title: "Now Playing",
                                             style: .default) { action -> Void in
            self.setType(type: .nowPlaying)
        }
        actionSheetController.addAction(nowPlayingButton)
        
        let upcomingButton = UIAlertAction(title: "Upcoming",
                                           style: .default) { action -> Void in
            self.setType(type: .upcoming)
        }
        actionSheetController.addAction(upcomingButton)
        
        let topRatedButton = UIAlertAction(title: "Top Rated",
                                           style: .default) { action -> Void in
            self.setType(type: .topRated)
        }
        actionSheetController.addAction(topRatedButton)
        
        let popularButton = UIAlertAction(title: "Popular",
                                          style: .default) { action -> Void in
            self.setType(type: .popular)
        }
        actionSheetController.addAction(popularButton)
        
        let cancleActionButton = UIAlertAction(title: "Cancel",
                                               style: .cancel) { action -> Void in
            print("Do nothing")
        }
        actionSheetController.addAction(cancleActionButton)
        
        self.present(actionSheetController, animated: true, completion: nil)
    }
    
    func setType(type: typeOfMovies) -> Void {
        
        self.clearOldList()
        
        switch type {
        case .topRated:
            MovieMDB.toprated(apikey, language: "en", page: self.pageNumber) {
                data, topRatedMovies in
                if let movie = topRatedMovies {
                    self.title = kTopRatedMovies
                    self.getMovies(movieData: movie)
                    self.reloadTable()
                }
            }
            break
        case .nowPlaying:
            MovieMDB.nowplaying(apikey, language: "en", page: self.pageNumber) {
                data, nowPlaying in
                if let movie = nowPlaying {
                    self.title = kNowPlayingMovies
                    self.getMovies(movieData: movie)
                    self.reloadTable()
                }
            }
            break
        case .upcoming:
            MovieMDB.upcoming(apikey, page: self.pageNumber, language: "en") {
                data, upcomingMovies in
                if let movie = upcomingMovies {
                    self.title = kUpcomingMovies
                    self.getMovies(movieData: movie)
                    self.reloadTable()
                }
            }
            break
        case .popular:
            MovieMDB.popular(apikey, language: "en", page: self.pageNumber) {
                data, popularMovies in
                if let movie = popularMovies {
                    self.title = kPopularMovies
                    self.getMovies(movieData: movie)
                    self.reloadTable()
                }
            }
            break
        }
    }
    
    func getMovies(movieData: [MovieMDB] ) {
        for movieIterator in movieData {
            self.movies.append(Movies(
                    id: movieIterator.id ?? 0,
                    posterPath: movieIterator.poster_path ?? "",
                    title: movieIterator.title ?? "",
                    overview: movieIterator.overview ?? "",
                    release_date: movieIterator.release_date ?? ""
                )
            )
        }
    }
    
    func getFilteredMovies(movieData: [MovieMDB]) {
        self.clearOldList()

        for movieIterator in movieData {
            self.movies.append(Movies(
                    id: movieIterator.id ?? 0,
                    posterPath: movieIterator.poster_path ?? "",
                    title: movieIterator.title ?? "",
                    overview: movieIterator.overview ?? "",
                    release_date: movieIterator.release_date ?? ""
                )
            )
        }
    }

    func reloadTable() {
        self.tableView.reloadData()
        self.status = LoadingStatus.StatusLoaded
    }
    
    @IBAction func filterButtonPressed(_ sender: Any) {
        let soFilterVC = soStoryBoard.instantiateViewController(withIdentifier: "SOFilterVC") as? SOFilterVC
        self.navigationController?.pushViewController(soFilterVC!, animated: true)
    }
    
    func callFilteredMovies(till: String, from: String) {
        self.title = kReleaseDates
        DiscoverMovieMDB.discoverMovies(
            apikey: apikey, language: "EN", page: 1,
            primary_release_date_gte: from,
            primary_release_date_lte: till) {
                data, moviesReleaseDateFilterArray  in
                if let movieArr = moviesReleaseDateFilterArray {
                    self.title = kReleaseDates
                    self.getFilteredMovies(movieData: movieArr)
                    self.reloadTable()
                }
        }
    }
    
//    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        let offset:CGPoint = scrollView.contentOffset
//        let bounds:CGRect = scrollView.bounds
//        let size:CGSize = scrollView.contentSize
//        let inset:UIEdgeInsets = scrollView.contentInset
//        let y:CGFloat = offset.y + bounds.size.height - inset.bottom
//        let h:CGFloat = size.height
//        let reload_distance:CGFloat = 0
//        if(y > h + reload_distance) {
//            print("load more rows down");
////            self.pageNumber = self.pageNumber + 1
////            print(self.pageNumber)
////            refreshMoviesList()
//        }
//    }
 
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
        guard let cell = tableView.dequeueReusableCell (
            withIdentifier: cellIdentifier, for: indexPath) as? SOMoviesTVCell else { return UITableViewCell() }
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        
        if self.status == LoadingStatus.StatusLoading {
            cell.movieNameLabel?.text        = kLoadingStateText
            cell.movieYearLabel?.text        = kLoadingStateText
            cell.moviePlotLabel?.text        = kLoadingStateText
            cell.moviesImageView?.image      = kDefaultMovieImage
        } else if self.status == LoadingStatus.StatusLoaded {
            cell.movieNameLabel?.text        = self.movies[indexPath.row].title
            cell.movieYearLabel?.text        = self.movies[indexPath.row].releaseDate
            cell.moviesImageView.kf.setImage(with: self.movies[indexPath.row].getPosterURL(),
                                             placeholder: UIImage(named: "movie-poster-not-found"),
                                             options: nil, progressBlock: nil, completionHandler: nil)
            cell.moviePlotLabel.text = self.movies[indexPath.row].overview
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (tableView.cellForRow(at: indexPath) as? SOMoviesTVCell) != nil {
            let soMoviesDetailVC = soStoryBoard.instantiateViewController(withIdentifier: "SOMoviesDetailVC") as? SOMoviesDetailVC
            soMoviesDetailVC?.moviePosterURL        = self.movies[indexPath.row].posterPath
            soMoviesDetailVC?.movieID               = self.movies[indexPath.row].id
            soMoviesDetailVC?.movieOverview         = self.movies[indexPath.row].overview
            soMoviesDetailVC?.movieTitle            = self.movies[indexPath.row].title
            soMoviesDetailVC?.movieReleaseDate      = self.movies[indexPath.row].releaseDate
            self.navigationController?.pushViewController(soMoviesDetailVC!, animated: true)
        }
    }
}
