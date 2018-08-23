//
//  EmailView.swift
//  ThiqahDelivery
//
//  Created by Gaurav Prakash on 15/08/18.
//  Copyright © 2018 Gaurav Prakash. All rights reserved.
//

import UIKit

class EmailView: UIView {
@IBOutlet var contentView: UIView!
@IBOutlet weak var txtEmail: UITextField!
@IBOutlet weak var txtPass: UITextField!
@IBOutlet weak var confirmPassword: UITextField!

var usertype:UserCase!
var loginRequest:LoginModel!

    override init(frame: CGRect) {
   super.init(frame: frame)
    xibSetUp()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibSetUp()
    }
    
    func xibSetUp(){
        contentView = loadViewFromNib()
        contentView.frame = bounds
        addSubview(contentView)
        txtEmail.keyboardType = .emailAddress
        txtPass.keyboardType = .default
        confirmPassword.keyboardType = .default
        txtPass.isSecureTextEntry = true
        confirmPassword.isSecureTextEntry = true
        loginRequest = LoginModel(from: "", withPass: "")
       }
    
    func loadViewFromNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil).first as! UIView
        return view
        }
    
    func isValidate(usertype: UserCase = .ExistingUser) -> (Bool, String) {
        if self.loginRequest.email.isEmpty{
            return (false, "please fill email Id")
        }
        if !self.loginRequest.email.isValidEmail(){
            return (false, "please enter valid email id")
        }
        
        if self.loginRequest.password.isEmpty{
            return (false, "please fill password")
        }
        if self.loginRequest.password.count<6{
            return (false, "please fill at least 6 character for password")
        }
        if usertype == .NewUser{
           if let text = self.confirmPassword.text, text.isEmpty{
              return (false, "please confirm your password")
            }
        if self.confirmPassword.text == self.loginRequest.password{
             return(true,"")
            }
        else{
            return (false, "password not match, please try again")
            }
        }
        
        return(true,"")
    }

}

extension EmailView: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case txtEmail:
            txtPass.becomeFirstResponder()
        case txtPass:
            textField.resignFirstResponder()
        default:
            break
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == self.txtEmail {
            loginRequest.email = textField.text
        }
        else if textField == self.txtPass{
            loginRequest.password = textField.text
        }
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        return true
    }
}
