//
//  LoginViewModel.swift
//  WatchMyBack
//
//  Created by Chetu on 7/10/18.
//  Copyright © 2018 LocatorTechnologies. All rights reserved.
//

import Foundation
import UIKit



open class LoginViewModel {
    public init(){}
    /*
     @description : Method for validating the login Entries
     Parameters:
     data: is being used to hold login form data
     viewController: is being used to hold viewController from which controller we are passing data
     return : Bool
     */
    func validateEntries(data: LoginFormData, viewController: UIViewController) -> Bool {
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
        } else if data.password.isEmpty || data.password.count < 6 {
            Utility.alertContoller(title: Utility.localized(key: "kMessage"),
                                   message: Utility.localized(key: "kPleaseEnterValidPassword"),
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
     @description : Method is being used for login service
     Parameters:
     logIn
     Parameter: hold the parameter for login,
     serviceType: Which type of service is used in network class,
     completion: completion block is being used for callback
     error: will hold the error
     return : Void
     */
    
    func loginServiceCall(logInParameter: LogInParameter, serviceType: TypeOfServiceCall, completion:@escaping(_ response: String?, _ error:NetworkServiceError?)->Void)  {
        ApplicationState.sharedAppState.appDataStore.logIn(loginParam: logInParameter, serviceType: serviceType) { (response, error) in
            completion(response, error)
        }
    }
    
    /*
     @description : Method is being used for login service
     Parameters:
     getMediaIdOfUser: Hold the media ID service parameters,
     serviceType: Which type of service is used in network class,
     completion: completion block is being used for callback,
     error: will hold the error if occurs
     return : Void
     */
    func getMediaID(getMediaIdOfUser: MediaIdOfParticularUser, serviceType: TypeOfServiceCall, completion:@escaping(_ response: String?, _ error:NetworkServiceError?)->Void)  {
        ApplicationState.sharedAppState.appDataStore.getMediaID(getMediaIdOfUser: getMediaIdOfUser, serviceType: serviceType) { (response, error) in
            completion(response, error)
        }
    }
    
    func getContactID(getContactIdOfUser: ContactIdOfParticularUser, serviceType: TypeOfServiceCall, completion:@escaping(_ response: NSArray?, _ error:NetworkServiceError?)->Void)  {
        ApplicationState.sharedAppState.appDataStore.getContactID(getContactIdOfParticularUser: getContactIdOfUser, serviceType: serviceType) { (response, error) in
            completion(response, error)
        }
    }
    
}
