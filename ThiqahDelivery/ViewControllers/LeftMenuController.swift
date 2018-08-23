//
//  LeftMenuController.swift
//  ThiqahDelivery
//
//  Created by Gaurav Prakash on 16/08/18.
//  Copyright © 2018 Gaurav Prakash. All rights reserved.
//

import UIKit

class LeftMenuController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    var menuItems = ["HOME", "PROFILE","LOGOUT"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.backgroundColor =  Theme.Color.primaryColor
        tableView.separatorColor = .clear
      }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "LOGOUT":
            DefaultManager.setLogged(value: false)
        default:
            break
        }
    }
}

extension LeftMenuController:UITableViewDataSource, UITableViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return menuItems.count
        default:
            break
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: Theme.Strings.cellIdentifier, for: indexPath)
        cell.textLabel?.textColor = Theme.Color.primaryTextColor
        switch indexPath.section {
        case 0:
            if let fname = DefaultManager.sharedInstance.getUserdata().fname, !fname.isEmpty, let lname = DefaultManager.sharedInstance.getUserdata().lname,!lname.isEmpty{
                cell.textLabel?.text = "Welcome,\(fname) \(lname)"
            }
            else{
                cell.textLabel?.text = "Welcome User"
            }
            
        case 1:
            cell.textLabel?.text = menuItems[indexPath.row]
            
        default:
            break
        }
        return cell
       
    }

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: menuItems[indexPath.row], sender: nil)
    }
    
}
