//
//  LoginModel.swift
//  ThiqahDelivery
//
//  Created by Gaurav Prakash on 16/08/18.
//  Copyright © 2018 Gaurav Prakash. All rights reserved.
//

import Foundation

class LoginModel{
    var email:String!
    var password:String!
    init(from email:String, withPass password:String){
        self.email = email
        self.password = password
    }

    func toDictionary() -> [String:Any]{
        var dictionary = [String:Any]()
        if self.email != nil {
            dictionary["email"] = self.email
        }
       
        if self.password != nil {
            dictionary["password"] = self.password
        }
    return dictionary
    }
    
 
}

class DriverOrders{
    var driverId: String!
    init(from driverid:String) {
        self.driverId = driverid
    }
    func toDictionary() -> [String:Any]{
        var dictionary = [String:Any]()
        if driverId != nil {
            dictionary["driver_id"] = driverId
        }
    return dictionary
    }
}

class DeliveredOrder{
    var orderId:String!
    var deliverDate:String!
    init(from orderid:String, deliverDate:String ) {
        self.orderId = orderid
        self.deliverDate = deliverDate
    }
    
    func toDictionary() -> [String:Any]{
        var dictionary = [String:Any]()
        if orderId != nil {
            dictionary["order_id"] = orderId
        }
        if deliverDate != nil {
            dictionary["deliver_date"] = deliverDate
        }
      return dictionary
    }
}

class UndeliveredStstus{
    var orderId:String!
    var reason:String!
    
    init(from orderid:String, reason:String) {
        self.orderId = orderid
        self.reason = reason
    }
    
    func toDictionary() -> [String:Any]{
        var dictionary = [String:Any]()
        if self.orderId != nil{
            dictionary["order_id"] = self.orderId
        }
        if self.reason != nil{
            dictionary["reason"] = self.reason
        }
     return dictionary
    }
}


