//
//  ForgotPasswordViewModel.swift
//  WatchMyBack
//
//  Created by Chetu on 7/10/18.
//  Copyright © 2018 LocatorTechnologies. All rights reserved.
//

import Foundation
import UIKit

open class ForgotPasswordViewModel {
    public init(){}
    
    /*
     @description : Method for validating the forgot password Entries
     Parameters:
     data: is being used to hold forgot password form data
     viewController: is being used to hold viewController from which controller we are passing data
     return : Bool
     */
    func validateEntries(data: ForgotPasswordData, viewController: UIViewController) -> Bool {
        if data.email.isEmpty {
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
        } else {
            viewController.view.endEditing(true)
            return true
        }
    }
    
    
    /*
     @description : Method is being used for forgot password service
     Parameters:
     userForgotPasswordParameter: Hold the forgot service parameters,
     serviceType: Which type of service is used in network class,
     completion: completion block is being used for callback,
     error: will hold the error if occurs
     return : Void
     */
    func forgotPasswordServiceCall(userForgotPasswordParameter: ForgotPasswordParams, serviceType: TypeOfServiceCall, completion:@escaping(_ response: String?, _ error:NetworkServiceError?)->Void)  {
        ApplicationState.sharedAppState.appDataStore.forgotPassword(forgotPasswordParam: userForgotPasswordParameter, serviceType: serviceType) { (response, error) in
            completion(response, error)
        }
    }
}

