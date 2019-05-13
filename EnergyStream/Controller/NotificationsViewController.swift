//
//  NotificationsViewController.swift
//  EnergyStream
//
//  Created by Timur on 3/8/19.
//  Copyright © 2019 Parth Changela. All rights reserved.
//

import UIKit


class NotificationsViewController: UIViewController {
    
     var refreshControl: UIRefreshControl!
    
    var notificationText: String = ""
    var notificationListArr = [Notification]() {
        didSet {
            DispatchQueue.main.async {
                self.notificationsTableView.reloadData()
            }
            
        }
    }
    
    @IBOutlet var notificationsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Уведомления"
        self.navigationController!.navigationBar.backItem!.title = "Назад"
        self.notificationsTableView.tableHeaderView = self.createHeaderView()
        self.notificationsTableView.backgroundColor = UIColor(red:0.94, green:0.94, blue:0.95, alpha:1.0)
        notificationsTableView.separatorStyle = UITableViewCellSeparatorStyle.none
        self.getNotificationsList()
        print("notificationListArr count is \(notificationListArr.count)")
        
        refreshControl = UIRefreshControl()
        //        refreshControl.attributedTitle = NSAttributedString(string: "Идет обновление")
        refreshControl.addTarget(self, action: #selector(refresh(sender:)), for: UIControlEvents.valueChanged)
        notificationsTableView.addSubview(refreshControl)
        // Do any additional setup after loading the view.
    }
    
    @objc func refresh(sender: AnyObject) {
        self.getNotificationsList()
        self.notificationsTableView.reloadData()
        self.refreshControl.endRefreshing()
    }
    
