//
//  ButtonExt.swift
//  ThiqahDelivery
//
//  Created by Gaurav Prakash on 15/08/18.
//  Copyright © 2018 Gaurav Prakash. All rights reserved.
//

import Foundation
import UIKit

extension UIButton{
func addCornerRadius(){
 self.layer.cornerRadius = 5
 self.clipsToBounds = true
}
}

extension UITableView {
    func registerNibs(nibNames nibs: [String]) {
        for nib in nibs {
            let cellNib = UINib(nibName: nib, bundle: nil)
            register(cellNib, forCellReuseIdentifier: nib)
        }
    }
}


extension UIImageView{
    func addCornerLayout(){
        self.layer.cornerRadius = self.frame.size.width/2
        self.layer.masksToBounds = false
        self.clipsToBounds = true
    }
}
