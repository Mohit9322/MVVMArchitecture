//
//  UserService.swift
//  WatchMyBack
//
//  Created by Chetu on 8/9/18.
//  Copyright © 2018 LocatorTechnologies. All rights reserved.
//

import Foundation
import Foundation
import Alamofire
import SwiftyJSON


class UserService
{
    /// registerUser - registers a new user
    ///
    /// - Parameters:
    ///   - userRegisterParams: the parameters to send to the call
    ///   - completion: callback
    func registerUser(userRegisterParams:UserRegisterParams,serviceType: TypeOfServiceCall, completion:@escaping(_ registerationResponse: String?, _ error:NetworkServiceError?)->Void)
    {
        // create the parameters for the call
        let params : Parameters = userRegisterParams.getParams();
        let watchMyBackNetworkClass = WatchMyBackNetworkClass()
        watchMyBackNetworkClass.callSecureService(Constants.ServicesStrings.registerSvc, params: params, serviceType: serviceType, type:userRegisterParams.getMethod()) { (json, error) in
            // check for an error
            guard error == nil else {
                completion(nil, error);
                return;
            }
            
            guard let json = json else {
                completion(nil, NetworkServiceError.generic(Constants.ServiceErrorMsg.errorMsg_InvalidFormat))
                return;
            }
            
            // send back to caller a valid user
            completion(json, nil);
        }
    }
    
    /*
     @description : Method is being used to call forgot password API
     Parameters:
     forgotPasswordParam: Hold the forgot service parameters,
     serviceType: Which type of service is used in network class,
     completion: completion block is being used for callback,
     error: will hold the error if occurs
     return : Void
     */
    func forgotPassword(forgotParams: ForgotPasswordParams,serviceType: TypeOfServiceCall, completion:@escaping(_ registerationResponse: String?, _ error:NetworkServiceError?)->Void)
    {
        // create the parameters for the call
        let params : Parameters = forgotParams.getParams();
        let watchMyBackNetworkClass = WatchMyBackNetworkClass()
        watchMyBackNetworkClass.callSecureService(Constants.ServicesStrings.forgotPassword, params: params, serviceType: serviceType, type: forgotParams.getMethod()) { (json, error) in
            // check for an error
            guard error == nil else {
                completion(nil, error);
                return;
            }
            
            guard let json = json else {
                completion(nil, NetworkServiceError.generic(Constants.ServiceErrorMsg.errorMsg_InvalidFormat))
                return;
            }
            
            // send back to caller a valid user
            completion(json, nil);
        }
    }
    
    /*
     @description : Method is being used for login service
     Parameters:
     loginParam: hold the parameter for login,
     serviceType: Which type of service is used in network class,
     completion: completion block is being used for callback
     error: will hold the error
     return : Void
     */
    func logIn(logInParams: LogInParameter, serviceType: TypeOfServiceCall, completion:@escaping(_ registerationResponse: String?, _ error:NetworkServiceError?)->Void)
    {
        // create the parameters for the call
        let params : Parameters = logInParams.getParams();
        let watchMyBackNetworkClass = WatchMyBackNetworkClass()
        watchMyBackNetworkClass.callSecureService(Constants.ServicesStrings.userLogIn, params: params, serviceType: serviceType, type: logInParams.getMethod()) { (json, error) in
            // check for an error
            guard error == nil else {
                completion(nil, error);
                return;
            }
            
            guard let json = json else {
                completion(nil, NetworkServiceError.generic(Constants.ServiceErrorMsg.errorMsg_InvalidFormat))
                return;
            }
            
            // send back to caller a valid user
            completion(json, nil);
        }
    }
    
