//
//  SOTVShowsTVC.swift
//  swiftobjc
//
//  Created by Ashish Kapoor on 19/05/17.
//  Copyright © 2017 Ashish Kapoor. All rights reserved.
//

import UIKit
import TMDBSwift
import PeekPop

class SOTVShowsTVC: UITableViewController, PeekPopPreviewingDelegate {
        
    var tvShows: [TVShows]              = []
    var status: LoadingStatus?          = nil
    var pageNumber                      = Int()
    var totalPages                      = Int()
    var fromReleaseYear                 = String()
    var tillReleaseYear                 = String()
    var currentTVShowsType              = typeOfTVShows.popular
    var isFromFilteredMovies            = false
    var peekPop: PeekPop?


    override func viewDidLoad() {
        super.viewDidLoad()
        pageNumber = kInitialValue
        setupRefreshControl()
        setupTableView()
        setType(type: currentTVShowsType)
        
        peekPop = PeekPop(viewController: self)
        peekPop?.registerForPreviewingWithDelegate(self, sourceView: tableView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if (isFromFilteredMovies) {
            clearOldList()
            isFromFilteredMovies = false
        }
    }
    
    func previewingContext(_ previewingContext: PreviewingContext, viewControllerForLocation location: CGPoint) -> UIViewController? {
        let storyboard = UIStoryboard(name:"Main", bundle:nil)
        if let previewViewController = storyboard.instantiateViewController(withIdentifier: "SOMoviesDetailVC") as? SOMoviesDetailVC {
            if let indexPath = tableView.indexPathForRow(at: location) {
                previewViewController.moviePosterURL        = self.tvShows[indexPath.row].posterPath
                previewViewController.movieID               = self.tvShows[indexPath.row].id
                previewViewController.movieOverview         = self.tvShows[indexPath.row].overview
                previewViewController.movieTitle            = self.tvShows[indexPath.row].title
                previewViewController.movieReleaseDate      = self.tvShows[indexPath.row].releaseDate
                
                return previewViewController
            }
        }
        return nil
    }

    func previewingContext(_ previewingContext: PreviewingContext, commitViewController viewControllerToCommit: UIViewController) {
        self.navigationController?.pushViewController(viewControllerToCommit, animated: false)
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
        
        //self.tableView.rowHeight = UITableViewAutomaticDimension
        //self.tableView.estimatedRowHeight = 120
        
        // to remove the unwanted cells from footer.
        self.tableView.tableFooterView = UIView()
    }
    
    @IBAction func typeButtonPressed(_ sender: Any) {
        showAlertSheet()
    }
    
    func clearOldList() {
        if self.tvShows.count > 0 {
            self.tvShows.removeAll()
        }
    }
    
    func showAlertSheet () -> Void {
        // Create the AlertController and add its actions like button in ActionSheet
        let actionSheetController = UIAlertController(
            title: nil, message: nil,
            preferredStyle: .actionSheet
        )
        
        let nowPlayingButton = UIAlertAction(title: kPopularTVShows, style: .default) { action -> Void in
            self.setType(type: .popular)
            self.currentTVShowsType = .popular
            self.clearOldList()
            self.refreshMoviesList()
        }
        actionSheetController.addAction(nowPlayingButton)
        
        let upcomingButton = UIAlertAction(title: kTopRatedTVShows, style: .default) { action -> Void in
            self.setType(type: .toprated)
            self.currentTVShowsType = .toprated
            self.clearOldList()
            self.refreshMoviesList()
        }
        actionSheetController.addAction(upcomingButton)
        
        let popularButton = UIAlertAction(title: kOnTheAirTVShows, style: .default) { action -> Void in
            self.setType(type: .ontheair)
            self.currentTVShowsType = .ontheair
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
    
    func setType(type: typeOfTVShows) {
        
        switch type {
        case .popular:
            TVMDB.popular(apikey, page: self.pageNumber, language: kEnglishLanguage){ [weak self]
                data, popularTVShows in
                guard let tvShow = popularTVShows else { return }
                self?.totalPages = (data.pageResults?.total_pages)!
                self?.title     = kPopularTVShows
                self?.getTVShows(tvShowData: tvShow)
            }
            break
        case .toprated:
            TVMDB.toprated(apikey, page: self.pageNumber, language: kEnglishLanguage){
                data, topRatedTVShows in
                guard let tvShow = topRatedTVShows else { return }
                
                self.totalPages = (data.pageResults?.total_pages)!
                self.title      = kTopRatedTVShows
                self.getTVShows(tvShowData: tvShow)
            }
            break
        case .ontheair:
            TVMDB.ontheair(apikey, page: self.pageNumber, language: kEnglishLanguage){
                data, onTheAirTVShows in
                guard let tvShow = onTheAirTVShows else { return }
                
                self.totalPages = (data.pageResults?.total_pages)!
                self.title      = kOnTheAirTVShows
                self.getTVShows(tvShowData: tvShow)
            }
            break
        }
    }
    
    func getTVShows(tvShowData: [TVMDB] ) {
        for tvShow in tvShowData {
            self.tvShows.append(TVShows(
                id: tvShow.id,
                posterPath: tvShow.poster_path,
                title: tvShow.name ?? "",
                overview: tvShow.overview,
                release_date: tvShow.first_air_date
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


extension SOTVShowsTVC {
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return kInitialValue
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tvShows.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Configure the cell...
        let cellIdentifier = "SOTVShowTVCell"
        guard let cell = tableView.dequeueReusableCell (
            withIdentifier: cellIdentifier, for: indexPath) as? SOTVShowTVCell else { return UITableViewCell() }
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        
        if self.status == LoadingStatus.StatusLoading {
            cell.tvShowTitle?.text                  = kLoadingStateText
            cell.tvShowAirDate?.text                = kLoadingStateText
            cell.tvShowDescription?.text            = kLoadingStateText
            cell.posterImageView?.image             = kDefaultMovieImage
        } else if self.status == LoadingStatus.StatusLoaded {
            cell.tvShowTitle?.text               = self.tvShows[indexPath.row].title
            cell.tvShowAirDate?.text               = self.tvShows[indexPath.row].releaseDate
            cell.posterImageView.kf.setImage(with: self.tvShows[indexPath.row].getPosterURL(),
                                             placeholder: UIImage(named: "movie-poster-not-found"),
                                             options: nil, progressBlock: nil, completionHandler: nil)
            cell.tvShowDescription.text                = self.tvShows[indexPath.row].overview
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (tableView.cellForRow(at: indexPath) as? SOTVShowTVCell) != nil {
            let soMoviesDetailVC = soStoryBoard.instantiateViewController(withIdentifier: "SOMoviesDetailVC") as? SOMoviesDetailVC
            soMoviesDetailVC?.moviePosterURL        = self.tvShows[indexPath.row].posterPath
            soMoviesDetailVC?.movieID               = self.tvShows[indexPath.row].id
            soMoviesDetailVC?.movieOverview         = self.tvShows[indexPath.row].overview
            soMoviesDetailVC?.movieTitle            = self.tvShows[indexPath.row].title
            soMoviesDetailVC?.movieReleaseDate      = self.tvShows[indexPath.row].releaseDate
            self.navigationController?.pushViewController(soMoviesDetailVC!, animated: true)
        }
    }
    
    // Added infinite scroll
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if self.pageNumber <= totalPages {
            let lastRowIndex = tableView.numberOfRows(inSection: 0)
            if indexPath.row == lastRowIndex - kInitialValue {
                self.pageNumber = self.pageNumber + kInitialValue
                switch self.currentTVShowsType {
                case .toprated:
                    setType(type: .toprated)
                    break
                case .ontheair:
                    setType(type: .ontheair)
                    break
                case .popular:
                    setType(type: .popular)
                    break
                }
            }
        }
    }
}
