//
//  Movies.swift
//  swiftobjc
//
//  Created by Ashish Kapoor on 07/02/17.
//  Copyright © 2017 Ashish Kapoor. All rights reserved.
//

import Foundation

class Movies {
    
    // Properties
    private var _id                 = Int()
    private var _title              = String()
    private var _release_date       = String()
    private var _overview           = String()
    private var _poster_path        = String()
    private var _popularity         = Double()
    
    init(id: Int?, posterPath: String?, title:String?, overview:String?, release_date:String?, popularity: Double?) {
        
        self._id                    = id                ?? 0
        self._title                 = title             ?? ""
        self._release_date          = release_date      ?? ""
        self._overview              = overview          ?? ""
        self._poster_path           = posterPath        ?? ""
        self._popularity            = popularity        ?? 0.0
    }
    
    // Getters
    var id: Int                     { return _id }
    var title: String               { return _title }
    var releaseDate: String         { return _release_date }
    var overview: String            { return _overview }
    var posterPath: String          { return _poster_path }
    var popularity: Double             { return _popularity }
    
    // Helper method for posters
    func getPosterURL() -> URL      { return getTMDBUrl(posterPath: posterPath) }
}
