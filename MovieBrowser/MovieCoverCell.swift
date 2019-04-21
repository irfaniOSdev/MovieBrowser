//
//  MovieCoverCell.swift
//  MovieBrowser
//
//  Created by Irfan on 19/04/2019.
//  Copyright © 2019 Irfan. All rights reserved.
//

import UIKit
protocol MovieCoverCellDelegate: class {
    func watchTrailerTapped(movieId: Int)
}

class MovieCoverCell: UITableViewCell {

    @IBOutlet weak var coverImage: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var trailerButton: UIButton!
    weak var delegate: MovieCoverCellDelegate?
    var movieId : Int?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func trailerTapped(_ sender: Any) {
        delegate?.watchTrailerTapped(movieId: movieId ?? 0)
    }
}