    /*
     @description : Method is being used for addcontact service
     Parameters:
     addContactParams: hold the parameter for addcontact,
     serviceType: Which type of service is used in network class,
     completion: completion block is being used for callback
     error: will hold the error
     return : Void
     */
    func addContact(addContactParams: AddContactParams, serviceType: TypeOfServiceCall, completion:@escaping(_ registerationResponse: String?, _ error:NetworkServiceError?)->Void)
    {
        // create the parameters for the call
        let params : Parameters = addContactParams.getParams();
        let watchMyBackNetworkClass = WatchMyBackNetworkClass()
        watchMyBackNetworkClass.callSecureService(Constants.ServicesStrings.addContacts, params: params, serviceType: serviceType, type: addContactParams.getMethod()) { (json, error) in
            // check for an error
            guard error == nil else {
                completion(nil, error);
                return;
            }
            
            guard let json = json else {
                completion(nil, NetworkServiceError.generic(Constants.ServiceErrorMsg.errorMsg_InvalidFormat))
                return;
            }
            
            // send back to caller a valid user
            completion(json, nil);
        }
    }
    
    
    /*
     @description : Method is being used for editcontact service
     Parameters:
     editContactParams: hold the parameter for editcontact,
     serviceType: Which type of service is used in network class,
     completion: completion block is being used for callback
     error: will hold the error
     return : Void
     */
    
    func editContact(editContactParams: EditContactParams, serviceType: TypeOfServiceCall, completion:@escaping(_ registerationResponse: Bool?, _ error:NetworkServiceError?)->Void){
        // create the parameters for the call
        let params : Parameters = editContactParams.getParams();
        let watchMyBackNetworkClass = WatchMyBackNetworkClass()
        watchMyBackNetworkClass.callSecureServiceEditContacts(Constants.ServicesStrings.updateContacts, params: params, serviceType: serviceType, type: editContactParams.getMethod()) { (json, error) in
            // check for an error
            guard error == nil else {
                completion(nil, error);
                return;
            }
            
            guard let json = json else {
                completion(nil, NetworkServiceError.generic(Constants.ServiceErrorMsg.errorMsg_InvalidFormat))
                return;
            }
            
            // send back to caller a valid user
            completion(json, nil);
        }
    }
    
    /*
     @description : Method is being used for deletecontact service
     Parameters:
     editContactParams: hold the parameter for delete contact
     serviceType: Which type of service is used in network class,
     completion: completion block is being used for callback
     error: will hold the error
     return : Void
     */
    func deleteContact(deleteContactParams: DeleteContactParams, serviceType: TypeOfServiceCall, completion:@escaping(_ registerationResponse: Bool?, _ error:NetworkServiceError?)->Void){
        // create the parameters for the call
        let params : Parameters = deleteContactParams.getParams();
        let watchMyBackNetworkClass = WatchMyBackNetworkClass()
        watchMyBackNetworkClass.callSecureServiceEditContacts(Constants.ServicesStrings.deleteContact, params: params, serviceType: serviceType, type: deleteContactParams.getMethod()) { (json, error) in
            // check for an error
            guard error == nil else {
                completion(nil, error);
                return;
            }
            
            guard let json = json else {
                completion(nil, NetworkServiceError.generic(Constants.ServiceErrorMsg.errorMsg_InvalidFormat))
                return;
            }
            
            // send back to caller a valid user
            completion(json, nil);
        }
    }
    /*
     @description : Method is being used to get media ID
     Parameters:
     mediaIdOfParticularUser: Hold the media ID service parameters,
     serviceType: Which type of service is used in network class,
     completion: completion block is being used for callback,
     error: will hold the error if occurs
     return : Void
     */
    func getMediaID(mediaIdOfParticularUser: MediaIdOfParticularUser, serviceType: TypeOfServiceCall, completion:@escaping(_ registerationResponse: String?, _ error:NetworkServiceError?)->Void)
    {
        // create the parameters for the call
        let params : Parameters = mediaIdOfParticularUser.getParams();
        let watchMyBackNetworkClass = WatchMyBackNetworkClass()
        watchMyBackNetworkClass.callSecureService(Constants.ServicesStrings.userLogIn, params: params, serviceType: serviceType, type: mediaIdOfParticularUser.getMethod()) { (json, error) in
            // check for an error
            guard error == nil else {
                completion(nil, error);
                return;
            }
            
            guard let json = json else {
                completion(nil, NetworkServiceError.generic(Constants.ServiceErrorMsg.errorMsg_InvalidFormat))
                return;
            }
            
            // send back to caller a valid user
            completion(json, nil);
        }
    }
    
