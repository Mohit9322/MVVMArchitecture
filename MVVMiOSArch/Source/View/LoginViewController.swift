//
//  ViewController.swift
//  WatchMyBack
//
//  Created by LocatorTechnologies on 6/25/18.
//  Copyright © 2018 LocatorTechnologies. All rights reserved.
//

import UIKit
import Alamofire

class LoginViewController: BaseViewController {
    //MARK: IBOutlet
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var forgotPasswordButton: UIButton!
    @IBOutlet weak var registrationButton: UIButton!
    @IBOutlet weak var registrationButtonTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var forgotPasswordTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var eyeButton: UIButton!
    
    //MARK: Variable
    var passwordIconClicked : Bool = true
    var loginViewModel = LoginViewModel()
    
    
    //MARK: Life cycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpCommonUI()
        self.emailTextField.text = DataManager.email;
        self.passwordTextField.text = DataManager.password;
//        if(UIDeviceOrientation.isLandscape){
//            DispatchQueue.main.asyncAfter(deadline: .now() + 0.0) { [weak self] in
//                self?.setUpUIforLandscapeMode()
//            }
//        }
        
//        if(UIDeviceOrientationIsPortrait(UIDevice.current.orientation)){
//            DispatchQueue.main.asyncAfter(deadline: .now() + 0.0) { [weak self] in
//                self?.setUpUIforPortraiteMode()
//            }
//        }
        if(DataManager.isLogin == true){
            self.logInAction(self.loginButton)
        }
    }
    
    /*
     @description : Method is being used to manage User interface when screen will appear
     Parameters: NA
     return : NA
     */
    func setUpCommonUI() {
        navigationController?.navigationBar.isHidden = true
        loginButton.setButtonProperty(title: Utility.localized(key: "kLogin"),
                                      FontSize: Int(18.0),
                                      cornerRadius: 10.0,
                                      backgroundColor: PrimaryColor.navyBlue(alphaValue: 1.0))
        emailTextField.setTextFieldPlaceHolderColor(text: Utility.localized(key: "kEmail"),
                                                    color: UIColor.white)
        passwordTextField.setTextFieldPlaceHolderColor(text: Utility.localized(key: "kPassword"),
                                                       color: UIColor.white)
    }
    
    /*
     @description : Method is being used to manage Constraint for the register button in portrait mode
     Parameters: NA
     return : NA
     */
    func setUpUIforPortraiteMode()  {
        if UIScreen.main.bounds.size.height == Constants.screenSizeHeight.iPhoneSmall  {
            registrationButtonTopConstraint.constant = 20
            forgotPasswordTopConstraint.constant = 20
        } else if UIScreen.main.bounds.size.height == Constants.screenSizeHeight.iPhoneRegular {
            registrationButtonTopConstraint.constant = 60
        } else if UIScreen.main.bounds.size.height == Constants.screenSizeHeight.iPhonePlus {
            registrationButtonTopConstraint.constant = 110
        } else if UIScreen.main.bounds.size.height == Constants.screenSizeHeight.iPhoneX {
            registrationButtonTopConstraint.constant = 160
        }
    }
    
    /*
     @description : Method is being used to manage Constraint for the register button in land scape mode
     Parameters: NA
     return : NA
     */
    func setUpUIforLandscapeMode()  {
        registrationButtonTopConstraint.constant = 50
    }
    
    //MARK: Delegate method for rotation
    override func willRotate(to toInterfaceOrientation: UIInterfaceOrientation, duration: TimeInterval) {
//        if(UIDeviceOrientationIsLandscape(UIDevice.current.orientation)){
//            DispatchQueue.main.asyncAfter(deadline: .now() + 0.0) { [weak self] in
//                self?.setUpUIforLandscapeMode()
//            }
//        }
//
//        if(UIDeviceOrientationIsPortrait(UIDevice.current.orientation)){
//            DispatchQueue.main.asyncAfter(deadline: .now() + 0.0) { [weak self] in
//                self?.setUpUIforPortraiteMode()
//            }
//        }
    }
    
    /*
     @description : Method is being used to validate entries in textfields
     Parameters:
     emailTextField: email text field UITextField
     passwordTextField: password text field UITextField
     return : Bool
     */
    func isEntriesValid(emailTextField: UITextField, passwordTextField: UITextField) -> Bool {
        let loginformData = LoginFormData(email: emailTextField.text ?? "", password: passwordTextField.text ?? "")
        return loginViewModel.validateEntries(data: loginformData, viewController: self)
    }
    
    //MARK: IBActions
    /*
     @description : Method is being used to call click event for login button
     Parameters:
     sender: UIButton
     return : NA
     */
    @IBAction func logInAction(_ sender: UIButton) {
        if isEntriesValid(emailTextField: emailTextField,
                          passwordTextField: passwordTextField) {
            callLogin()
            
        }
    }
    
    /*
     @description : Method is being used to call click event for forgot password button
     Parameters:
     sender: UIButton
     return : NA
     */
    @IBAction func forgotPasswordAction(_ sender: UIButton) {
        guard let vc = UIStoryboard.init(name: Constants.StoryBoardIdentifiers.kStoryboardMain,
                                         bundle: Bundle.main).instantiateViewController(withIdentifier: Constants.ViewControllerIdentiFiers.kForgotPasswordViewController) as? ForgotPasswordViewController else {
                                            return
        }
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    /*
     @description : Method is being used to call click event for forgot register button
     Parameters:
     sender: UIButton
     return : NA
     */
    @IBAction func registrationAction(_ sender: UIButton) {
        guard let vc = UIStoryboard.init(name: Constants.StoryBoardIdentifiers.kStoryboardMain,
                                         bundle: Bundle.main).instantiateViewController(withIdentifier: Constants.ViewControllerIdentiFiers.kRegisterViewController) as? RegisterViewController else {
                                            return
        }
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    /*
     @description : Method is being used to show the password
     Parameters:
     sender: UIButton
     return : NA
     */
    @IBAction func showPasswordButton(_ sender: Any) {
        if !passwordTextField.isEmpty {
            if(passwordIconClicked == true) {
                eyeButton.setBackgroundImage(#imageLiteral(resourceName: "eyeIcon"), for: .normal)
                passwordTextField.isSecureTextEntry = false
                passwordIconClicked = false
            } else {
                eyeButton.setBackgroundImage(#imageLiteral(resourceName: "eyeClose"), for: .normal)
                passwordTextField.isSecureTextEntry = true
                passwordIconClicked = true
            }
        }
    }
    
    
    /*
     @description : Method is being used to call Login API
     Parameters: NA
     return : NA
     */
    func callLogin() {
        HISActivityIndicator.start()
        
        let userLogInParams = LogInParameter(email: emailTextField.text ?? "", passWord: passwordTextField.text?.base64String ?? "", isPaidUser: "true")
        let logInViewModel = LoginViewModel()
        
        logInViewModel.loginServiceCall(logInParameter: userLogInParams, serviceType: .login) { [weak self] (response, error) in
            DispatchQueue.main.async {
                HISActivityIndicator.stop()
                if let strongSelf = self {
                    if error == nil {
                        //storing data into the local storage
                        DataManager.email = strongSelf.emailTextField.text ?? ""
                        DataManager.password = strongSelf.passwordTextField.text ?? ""
                        DataManager.isLogin = true
                        self?.saveContactCache()
                        strongSelf.moveToHomeScreen()
                    } else {
                        Utility.alertContoller(title: Utility.localized(key: "kMessage"),
                                               message: error?.description ?? "",
                                               actionTitleFirst: Utility.localized(key: "kOk"),
                                               actionTitleSecond: "", firstActoin: nil,
                                               secondAction: nil,
                                               controller: strongSelf)
                    }
                }
            }
        }
    }
    
    func saveContactCache(){
        let userLogInParams = ContactIdOfParticularUser(email: DataManager.email ?? "", passWord: DataManager.password?.base64String ?? "")
        let logInViewModel = LoginViewModel()
        
        logInViewModel.getContactID(getContactIdOfUser: userLogInParams, serviceType: .getcontactIdForParticalUser) { [weak self] (response, error) in
            DispatchQueue.main.async {
                HISActivityIndicator.stop()
                
                if error == nil {
                    var arrayContact: NSArray = []
                    arrayContact = response!
                    
                    if (arrayContact.count) > 0 {
                        
                        UserDefaults().set(arrayContact.mutableCopy() as! NSMutableArray, forKey: "contactCache")
                    }
                } else {
                    
                }
            }
        }
    }
    
    /*
     @description : Method is being used to navigate home screen
     Parameters: NA
     return : NA
     */
    func moveToHomeScreen(){
        guard let vc = UIStoryboard.init(name: Constants.StoryBoardIdentifiers.kStoryboardMain,
                                         bundle: Bundle.main).instantiateViewController(withIdentifier: Constants.ViewControllerIdentiFiers.kHomeViewController) as? HomeViewController else {
                                            return
        }
        DocumentDirecotoryOperations.createDirectoryForMediaStorage(typeOfMedia: .photo, controller: self)
        DocumentDirecotoryOperations.createDirectoryForArchiveStorage(typeOfMedia: .photo, controller: self)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

//MARK: Textfield Delegates
extension LoginViewController: UITextFieldDelegate {
    /*
     @description : Method is being used to call Login API
     Parameters:
     textField: parameter is used to get current textfield object
     range: it is being used to get length of string
     replacementString: the new string which will replace the last string
     return : Bool
     */
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == passwordTextField {
            if(string.count == 0){
                // Returning yes here to allow entry of backspace
                return true;
            }
            if string == " " {
                return false
            }
        }
        return true
    }
}

