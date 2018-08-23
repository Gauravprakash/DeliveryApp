//
//  StringExt.swift
//  ThiqahDelivery
//
//  Created by Gaurav Prakash on 17/08/18.
//  Copyright © 2018 Gaurav Prakash. All rights reserved.
//

import Foundation
extension String{
func isValidEmail() -> Bool {
    let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
    let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
    return emailTest.evaluate(with: self)
}
}


