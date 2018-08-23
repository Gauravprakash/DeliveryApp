//
//  LoginData.swift
//  ThiqahDelivery
//
//  Created by Gaurav Prakash on 17/08/18.
//  Copyright © 2018 Gaurav Prakash. All rights reserved.
//

import Foundation

struct LoginData: Codable {
    let driverDetail: [DriverDetail]?
    let errorCode: String?
    let errorDescription: String?
    
    enum CodingKeys: String, CodingKey {
        case driverDetail = "driver_detail"
        case errorCode = "ERROR_CODE"
        case errorDescription = "ERROR_DESCRIPTION"
    }
}

struct DriverDetail: Codable {
    let tDmid: String?
    let fname: String?
    let lname: String?
    let email: String?
    let password: String?
    let mobile: String?
    let address: String?
    let country: String?
    let state: String?
    let zip: String?
    let licenceno: String?
    let vehicalno: String?
    let pic: String?
    let date: String?
    
    enum CodingKeys: String, CodingKey {
        case tDmid = "t_dmid"
        case fname = "fname"
        case lname = "lname"
        case email = "email"
        case password = "password"
        case mobile = "mobile"
        case address = "address"
        case country = "country"
        case state = "state"
        case zip = "zip"
        case licenceno = "licenceno"
        case vehicalno = "vehicalno"
        case pic = "pic"
        case date = "date"
}
}
struct CurrentOrders: Codable {
    let errorDescription: String?
    let orderDetails: [[OrderDetail]]?
    let errorCode: String?

    enum CodingKeys: String, CodingKey {
        case errorDescription = "ERROR_DESCRIPTION"
        case orderDetails = "order_details"
        case errorCode = "ERROR_CODE"
    }
    
    func getOrderDetailCount() -> [[OrderDetail]]{
        return orderDetails!
    }
}

struct OrderDetail: Codable {
    let parentID: String?
    let dob: String?
    let trackNumber: String?
    let state: String?
    let trackYourOrder: String?
    let subtotal: String?
    let orderMethod: String?
    let cEmail: String?
    let boxCharge: String?
    let isVisible: String?
    let lname: String?
    let addressID: String?
    let cCity: String?
    let currency: String?
    let undeliverReason: String?
    let loyaltyPoint: String?
    let address: String?
    let nameAr: String?
    let locationID: String?
    let cState: String?
    let deliverDate: String?
    let cCountry: String?
    let paymentReason: String?
    let sessionid: String?
    let nameEn: String?
    let customerID: String?
    let cAddress: String?
    let postalCode: String?
    let country: String?
    let remember: String?
    let orderTotal: String?
    let cLname: String?
    let email: String?
    let defaultAdd: String?
    let paymentMethod: String?
    let returnStatus: String?
    let discountPrice: String?
    let cPassword: String?
    let coupan: String?
    let returnDate: String?
    let custID: String?
    let orderDate: String?
    let cZip: String?
    let cMobile: String?
    let zip: String?
    let mcode: String?
    let shippingCharge: String?
    let orderStatus: String?
    let orderID: String?
    let transport: String?
    let city: String?
    let paymentStatus: String?
    let currencyRate: String?
    let logby: String?
    let addID: String?
    let mobile: String?
    let cFname: String?
    let logid: String?
    let locationType: String?
    let fname: String?
    let totalWeight: String?
    let shippingDate: String?
    let customePrice: String?
    let deliveryType: String?
    
    enum CodingKeys: String, CodingKey {
        case parentID = "parent_id"
        case dob = "dob"
        case trackNumber = "track_number"
        case state = "state"
        case trackYourOrder = "track_your_order"
        case subtotal = "subtotal"
        case orderMethod = "order_method"
        case cEmail = "c_email"
        case boxCharge = "box_charge"
        case isVisible = "is_visible"
        case lname = "lname"
        case addressID = "address_id"
        case cCity = "c_city"
        case currency = "currency"
        case undeliverReason = "undeliver_reason"
        case loyaltyPoint = "loyalty_point"
        case address = "address"
        case nameAr = "name_ar"
        case locationID = "location_id"
        case cState = "c_state"
        case deliverDate = "deliver_date"
        case cCountry = "c_country"
        case paymentReason = "payment_reason"
        case sessionid = "sessionid"
        case nameEn = "name_en"
        case customerID = "customer_id"
        case cAddress = "c_address"
        case postalCode = "postal_code"
        case country = "country"
        case remember = "remember"
        case orderTotal = "order_total"
        case cLname = "c_lname"
        case email = "email"
        case defaultAdd = "default_add"
        case paymentMethod = "payment_method"
        case returnStatus = "return_status"
        case discountPrice = "discount_price"
        case cPassword = "c_password"
        case coupan = "coupan"
        case returnDate = "return_date"
        case custID = "cust_id"
        case orderDate = "order_date"
        case cZip = "c_zip"
        case cMobile = "c_mobile"
        case zip = "zip"
        case mcode = "mcode"
        case shippingCharge = "shipping_charge"
        case orderStatus = "order_status"
        case orderID = "order_id"
        case transport = "transport"
        case city = "city"
        case paymentStatus = "payment_status"
        case currencyRate = "currency_rate"
        case logby = "logby"
        case addID = "add_id"
        case mobile = "mobile"
        case cFname = "c_fname"
        case logid = "logid"
        case locationType = "location_type"
        case fname = "fname"
        case totalWeight = "total_weight"
        case shippingDate = "shipping_date"
        case customePrice = "custome_price"
        case deliveryType = "delivery_type"
    }
    
    

}

