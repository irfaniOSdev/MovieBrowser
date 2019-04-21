//
//  MovieOverviewCell.swift
//  MovieBrowser
//
//  Created by Irfan on 19/04/2019.
//  Copyright © 2019 Irfan. All rights reserved.
//

import UIKit

class MovieOverviewCell: UITableViewCell {

    @IBOutlet weak var overviewText: UITextView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
