//
//  AppDataStore.swift
//  WatchMyBack
//
//  Created by Chetu on 8/9/18.
//  Copyright © 2018 LocatorTechnologies. All rights reserved.
//

import Foundation
class AppDataStore
{

    fileprivate let userService : UserService = UserService();

    init(){
    }
    
    /*
     @description : Method is being used for register service service
     Parameters:
     userRegisterParams: Hold the register service parameters,
     serviceType: Which type of service is used in network class,
     completion: completion block is being used for callback,
     error: will hold the error if occurs
     return : Void
     */
    func registerUser(userRegisterParams: UserRegisterParams, serviceType: TypeOfServiceCall, completion:@escaping(_ registerationResponse: String?, _ error:NetworkServiceError?)->Void){
        userService.registerUser(userRegisterParams: userRegisterParams, serviceType: serviceType) { (registerationResponse, error) in
            completion(registerationResponse, error);
        }
    }
  
    /*
     @description : Method is being used for forgot password service
     Parameters:
     forgotPasswordParam: Hold the forgot service parameters,
     serviceType: Which type of service is used in network class,
     completion: completion block is being used for callback,
     error: will hold the error if occurs
     return : Void
     */
    func forgotPassword(forgotPasswordParam: ForgotPasswordParams, serviceType: TypeOfServiceCall, completion:@escaping(_ response: String?, _ error:NetworkServiceError?)->Void){
        userService.forgotPassword(forgotParams: forgotPasswordParam, serviceType: serviceType) { (response, error) in
            completion(response, error);
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
    
    func logIn(loginParam: LogInParameter, serviceType: TypeOfServiceCall, completion:@escaping(_ response: String?, _ error:NetworkServiceError?)->Void){
        userService.logIn(logInParams: loginParam, serviceType: serviceType) { (response, error) in
            completion(response, error);
        }
    }
    
    /*
     @description : Method is being used for addContact service
     Parameters:
     loginParam: hold the parameter for addContactParams,
     serviceType: Which type of service is used in network class,
     completion: completion block is being used for callback
     error: will hold the error
     return : Void
     */
    
    func addContact(addContactParams: AddContactParams, serviceType: TypeOfServiceCall, completion:@escaping(_ response: String?, _ error:NetworkServiceError?)->Void){
        userService.addContact(addContactParams: addContactParams, serviceType: serviceType) { (response, error) in
            completion(response, error);
        }
    }
    
    /*
     @description : Method is being used for editContact service
     Parameters:
     loginParam: hold the parameter for editContactParams,
     serviceType: Which type of service is used in network class,
     completion: completion block is being used for callback
     error: will hold the error
     return : Void
     */
    func editContact(editContactParams: EditContactParams, serviceType: TypeOfServiceCall, completion:@escaping(_ response: Bool?, _ error:NetworkServiceError?)->Void){
        userService.editContact(editContactParams: editContactParams, serviceType: serviceType) { (response, error) in
            completion(response, error);
        }
    }
    
    /*
     @description : Method is being used for deleteContact service
     Parameters:
     loginParam: hold the parameter for deleteContactParams,
     serviceType: Which type of service is used in network class,
     completion: completion block is being used for callback
     error: will hold the error
     return : Void
     */
    func deleteContact(deleteContactParams: DeleteContactParams, serviceType: TypeOfServiceCall, completion:@escaping(_ response: Bool?, _ error:NetworkServiceError?)->Void){
        userService.deleteContact(deleteContactParams: deleteContactParams, serviceType: serviceType) { (response, error) in
            completion(response, error);
        }
    }
    /*
     @description : Method is being used to get media ID
     Parameters:
     getMediaIdOfUser: Hold the media ID service parameters,
     serviceType: Which type of service is used in network class,
     completion: completion block is being used for callback,
     error: will hold the error if occurs
     return : Void
     */
    func getMediaID(getMediaIdOfUser: MediaIdOfParticularUser, serviceType: TypeOfServiceCall, completion:@escaping(_ response: String?, _ error:NetworkServiceError?)->Void){
        userService.getMediaID(mediaIdOfParticularUser: getMediaIdOfUser, serviceType: serviceType) { (response, error) in
            completion(response, error);
        }
    }
    
    /*
     @description : Method is being used to get contact list
     Parameters:
     getMediaIdOfUser: Hold the media ID service parameters,
     serviceType: Which type of service is used in network class,
     completion: completion block is being used for callback,
     error: will hold the error if occurs
     return : Void
     */
    func getContactID(getContactIdOfParticularUser: ContactIdOfParticularUser, serviceType: TypeOfServiceCall, completion:@escaping(_ response: NSArray?, _ error:NetworkServiceError?)->Void){
        userService.getContactID(getContactIdOfParticularUser: getContactIdOfParticularUser, serviceType: serviceType) { (response, error) in
            completion(response, error);
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
    func downloadData(id: String, completion:@escaping(_ uploadResponse: Data?, _ error:NetworkServiceError?)->Void){
        userService.downloadMedia(id: id) { (uploadResponse, error) in
            completion(uploadResponse, error);
        }
    }
    
    /// - Parameters:
    //saveMediaParameter: parameter for webservice call,
    //mediaData: data for api call,
    //uploadedMediaType: type of media,
    //nameOfFile: file name
    ///   - completion: callback
    func serviceForUploadMedia(mediaData: Data, uploadMediaType: SelectedMediaType, nameOfFile: String, saveMediaParameter: SaveMediaParameter, completion:@escaping(_ saveMediaResponse: String?, _ error:NetworkServiceError?)->Void){
        userService.callSecureServiceForUploadMedia(saveMediaParameter: saveMediaParameter, mediaData: mediaData, uploadedMediaType: uploadMediaType, fileName: nameOfFile) { (saveMediaResponse, error) in
            completion(saveMediaResponse, error)
        }
    }
    
    /*
     @description : Method is being used to cancel all the requests
     Parameters: N/A
     return : N/A
     */
    func cancelAllRequest() {
        userService.cancelAllRequest()
    }
}

