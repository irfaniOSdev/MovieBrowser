//
//  NetworkManager.swift
//  MovieBrowser
//
//  Created by Irfan on 21/04/2019.
//  Copyright © 2019 Irfan. All rights reserved.
//

import UIKit
import Alamofire
import Freddy
import AlamofireImage
private let networkManager = NetworkManager()

class NetworkManager {
    
    class var sharedInstance: NetworkManager {
        
        struct Static {
            static let instance: NetworkManager = NetworkManager()
        }
        
        return Static.instance
    }
    
    var doesTheInternetWork: Bool {
        return NetworkReachabilityManager()!.isReachable
    }
    
    func getMoviesRequest(completion: @escaping ([Movie]) -> (), onFailure failure: @escaping (String) -> ()) {
        let url = MovieURL.PopularMoviesURL + MovieURL.apiKey
        if doesTheInternetWork {
            Alamofire.request(url).responseJSON { response in
                
                if let error = response.error {
                    print("!!! \(error)")
                } else {
                    
                    if let data = response.data {
                        switch response.result {
                        case .success:
                            
                            do {
                                let json = try JSON(data: data)
                                let movies = try json.getArray(at: "results").map(Movie.init)
                                completion(movies)
                                
                            } catch {
                                // do something with the error
                                let errorDescription = "JSON decoder fail with data: \(String(data: data, encoding: .utf8) ?? "")"
                                failure(errorDescription)
                            }
                            break
                        case .failure( _):
                            let errorDescription = "JSON decoder fail with data: \(String(data: data, encoding: .utf8) ?? "")"
                            failure(errorDescription)
                            break
                            
                        }
                    }
                   
                }
            }
        } else {
            failure("No internet connection!")
            print("no internet connection")
        }
    }
    
    func getMovieDetailRequest(movieId: String, completion: @escaping (MovieDetails) -> (), onFailure failure: @escaping (String) -> ()) {
        let url = MovieURL.MovieBaseURL + movieId + MovieParams.apiKey + MovieURL.apiKey
        if doesTheInternetWork {
            Alamofire.request(url).responseJSON { response in
                
                if let error = response.error {
                    print("!!! \(error)")
                } else {
                    
                    if let data = response.data {
                        
                        do {
                            let decoder = JSONDecoder()
                            let movieDetails = try decoder.decode(MovieDetails.self, from: data)
                            completion(movieDetails)

                        } catch {
                            print("JSON decoder fail with data: \(String(data: data, encoding: .utf8) ?? "")")
                            let errorDescription = "JSON decoder fail with data: \(String(data: data, encoding: .utf8) ?? "")"

                            failure(errorDescription)

                        }
                    }
                }
            }
        } else {
            failure("No internet connection!")
            print("no internet connection")
        }
    }

    func getMovieTrailerRequest(movieId: String, completion: @escaping (MovieVideo) -> (), onFailure failure: @escaping (String) -> ()) {
        let url = MovieURL.MovieBaseURL + movieId + MovieParams.videoKey + MovieParams.apiKey + MovieURL.apiKey
        if doesTheInternetWork {
            Alamofire.request(url).responseJSON { response in
                
                if let error = response.error {
                    print("!!! \(error)")
                } else {
                    
                    if let data = response.data {
                        
                        do {
                            
                            let json = try JSON(data: response.data!)
                            let moviesTrailers = try json.getArray(at: "results").map(MovieVideo.init)
                            let movieTrailer = moviesTrailers[0]
                            completion(movieTrailer)
                            
                        } catch {
                            print("JSON decoder fail with data: \(String(data: data, encoding: .utf8) ?? "")")
                            let errorDescription = "JSON decoder fail with data: \(String(data: data, encoding: .utf8) ?? "")"
                            failure(errorDescription)

                        }
                    }
                }
            }
        } else {
            failure("No internet connection!")
            print("no internet connection")
        }
    }

    
}
