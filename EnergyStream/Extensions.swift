//
//  Extensions.swift
//  memuDemo
//
//  Created by Timur on 1/19/19.
//  Copyright © 2019 Parth Changela. All rights reserved.
//

import Foundation
import UIKit
extension UITextField {
    
    func useUnderline() {
        let border = CALayer()
        let borderWidth = CGFloat(1.0)
        border.borderColor = UIColor.lightGray.cgColor
        border.frame = CGRect(origin: CGPoint(x: 0,y :self.frame.size.height - borderWidth), size: CGSize(width: self.frame.size.width, height: self.frame.size.height))
        border.borderWidth = borderWidth
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
    }
}


extension FileManager {
    static var documentDicrectoryURL: URL {
//        print(FileManager.default.urls(for: <#T##FileManager.SearchPathDirectory#>, in: <#T##FileManager.SearchPathDomainMask#>))
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
}

