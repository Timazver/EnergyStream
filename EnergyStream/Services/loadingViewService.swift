//
//  File.swift
//  EnergyStream
//
//  Created by Timur on 1/23/19.
//  Copyright © 2019 Parth Changela. All rights reserved.
//

import Foundation
import UIKit

class loadingViewService {
    
    /// View which contains the loading text and the spinner
    static let loadingView = UIView()
    
    // Label which contains the text at the right of activity indicator
    static let loadingLabel = UILabel()
    
    /// Spinner shown during load the TableView
    static let spinner = UIActivityIndicatorView()
    
    static func setLoadingScreen(_ view: UITableView, text: String = "Загрузка...") {
        
        // Sets the view which contains the loading text and the spinner
        let width: CGFloat = 120
        let height: CGFloat = 30
        let x = (view.frame.width / 2) - (width / 2)
        let y = (view.frame.height / 2) - (height / 2)
//            - (navigationController?.navigationBar.frame.height)!
        loadingView.frame = CGRect(x:x, y:y, width:width, height:height)
        
        // Sets loading text
        self.loadingLabel.textColor = UIColor.gray
        self.loadingLabel.textAlignment = NSTextAlignment.center
        self.loadingLabel.text = text
        self.loadingLabel.frame = CGRect(x:0,y:0,width: 140,height: 30)
        self.loadingLabel.isHidden = false
        
        // Sets spinner
        self.spinner.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        self.spinner.frame = CGRect(x:0,y: 0,width: 30,height: 30)
        self.spinner.startAnimating()
        
        // Adds text and spinner to the view
        loadingView.addSubview(self.loadingLabel)
        loadingView.addSubview(self.spinner)
        
        
        view.addSubview(loadingView)
        
    }
    
    // Remove the activity indicator from the main view
    static func removeLoadingScreen() {
        
        // Hides and stops the text and the spinner
        self.spinner.stopAnimating()
        self.loadingLabel.isHidden = true
        
        
    }
}
