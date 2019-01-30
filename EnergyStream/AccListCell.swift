//
//  AccListCell.swift
//  memuDemo
//
//  Created by Timur on 1/17/19.
//  Copyright © 2019 Parth Changela. All rights reserved.
//

import UIKit

class AccListCell: UITableViewCell {

    @IBOutlet weak var accNum: UILabel!
    @IBOutlet weak var fullName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
