//
//  Utils.swift
//  ThiqahDelivery
//
//  Created by Gaurav Prakash on 16/08/18.
//  Copyright © 2018 Gaurav Prakash. All rights reserved.
//

import Foundation
enum Storyboards{
case MAIN
case LOGIN
case HOME
case DASHBOARD
case PROFILE

var storyBoard : UIStoryboard {
        switch self {
        case .MAIN:
            return UIStoryboard(name: "Main", bundle: nil)
        case .LOGIN:
            return UIStoryboard(name: "Login", bundle: nil)
        case .HOME:
             return UIStoryboard(name: "Home", bundle: nil)
        case .DASHBOARD:
             return UIStoryboard(name: "Dashboard", bundle: nil)
        case .PROFILE:
            return UIStoryboard(name: "Profile", bundle: nil)
    }
}
}

enum StatusReport{
    case DELIVERED
    case UNDELIVERED
    case LOCATION
}

enum OrderType:String{
    case ALL = "alldelivery"
    case REGULAR = "regulardelivery"
    case EXPRESS = "expressdelivery"
    
    func getValue()->String{
        switch self {
        case .ALL:
            return "All"
        case .EXPRESS:
            return "Express"
        case .REGULAR:
            return "Regular"
        }
    }
}

class MenuViewController: UITableViewController {
    let rowsCount:[OrderType] = [.ALL,.EXPRESS,.REGULAR]
    var delegate :OrderTypeDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.reloadData()
        tableView.isScrollEnabled = false
        tableView.bounces = false
        tableView.layoutIfNeeded()
        preferredContentSize = CGSize(width: 150, height: tableView.contentSize.height - 44)
        navigationController?.navigationBar.isHidden = true
        navigationItem.backBarButtonItem = UIBarButtonItem(title: " ", style: .plain, target: nil, action: nil)
        tableView.backgroundColor = .clear
        tableView.separatorColor = .clear
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rowsCount.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = rowsCount[indexPath.row].getValue()
        cell.textLabel?.font = .boldSystemFont(ofSize: 17)
        cell.textLabel?.textColor = .darkGray
        cell.backgroundColor = .clear
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        delegate?.setOrderType(data: rowsCount[indexPath.row])
        self.dismiss(animated: true)
    }
}
