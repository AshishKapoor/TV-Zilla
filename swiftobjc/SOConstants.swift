//
//  SOConstants.swift
//  swiftobjc
//
//  Created by Ashish Kapoor on 07/02/17.
//  Copyright © 2017 Ashish Kapoor. All rights reserved.
//

import Foundation
import UIKit

let apikey      = "2de045dee84cbaea635494518315f957"

func getImageURL(movieId: Int) -> URL {
    let url : NSString = "https://api.themoviedb.org/3/movie/\(movieId)/images?api_key=\(apikey)&language=en-US" as NSString
    let urlStr : NSString = url.addingPercentEscapes(using: String.Encoding.utf8.rawValue)! as NSString
    let imageURL : NSURL = NSURL(string: urlStr as String)!
    return imageURL as URL
}

enum typeOfMovies: String {
    case upcoming
    case topRated
    case nowPlaying
    case popular
}

let kTableViewBackgroundColor   = UIColor.init(white: 0.969, alpha: 1.000)

let kLoadingStateText           = "Loading..."
let kDefaultMovieImage          = UIImage(named: "movie-poster-not-found")

enum LoadingStatus {
    case StatusLoading
    case StatusLoaded
    case StatusLoadingFailed
}
