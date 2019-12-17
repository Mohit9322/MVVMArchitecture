//
//  RegisterViewController.swift
//  WatchMyBack
//
//  Created by Chetu on 6/26/18.
//  Copyright © 2018 LocatorTechnologies. All rights reserved.
//

import UIKit

class RegisterViewController: BaseViewController {
    
    //MARK: IBOutlet
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var passwordEyeIcon: UIButton!
    @IBOutlet weak var confirmPasswordEyeIcon: UIButton!
    
    //MARK: variables
    var passwordIconClicked : Bool = true
    var confirmPasswordIconClicked : Bool = true

    //MARK: Life cycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
        setTitle(title: Utility.localized(key: "kRegister"))
        setBackButton()
        setUpCommonUI()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
     @description : Method is being used to manage User interface when screen will appear
     Parameters: NA
     return : NA
     */
    func setUpCommonUI() {
        submitButton.setButtonProperty(title: Utility.localized(key: "kSubmit"),
                                       FontSize: Int(18.0),
                                       cornerRadius: 10.0,
                                       backgroundColor: PrimaryColor.navyBlue(alphaValue: 1.0))
        firstNameTextField.setTextFieldPlaceHolderColor(text: Utility.localized(key: "kFirstName"),
                                                        color: UIColor.white)
        lastNameTextField.setTextFieldPlaceHolderColor(text: Utility.localized(key: "kLastName"),
                                                       color: UIColor.white)
        passwordTextField.setTextFieldPlaceHolderColor(text: Utility.localized(key: "kPassword"),
                                                       color: UIColor.white)
        confirmPasswordTextField.setTextFieldPlaceHolderColor(text: Utility.localized(key: "kConfirm_Password"),
                                                              color: UIColor.white)
        emailTextField.setTextFieldPlaceHolderColor(text: Utility.localized(key: "kEmail"),
                                                    color: UIColor.white)
    }
    
    /*
     @description : Method is being used to validate entries in textfields
     Parameters:
     firstNameTextField: first name UITextField
     lastNameTextField: last name UITextField
     emailTextField: email UITextField
     passwordTextField: password UITextField
     confirmPasswordTextField: confirm password UITextField
     return : Bool
     */
    func isEntriesValid(firstNameTextField: UITextField, lastNameTextField: UITextField, emailTextField: UITextField, passwordTextField: UITextField, confirmPasswordTextField: UITextField) -> Bool {
        let signUpViewModel = SignupViewModel()
        let signUpFormData = SignupFormData(firstName: firstNameTextField.text ?? "", lastName: lastNameTextField.text ?? "", email: emailTextField.text ?? "", password: passwordTextField.text ?? "", confirmPassword: confirmPasswordTextField.text ?? "")
       return signUpViewModel.validateEntries(data: signUpFormData, viewController: self)
    }

    
    //MARK: IBAction
    /*
     @description : Method is being used to manage User interface when screen will appear
     Parameters:
     sender : UIButton
     return : NA
     */
    @IBAction func submitAction(_ sender: UIButton) {
        if isEntriesValid(firstNameTextField: firstNameTextField,
                          lastNameTextField: lastNameTextField,
                          emailTextField: emailTextField,
                          passwordTextField: passwordTextField,
                          confirmPasswordTextField: confirmPasswordTextField) {
            
            callSignUpService()
        }
    }
    
    /*
     @description : Method is being used to show the password for password field
     Parameters:
     sender: UIButton
     return : NA
     */
    @IBAction func passwordEyeAction(_ sender: UIButton) {
        if !passwordTextField.isEmpty {
            if(passwordIconClicked == true) {
                passwordEyeIcon.setBackgroundImage(#imageLiteral(resourceName: "eyeIcon"), for: .normal)
                passwordTextField.isSecureTextEntry = false
                passwordIconClicked = false
            } else {
                passwordEyeIcon.setBackgroundImage(#imageLiteral(resourceName: "eyeClose"), for: .normal)
                passwordTextField.isSecureTextEntry = true
                passwordIconClicked = true
            }
        }
    }
    
    /*
     @description : Method is being used to show the password for confirm password field
     Parameters:
     sender: UIButton
     return : NA
     */
    @IBAction func confirmPasswordEyeAction(_ sender: UIButton) {
         if !confirmPasswordTextField.isEmpty {
            if(confirmPasswordIconClicked == true) {
                confirmPasswordEyeIcon.setBackgroundImage(#imageLiteral(resourceName: "eyeIcon"), for: .normal)
                confirmPasswordTextField.isSecureTextEntry = false
                confirmPasswordIconClicked = false
            } else {
                confirmPasswordEyeIcon.setBackgroundImage(#imageLiteral(resourceName: "eyeClose"), for: .normal)
                confirmPasswordTextField.isSecureTextEntry = true
                confirmPasswordIconClicked = true
            }
         }
    }
    
    //MARK: IBAction
    /*
     @description : Method is being used to call sign up service
     Parameters: NA
     return : NA
     */
    func callSignUpService() {
        HISActivityIndicator.start()
        let firstName = firstNameTextField.text ?? ""
        let lastName = lastNameTextField.text ?? ""
        let userName = firstName + lastName
        
        let userRegistrationParameter = UserRegisterParams(username: userName, email: emailTextField.text ?? "", password: passwordTextField.text?.base64String ?? "")
        let signUpViewModel = SignupViewModel()
        
        signUpViewModel.registerServiceCall(userRegistrationParameter: userRegistrationParameter, serviceType: .registration) { [weak self] (registerResponse, error) in
                DispatchQueue.main.async {
                    HISActivityIndicator.stop()
                    if let strongSelf = self {
                        if error == nil {
                            Utility.alertContoller(title: Utility.localized(key: "kMessage"),
                                                   message: Utility.localized(key: "kRegistrationSuccessful"),
                                                   actionTitleFirst: Utility.localized(key: "kOk"),
                                                   actionTitleSecond: "", firstActoin: #selector(RegisterViewController.dismissViewController),
                                                   secondAction: nil,
                                                   controller: strongSelf)
                            
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
    
    
    /*
     @description : Selector Method is being used to popview controller
     Parameters: NA
     return : NA
     */
    @objc func dismissViewController() {
        navigationController?.popViewController(animated: true)
    }
}

//MARK: Textfield Delegates
extension RegisterViewController: UITextFieldDelegate {
    /*
     @description : Method is being used to call Login API
     Parameters:
     textField: parameter is used to get current textfield object
     range: it is being used to get length of string
     replacementString: the new string which will replace the last string
     return : Bool
     */
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == passwordTextField || textField == confirmPasswordTextField {
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
