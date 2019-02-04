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
    var ticketListArr = [Ticket]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadingViewService.setLoadingScreen(ticketListTableView)
        self.ticketListTableView.backgroundColor = UIColor(red:0.94, green:0.94, blue:0.95, alpha:1.0)
        
        ticketListTableView.separatorStyle = UITableViewCellSeparatorStyle.none
        
        print("ticketListArray count is \(ticketListArr.count)")
//        let addTicket = UIBarButtonItem(barButtonSystemItem:.add, target: self, action: #selector(addTicketVC))
//        self.navigationItem.rightBarButtonItem = addTicket
        // Do any additional setup after loading the view.
    }
    
    @objc func addTicketVC(sender: UIButton) {
//        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
//        let newVC = storyBoard.instantiateViewController(withIdentifier: "AddTicketViewController") as! AddTicketViewController
//        self.present(newVC, animated: true, completion: nil)
        performSegue(withIdentifier: "toAddTicketVC", sender: self)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {

            return Requests.ticketListArray.count
//        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return 1
        }
      
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ticketCell", for: indexPath ) as! TicketListViewCell
//        cell.textLabel?.numberOfLines = 0
//        cell.textLabel?.lineBreakMode = .byWordWrapping
        print("Filling cells")
        if !Requests.ticketListArray.isEmpty {
            cell.ticketNumber.text = "№ \(Requests.ticketListArray[indexPath.row].ticketNumber)"
            cell.ticketTitle.text = Requests.ticketListArray[indexPath.row].ticketTitle
            cell.ticketDate.text = Requests.ticketListArray[indexPath.row].date
            loadingViewService.removeLoadingScreen()
            print(Requests.ticketListArray[indexPath.row].date)
        }
        else {
            ticketListTableView.reloadData()
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        msgTitle = Requests.ticketListArray[indexPath.row].ticketTitle
        msgText = Requests.ticketListArray[indexPath.row].ticketMsg
        self.showTicket(msgTitle: msgTitle, msgText: msgText)
//        performSegue(withIdentifier: "toTicketVC", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toAddTicketVC" {
            let newVC = segue.destination as! AddTicketViewController
        }
        else {
        let ticketVC = segue.destination as! TicketViewController
        ticketVC.titleFromTable = msgTitle
        ticketVC.text = msgText
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70.0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 120
        }
        
        else {
            return 5
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 130))
        headerView.backgroundColor = .clear
        self.view.addSubview(headerView)
   
        let addBtn = UIButton()
        addBtn.backgroundColor = UIColor(red:0.11, green:0.60, blue:0.87, alpha:1.0)
        addBtn.layer.cornerRadius = CGFloat(5)
        addBtn.setTitleColor(UIColor.white, for: .normal)
        addBtn.setTitle("Подать заявку", for: .normal)
        addBtn.addTarget(self, action: #selector(self.addTicketVC(sender:)), for:.touchUpInside)
        headerView.addSubview(addBtn)
            
        addBtn.translatesAutoresizingMaskIntoConstraints = false
        addBtn.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 10.0).isActive = true
        addBtn.centerXAnchor.constraint(equalTo: headerView.centerXAnchor).isActive = true
        addBtn.layer.cornerRadius = CGFloat(5)
        addBtn.widthAnchor.constraint(equalToConstant: 280).isActive = true
        addBtn.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        let ticketNumLbl = UILabel(frame: CGRect(x: 10, y: 80, width: 150, height: 30))
        ticketNumLbl.numberOfLines = 0
        ticketNumLbl.font = UIFont.systemFont(ofSize: 15.0)
        ticketNumLbl.textColor = UIColor.gray
        ticketNumLbl.text = "Номер заявки"
        
        let dateLbl = UILabel(frame: CGRect(x: self.view.frame.width - 90, y: 80, width: 150, height: 30))
        dateLbl.numberOfLines = 0
        dateLbl.font = UIFont.systemFont(ofSize: 15.0)
        dateLbl.textColor = UIColor.gray
        dateLbl.text = "Дата"
            
        
        headerView.addSubview(ticketNumLbl)
        headerView.addSubview(dateLbl)
      
        return headerView
        }
        
        else {
            return UIView()
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor.white
    }
    
    func showTicket(msgTitle: String, msgText: String) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let TicketVC = storyboard.instantiateViewController(withIdentifier: "TicketViewController") as! TicketViewController
        self.addChildViewController(TicketVC)
        TicketVC.view.frame = self.view.frame
        self.view.addSubview(TicketVC.view)
        TicketVC.msgText.text! = msgText
        TicketVC.msgSubject.text! = msgTitle
        TicketVC.didMove(toParentViewController: self)
    }
}

