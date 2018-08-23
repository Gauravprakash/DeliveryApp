//
//  DashboardCell.swift
//  ThiqahDelivery
//
//  Created by Gaurav Prakash on 16/08/18.
//  Copyright © 2018 Gaurav Prakash. All rights reserved.
//

import UIKit

protocol StatusUpdateDelegate : class {
    func SelectStatusType(_ sender: DashboardCell, _ status: StatusReport)
}

class DashboardCell: UITableViewCell {
    static let identifier = "DashboardCell"
    @IBOutlet weak var lblOrder: UILabel!
    @IBOutlet weak var lblCustomer: UILabel!
    @IBOutlet weak var lblContact: UILabel!
    @IBOutlet weak var lblShipping: UILabel!
    @IBOutlet weak var lblPayment: UILabel!
    @IBOutlet weak var lblamount: UILabel!
    @IBOutlet weak var lblState: UILabel!
    @IBOutlet weak var lblDeliveryType: UILabel!
    @IBOutlet weak var deliveryType: UILabel!
    @IBOutlet weak var parentView: CardView!
    @IBOutlet weak var orderNo: UILabel!
    @IBOutlet weak var customerName: UILabel!
    @IBOutlet weak var contactNo: UILabel!
    @IBOutlet weak var shippingAddress: UILabel!
    @IBOutlet weak var payment: UILabel!
    @IBOutlet weak var state: UILabel!
    @IBOutlet weak var amount: UILabel!
    @IBOutlet weak var deliverButton: UIButton!
    @IBOutlet weak var notdeliverButton: UIButton!
    @IBOutlet weak var locationButton: UIButton!
    
    weak var delegate:StatusUpdateDelegate!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.parentView.backgroundColor = Theme.Color.loginView
[lblOrder,lblCustomer,lblContact,lblShipping,lblPayment,lblamount,lblDeliveryType,lblState].forEach({$0?.textColor = Theme.Color.primaryTextColor})
        [orderNo, customerName, contactNo, shippingAddress,amount,payment,state,deliveryType].forEach({$0?.textColor = Theme.Color.cellTextColor})
        [deliverButton,locationButton].forEach({$0?.backgroundColor = Theme.Color.cellTextColor})
        [deliverButton, notdeliverButton, locationButton].forEach({$0?.addCornerRadius()})
    }
    func bindUpView(data:OrderDetail){
        if let orderid = data.orderID, !orderid.isEmpty{
           self.orderNo.text = orderid
        }
        else{
            self.orderNo.text = "N/A"
        }
        if let lastName = data.lname, let firstName = data.fname{
            self.customerName.text = "\(firstName) \(lastName)"
        }
        if let contactNo = data.mobile, !contactNo.isEmpty{
            self.contactNo.text = contactNo
        }else{
            self.contactNo.text = "N/A"
        }
        if let shipping = data.address, !shipping.isEmpty{
            self.shippingAddress.text = shipping
        }
        else{
            self.shippingAddress.text = "N/A"
        }
        if let payment = data.paymentMethod , !payment.isEmpty{
            self.payment.text = payment
        }
        else{
            self.payment.text = "N/A"
        }
        if let amount = data.subtotal , let currency = data.currency{
            self.amount.text = "\(amount) \(currency)"
        }
        else{
            self.amount.text = "N/A"
        }
        if let type = data.deliveryType, !type.isEmpty{
            self.deliveryType.text = type
        }
        else{
             self.deliveryType.text = "N/A"
        }
        if let state = data.state , !state.isEmpty{
            self.state.text = state
        }
        else{
             self.state.text = "N/A"
        }
        
       
    }

    @IBAction func updateStatus(_ sender: UIButton) {
        var statusReport: StatusReport!
        switch sender.tag{
        case 11:
            statusReport = .DELIVERED
        case 12:
            statusReport = .UNDELIVERED
        case 13:
            statusReport = .LOCATION
        default:
            break
        }
        delegate.SelectStatusType(self, statusReport)
    }
    
}
