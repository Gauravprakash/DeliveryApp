//
//  UserCell.swift
//  ThiqahDelivery
//
//  Created by Gaurav Prakash on 18/08/18.
//  Copyright © 2018 Gaurav Prakash. All rights reserved.
//

import UIKit

class UserCell: UITableViewCell {
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var phoneNumber: UILabel!
    @IBOutlet weak var userImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.userImage.addCornerLayout()
        self.selectionStyle = .none
    }

    func bindUpView(data:DriverDetail){
        if let fname = data.fname, let lname = data.lname{
            self.username.text = "\(fname) \(lname)"
        }
        else{
            self.username.text = "N/A"
        }
        
        if let phoneno = data.mobile{
            self.phoneNumber.text = phoneno
        }
        else{
             self.phoneNumber.text = "N/A"
        }
    }
   
}
