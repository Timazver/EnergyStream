//
//  EpdCellTableViewCell.swift
//  memuDemo
//
//  Created by Timur on 1/10/19.
//  Copyright © 2019 Parth Changela. All rights reserved.
//

import UIKit

class EpdCell: UITableViewCell {

    @IBOutlet weak  var title: UILabel!
//    @IBOutlet weak var data: UILabel!
    @IBOutlet weak var switchForEpd: UISwitch!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
