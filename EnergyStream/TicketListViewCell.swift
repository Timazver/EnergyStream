//
//  TicketListViewCell.swift
//  EnergyStream
//
//  Created by Timur on 1/23/19.
//  Copyright © 2019 Parth Changela. All rights reserved.
//

import UIKit

class TicketListViewCell: UITableViewCell {
    
    @IBOutlet weak var ticketNumber: UILabel!
    @IBOutlet weak var ticketTitle:UILabel!
    @IBOutlet weak var ticketDate: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
