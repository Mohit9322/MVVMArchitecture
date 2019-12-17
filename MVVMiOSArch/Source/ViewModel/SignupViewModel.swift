//
//  SignupViewModel.swift
//  WatchMyBack
//
//  Created by Chetu on 7/10/18.
//  Copyright © 2018 LocatorTechnologies. All rights reserved.
//

import Foundation
import UIKit


open class SignupViewModel {
    public init(){}
    
    /*
     @description : Method for validating the signup Entries
     Parameters:
     data: is being used to hold signup form data
     viewController: is being used to hold viewController from which controller we are passing data
     return : Bool
     */
    func validateEntries(data: SignupFormData, viewController: UIViewController) -> Bool {
        if data.firstName.isEmpty {
            Utility.alertContoller(title: Utility.localized(key: "kMessage"),
                                   message: Utility.localized(key: "kEnterFirstName"),
                                   actionTitleFirst: Utility.localized(key: "kOk"),
                                   actionTitleSecond: "",
                                   firstActoin: nil, secondAction: nil,
                                   controller: viewController)
            return false
        } else if data.lastName.isEmpty {
            Utility.alertContoller(title: Utility.localized(key: "kMessage"),
                                   message: Utility.localized(key: "kEnterLastName"),
                                   actionTitleFirst: Utility.localized(key: "kOk"),
                                   actionTitleSecond: "",
                                   firstActoin: nil, secondAction: nil,
                                   controller: viewController)
            return false
        } else if data.email.isEmpty {
            Utility.alertContoller(title: Utility.localized(key: "kMessage"),
                                   message: Utility.localized(key: "kEnterEmail"),
                                   actionTitleFirst: Utility.localized(key: "kOk"),
                                   actionTitleSecond: "",
                                   firstActoin: nil, secondAction: nil,
                                   controller: viewController)
            return false
        } else if !data.email.isValidEmail{
            Utility.alertContoller(title: Utility.localized(key: "kMessage"),
                                   message: Utility.localized(key: "kPleaseEnterValidEmail"),
                                   actionTitleFirst: Utility.localized(key: "kOk"),
                                   actionTitleSecond: "",
                                   firstActoin: nil,
                                   secondAction: nil,
                                   controller: viewController)
            return false
        } else if data.password.isEmpty || data.password.count < 6 || !data.password.isValidPassword{
            Utility.alertContoller(title: Utility.localized(key: "kMessage"),
                                   message: Utility.localized(key: "kPasswordMustContain"),
                                   actionTitleFirst: Utility.localized(key: "kOk"),
                                   actionTitleSecond: "",
                                   firstActoin: nil,
                                   secondAction: nil,
                                   controller: viewController)
            return false
        } else if data.confirmPassword.isEmpty || data.confirmPassword.count < 6 {
            Utility.alertContoller(title: Utility.localized(key: "kMessage"),
                                   message: Utility.localized(key: "kPleaseEnterValidConfirmPasswordPassword"),
                                   actionTitleFirst: Utility.localized(key: "kOk"),
                                   actionTitleSecond: "",
                                   firstActoin: nil,
                                   secondAction: nil,
                                   controller: viewController)
            return false
        } else if data.confirmPassword != data.password {
            Utility.alertContoller(title: Utility.localized(key: "kMessage"),
                                   message: Utility.localized(key: "kPasswordAndConfirmPasswordMustSame"),
                                   actionTitleFirst: Utility.localized(key: "kOk"),
                                   actionTitleSecond: "",
                                   firstActoin: nil,
                                   secondAction: nil,
                                   controller: viewController)
            return false
        } else {
            viewController.view.endEditing(true)
            return true
        }
    }
    
    
    /*
     @description : Method is being used for register service service
     Parameters:
     userRegistrationParameter: Hold the register service parameters,
     serviceType: Which type of service is used in network class,
     completion: completion block is being used for callback,
     error: will hold the error if occurs
     return : Void
     */
    func registerServiceCall(userRegistrationParameter: UserRegisterParams, serviceType: TypeOfServiceCall, completion:@escaping(_ registerationResponse: String?, _ error:NetworkServiceError?)->Void)  {
        ApplicationState.sharedAppState.appDataStore.registerUser(userRegisterParams: userRegistrationParameter, serviceType: serviceType) { (registerationResponse, error) in
            completion(registerationResponse, error)
        }
    }
}
