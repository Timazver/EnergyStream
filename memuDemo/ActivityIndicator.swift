//
//  ActivityIndicator.swift
//  memuDemo
//
//  Created by Timur on 1/20/19.
//  Copyright © 2019 Parth Changela. All rights reserved.
//

import UIKit

class ActivityIndicator: UIActivityIndicatorView {

    func start(_ sender: AnyObject) {
//        self.center = .center
        self.hidesWhenStopped = true
        self.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        sender.addSubview(self)
        self.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()
    }
    
    func stop(_ sender: AnyObject) {
        self.stopAnimating()
        UIApplication.shared.endIgnoringInteractionEvents()
    }

}
