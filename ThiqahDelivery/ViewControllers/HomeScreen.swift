//
//  HomeScreen.swift
//  ThiqahDelivery
//
//  Created by Gaurav Prakash on 15/08/18.
//  Copyright © 2018 Gaurav Prakash. All rights reserved.
//

import UIKit
import Material
import RxCocoa
import RxSwift
import ContextMenu
import CoreLocation

class HomeScreen: BaseViewController {
    var driverorder:DriverOrders = DriverOrders(from: DefaultManager.sharedInstance.getUserdata().tDmid!)
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var menuButton: UIBarButtonItem!
    var disposeBag = DisposeBag()
    var currentorder:[OrderDetail]? = []
    var ordertype:OrderType! = .ALL
    var report: StatusReport!
    var thiqah:Thiqah!
    var latvalue: CLLocationDegrees!
    var longValue:CLLocationDegrees!
    let locationManager = CLLocationManager()
    lazy var geocoder = CLGeocoder()
    
    func getfilteredArray(type:OrderType = .ALL) -> [OrderDetail]{
    var filteredArray:[OrderDetail]! = []
        if let order = currentorder{
        filteredArray = order
        switch type{
        case .ALL:
           return filteredArray
        case .EXPRESS:
        return filteredArray.filter({$0.deliveryType == type.rawValue })
        case .REGULAR:
            return filteredArray.filter({$0.deliveryType == type.rawValue || $0.deliveryType == ""})
        }
        }
        return filteredArray
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    if  self.revealViewController() != nil{
        menuButton.target = self.revealViewController()
        menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
      self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
    }
        self.tableView.registerNibs(nibNames: ["UserCell", "DashboardCell"])
        getActiveOrders()
        getUserLocation()
        }
    
    fileprivate func getUserLocation(){
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }
    
    func showAlert(order: OrderDetail){
        let alert = UIAlertController(title: "Order Id: \(order.orderID ?? "")", message: "Add Remark", preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = "Enter reason here"
        }
    
        alert.addAction(title: "Confirm", color: .green, style: .default, isEnabled: true) { [weak self](action) in
            if let text = alert.textFields?.first?.text, !text.isEmpty{
                 self?.hitRequest(orderdetail:order,reason: text)
            }
            else{
               self?.view.makeToast("please enter remark to confirm")
            }
           
        }
        alert.addAction(title: "Cancel", color: .red, style: .cancel, isEnabled: true) { (action) in
            alert.dismiss(animated: true, completion: nil)
        }
        alert.show()
    }
    
    func getActiveOrders(){
    ThiqahAPIProvider.rx.request(Thiqah.DRIVERORDERS(driverorder.toDictionary())).subscribe({event in
            switch event{
            case .success(let response):
                let json = try? JSONSerialization.jsonObject(with: response.data, options: []) as? [String:Any]
                if let dictionary = json as? [String:Any]{
                    if let errorCode = dictionary["ERROR_CODE"] as? String, errorCode == "1"{
                        do {
                            let decoder = JSONDecoder()
                            let orderData = try decoder.decode(CurrentOrders.self, from: response.data)
                            self.currentorder = orderData.orderDetails?.flatMap({$0}).filter({$0.orderStatus != "3"})
                            DispatchQueue.main.async {
                                self.tableView.reloadData()
                            }
                        }   catch { print(error) }
                    }
                    else{
                        self.view.makeToast(dictionary["ERROR_DESCRIPTION"] as? String)
                    }
                }
            case .error(let error):
                print(error.localizedDescription)
            }
        }).disposed(by: disposeBag)
    }
    
    @IBAction func filterOrder(_ sender: UIBarButtonItem) {
        let vc = MenuViewController()
        let view = sender.value(forKey: "view") as? UIView
        vc.delegate = self
        ContextMenu.shared.show(
            sourceViewController: self,
            viewController: vc,
            options: ContextMenu.Options(containerStyle: ContextMenu.ContainerStyle(backgroundColor: .white), menuStyle: .default),
            sourceView: view,
            delegate: self
        )
    }
}
extension HomeScreen:OrderTypeDelegate{
    func setOrderType(data: OrderType?) {
        switch data!{
        case .ALL:
            ordertype = .ALL
        case .REGULAR:
            ordertype = .REGULAR
        case .EXPRESS:
            ordertype = .EXPRESS
     }
       self.tableView.reloadData()
}
}

extension HomeScreen:ContextMenuDelegate{
    func contextMenuWillDismiss(viewController: UIViewController, animated: Bool) {
       print("will dismiss")
    }
    func contextMenuDidDismiss(viewController: UIViewController, animated: Bool) {
        print("did dismiss")}
   }

