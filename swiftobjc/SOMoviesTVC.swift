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
import PeekPop

class SOMoviesTVC: UITableViewController, PeekPopPreviewingDelegate, UISearchBarDelegate {
    
    @IBOutlet weak var moviesSearchBar: UISearchBar!

    var movies: [Movies]                = []
    var status: LoadingStatus?          = nil
    var pageNumber                      = Int()
    var totalPages                      = Int()
    var fromReleaseYear                 = String()
    var tillReleaseYear                 = String()
    var currentMovieType                = typeOfMovies.nowPlaying
    var isFromFilteredMovies            = false
    var peekPop: PeekPop?
    var loading: DPBasicLoading?
    var startAppBanner: STABannerView?

    override func viewDidLoad() {
        super.viewDidLoad()
        pageNumber = kInitialValue
        setupTableView()
        setupSearchBar()
        loading?.startLoading(text: "Loading...")

        setType(type: currentMovieType)
        loading = DPBasicLoading(table: tableView)

        moviesSearchBar.delegate = self
        
        peekPop = PeekPop(viewController: self)
        peekPop?.registerForPreviewingWithDelegate(self, sourceView: tableView)
        // Ads
        if (startAppBanner == nil) {
            startAppBanner = STABannerView(size: STA_AutoAdSize, autoOrigin: STAAdOrigin_Bottom, with: self.view, withDelegate: nil);
            self.tableView.addSubview(startAppBanner!)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if (isFromFilteredMovies) {
            clearOldList()
            isFromFilteredMovies = false
        }
    }
    
    func setupSearchBar() {
        view.endEditing(true)
    }
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        moviesSearchBar.showsCancelButton = true
        return true
    }
    
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        moviesSearchBar.showsCancelButton = false
        return true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
        searchBar.text = ""
        clearOldList()
        setType(type: currentMovieType)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        loading?.startLoading(text: "Loading...")
        SearchMDB.movie(apikey, query: searchBar.text!, language: kEnglishLanguage, page: self.pageNumber, includeAdult: true, year: nil, primaryReleaseYear: nil){
            data, movies in
            guard let moviesSearched = movies else {
                self.showPopupWithTitle(title: "Not found!", message: "Try other names...", interval: 1)
                return
            }
            
            self.totalPages = (data.pageResults?.total_pages)!
            self.title      = "Movies"
            self.clearOldList()
            self.getMovies(movieData: moviesSearched)
        }
        view.endEditing(true)
//        searchBar.text = ""
    }
    
    func showPopupWithTitle(title: String, message: String, interval: TimeInterval) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        present(alertController, animated: true, completion: nil)
        self.perform(#selector(dismissAlertViewController), with: alertController, afterDelay: interval)
    }
    
    func dismissAlertViewController(alertController: UIAlertController) {
        alertController.dismiss(animated: true, completion: nil)
    }
    
    func previewingContext(_ previewingContext: PreviewingContext, viewControllerForLocation location: CGPoint) -> UIViewController? {
        let storyboard = UIStoryboard(name:"Main", bundle:nil)
        if let previewViewController = storyboard.instantiateViewController(withIdentifier: "SOMoviesDetailVC") as? SOMoviesDetailVC {
            if let indexPath = tableView.indexPathForRow(at: location) {
                previewViewController.itemPosterURL        = self.movies[indexPath.row].posterPath
                previewViewController.itemID               = self.movies[indexPath.row].id
                previewViewController.itemOverview         = self.movies[indexPath.row].overview
                previewViewController.itemTitle            = self.movies[indexPath.row].title
                previewViewController.itemReleaseDate      = self.movies[indexPath.row].releaseDate
                
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
        setType(type: currentMovieType)
        refreshControl?.endRefreshing()
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
        if self.movies.count > 0 {
            self.movies.removeAll()
        }
    }
    
    override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        view.endEditing(true)
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
            MovieMDB.toprated(apikey, language: kEnglishLanguage, page: self.pageNumber) { [weak self]
                data, topRatedMovies in
                guard let movie = topRatedMovies else { return }
                
                self?.totalPages = (data.pageResults?.total_pages)!
                self?.title = kTopRatedMovies
                self?.getMovies(movieData: movie)
            }
            break
        case .nowPlaying:
            MovieMDB.nowplaying(apikey, language: kEnglishLanguage, page: self.pageNumber) { [weak self]
                data, nowPlaying in
                guard let movie = nowPlaying else { return }
                
                self?.totalPages = (data.pageResults?.total_pages)!
                self?.title = kNowPlayingMovies
                self?.getMovies(movieData: movie)
            }
            break
        case .upcoming:
            MovieMDB.upcoming(apikey, page: self.pageNumber, language: kEnglishLanguage) { [weak self]
                data, upcomingMovies in
                guard let movie = upcomingMovies else { return }
                
                self?.totalPages = (data.pageResults?.total_pages)!
                self?.title = kUpcomingMovies
                self?.getMovies(movieData: movie)
            }
            break
        case .popular:
            MovieMDB.popular(apikey, language: kEnglishLanguage, page: self.pageNumber) { [weak self]
                data, popularMovies in
                guard let movie = popularMovies else { return }
                
                self?.totalPages = (data.pageResults?.total_pages)!
                self?.title = kPopularMovies
                self?.getMovies(movieData: movie)
            }
            break
        case .filtered:
            DiscoverMovieMDB.discoverMovies(apikey: apikey, language: kEnglishLanguage, page: Double(self.pageNumber),
                                            primary_release_date_gte: self.fromReleaseYear,
                                            primary_release_date_lte: self.tillReleaseYear) { [weak self]
                data, filteredMovies  in
                guard let movie = filteredMovies else { return }
                                                
                self?.totalPages = (data.pageResults?.total_pages)!
                self?.title = kReleaseDates
                self?.getMovies(movieData: movie)
            }
            break
        }
    }
    
    func getMovies(movieData: [MovieMDB] ) {
        for movieIterator in movieData {
            self.movies.append(Movies(
                    id: movieIterator.id,
                    posterPath: movieIterator.poster_path,
                    title: movieIterator.title,
                    overview: movieIterator.overview,
                    release_date: movieIterator.release_date,
                    popularity: movieIterator.popularity
                )
            )
        }
        self.reloadTable()
    }

    func reloadTable() {
        DispatchQueue.global(qos: .default).async {
            DispatchQueue.main.async {
                self.loading?.endLoading()
                self.refreshControl?.endRefreshing()
                self.tableView.reloadData()
                self.status = LoadingStatus.StatusLoaded
            }
        }
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
            cell.movieNameLabel?.text               = kLoadingStateText
            cell.movieYearLabel?.text               = kLoadingStateText
            cell.moviePlotLabel?.text               = kLoadingStateText
            cell.moviesImageView?.image             = kDefaultMovieImage
        } else if self.status == LoadingStatus.StatusLoaded {
            cell.movieNameLabel?.text               = self.movies[indexPath.row].title
            cell.movieYearLabel?.text               = self.movies[indexPath.row].releaseDate
            cell.moviesImageView.kf.setImage(with: self.movies[indexPath.row].getPosterURL(),
                                             placeholder: UIImage(named: "movie-poster-not-found"),
                                             options: nil, progressBlock: nil, completionHandler: nil)
            cell.moviePlotLabel.text                = self.movies[indexPath.row].overview
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (tableView.cellForRow(at: indexPath) as? SOMoviesTVCell) != nil {
            let soMoviesDetailVC = soStoryBoard.instantiateViewController(withIdentifier: "SOMoviesDetailVC") as? SOMoviesDetailVC
            soMoviesDetailVC?.itemPosterURL        = self.movies[indexPath.row].posterPath
            soMoviesDetailVC?.itemID               = self.movies[indexPath.row].id
            soMoviesDetailVC?.itemOverview         = self.movies[indexPath.row].overview
            soMoviesDetailVC?.itemTitle            = self.movies[indexPath.row].title
            soMoviesDetailVC?.itemReleaseDate      = self.movies[indexPath.row].releaseDate
            soMoviesDetailVC?.itemPopularity       = self.movies[indexPath.row].popularity
            self.navigationController?.pushViewController(soMoviesDetailVC!, animated: true)
        }
        view.endEditing(true)
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