    @objc func addTicketVC(sender: UIButton) {
        //        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        //        let newVC = storyBoard.instantiateViewController(withIdentifier: "AddTicketViewController") as! AddTicketViewController
        //        self.present(newVC, animated: true, completion: nil)
        performSegue(withIdentifier: "toAddTicketVC", sender: self)
    }
    
    
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        notificationTitle = self.notificationListArr[indexPath.section].ticketTitle
//        notificationText = self.notificationListArr[indexPath.section].ticketMsg
//        self.showTicket(msgTitle: notificationTitle, msgText: notificationText)
//        //        performSegue(withIdentifier: "toTicketVC", sender: self)
//    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem
        if segue.identifier == "toAddTicketVC" {
            _ = segue.destination as! AddTicketViewController
        }
        else {
            //        let ticketVC = segue.destination as! TicketViewController
            //        ticketVC.titleFromTable = msgTitle
            //        ticketVC.text = msgText
        }
        
    }
    
    func getNotificationsList() {
//        let headers = ["Authorization": "Bearer \(Requests.authToken)","Content-Type": "application/json"]
        
        guard let url = URL(string: "\(Constants.URLForApi ?? "")/api/notification?accountNumber=\(Requests.currentAccoutNumber)") else {return }
        
        //MARK: Request with onlu swift features
        var requestForUserInfo = URLRequest(url:url )
        
        requestForUserInfo.httpMethod = "GET"
        requestForUserInfo.addValue("Bearer \(Requests.authToken) ", forHTTPHeaderField: "Authorization")
        requestForUserInfo.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let session = URLSession.shared
        
        session.dataTask(with: requestForUserInfo) {
            (data,response,error) in
            
            if let response = response {
                print(response)
            }
            
            guard let data = data else {return}
            
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                print(json)
                guard let notificationList = json as? [[String:Any]] else {return}
                self.notificationListArr.removeAll()
                for dic in notificationList {
                    self.notificationListArr.append(Notification(dic))
                }
                
            }catch {
                print(error)
            }
            
            }.resume()
        
    }
    
    func createHeaderView() -> UIView {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 200))
        headerView.backgroundColor = UIColor(red:0.92, green:0.92, blue:0.92, alpha:1.0)
        self.view.addSubview(headerView)
        
        let viewForElements = UIView(frame: CGRect(x: 0, y: 0, width: headerView.frame.width - 20, height: 150))
        viewForElements.backgroundColor = UIColor.white
        viewForElements.layer.shadowOpacity = 0.18
        viewForElements.layer.shadowOffset = CGSize(width: 0, height: 2)
        viewForElements.layer.shadowRadius = 2
        viewForElements.layer.shadowColor = UIColor.black.cgColor
        viewForElements.layer.masksToBounds = false
        headerView.addSubview(viewForElements)
        
        let accNumLbl = UILabel(frame: CGRect(x: 0, y: 0, width: 150, height: 30))
        accNumLbl.numberOfLines = 0
        accNumLbl.font = UIFont.boldSystemFont(ofSize: 21.0)
        accNumLbl.textColor = UIColor.black
        accNumLbl.text = "№\(Requests.currentAccoutNumber)"
        
        let fioTitleLbl = UILabel(frame: CGRect(x: 0, y: 0, width: 150, height: 20))
        fioTitleLbl.numberOfLines = 0
        fioTitleLbl.font = UIFont.systemFont(ofSize: 13.0)
        fioTitleLbl.textColor = UIColor.lightGray
        fioTitleLbl.text = "ФИО"
        
        let fioDataLbl = UILabel(frame: CGRect(x: 0, y: 0, width: 250, height: 30))
        fioDataLbl.numberOfLines = 0
        fioDataLbl.font = UIFont(name: "PT Sans Caption", size: 19.0)
        fioDataLbl.textColor = UIColor.black
        fioDataLbl.text = Requests.currentUser.fio.capitalizingFirstLetter()
        
        let addressTitleLbl = UILabel(frame: CGRect(x: 0, y: 0, width: 150, height: 20))
        addressTitleLbl.numberOfLines = 0
        addressTitleLbl.font = UIFont.systemFont(ofSize: 13.0)
        addressTitleLbl.textColor = UIColor.lightGray
        addressTitleLbl.text = "Адрес"
        
        let addressDataLbl = UILabel(frame: CGRect(x: 0, y: 0, width: 150, height: 30))
        addressDataLbl.numberOfLines = 0
        addressDataLbl.font = UIFont(name: "PT Sans Caption", size: 19.0)
        addressDataLbl.textColor = UIColor.black
        addressDataLbl.text = Requests.currentUser.address.capitalizingFirstLetter()
        
        viewForElements.addSubview(accNumLbl)
        viewForElements.addSubview(fioTitleLbl)
        viewForElements.addSubview(fioDataLbl)
        viewForElements.addSubview(addressTitleLbl)
        viewForElements.addSubview(addressDataLbl)
        
        //add constraints
        accNumLbl.translatesAutoresizingMaskIntoConstraints = false
        fioTitleLbl.translatesAutoresizingMaskIntoConstraints = false
        fioDataLbl.translatesAutoresizingMaskIntoConstraints = false
        addressTitleLbl.translatesAutoresizingMaskIntoConstraints = false
        addressDataLbl.translatesAutoresizingMaskIntoConstraints = false
        
        accNumLbl.topAnchor.constraint(equalTo: viewForElements.topAnchor, constant: 10).isActive = true
        accNumLbl.leftAnchor.constraint(equalTo: viewForElements.leftAnchor, constant: 50).isActive = true
        
        fioTitleLbl.topAnchor.constraint(equalTo: accNumLbl.topAnchor, constant: 30).isActive = true
        fioTitleLbl.leftAnchor.constraint(equalTo: viewForElements.leftAnchor, constant: 50).isActive = true
        
        fioDataLbl.topAnchor.constraint(equalTo: fioTitleLbl.topAnchor, constant: 20).isActive = true
        fioDataLbl.leftAnchor.constraint(equalTo: viewForElements.leftAnchor, constant: 50).isActive = true
        
        addressTitleLbl.topAnchor.constraint(equalTo: fioDataLbl.topAnchor, constant: 40).isActive = true
        addressTitleLbl.leftAnchor.constraint(equalTo: viewForElements.leftAnchor, constant: 50).isActive = true
        
        addressDataLbl.topAnchor.constraint(equalTo: addressTitleLbl.topAnchor, constant: 20).isActive = true
        addressDataLbl.leftAnchor.constraint(equalTo: viewForElements.leftAnchor, constant: 50).isActive = true
        
        
        let accNumImageView = UIImageView(frame: CGRect(x: 10, y: 10, width: 25, height: 25))
        viewForElements.addSubview(accNumImageView)
        accNumImageView.image = UIImage(named: "accNum")
        //add contraints
        accNumImageView.translatesAutoresizingMaskIntoConstraints = false
        accNumImageView.leftAnchor.constraint(equalTo: viewForElements.leftAnchor, constant: 15).isActive = true
        accNumImageView.topAnchor.constraint(equalTo: viewForElements.topAnchor, constant: 15).isActive = true
        accNumImageView.widthAnchor.constraint(equalToConstant: 25).isActive = true
        accNumImageView.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        let fioImageView = UIImageView(frame: CGRect(x: 10, y: 10, width: 25, height: 25))
        viewForElements.addSubview(fioImageView)
        fioImageView.image = UIImage(named: "fio")
        //add contraints
        fioImageView.translatesAutoresizingMaskIntoConstraints = false
        fioImageView.leftAnchor.constraint(equalTo: viewForElements.leftAnchor, constant: 15).isActive = true
        fioImageView.topAnchor.constraint(equalTo: accNumImageView.topAnchor, constant: 45).isActive = true
        fioImageView.widthAnchor.constraint(equalToConstant: 25).isActive = true
        fioImageView.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        let addressImageView = UIImageView(frame: CGRect(x: 10, y: 10, width: 25, height: 25))
        viewForElements.addSubview(addressImageView)
        addressImageView.image = UIImage(named: "address")
        //add contraints
        addressImageView.translatesAutoresizingMaskIntoConstraints = false
        addressImageView.leftAnchor.constraint(equalTo: viewForElements.leftAnchor, constant: 15).isActive = true
        addressImageView.topAnchor.constraint(equalTo: fioImageView.topAnchor, constant: 50).isActive = true
        addressImageView.widthAnchor.constraint(equalToConstant: 25).isActive = true
        addressImageView.heightAnchor.constraint(equalToConstant: 25).isActive = true
 
        let ticketNumLbl = UILabel(frame: CGRect(x: 0, y: 0, width: 150, height: 30))
        ticketNumLbl.numberOfLines = 0
        ticketNumLbl.font = UIFont.systemFont(ofSize: 15.0)
        ticketNumLbl.textColor = UIColor.gray
        ticketNumLbl.text = "Номер заявки"
        headerView.addSubview(ticketNumLbl)
        
        //add constraints
        ticketNumLbl.translatesAutoresizingMaskIntoConstraints = false
        ticketNumLbl.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -10).isActive = true
        ticketNumLbl.leftAnchor.constraint(equalTo: headerView.leftAnchor, constant: 10).isActive = true
        
        let dateLbl = UILabel(frame: CGRect(x: 0, y: 0, width: 150, height: 30))
        dateLbl.numberOfLines = 0
        dateLbl.font = UIFont.systemFont(ofSize: 15.0)
        dateLbl.textColor = UIColor.gray
        dateLbl.text = "Дата"
        headerView.addSubview(dateLbl)
        //add constraints
        dateLbl.translatesAutoresizingMaskIntoConstraints = false
        dateLbl.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -10).isActive = true
        dateLbl.rightAnchor.constraint(equalTo: headerView.rightAnchor, constant: -100).isActive = true
        
        
        return headerView
    }
    
}