extension HomeScreen:UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
          return self.getfilteredArray(type: ordertype).count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath) as! UserCell
             return cell
        case 1:
             let cell = tableView.dequeueReusableCell(withIdentifier: "DashboardCell", for: indexPath) as! DashboardCell
             cell.delegate = self
             return cell
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let cell = cell as? UserCell{
            cell.bindUpView(data: DefaultManager.sharedInstance.getUserdata())
        }
        else if let cell = cell as? DashboardCell{
            cell.bindUpView(data: getfilteredArray(type: ordertype)[indexPath.row])
        }
    }
}
extension HomeScreen: StatusUpdateDelegate{
func SelectStatusType(_ sender: DashboardCell, _ status: StatusReport){
    guard let tappedIndexPath = tableView.indexPath(for: sender) else { return }
    report = status
    switch report!{
    case .DELIVERED:
        let alert = UIAlertController(title: "Order Id: \(self.getfilteredArray(type: ordertype)[tappedIndexPath.row].orderID ?? "")", message: "Are you sure, You wanted to mark this order as Delivered?", preferredStyle: .alert)
         alert.addAction(title: "Confirm", color: .green, style: .default, isEnabled: true) { [weak self](action) in
            if let type = self?.ordertype, let orderdetail = self?.getfilteredArray(type: type)[tappedIndexPath.row]{
            self?.hitRequest(orderdetail:orderdetail)
            }
        }
        alert.addAction(title: "Cancel", color: .red, style: .cancel, isEnabled: true) { (action) in
            alert.dismiss(animated: true, completion: nil)
        }
        alert.show()
        
    case .UNDELIVERED:
          showAlert(order: self.getfilteredArray(type: ordertype)[tappedIndexPath.row])
    case .LOCATION:
        guard let country = self.getfilteredArray(type: ordertype)[tappedIndexPath.row].country else { return }
        guard let street = self.getfilteredArray(type: ordertype)[tappedIndexPath.row].state else { return }
        guard let city =  self.getfilteredArray(type: ordertype)[tappedIndexPath.row].city else { return }
        let address = "\(country), \(city), \(street)"
        geocoder.geocodeAddressString(address) { (placemarks, error) in
            self.processResponse(withPlacemarks: placemarks, error: error)
        }
    }
}
}

extension HomeScreen: UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 100
        case 1:
            return 308
        default:
            return 100
        }
    }
}

protocol OrderTypeDelegate{
     func setOrderType(data: OrderType?)
}

extension HomeScreen{
    func hitRequest(orderdetail:OrderDetail,reason:String = "") {
        self.showLoader()
        var dictionary = [String:Any]()
        dictionary["order_id"] = orderdetail.orderID
        switch report! {
        case .UNDELIVERED:
            dictionary["reason"] = reason
            thiqah = Thiqah.UNDELIVEREDSTATUS(dictionary)
        case .DELIVERED:
            dictionary["deliver_date"] = orderdetail.deliverDate
            thiqah = Thiqah.DELIVEREDSTATUS(dictionary)
        case .LOCATION:
            break
        }
        ThiqahAPIProvider.rx.request(thiqah).subscribe({event in
            switch event{
            case .success(let response):
                let json = try? JSONSerialization.jsonObject(with: response.data, options: []) as? [String:Any]
                if let dictionary = json as? [String:Any]{
                    if let errorCode = dictionary["ERROR_CODE"] as? String, errorCode == "1"{
                        self.hideLoader(completion: {
                            if let id = orderdetail.orderID, let message = dictionary["MESSAGE"] as? String {
                                 self.getActiveOrders()
                                 self.view.makeToast("Order No:\(id) \(message)")
                            }
                          })
                        }
                    else{
                        self.hideLoader(completion: {
                            self.view.makeToast("Something went wrong")
                        })
                    }
                }
            case .error(let err):
                print(err.localizedDescription)
                
            }
        }).disposed(by: disposeBag)
    }
}

extension HomeScreen:CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        latvalue = locValue.latitude
        longValue = locValue.longitude
        print("locations = \(latvalue) \(longValue)")
    }
}

extension HomeScreen{
    private func processResponse(withPlacemarks placemarks: [CLPlacemark]?, error: Error?) {
        if let error = error {
            print("Unable to Forward Geocode Address (\(error))")
            self.view.makeToast("Unable to Find Location for Address")
         } else {
            var location: CLLocation?
            if let placemarks = placemarks, placemarks.count > 0 {
                location = placemarks.first?.location
            }
            
            if let location = location {
                let coordinate = location.coordinate
                var url = ""
                if let latitude = latvalue, let longitude = longValue{
                      url = UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!) ? "comgooglemaps://?saddr=&daddr=\(coordinate.latitude),\(coordinate.longitude)&directionsmode=driving" : "http://maps.apple.com/maps?saddr=\(latitude),\(longitude)&daddr=\(coordinate.latitude),\(coordinate.longitude)"
                }
                
                if #available(iOS 10.0, *) {
                    if UIApplication.shared.canOpenURL(URL(string: url)!){
                        UIApplication.shared.open(URL(string: url)!, options: [:], completionHandler: nil)
                    }
                    
                } else {
                    UIApplication.shared.openURL(URL(string: url)!)
                }
            } else {
                self.view.makeToast("No Matching Location Found")
            }
        }
    }

}


