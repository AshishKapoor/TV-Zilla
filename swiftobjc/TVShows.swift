//
//  TVShows.swift
//  swiftobjc
//
//  Created by Ashish Kapoor on 19/05/17.
//  Copyright © 2017 Ashish Kapoor. All rights reserved.
//

import Foundation
import TMDBSwift

class TVShows {
    
    // Properties
    private var _id                 = Int()
    private var _title              = String()
    private var _release_date       = String()
    private var _overview           = String()
    private var _poster_path        = String()
    private var _popularity         = Double()
        
    init(tvShowsJSON: TVMDB) {
        
        guard let id = tvShowsJSON.id else {
            self._id = 0
            return
        }
        self._id = id
        
        guard let title = tvShowsJSON.name else {
            self._title = ""
            return
        }
        self._title = title
        
        guard let releaseDate = tvShowsJSON.first_air_date else {
            self._release_date = ""
            return
        }
        self._release_date = releaseDate
        
        guard let overview = tvShowsJSON.overview else {
            self._overview = ""
            return
        }
        self._overview = overview
        
        guard let posterPath = tvShowsJSON.poster_path else {
            self._poster_path = ""
            return
        }
        self._poster_path = posterPath
        
        guard let popularity = tvShowsJSON.popularity else {
            self._popularity = 0.0
            return
        }
        self._popularity = popularity
        
    }
    
    // Getters
    var id: Int                     { return _id }
    var title: String               { return _title }
    var releaseDate: String         { return _release_date }
    var overview: String            { return _overview }
    var posterPath: String          { return _poster_path }
    var popularity: Double          { return _popularity }
    
    // Helper method for posters
    func getPosterURL() -> URL      { return getTMDBUrl(posterPath: posterPath) }
}
