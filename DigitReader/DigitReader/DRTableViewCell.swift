//
//  DRTableViewCell.swift
//  DigitReader
//
//  Created by Pranay Suresh Pawar on 21/06/17.
//  Copyright © 2017 Pranay Suresh Pawar. All rights reserved.
//

import UIKit

class DRTableViewCell: UITableViewCell {

    @IBOutlet weak var showImage: UIImageView!
    @IBOutlet weak var showTitle: UILabel!
    @IBOutlet weak var showAuthor: UILabel!
    @IBOutlet weak var showDate: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
