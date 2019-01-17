//
//  MessageViewController.swift
//  memuDemo
//
//  Created by Parth Changela on 09/10/16.
//  Copyright © 2016 Parth Changela. All rights reserved.
//

import UIKit

class EpdViewController: UIViewController,UITableViewDelegate, UITableViewDataSource{
    
    
//    @IBOutlet weak var dropDownTextField: UITextField!
    @IBOutlet weak var epdTableView: UITableView!
    @IBOutlet weak var menu: UIBarButtonItem!
//    @IBOutlet weak var energyStreamTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Начисления"
        Requests.getListAccountNumbers()
        epdTableView.separatorStyle = UITableViewCellSeparatorStyle.none
        Requests.getUserEpd(Requests.currentAccoutNumber)
        // Do any additional setup after loading the view.
            if revealViewController() != nil {
        //revealViewController().rearViewRevealWidth = 200
                menu.target = revealViewController()
                menu.action = #selector(SWRevealViewController.revealToggle(_:))
            }
    }

  
    
    //Define tableView methods
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Requests.epdTitles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let epdCell = tableView.dequeueReusableCell(withIdentifier: "EpdCell", for: indexPath ) as! EpdCell
        print("tableView method was called")
        print(Requests.epdModel)
        
        if !Requests.epdModel.isEmpty {
            epdCell.title.text! = Requests.epdTitles[indexPath.row]
            switch Requests.epdTitles[indexPath.row] {
                case "Организация":
                    epdCell.data.text! = Requests.epdModel[0].organization
                case "Назначение":
                    epdCell.data.text! = Requests.epdModel[0].destination
                case "К оплате":
                    epdCell.data.text! = Requests.epdModel[0].sumForPayment
                default:
                    break
            }
//            print(Requests.epdData[indexPath.row])
        }
        else {
            self.epdTableView.reloadData()
        }
        
        return epdCell
    }
//    func showDropDown() {
//    let modalViewController = ModalPickerViewController()
//    modalViewController.modalPresentationStyle = .overCurrentContext
//        present(modalViewController, animated: true, completion: nil)
//    }
    
}
