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
    override func viewDidLoad() {
        super.viewDidLoad()

        if revealViewController() != nil {
            //revealViewController().rearViewRevealWidth = 200
            menu.target = revealViewController()
            menu.action = #selector(SWRevealViewController.revealToggle(_:))
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
        let cell:AccListCell = tableView.cellForRow(at: indexPath) as! AccListCell
        
        
    }
   

}
