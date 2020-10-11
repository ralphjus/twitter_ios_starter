//
//  TweetCellTableViewCell.swift
//  Pods
//
//  Created by Justin Ralph on 10/8/20.
//

import UIKit



class TweetCellTableViewCell: UITableViewCell {

    @IBOutlet var ProfileImageView: UIImageView!

    @IBOutlet var userNameLabel: UILabel!
    
    @IBOutlet var tweetContent: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
