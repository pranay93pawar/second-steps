//
//  TrackTableViewCell.swift
//  DigitReader
//
//  Created by LT-145-PRANAY-PAWAR on 30/08/17.
//  Copyright © 2017 Pranay Suresh Pawar. All rights reserved.
//

import UIKit

class TrackTableViewCell: UITableViewCell {
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var artist: UILabel!
    @IBOutlet weak var downloadButton: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
