//
//  ViewController.swift
//  MovieBrowser
//
//  Created by Irfan on 15/04/2019.
//  Copyright © 2019 Irfan. All rights reserved.
//

import UIKit
import AVKit
import Alamofire
import Freddy
class MovieListVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    var searchActive = false
    let playerViewController = AVPlayerViewController()
    var moviesArray : [Movie] = []
    var searchMoviesArray : [Movie] = []
    var searchBarYPosition : CGFloat = 0.0
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var movieListTable: UITableView!
  
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Movie Catalog"
        //Saving Search Bar Initial Y Position
        searchBarYPosition = searchBar.frame.origin.y
        searchBar.delegate = self

        //Notification Settings when keyboard show and hide
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        
        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        tap.cancelsTouchesInView = false
        
         view.addGestureRecognizer(tap)
        //registering custom Movie Cell nib
        movieListTable.register(UINib(nibName: "MovieCell", bundle: nil), forCellReuseIdentifier: "MovieCell")
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        searchBar.text = ""
        searchBar.becomeFirstResponder()
        // getting list of Movies from NetworkManager
        
        NetworkManager.sharedInstance.getMoviesRequest(completion:{ (movies) in
            
            self.moviesArray = movies
            // Reloading Table on UI thread
            DispatchQueue.main.async { [weak self] in
                self?.movieListTable.reloadData()
            }
        }) { (text) in
            
            self.displayMessage(userMessage:text)
        }
    }
    
    // Pragma Mark:- SearchBar Delegates
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchActive = false
    }
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
    
    }
    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        text.count > 0 ? (searchActive = true) : (searchActive = false)
        self.movieListTable.reloadData()
        return true
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.count == 0 {
            return
        }
        
        // Filtering main movies array by title
        let filtered = moviesArray.filter { (data) -> Bool in
            return data.title?.range(of: searchText, options: String.CompareOptions.caseInsensitive) != nil
        }
        
        // Updating data source according to search text
        
        searchMoviesArray = filtered

        if (searchMoviesArray.count == 0){
            searchActive = false
        }
        else{
            searchActive = true
            self.movieListTable.reloadData()
        }
    }
    
    // handle keyboard
    @objc func keyboardWillShow(notification: NSNotification) {
        // Getting keyboard height and setting search bar position according to it
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            if self.searchBar.frame.origin.y == searchBarYPosition {
                self.searchBar.frame.origin.y -= keyboardHeight
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        //update search bar position when keyboard hides
        if self.searchBar.frame.origin.y <= searchBarYPosition {
            self.searchBar.frame.origin.y = searchBarYPosition
        }
    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    //# Pragma Mark:- Table DataSource and Delegates
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return searchActive ? searchMoviesArray.count : moviesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MovieCell
        let movie = searchActive ? searchMoviesArray[indexPath.row] : moviesArray[indexPath.row]
        cell.movieTitle.text = movie.title
        let urlStr = MovieURL.imageURL  + movie.posterPath!
        if let url = URL(string: urlStr)
        {
          cell.movieThumbnail.af_setImage(withURL: url)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let moviedetail = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MovieDetailVC") as! MovieDetailVC
        let movie = moviesArray[indexPath.row]
        moviedetail.movieId = "\(movie.id ?? 0)"
        navigationController?.pushViewController(moviedetail, animated: false)
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
}

