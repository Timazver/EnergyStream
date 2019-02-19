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
    @IBOutlet weak var icon: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        contentView.layoutMargins = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
//    }


    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
