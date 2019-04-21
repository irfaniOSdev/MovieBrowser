//
//  Constants.swift
//  MovieBrowser
//
//  Created by Irfan on 21/04/2019.
//  Copyright © 2019 Irfan. All rights reserved.
//

import UIKit

struct MovieURL {
    static let apiKey = "1f54bd990f1cdfb230adb312546d765d"
    static let PopularMoviesURL = "https://api.themoviedb.org/3/movie/popular?api_key="
    static let MovieBaseURL = "https://api.themoviedb.org/3/movie/"
    static let imageURL = "http://image.tmdb.org/t/p/w342"
}
struct MovieParams
{
    static let apiKey = "api_key="
    static let videoKey = "videos?"

}
struct YouTubeVideoQuality {
    static let hd720 = NSNumber(value: XCDYouTubeVideoQuality.HD720.rawValue)
    static let medium360 = NSNumber(value: XCDYouTubeVideoQuality.medium360.rawValue)
    static let small240 = NSNumber(value: XCDYouTubeVideoQuality.small240.rawValue)
}

