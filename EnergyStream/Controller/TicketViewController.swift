//
//  TicketViewController.swift
//  EnergyStream
//
//  Created by Timur on 1/24/19.
//  Copyright © 2019 Parth Changela. All rights reserved.
//

import UIKit
import Alamofire

class TicketViewController: UIViewController {
    
//    var titleFromTable: String = ""
//    var text: String = ""

    var ticket = Ticket()
    var imageArray = [UIImage]() {
        didSet {
            DispatchQueue.main.async {
                self.attachedImages.reloadData()
            }
        }
    }
    
    @IBOutlet weak var msgSubject: UILabel!
    @IBOutlet weak var msgText: UITextView!
    @IBOutlet weak var viewForElements: UIView!
    @IBOutlet weak var attachedImages: UICollectionView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getImages(ticket: ticket)
        msgText.contentInsetAdjustmentBehavior = .never
        viewForElements.layer.cornerRadius = CGFloat(5)
        self.view.backgroundColor = UIColor(red:0.07, green:0.12, blue:0.28, alpha:0.8)
        self.showAnimate()
        msgSubject.text! = ticket.ticketTitle
        msgText.text! = ticket.ticketMsg
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
    @IBAction func closeWindow() {
        //        dismiss(animated: true, completion: nil)
        self.removeAnimate()
    }
    func getImages(ticket: Ticket) {
        for image in ticket.imagesUrlArray {
            print(image)
            request(URL(string: Constants.URLForApi + image)!, method: .get, encoding: JSONEncoding.default).responseData {
                response in
                guard let data = response.value else { return }
                self.imageArray.append(UIImage(data: data)!)
            }
        }
    }
}

extension TicketViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageCell", for: indexPath) as! ImageViewCell
        cell.photoImage.image = imageArray[indexPath.row]
        print(imageArray.count)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        print("didSelectItemAt method was called")
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ImageShowViewController") as! ImageShowViewController
//        vc.imageForShow =
        vc.configure(image: imageArray[indexPath.row])
        self.addChildViewController(vc)
        vc.view.frame = self.view.frame
        self.view.addSubview(vc.view)
        vc.didMove(toParentViewController: self)
    }
    
    
}
