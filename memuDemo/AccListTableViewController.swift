//
//  AccListTableViewController.swift
//  memuDemo
//
//  Created by Timur on 1/17/19.
//  Copyright © 2019 Parth Changela. All rights reserved.
//

import UIKit

class AccListTableViewController: UITableViewController {
    @IBOutlet weak var menu: UIBarButtonItem!
    @IBOutlet weak var accAddBtn: UIBarButtonItem!
    @IBOutlet weak var accListTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        if revealViewController() != nil {
            //revealViewController().rearViewRevealWidth = 200
            accListTableView.separatorStyle = UITableViewCellSeparatorStyle.none
            menu.target = revealViewController()
            menu.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        // Do any additional setup after loading the view.
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Requests.listAccountNumbers.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AccListCell") as! AccListCell
        cell.textLabel?.text! = Requests.listAccountNumbers[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let revealviewcontroller:SWRevealViewController = self.revealViewController()
        
        let cell:AccListCell = tableView.cellForRow(at: indexPath) as! AccListCell
        print(Requests.currentAccoutNumber)
        Requests.currentAccoutNumber = (cell.textLabel?.text) ?? Requests.listAccountNumbers[0]
        
        let mainstoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewcontroller = mainstoryboard.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
        let newFrontController = UINavigationController.init(rootViewController: newViewcontroller)
        
        revealviewcontroller.pushFrontViewController(newFrontController, animated: true)
        
    }
   

}