extension NotificationsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
//        if notificationListArr.isEmpty {
//            return 1
//        }
//        else {
//            return self.notificationListArr.count
//        }
        return self.notificationListArr.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        loadingViewService.setLoadingScreen(notificationsTableView)
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationsViewCell", for: indexPath ) as! NotificationsViewCell
        //        cell.textLabel?.numberOfLines = 0
        //        cell.textLabel?.lineBreakMode = .byWordWrapping
        print("Filling cells")
        if !self.notificationListArr.isEmpty {
            cell.notificationTitle.text = self.notificationListArr[indexPath.section].title
            cell.notificationDate.text = self.notificationListArr[indexPath.section].date
            loadingViewService.removeLoadingScreen()
            print("array is not empty")
        }
        
        else {
            loadingViewService.removeLoadingScreen()
            print("array is empty")
        }
      
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70.0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        //        if section == 0 {
        //            return 20
        //        }
        //        else {
        return 5
        //        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor.white
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let notificationVC = storyboard.instantiateViewController(withIdentifier: "NotificationViewController") as! NotificationViewController
        notificationVC.text = self.notificationListArr[indexPath.section].title
        self.addChildViewController(notificationVC)
        notificationVC.view.frame = self.view.frame
        self.view.addSubview(notificationVC.view)
        notificationVC.didMove(toParentViewController: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}


