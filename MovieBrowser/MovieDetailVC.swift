//
//  MovieDetailVC.swift
//  MovieBrowser
//
//  Created by Irfan on 19/04/2019.
//  Copyright © 2019 Irfan. All rights reserved.
//

import UIKit
import Alamofire
import Freddy
import AVKit
class MovieDetailVC: UIViewController, UITableViewDelegate, UITableViewDataSource, MovieCoverCellDelegate {
    
    let playerViewController = AVPlayerViewController()
    @IBOutlet weak var movieDetailsTable: UITableView!
    var movieId: String = ""
    var movieDetailModel: MovieDetails?
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NetworkManager.sharedInstance.getMovieDetailRequest(movieId: "\(movieId)?", completion: {(movieDetails) in
            self.movieDetailModel = movieDetails
            
            DispatchQueue.main.async { [weak self] in
                self?.movieDetailsTable.reloadData()
            }

        }) { (text) in
            
            self.displayMessage(userMessage:text)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Movie Detail"
    }
    
    //MARK:- Movie Cover Delegate
    
    func watchTrailerTapped(movieId: Int) {
        // Getting info from Network manager about trailer
        NetworkManager.sharedInstance.getMovieTrailerRequest(movieId: "\(movieId)/", completion:{ (trailer) in
             self.playVideo(videoIdentifier: trailer.key)
        }) { (text) in
            
            self.displayMessage(userMessage:text)
        }
        
    }
    
    // Video Player settings
    func playVideo(videoIdentifier: String?) {
        self.present(playerViewController, animated: true, completion: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.playerDidFinishPlaying(note:)),name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: playerViewController.player?.currentItem)
        XCDYouTubeClient.default().getVideoWithIdentifier(videoIdentifier) { [weak playerViewController] (video: XCDYouTubeVideo?, error: Error?) in
            if let streamURLs = video?.streamURLs, let streamURL = (streamURLs[XCDYouTubeVideoQualityHTTPLiveStreaming] ?? streamURLs[YouTubeVideoQuality.hd720] ?? streamURLs[YouTubeVideoQuality.medium360] ?? streamURLs[YouTubeVideoQuality.small240]) {
                playerViewController?.player = AVPlayer(url: streamURL)
            } else {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    // Call to trailer finish
    @objc func playerDidFinishPlaying(note: NSNotification) {
        print("Video Finished")
        playerViewController.dismiss(animated: false, completion: nil)
    }
    
    // MARK:- Table Delegate and Datasource
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if indexPath.row == 0 {
            return 450
        }
        else if indexPath.row == 1 || indexPath.row == 2 {
            return 70
        }
        else if indexPath.row == 3
        {
            return 187
        }
        
        return UITableView.automaticDimension//Choose your custom row height
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "movieCover", for: indexPath) as! MovieCoverCell
            cell.delegate = self
            if let movieModel = movieDetailModel
            {
                if let poster = movieModel.coverPath
                {
                    let url = MovieURL.imageURL  + poster
                    if let url = URL(string: url)
                    {
                        cell.coverImage.af_setImage(withURL: url)
                    }
                }
                cell.movieId = movieModel.id
                cell.title.text = movieModel.title
            }
            
            return cell
        }
        else if indexPath.row == 1
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "movieGenre", for: indexPath) as! MovieGenreCell
            let myDict = movieDetailModel?.genres?.reduce(into: [String: String]()) {
                $0[$1.name] = $1.name
            }
            let names = myDict?.compactMap { return $0.key }
            let joined = names?.joined(separator: ", ")
            cell.genresLabel.text = joined
            return cell
            
        }
        else if indexPath.row == 2
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "movieDate", for: indexPath) as! MovieDateCell
            cell.dateLabel.text = movieDetailModel?.releaseDate
            
            return cell
        }
        else if indexPath.row == 3
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "movieOverview", for: indexPath) as! MovieOverviewCell
            cell.overviewText.text = movieDetailModel?.overview
            return cell
        }
        
        return UITableViewCell()
    }
    func displayMessage(userMessage:String) -> Void {
        DispatchQueue.main.async
            {
                let alertController = UIAlertController(title: "Alert", message: userMessage, preferredStyle: .alert)
                
                let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
                    // Code in this block will trigger when OK button tapped.
                    print("Ok button tapped")
                    DispatchQueue.main.async
                        {
                            self.dismiss(animated: true, completion: nil)
                    }
                }
                alertController.addAction(OKAction)
                self.present(alertController, animated: true, completion:nil)
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
