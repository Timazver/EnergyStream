//
//  ImageShowViewController.swift
//  EnergyStream
//
//  Created by Timur on 3/20/19.
//  Copyright © 2019 Parth Changela. All rights reserved.
//

import UIKit

class ImageShowViewController: UIViewController {
    
    public var imageForShow: UIImage! = UIImage()
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = imageForShow
        imageView.layer.cornerRadius = CGFloat(5)
//        self.view.backgroundColor = UIColor(red:0.07, green:0.12, blue:0.28, alpha:0.8)
        self.view.backgroundColor = UIColor.white.withAlphaComponent(0.8)
        self.showAnimate()
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture))
        swipeDown.direction = .down
        self.view.addGestureRecognizer(swipeDown)
    }
    

    @objc func handleGesture(gesture: UISwipeGestureRecognizer) -> Void {
       if gesture.direction == UISwipeGestureRecognizerDirection.down {
            removeAnimate()
        }
    }

    func configure(image: UIImage) {
        self.imageForShow = image
    }
    
    func showAnimate() {
        self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        self.view.alpha = 0.0;
        UIView.animate(withDuration: 0.25, animations: {
            self.view.alpha = 1.0
            self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        });
    }
    
    func removeAnimate() {
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
