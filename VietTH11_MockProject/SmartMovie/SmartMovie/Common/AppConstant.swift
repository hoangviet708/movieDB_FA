//
//  ServerConstant.swift
//  SmartMovie
//
//  Created by Hoang Viet on 30/03/2023.
//

import Foundation

struct ServerConstant {
    struct URLBase {
        static var baseURL = "https://api.themoviedb.org/3/movie/"
        static var baseURLImage = "https://image.tmdb.org/t/p/w500/"
    }

    struct APIPath {
        static let popular = "popular"
        static let topRated = "top_rated"
        static let upComming = "upcoming"
        static let nowPlaying = "now_playing"
    }
}

struct AppConstant {
    static let appName = "Smart Movie"
}
