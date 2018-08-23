//
//  ProfileScreen.swift
//  ThiqahDelivery
//
//  Created by Gaurav Prakash on 19/08/18.
//  Copyright © 2018 Gaurav Prakash. All rights reserved.
//

import UIKit

class ProfileScreen: BaseViewController {
@IBOutlet weak var menuButton: UIBarButtonItem!
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblContact: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblVechile: UILabel!
    @IBOutlet weak var lblLicence: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var contact: UILabel!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var licenceno: UILabel!
    @IBOutlet weak var vechileno: UILabel!
    @IBOutlet weak var parentView: CardView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    if  self.revealViewController() != nil{
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
     [self.lblName, self.lblContact, self.lblAddress,self.lblVechile,self.lblLicence].forEach({$0?.textColor = Theme.Color.primaryTextColor})
     [self.name, self.contact, self.address, self.licenceno, self.vechileno].forEach({$0?.textColor = Theme.Color.cellTextColor})
        bindUpView()
    }
    
    fileprivate func bindUpView(){
    self.parentView.backgroundColor = Theme.Color.loginView
    let userdata = DefaultManager.sharedInstance.getUserdata()
    
        if let licence = userdata.licenceno, !licence.isEmpty{
            self.licenceno.text = licence
        }
        else{
            self.licenceno.text = "N/A"
        }
        if let firstName = userdata.fname, let lastName = userdata.lname{
            self.name.text = "\(firstName) \(lastName)"
        }
        else{
            self.name.text = "N/A"
        }
        
        if let contact = userdata.mobile, !contact.isEmpty{
            self.contact.text = contact
        }
        else{
            self.contact.text = "N/A"
        }
        
        if let shipping = userdata.address ,let country = userdata.country, let state = userdata.state, let zip = userdata.zip{
            self.address.text = "\(shipping),\(state),\(country),\(zip)"
        }
        else{
            self.address.text = "N/A"
        }
        if let vechile = userdata.vehicalno, !vechile.isEmpty{
            self.vechileno.text = vechile
        }
        
        else{
            self.vechileno.text = "N/A"
        }
      
        
    }
        
    


    

}
