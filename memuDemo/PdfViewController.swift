//
//  PdfViewController.swift
//  memuDemo
//
//  Created by Timur on 1/18/19.
//  Copyright © 2019 Parth Changela. All rights reserved.
//

import UIKit
import WebKit
class PdfViewController: UIViewController {

   
    @IBOutlet weak var webView: WKWebView!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Do any additional setup after loading the view.
    
}
    override func viewDidLayoutSubviews() {
    
    }
    
    @IBAction func closePdfView() {
        dismiss(animated: true, completion: nil)
    }
    

  
}

