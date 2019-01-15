//
//  Section.swift
//  memuDemo
//
//  Created by Timur on 1/14/19.
//  Copyright © 2019 Parth Changela. All rights reserved.
//

import Foundation

struct Section {
    var name: String
    var items: [String]
    var collapsed: Bool
    
    init(name: String, items: [String], collapsed: Bool = false) {
        self.name = name
        self.items = items
        self.collapsed = collapsed
    }
}
