//
//  DefaultManager.swift
//  ThiqahDelivery
//
//  Created by Gaurav Prakash on 17/08/18.
//  Copyright © 2018 Gaurav Prakash. All rights reserved.
//

import Foundation
class DefaultManager{
    static let loggedInKey = "IsLoggedIn"
    static let userDataKey = "loginData"
    static let defaults = UserDefaults.standard
    static let sharedInstance = DefaultManager()
    
    var loginData: DriverDetail?
    
    class func setUserData(value: DriverDetail){
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(value) {
            DefaultManager.defaults.set(encoded, forKey: userDataKey)
            DefaultManager.defaults.synchronize()
        }
        DefaultManager.sharedInstance.loginData = value
    }
    func getUserdata() -> DriverDetail {
        if loginData != nil {
            return  loginData!
        }
        else{
            do {
                let decoder = JSONDecoder()
                 loginData = try decoder.decode(DriverDetail.self, from: DefaultManager.defaults.data(forKey: DefaultManager.userDataKey)!)
              }catch { print(error) }
            
            return loginData!
        }
    }
    
    class func setLogged(value:Bool){
        DefaultManager.defaults.set(value, forKey: loggedInKey)
        DefaultManager.defaults.synchronize()
    }

    
    class func getIsLoggedIn() -> Bool {
        return DefaultManager.defaults.bool(forKey: loggedInKey)
    }
}
