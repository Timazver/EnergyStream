//
//  AlertService.swift
//  EnergyStream
//
//  Created by Timur on 2/25/19.
//  Copyright © 2019 Parth Changela. All rights reserved.
//

import Foundation
import UIKit

class AlertService {
    
    static func showAlert(title: String, message:String, handler: ((UIAlertAction) -> Void)? = nil ) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ок", style: .default, handler: handler))
        return alert
    }
}
