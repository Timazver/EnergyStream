//
//  menuViewController.swift
//  memuDemo
//
//  Created by Parth Changela on 09/10/16.
//  Copyright © 2016 Parth Changela. All rights reserved.
//

import UIKit

class menuViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var tblTableView: UITableView!
    @IBOutlet weak var imgProfile: UIImageView!
    
    @IBAction func goBackToOneButtonTapped(_ sender: Any) {
        performSegue(withIdentifier: "logout", sender: self)
    }
    
    
    var ManuNameArray:Array = [String]()
    var iconArray:Array = [UIImage]()
    override func viewDidLoad() {
        super.viewDidLoad()
        tblTableView.separatorStyle = UITableViewCellSeparatorStyle.none
        ManuNameArray = ["Мои лицевые счета","Квитанции по лицевыми счетам","Оплата","Настройки","Выйти"]
        iconArray = [UIImage(named:"menuProfile")!,UIImage(named:"message")!,UIImage(named:"map")!,UIImage(named:"setting")!,UIImage(named:"logout")!]
//        
//        imgProfile.layer.borderWidth = 2
//        imgProfile.layer.borderColor = UIColor.green.cgColor
//        imgProfile.layer.cornerRadius = 50
//        
//        imgProfile.layer.masksToBounds = false
//        imgProfile.clipsToBounds = true 
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ManuNameArray.count
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuCell", for: indexPath) as! MenuCell
        
        cell.lblMenuname.text! = ManuNameArray[indexPath.row]
        cell.imgIcon.image = iconArray[indexPath.row]
        
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        
        let cell:MenuCell = tableView.cellForRow(at: indexPath) as! MenuCell
        print(cell.lblMenuname.text!)
        if cell.lblMenuname.text! == "Мои лицевые счета"
        {
            print("Открыт профиль")
            let mainstoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let newViewcontroller = mainstoryboard.instantiateViewController(withIdentifier: "AccListTableViewController") as! AccListTableViewController
            let newFrontController = UINavigationController.init(rootViewController: newViewcontroller)
            
            
            
        }
        if cell.lblMenuname.text! == "Квитанции по лицевыми счетам"
        {
            print("Все ваши счета")
           
            let mainstoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let newViewcontroller = mainstoryboard.instantiateViewController(withIdentifier: "EpdViewController") as! EpdViewController
            let newFrontController = UINavigationController.init(rootViewController: newViewcontroller)
            
            
        }
        if cell.lblMenuname.text! == "Оплата"
        {
            print("Здесь вы можете оплатить счет")
        }
        if cell.lblMenuname.text! == "Настройки"
        {
           print("Настройки")
        }
        if cell.lblMenuname.text! == "Выйти"
        {
            print("Выход")
           goBackToOneButtonTapped(self)
        }
    }
    
}
