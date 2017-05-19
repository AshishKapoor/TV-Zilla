//
//  SOConstants.swift
//  swiftobjc
//
//  Created by Ashish Kapoor on 07/02/17.
//  Copyright © 2017 Ashish Kapoor. All rights reserved.
//

import Foundation
import UIKit

// TMDb ApiKey-v3
let apikey                      = "2de045dee84cbaea635494518315f957"

// List of movies type
let kTopRatedMovies             = "Top Rated Movies"
let kNowPlayingMovies           = "Now Playing"
let kUpcomingMovies             = "Upcoming Movies"
let kPopularMovies              = "Popular Movies"
let kReleaseDates               = "Release Dates"

// List of TVShows type
let kTopRatedTVShows            = "Top Rated TV Shows"
let kPopularTVShows             = "Popular TV Shows"
let kOnTheAirTVShows            = "On The Air TV Shows"

enum typeOfMovies: String {
    case upcoming
    case topRated
    case nowPlaying
    case popular
    case filtered
}

enum typeOfTVShows: String {
    case ontheair
    case toprated
    case popular
}

// Table and defaults
let kLoadingStateText           = "Loading..."
let kTableViewBackgroundColor   = UIColor.init(white: 0.969, alpha: 1.000)
let kDefaultMovieImage          = UIImage(named: "movie-poster-not-found")
let kDefaultTVShowImage         = UIImage(named: "movie-poster-not-found")

enum LoadingStatus {
    case StatusLoading
    case StatusLoaded
    case StatusLoadingFailed
}

let kDateTimeFormat             = "yyyy-MM-dd"
let kEnglishLanguage            = "en"
let kCancel                     = "Cancel"
let kOkay                       = "Okay"

let kMinimumYear                = "Minimum Year"
let kMaximumYear                = "Maximum Year"
let kFilter                     = "Filter"

let kInitialValue               = 1

let soStoryBoard: UIStoryboard  = UIStoryboard(name: "Main", bundle: nil)

func getTMDBUrl (posterPath: String) -> URL {
    return URL(string: "https://image.tmdb.org/t/p/w500\(posterPath)")!
}

