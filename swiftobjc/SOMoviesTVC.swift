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
    
    var movies: [Movies]                = []
    var status: LoadingStatus?          = nil
    var pageNumber                      = Int()
    var totalPages                      = Int()
    var fromReleaseYear                 = String()
    var tillReleaseYear                 = String()
    var currentMovieType                = typeOfMovies.nowPlaying
    var isFromFilteredMovies            = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pageNumber = kInitialValue
        setupRefreshControl()
        setupTableView()
        setType(type: currentMovieType)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if (isFromFilteredMovies) {
            clearOldList()
            isFromFilteredMovies = false
        }
    }
    
    func setupRefreshControl() {
        // Refresh control
        self.refreshControl?.addTarget(self, action: #selector(refreshMoviesList), for: UIControlEvents.valueChanged)
        self.refreshControl?.tintColor = UIColor.black
    }
    
    
    func refreshMoviesList() {
        self.refreshControl?.beginRefreshing()
        self.tableView.reloadData()
        self.refreshControl?.endRefreshing()
    }
    
    func setupTableView() {
        // to preserve selection between presentations
        self.clearsSelectionOnViewWillAppear = false
        self.tableView.backgroundColor = kTableViewBackgroundColor
        // dynamic row height
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 90
        // to remove the unwanted cells from footer.
        self.tableView.tableFooterView = UIView()
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
        
        let nowPlayingButton = UIAlertAction(title: kNowPlayingMovies, style: .default) { action -> Void in
            self.setType(type: .nowPlaying)
            self.currentMovieType = .nowPlaying
            self.clearOldList()
            self.refreshMoviesList()
        }
        actionSheetController.addAction(nowPlayingButton)
        
        let upcomingButton = UIAlertAction(title: kUpcomingMovies, style: .default) { action -> Void in
            self.setType(type: .upcoming)
            self.currentMovieType = .upcoming
            self.clearOldList()
            self.refreshMoviesList()
        }
        actionSheetController.addAction(upcomingButton)
        
        let topRatedButton = UIAlertAction(title: kTopRatedMovies, style: .default) { action -> Void in
            self.setType(type: .topRated)
            self.currentMovieType = .topRated
            self.clearOldList()
            self.refreshMoviesList()
        }
        actionSheetController.addAction(topRatedButton)
        
        let popularButton = UIAlertAction(title: kPopularMovies, style: .default) { action -> Void in
            self.setType(type: .popular)
            self.currentMovieType = .popular
            self.clearOldList()
            self.refreshMoviesList()
        }
        actionSheetController.addAction(popularButton)
        
        let cancleActionButton = UIAlertAction(title: kCancel, style: .cancel) { action -> Void in
            //Do nothing.
        }
        actionSheetController.addAction(cancleActionButton)
        
        self.present(actionSheetController, animated: true, completion: nil)
    }
    
    func setType(type: typeOfMovies) {
        
        switch type {
        case .topRated:
            MovieMDB.toprated(apikey, language: kEnglishLanguage, page: self.pageNumber) {
                data, topRatedMovies in
                if let movie = topRatedMovies {
                    self.totalPages = (data.pageResults?.total_pages)!
                    self.title = kTopRatedMovies
                    self.getMovies(movieData: movie)
                }
            }
            break
        case .nowPlaying:
            MovieMDB.nowplaying(apikey, language: kEnglishLanguage, page: self.pageNumber) {
                data, nowPlaying in
                if let movie = nowPlaying {
                    self.totalPages = (data.pageResults?.total_pages)!
                    self.title = kNowPlayingMovies
                    self.getMovies(movieData: movie)
                }
            }
            break
        case .upcoming:
            MovieMDB.upcoming(apikey, page: self.pageNumber, language: kEnglishLanguage) {
                data, upcomingMovies in
                if let movie = upcomingMovies {
                    self.totalPages = (data.pageResults?.total_pages)!
                    self.title = kUpcomingMovies
                    self.getMovies(movieData: movie)
                }
            }
            break
        case .popular:
            MovieMDB.popular(apikey, language: kEnglishLanguage, page: self.pageNumber) {
                data, popularMovies in
                if let movie = popularMovies {
                    self.totalPages = (data.pageResults?.total_pages)!
                    self.title = kPopularMovies
                    self.getMovies(movieData: movie)
                }
            }
            break
        case .filtered:
            DiscoverMovieMDB.discoverMovies(apikey: apikey, language: kEnglishLanguage, page: self.pageNumber,
                                            primary_release_date_gte: self.fromReleaseYear,
                                            primary_release_date_lte: self.tillReleaseYear) {
                data, filteredMovies  in
                if let movie = filteredMovies {
                    self.totalPages = (data.pageResults?.total_pages)!
                    self.title = kReleaseDates
                    self.getMovies(movieData: movie)
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
        self.reloadTable()
    }

    func reloadTable() {
        self.tableView.reloadData()
        self.status = LoadingStatus.StatusLoaded
    }
    
    @IBAction func filterButtonPressed(_ sender: Any) {
        let soFilterVC = soStoryBoard.instantiateViewController(withIdentifier: "SOFilterVC") as? SOFilterVC
        self.navigationController?.pushViewController(soFilterVC!, animated: true)
    }
 
}


extension SOMoviesTVC {
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return kInitialValue
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
            cell.moviePlotLabel.text         = self.movies[indexPath.row].overview
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
    
    // Added infinite scroll
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if self.pageNumber <= totalPages {
            let lastRowIndex = tableView.numberOfRows(inSection: 0)
            if indexPath.row == lastRowIndex - kInitialValue {
                self.pageNumber = self.pageNumber + kInitialValue
                switch self.currentMovieType {
                case .filtered:
                    setType(type: .filtered)
                    break
                case .upcoming:
                    setType(type: .upcoming)
                    break
                case .topRated:
                    setType(type: .topRated)
                    break
                case .popular:
                    setType(type: .popular)
                    break
                case .nowPlaying:
                    setType(type: .nowPlaying)
                    break
                }
            }
        }
    }
}
