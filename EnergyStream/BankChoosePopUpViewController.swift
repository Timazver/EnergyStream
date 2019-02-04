//
//  BankChoosePopUpViewController.swift
//  EnergyStream
//
//  Created by Timur on 1/28/19.
//  Copyright © 2019 Parth Changela. All rights reserved.
//

import UIKit
import Alamofire



class BankChoosePopUpViewController: UIViewController {

    @IBOutlet weak var  kaspiBtn: UIButton!
    @IBOutlet weak var halykBtn: UIButton!
    @IBOutlet weak var viewForImages: UIView!
    
    var kaspiImageUrl: URL!
    var halykImageUrl: URL!
    var kaspiImage: Data!
    var halykImage: Data!
    var URLForWebView: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red:0.07, green:0.12, blue:0.28, alpha:0.8)
        self.showAnimate()
        kaspiImageUrl = URL(string: Requests.bankArray[1].imgUrl)
        halykImageUrl = URL(string: Requests.bankArray[0].imgUrl)
        do {
            try kaspiImage = Data.init(contentsOf: kaspiImageUrl)
            try halykImage = Data.init(contentsOf: halykImageUrl)
        }
        catch {
            print("error during saving image")
        }
        kaspiBtn.setBackgroundImage(UIImage(data:kaspiImage), for: UIControlState.normal)
        halykBtn.setBackgroundImage(UIImage(data:halykImage), for: UIControlState.normal)
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

    @IBAction func getKaspiPage() {
        URLForWebView = Requests.bankArray[1].link
        performSegue(withIdentifier: "toWebView", sender: self)
    }
    
    @IBAction func getHalykPage() {
        URLForWebView = Requests.bankArray[0].link
        performSegue(withIdentifier: "toWebView", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let newVC = segue.destination as! WebViewController
        newVC.url = self.URLForWebView
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
   
}