    /*
     @description : Method is being used to get contact id of a particular user
     Parameters:
     mediaIdOfParticularUser: Hold the contact ID service parameters,
     serviceType: Which type of service is used in network class,
     completion: completion block is being used for callback,
     error: will hold the error if occurs
     return : Void
     */
    func getContactID(getContactIdOfParticularUser: ContactIdOfParticularUser, serviceType: TypeOfServiceCall, completion:@escaping(_ registerationResponse: NSArray?, _ error:NetworkServiceError?)->Void){
        // create the parameters for the call
        let params : Parameters = getContactIdOfParticularUser.getParams()
        let watchMyBackNetworkClass = WatchMyBackNetworkClass()
        watchMyBackNetworkClass.callSecureServiceGetContacts(Constants.ServicesStrings.getContacts, params: params, serviceType: serviceType, type: getContactIdOfParticularUser.getMethod()) { (json, error) in
            // check for an error
            guard error == nil else {
                completion(nil, error);
                return;
            }
            
            guard let json = json else {
                completion(nil, NetworkServiceError.generic(Constants.ServiceErrorMsg.errorMsg_InvalidFormat))
                return;
            }
            
            // send back to caller a valid user
            completion(json, nil);
        }
    }
    /*
     @description : Method is being used for download media for corresponding media ID
     Parameters:
     id: Which media is being used to download,
     completionHandler: completion block is being used for callback,
     error: will hold the error if occurs
     return : Void
     */
    func downloadMedia(id: String, completion:@escaping(_ registerationResponse: Data?, _ error:NetworkServiceError?)->Void)
    {
        // create the parameters for the call
        let watchMyBackNetworkClass = WatchMyBackNetworkClass()
        watchMyBackNetworkClass.callSecureServiceForDownLoad(Constants.urlForDownloadImage + id, params: nil, type: .get) { (json, error) in
            // check for an error
            guard error == nil else {
                completion(nil, error);
                return;
            }
            
            guard let json = json else {
                completion(nil, NetworkServiceError.generic(Constants.ServiceErrorMsg.errorMsg_InvalidFormat))
                return;
            }
            
            // send back to caller a valid user
            completion(json, nil);
        }
    }
    
    /// registerUser - registers a new user
    ///
    /// - Parameters:
    //saveMediaParameter: parameter for webservice call,
    //mediaData: data for api call,
    //uploadedMediaType: type of media,
    //fileName: file name
    ///   - completion: callback
    func callSecureServiceForUploadMedia(saveMediaParameter: SaveMediaParameter, mediaData: Data?, uploadedMediaType: SelectedMediaType, fileName: String, completionHandler:@escaping(_ registerationResponse: String?, _ error: NetworkServiceError?)->Void){
        // create the parameters for the call
        let params : Parameters = saveMediaParameter.getParams();
        let watchMyBackNetworkClass = WatchMyBackNetworkClass()
        watchMyBackNetworkClass.callSecureServiceForUploadMedia(Constants.ServicesStrings.saveMedia, imageData: mediaData, uploadedMediaType: uploadedMediaType, params: params, fileName: fileName) { (json, error) in
            // check for an error
            guard error == nil else {
                completionHandler(nil, error);
                return;
            }
            
            guard let json = json else {
                completionHandler(nil, NetworkServiceError.generic(Constants.ServiceErrorMsg.errorMsg_InvalidFormat))
                return;
            }
            
            // send back to caller a valid user
            completionHandler(json, nil);
        }
    }
    
    /*
     @description : Method is being used to cancel all the requests
     Parameters: N/A
     return : N/A
     */
    func cancelAllRequest()  {
        let watchMyBackNetworkClass = WatchMyBackNetworkClass()
        watchMyBackNetworkClass.cancelAllRequest()
    }
}
