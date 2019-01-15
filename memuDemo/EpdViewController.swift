//
//  MessageViewController.swift
//  memuDemo
//
//  Created by Parth Changela on 09/10/16.
//  Copyright © 2016 Parth Changela. All rights reserved.
//

import UIKit

class EpdViewController: UIViewController,UITableViewDelegate, UITableViewDataSource{
    
    
    @IBOutlet weak var dropDownTextField: UITextField!
    @IBOutlet weak var epdTableView: UITableView!
    @IBOutlet weak var menu: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Define tableView methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Requests.epdTitles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let epdCell = tableView.dequeueReusableCell(withIdentifier: "EpdCell", for: indexPath ) as! EpdCell
        
        epdCell.title.text! = Requests.epdTitles[indexPath.row]
        if !Requests.epdData.isEmpty {
            epdCell.data.text! = Requests.epdData[indexPath.row]
            
        }
        else {
            self.epdTableView.reloadData()
        }
        
        return epdCell
    }
    func showDropDown() {
    let modalViewController = ModalPickerViewController()
    modalViewController.modalPresentationStyle = .overCurrentContext
        present(modalViewController, animated: true, completion: nil)
    }
    
}
