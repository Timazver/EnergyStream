//
//  UserCard.swift
//  EnergyStream
//
//  Created by Timur on 3/12/19.
//  Copyright © 2019 Parth Changela. All rights reserved.
//

import Foundation
struct UserCard {
    var accountNumber: String
    //    var firstName: String
    //    var lastName: String
    //    var middleName: String
    var numberOfPeople: String
    var address: String
    var phoneNumber: String
    var SCH_TYPE: String
    var fio: String
    var area: String
    
    init(_ userCard: [String:Any]) {
        self.accountNumber = userCard["LS"] as? String ?? "Не указано"
        self.fio = userCard["FIO"] as? String ?? ""
        //        self.firstName = ""
        //        self.lastName = ""
        //        self.middleName = "Не указано"
        self.numberOfPeople = userCard["KOL_MAN"] as? String ?? ""
        self.address = userCard["ADRESS"] as? String ?? "Не указано"
        self.phoneNumber = userCard["PHONE"] as? String ?? "Не указано"
        self.SCH_TYPE = userCard["SCH_TYPE"] as? String ?? "Не указано"
        self.area = userCard["RAYON"] as? String ?? "Не указано"
    }
    init() {
        self.accountNumber = ""
        self.fio = ""
        self.numberOfPeople = ""
        self.address = ""
        self.phoneNumber = ""
        self.SCH_TYPE = ""
        self.area = ""
    }
    func getPropertyCount() -> Int{
        return 6
    }
}
