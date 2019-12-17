//
//  AddContactViewModel.swift
//  WatchMyBack
//
//  Created by Chetu on 11/12/18.
//  Copyright © 2018 LocatorTechnologies. All rights reserved.
//

import UIKit

open class AddContactViewModel {
    
    public init(){}
    /*
     @description : Method for validating the contact Entries
     Parameters:
     data: is being used to hold contact details form data
     viewController: is being used to hold viewController from which controller we are passing data
     return : Bool
     */
    func validateEntries(data: AddContactFormData, viewController: UIViewController) -> Bool{
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
        } else if data.name.isEmpty {
            Utility.alertContoller(title: Utility.localized(key: "kMessage"),
                                   message: Utility.localized(key: "kPleaseEnterName"),
                                   actionTitleFirst: Utility.localized(key: "kOk"),
                                   actionTitleSecond: "",
                                   firstActoin: nil,
                                   secondAction: nil,
                                   controller: viewController)
            return false
        }
        else if data.phone.isEmpty || data.phone.count < 10 || data.phone.count > 10 {
            Utility.alertContoller(title: Utility.localized(key: "kMessage"),
                                   message: Utility.localized(key: "kPleaseEnterValidPhoneNumber"),
                                   actionTitleFirst: Utility.localized(key: "kOk"),
                                   actionTitleSecond: "",
                                   firstActoin: nil,
                                   secondAction: nil,
                                   controller: viewController)
            return false
        }else {
            viewController.view.endEditing(true)
            return true
        }
    }
    
    /*
     @description : Method is being used for addContact service
     Parameters:
     logIn
     Parameter: hold the parameter for login,
     serviceType: Which type of service is used in network class,
     completion: completion block is being used for callback
     error: will hold the error
     return : Void
     */
    
    func addContacServiceCall(addContactParameter: AddContactParams, serviceType: TypeOfServiceCall, completion:@escaping(_ response: String?, _ error:NetworkServiceError?)->Void)  {
        ApplicationState.sharedAppState.appDataStore.addContact(addContactParams: addContactParameter, serviceType: serviceType) { (response, error) in
            completion(response, error)
        }
    }
    
    func editContacServiceCall(editContactParameter: EditContactParams, serviceType: TypeOfServiceCall, completion:@escaping(_ response: Bool?, _ error:NetworkServiceError?)->Void) {
        ApplicationState.sharedAppState.appDataStore.editContact(editContactParams: editContactParameter, serviceType: serviceType) { (response, error) in
            completion(response, error)
        }
    }
    func deleteContacServiceCall(deleteContactParameter: DeleteContactParams, serviceType: TypeOfServiceCall, completion:@escaping(_ response: Bool?, _ error:NetworkServiceError?)->Void)  {
        ApplicationState.sharedAppState.appDataStore.deleteContact(deleteContactParams: deleteContactParameter, serviceType: serviceType) { (response, error) in
            completion(response, error)
        }
    }

}

