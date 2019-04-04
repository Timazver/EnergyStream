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
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = CGFloat(5)
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture))
        swipeDown.direction = .down
        self.view.addGestureRecognizer(swipeDown)
    }
    

    @objc func handleGesture(gesture: UISwipeGestureRecognizer) -> Void {
       if gesture.direction == UISwipeGestureRecognizerDirection.down {
        self.dismiss(animated: true, completion: nil)
        }
    }

    func configure(image: UIImage) {
        self.imageForShow = image
    }

}
