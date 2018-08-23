//
//  LoginScreen.swift
//  ThiqahDelivery
//
//  Created by Gaurav Prakash on 15/08/18.
//  Copyright © 2018 Gaurav Prakash. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Moya
import ContextMenu

enum UserCase {
    case NewUser
    case ExistingUser
}

class LoginScreen: BaseViewController {
    @IBOutlet weak var welcomeText: UILabel!
    @IBOutlet weak var parentView: UIView!
    @IBOutlet weak var newUser: UILabel!
    @IBOutlet weak var existingUser: UILabel!
    @IBOutlet weak var newUserConstraint: NSLayoutConstraint!
    @IBOutlet weak var existingUserConstraint: NSLayoutConstraint!
    @IBOutlet weak var parentViewHeight: NSLayoutConstraint!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var newUserRadioBtn: UIImageView!
    @IBOutlet weak var existingUserRadioBtn: UIImageView!
    @IBOutlet weak var existingUserView: EmailView!
    @IBOutlet weak var newUserView: EmailView!
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var moreButton: UIBarButtonItem!
    
    let disposeBag = DisposeBag()
    var apiDirectory: Thiqah!
    var userCase: UserCase!
    var loginRequest: LoginModel!
   
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTheme()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    fileprivate func setUpTheme(){
        userCase = .NewUser
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.navigationBar.tintColor = .white
        [self.newUser, self.existingUser, self.welcomeText].forEach({$0?.textColor = Theme.Color.primaryTextColor})
        self.parentView.backgroundColor = Theme.Color.loginView
        self.loginButton.setTitleColor(Theme.Color.loginButtonText, for: .normal)
        self.loginButton.backgroundColor = Theme.Color.loginButtonBg
        newUserView.isHidden = false
        existingUserView.isHidden = true
        existingUserConstraint.constant = 0.0
      
        self.loginButton.addCornerRadius()
        setuserview()
    }
    
    fileprivate func setuserview(){
        switch userCase! {
        case .NewUser:
            newUserRadioBtn.image = #imageLiteral(resourceName: "ic_button_checked")
            existingUserRadioBtn.image = #imageLiteral(resourceName: "ic_button_unchecked")
            existingUserView.isHidden = true
            existingUserView.txtEmail.text = ""
            existingUserView.txtPass.text = ""
            existingUserConstraint.constant = 0.0
            newUserView.isHidden = false
            newUserView.confirmPassword.isHidden = false
            newUserConstraint.constant = 160.0
            self.parentViewHeight.constant = 330.0
            loginButton.setTitle("SET UP ACCOUNT", for: .normal)
        case .ExistingUser:
            newUserRadioBtn.image = #imageLiteral(resourceName: "ic_button_unchecked")
            existingUserRadioBtn.image = #imageLiteral(resourceName: "ic_button_checked")
            newUserConstraint.constant = 0.0
            newUserView.isHidden = true
            existingUserView.confirmPassword.isHidden = true
            newUserView.txtEmail.text = ""
            newUserView.txtPass.text = ""
            existingUserConstraint.constant = 110.0
            existingUserView.isHidden = false
             self.parentViewHeight.constant = 280.0
            loginButton.setTitle("LOGIN", for: .normal)
        }
    }
    
    fileprivate func navigateView(){
        if let frontVC = Storyboards.DASHBOARD.storyBoard.instantiateViewController(withIdentifier: "Dashboard") as? UINavigationController, let rearVC = Storyboards.HOME.storyBoard.instantiateViewController(withIdentifier: "LeftMenu") as? LeftMenuController{
            if let swRevealVC = SWRevealViewController(rearViewController: rearVC, frontViewController: frontVC){
                self.navigationController?.pushViewController(swRevealVC, animated: true)
            }
        }
    }
    
    @IBAction func setUserRole(_ sender: UIButton) {
        switch sender.tag {
        case 10:
            userCase = .NewUser
            setuserview()
        case 11:
            userCase = .ExistingUser
            setuserview()
        default:
            break
        }
    }
    
    @IBAction func setUpAccount(_ sender: UIButton) {
        var dictionary = [String:Any]()
        self.view.endEditing(true)
        switch userCase! {
        case .NewUser:
            if newUserView.isValidate(usertype: .NewUser).0{
                dictionary["email"] = newUserView.txtEmail.text
                dictionary["password"] = newUserView.txtPass.text
                apiDirectory = .REGISTER(dictionary)
                self.showLoader(message: "Signing up..")
                registerForUser(thiqah: apiDirectory)
            }
            
            else{
                self.view.makeToast(newUserView.isValidate(usertype: .NewUser).1)
            }
            
        case .ExistingUser:
            if existingUserView.isValidate(usertype: .ExistingUser).0{
                dictionary["email"] = existingUserView.txtEmail.text
                dictionary["password"] = existingUserView.txtPass.text
                apiDirectory = .LOGIN(dictionary)
                self.showLoader(message: "Logging ..")
                registerForUser(thiqah: apiDirectory)
            }
            else{
                self.view.makeToast(existingUserView.isValidate(usertype: .ExistingUser).1)
            }
            
        }
        
    }
}

extension LoginScreen{
    func registerForUser(thiqah:Thiqah){
        ThiqahAPIProvider.rx.request(thiqah).subscribe( {event in
            switch event{
            case .success(let response):
                let json = try? JSONSerialization.jsonObject(with: response.data, options: []) as? [String:Any]
                if let dictionary = json as? [String: Any]{
                if let errorCode = dictionary["ERROR_CODE"] as? String, errorCode == "1"{
                    do {
                        let decoder = JSONDecoder()
                        let loginData = try decoder.decode(LoginData.self, from: response.data)
                        DefaultManager.setUserData(value: loginData.driverDetail![0])
                        DefaultManager.setLogged(value: true)
                        self.hideLoader(completion: {
                           self.navigateView()
                        })
                        }catch { print(error) }
                    }
                else{
                    self.hideLoader(completion: {
                     self.view.makeToast(dictionary["ERROR_DESCRIPTION"] as? String)
                    })
                    
                    }
                }
                else{
                    print("Incorrect format response")
                 }
                case .error(let err):
                print(err.localizedDescription)
            }
        }).disposed(by: disposeBag)
     
    }
   
}

class ContentViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Select"
        preferredContentSize = CGSize(width: 200, height: 200)
    }
}
