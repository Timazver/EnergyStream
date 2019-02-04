//
//  TicketViewController.swift
//  EnergyStream
//
//  Created by Timur on 1/24/19.
//  Copyright © 2019 Parth Changela. All rights reserved.
//

import UIKit

class TicketViewController: UIViewController {
    
    var titleFromTable: String = ""
    var text: String = ""
    
    @IBOutlet weak var msgSubject: UILabel!
    @IBOutlet weak var msgText: UITextView!
    @IBOutlet weak var viewForElements: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewForElements.backgroundColor = UIColor.white
        self.viewForElements.layer.cornerRadius = CGFloat(5)
        self.view.backgroundColor = UIColor(red:0.07, green:0.12, blue:0.28, alpha:0.8)
        self.showAnimate()
//        viewForElements.backgroundColor = .black
        msgSubject.text! = titleFromTable
        msgText.text! = text
        // Do any additional setup after loading the view.
    }
    

    func showAnimate()
    {
        self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        self.view.alpha = 0.0;
        UIView.animate(withDuration: 0.25, animations: {
            self.view.alpha = 1.0
            self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        });
    }
    
    func removeAnimate()
    {
        UIView.animate(withDuration: 0.25, animations: {
            self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.view.alpha = 0.0;
        }, completion:{(finished : Bool)  in
            if (finished)
            {
                self.view.removeFromSuperview()
            }
        });
    }
}
