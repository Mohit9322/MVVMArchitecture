//
//  ForgotPasswordViewController.swift
//  WatchMyBack
//
//  Created by Chetu on 6/26/18.
//  Copyright © 2018 LocatorTechnologies. All rights reserved.
//

import UIKit

class ForgotPasswordViewController: BaseViewController {

    //MARK: IBOutlets
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    
    //MARK: Variable
    var forgotPassWordViewModel = ForgotPasswordViewModel()
    
    //MARK: Life cycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
        setTitle(title: Utility.localized(key: "kForgotPassword"))
        setBackButton()
        setUpCommonUI()
    }
    
    //MARK: IBActions
    /*
     @description : Method is being used to call event for submit button
     Parameters:
     sender: UIButton
     return : NA
     */
    @IBAction func submitAction(_ sender: UIButton) {
        if isEntriesValid(emailTextField: emailTextField) {
            callforgotPassword()
        }
    }
    
    /*
     @description : Method is being used to call forgot password handling api using the callback
     Parameters: NA
     return : NA
     */
    func callforgotPassword() {
        HISActivityIndicator.start()
        
        let userForgotPasswordParams = ForgotPasswordParams(email: emailTextField.text ?? "")
        let forgotPasswordViewModel = ForgotPasswordViewModel()
        
        forgotPasswordViewModel.forgotPasswordServiceCall(userForgotPasswordParameter: userForgotPasswordParams, serviceType: .forgotPassword) { [weak self] (response, error) in
            DispatchQueue.main.async {
                HISActivityIndicator.stop()
                if let strongSelf = self {
                    if error == nil {
                        Utility.alertContoller(title: Utility.localized(key: "kMessage"),
                                               message: Utility.localized(key: "kForgotPasswordSuccessful"),
                                               actionTitleFirst: Utility.localized(key: "kOk"),
                                               actionTitleSecond: "", firstActoin: #selector(ForgotPasswordViewController.callDismiss),
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
     @description : Method is being used to manage User interface when screen will appear
     Parameters: NA
     return : NA
     */
    func setUpCommonUI() {
        submitButton.setButtonProperty(title: Utility.localized(key: "kSubmit"),
                                       FontSize: Int(18.0),
                                       cornerRadius: 10.0,
                                       backgroundColor: PrimaryColor.navyBlue(alphaValue: 1.0))
        emailTextField.setTextFieldPlaceHolderColor(text: Utility.localized(key: "kEmail"),
                                                    color: UIColor.white)
    }
    
    /*
     @description : Method is being used to validate the textfield entries
     Parameters:
     emailTextField : email textfield UITextField
     return : Bool
     */
    func isEntriesValid(emailTextField: UITextField) -> Bool {
        let forgotPasswordData = ForgotPasswordData(email: emailTextField.text ?? "")
        return forgotPassWordViewModel.validateEntries(data: forgotPasswordData, viewController: self)
    }
    
    
    /*
     @description : Method is being used to implement forgot password API
     Parameters: NA
     return : NA
     */
    @objc func callDismiss()  {
        navigationController?.popViewController(animated: true)
    }
}
