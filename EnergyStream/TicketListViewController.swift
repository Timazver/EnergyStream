//
//  TicketListViewController.swift
//  EnergyStream
//
//  Created by Timur on 1/22/19.
//  Copyright © 2019 Parth Changela. All rights reserved.
//

import UIKit

class TicketListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet var ticketListTableView: UITableView!
    var msgTitle: String = ""
    var msgText: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadingViewService.setLoadingScreen(ticketListTableView)
        ticketListTableView.separatorStyle = UITableViewCellSeparatorStyle.none
        
        print("ticketListArray count is \(Requests.ticketListArray.count)")
        let addTicket = UIBarButtonItem(barButtonSystemItem:.add, target: self, action: #selector(addTicketVC))
        self.navigationItem.rightBarButtonItem = addTicket
        // Do any additional setup after loading the view.
    }
    
    @objc func addTicketVC() {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let newVC = storyBoard.instantiateViewController(withIdentifier: "AddTicketViewController") as! AddTicketViewController
        self.present(newVC, animated: true, completion: nil)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return Requests.ticketListArray.count
        }
      
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ticketCell", for: indexPath ) as! TicketListViewCell
//        cell.textLabel?.numberOfLines = 0
//        cell.textLabel?.lineBreakMode = .byWordWrapping
        print("Filling cells")
        if Requests.ticketListArray.isEmpty {
            print("Trying to reload table data")
            
            ticketListTableView.reloadData()
            
        }
        
        else {
            cell.ticketNumber.text = Requests.ticketListArray[indexPath.row].ticketNumber
            cell.ticketTitle.text = Requests.ticketListArray[indexPath.row].ticketTitle
            cell.ticketDate.text = Requests.ticketListArray[indexPath.row].date
            loadingViewService.removeLoadingScreen()
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        msgTitle = Requests.ticketListArray[indexPath.row].ticketTitle
        msgText = Requests.ticketListArray[indexPath.row].ticketMsg
        performSegue(withIdentifier: "toTicketVC", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let ticketVC = segue.destination as! TicketViewController
        ticketVC.titleFromTable = msgTitle
        ticketVC.text = msgText
        
    }
}
