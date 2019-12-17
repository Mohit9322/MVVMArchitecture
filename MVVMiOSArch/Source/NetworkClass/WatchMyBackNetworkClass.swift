//
//  WatchMyBackNetworkClass.swift
//  WatchMyBack
//
//  Created by Chetu on 8/9/18.
//  Copyright © 2018 LocatorTechnologies. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class WatchMyBackNetworkClass
{
    let manager = Alamofire.SessionManager.default
    
    init() {
        manager.session.configuration.timeoutIntervalForRequest = 600
    }
    
    //structure is being used to manage error model
    struct ErrorInfo {
        var errorMessage : String
        var errorType : String?
    }
    
    /*
     @description : Method is being used to call API
     Parameters:
     url: Web service url,
     imageData: Image data,
     uploadedMediaType: type of media,
     params: Parameter for webservice call,
     fileName: file name
     return : NA
     */
    func callSecureServiceForUploadMedia(_ url: String, imageData: Data?, uploadedMediaType: SelectedMediaType, params:Parameters?, fileName: String, completionHandler:@escaping(_ jsonData : String?, _ error: NetworkServiceError?)->Void)
    {
        debugPrint(fileName)
        debugPrint(url)
       
        let headers : HTTPHeaders = [ "Content-Type": "multipart/form-data"
                                    ];
        _ = manager.upload(multipartFormData: { (multipartFormData) in
            //let dictionary: [String: Any] = ["email":"newuser@test.com", "password":"UUExMjM0NTY="]
            do{
                let dataParameters = try JSONSerialization.data(withJSONObject: params ?? ["":""], options: JSONSerialization.WritingOptions(rawValue: 0))
                multipartFormData.append(dataParameters, withName: "data")
            }catch{
                debugPrint("error occured")
            }
            
            let mediaCreationTime: String! = fileName.components(separatedBy: "/").last
            if uploadedMediaType == .photo && imageData != nil{
                multipartFormData.append(imageData!, withName: "file-data", fileName: "\(mediaCreationTime)WatchMyBack.jpg", mimeType: "image/jpg")
            }else if uploadedMediaType == .video{//for video
                multipartFormData.append(imageData!, withName: "file-data", fileName: "\(mediaCreationTime)WatchMyBack.mp4", mimeType: "video/mp4")
            }
        }, to:url, method:.post, headers: headers)
        { (result) in
            switch result {
            case .success(let upload, _, _):
                upload.uploadProgress(closure: { (Progress) in
                    print("Upload Progress: \(Progress.fractionCompleted)")
                })
                

                upload.responseJSON { response in
                    let json : JSON = JSON(response.value ?? "[]");
                    //if request cancel then handle from here
                    if response.result.error?.localizedDescription == Constants.kCancelError {
                        let errorInfo : ErrorInfo = ErrorInfo(errorMessage: Constants.kCancelByUser, errorType: Constants.kCancelError)
                        completionHandler(nil, NetworkServiceError.cancelled(errorInfo.errorMessage))
                        return
                    }
                    
                    guard response.error == nil else{
                        let errorInfo : ErrorInfo = ErrorInfo(errorMessage: Constants.kSomethingWentWrong, errorType: Constants.kServerError)
                        completionHandler(nil, NetworkServiceError.generic(errorInfo.errorMessage))
                        return
                    }
                    
                    //success case
                    if json.rawString() != nil {
                        if let dict = self.convertToDictionary(text: json.rawString()!) {
                            if let mediaId = dict["mediaId"] as? String{
                                //Sccess is media id
                                completionHandler(String(mediaId), nil)
                            }else {
                                let errorInfo : ErrorInfo = ErrorInfo(errorMessage: (dict["error"] as? String) ?? "", errorType: Constants.kServerError)
                                completionHandler(nil, NetworkServiceError.generic(errorInfo.errorMessage))
                            }
                        }
                        return
                    } else {
                        let errorInfo : ErrorInfo = ErrorInfo(errorMessage: Constants.kSomethingWentWrong, errorType: Constants.kServerError)
                        completionHandler(nil, NetworkServiceError.generic(errorInfo.errorMessage))
                        return
                    }
                }
            case .failure(let encodingError):
                //self.delegate?.showFailAlert()
                completionHandler(nil, NetworkServiceError.generic(encodingError as! String))
            }
            
        }
    }
    
    /// callGetContactService
    ///
    /// - parameter url:               url to call
    /// - parameter params:            any parameters the call needs
    /// - parameter completionHandler: handler triggered with json or error upon load
    func callSecureServiceGetContacts(_ url:String, params: Parameters?, serviceType: TypeOfServiceCall, type:HTTPMethod, completionHandler:@escaping(_ jsonData: NSArray?, _ error: NetworkServiceError?)->Void)
    {
        var request = URLRequest(url: URL(string: url)!, cachePolicy: URLRequest.CachePolicy.reloadIgnoringCacheData , timeoutInterval: 15)
        request.setValue(Constants.contentTypeParameter, forHTTPHeaderField: Constants.contentType)
        request.setValue(Constants.contentTypeParameter, forHTTPHeaderField: Constants.contentAccept)
        request.httpMethod = type.rawValue
        if type == .post {
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: params!, options: .prettyPrinted)
            }catch{
                debugPrint("error occured")
            }
        }
        Alamofire.request(request)
            .responseString { response in
                let json : JSON = JSON(response.value ?? "[]");
                guard response.error == nil else{
                    let errorInfo : ErrorInfo = ErrorInfo(errorMessage: Constants.kSomethingWentWrong, errorType: Constants.kServerError)
                    completionHandler(nil, NetworkServiceError.generic(errorInfo.errorMessage))
                    return
                }
                
                
                
                
                //    else if serviceType == .getcontactIdForParticalUser {
                
                if json.rawString() != nil {
                    if let dict = self.convertToDictionary(text: json.rawString()!) {
                        if let success = dict["contacts"] {
                            completionHandler(success as? NSArray, nil)
                        }else {
                            let errorInfo : ErrorInfo = ErrorInfo(errorMessage: (dict["error"] as? String) ?? "", errorType: Constants.kServerError)
                            completionHandler(nil, NetworkServiceError.generic(errorInfo.errorMessage))
                        }
                    }else {
                        let errorInfo : ErrorInfo = ErrorInfo(errorMessage: Utility.localized(key: "kInternalServerError"), errorType: Constants.kServerError)
                        completionHandler(nil, NetworkServiceError.generic(errorInfo.errorMessage))
                    }
                    return
                } else {
                    let errorInfo : ErrorInfo = ErrorInfo(errorMessage: Constants.kSomethingWentWrong, errorType: Constants.kServerError)
                    completionHandler(nil, NetworkServiceError.generic(errorInfo.errorMessage))
                    return
                }
                
                //    }
        }
    }
    func callSecureServiceEditContacts(_ url:String, params: Parameters?, serviceType: TypeOfServiceCall, type:HTTPMethod, completionHandler:@escaping(_ jsonData: Bool?, _ error: NetworkServiceError?)->Void){
    var request = URLRequest(url: URL(string: url)!, cachePolicy: URLRequest.CachePolicy.reloadIgnoringCacheData , timeoutInterval: 15)
    request.setValue(Constants.contentTypeParameter, forHTTPHeaderField: Constants.contentType)
    request.setValue(Constants.contentTypeParameter, forHTTPHeaderField: Constants.contentAccept)
    request.httpMethod = type.rawValue
    if type == .post {
    do {
    request.httpBody = try JSONSerialization.data(withJSONObject: params!, options: .prettyPrinted)
    }catch{
    debugPrint("error occured")
    }
    }
    Alamofire.request(request)
    .responseString { response in
    let json : JSON = JSON(response.value ?? "[]");
    guard response.error == nil else{
    let errorInfo : ErrorInfo = ErrorInfo(errorMessage: Constants.kSomethingWentWrong, errorType: Constants.kServerError)
    completionHandler(nil, NetworkServiceError.generic(errorInfo.errorMessage))
    return
    }
    
    
    
    
    //    else if serviceType == .getcontactIdForParticalUser {
    
    if json.rawString() != nil {
    if let dict = self.convertToDictionary(text: json.rawString()!) {
    if let success = dict["success"] {
    completionHandler(success as? Bool, nil)
    }else {
    let errorInfo : ErrorInfo = ErrorInfo(errorMessage: (dict["error"] as? String) ?? "", errorType: Constants.kServerError)
    completionHandler(nil, NetworkServiceError.generic(errorInfo.errorMessage))
    }
    }else {
    let errorInfo : ErrorInfo = ErrorInfo(errorMessage: Utility.localized(key: "kInternalServerError"), errorType: Constants.kServerError)
    completionHandler(nil, NetworkServiceError.generic(errorInfo.errorMessage))
    }
    return
    } else {
    let errorInfo : ErrorInfo = ErrorInfo(errorMessage: Constants.kSomethingWentWrong, errorType: Constants.kServerError)
    completionHandler(nil, NetworkServiceError.generic(errorInfo.errorMessage))
    return
    }
    
    //    }
    }
    }
    /// callService
    ///
    /// - parameter url:               url to call
    /// - parameter params:            any parameters the call needs
    /// - parameter completionHandler: handler triggered with json or error upon load
    func callSecureService(_ url:String, params: Parameters?, serviceType: TypeOfServiceCall, type:HTTPMethod, completionHandler:@escaping(_ jsonData: String?, _ error: NetworkServiceError?)->Void)
    {
        var request = URLRequest(url: URL(string: url)!, cachePolicy: URLRequest.CachePolicy.reloadIgnoringCacheData , timeoutInterval: 15)
        request.setValue(Constants.contentTypeParameter, forHTTPHeaderField: Constants.contentType)
        request.setValue(Constants.contentTypeParameter, forHTTPHeaderField: Constants.contentAccept)
        request.httpMethod = type.rawValue
        if type == .post {
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: params!, options: .prettyPrinted)
            }catch{
                debugPrint("error occured")
            }
        }
        Alamofire.request(request)
            .responseString { response in
                let json : JSON = JSON(response.value ?? "[]");
                guard response.error == nil else{
                    let errorInfo : ErrorInfo = ErrorInfo(errorMessage: Constants.kSomethingWentWrong, errorType: Constants.kServerError)
                    completionHandler(nil, NetworkServiceError.generic(errorInfo.errorMessage))
                    return
                }
                
                
                if serviceType == .registration {
                    if json.rawString() != nil {
                        if let dict = self.convertToDictionary(text: json.rawString()!) {
                            if let success = dict["success"] {
                                completionHandler(success as? String, nil)
                            }else {
                                let errorInfo : ErrorInfo = ErrorInfo(errorMessage: (dict["error"] as? String) ?? "", errorType: Constants.kServerError)
                                completionHandler(nil, NetworkServiceError.generic(errorInfo.errorMessage))
                            }
                        }else {
                            let errorInfo : ErrorInfo = ErrorInfo(errorMessage: Utility.localized(key: "kInternalServerError"), errorType: Constants.kServerError)
                            completionHandler(nil, NetworkServiceError.generic(errorInfo.errorMessage))
                        }
                        return
                    } else {
                        let errorInfo : ErrorInfo = ErrorInfo(errorMessage: Constants.kSomethingWentWrong, errorType: Constants.kServerError)
                        completionHandler(nil, NetworkServiceError.generic(errorInfo.errorMessage))
                        return
                    }
                } else if serviceType == .login {
                    if json.rawString() != nil {
                        if let dict = self.convertToDictionary(text: json.rawString()!) {
                            if let success = dict["success"] {
                                completionHandler(success as? String, nil)
                            }else {
                                let errorInfo : ErrorInfo = ErrorInfo(errorMessage: (dict["error"] as? String) ?? "", errorType: Constants.kServerError)
                                completionHandler(nil, NetworkServiceError.generic(errorInfo.errorMessage))
                            }
                        }else {
                            let errorInfo : ErrorInfo = ErrorInfo(errorMessage: Utility.localized(key: "kInternalServerError"), errorType: Constants.kServerError)
                            completionHandler(nil, NetworkServiceError.generic(errorInfo.errorMessage))
                        }
                        return
                    } else {
                        let errorInfo : ErrorInfo = ErrorInfo(errorMessage: Constants.kSomethingWentWrong, errorType: Constants.kServerError)
                        completionHandler(nil, NetworkServiceError.generic(errorInfo.errorMessage))
                        return
                    }
                } else if serviceType == .forgotPassword {
                    
                    if json.rawString() != nil {
                        if let dict = self.convertToDictionary(text: json.rawString()!) {
                            if let success = dict["success"] {
                                completionHandler(success as? String, nil)
                            }else {
                                let errorInfo : ErrorInfo = ErrorInfo(errorMessage: (dict["error"] as? String) ?? "", errorType: Constants.kServerError)
                                completionHandler(nil, NetworkServiceError.generic(errorInfo.errorMessage))
                            }
                        }else {
                            let errorInfo : ErrorInfo = ErrorInfo(errorMessage: Utility.localized(key: "kInternalServerError"), errorType: Constants.kServerError)
                            completionHandler(nil, NetworkServiceError.generic(errorInfo.errorMessage))
                        }
                        return
                    } else {
                        let errorInfo : ErrorInfo = ErrorInfo(errorMessage: Constants.kSomethingWentWrong, errorType: Constants.kServerError)
                        completionHandler(nil, NetworkServiceError.generic(errorInfo.errorMessage))
                        return
                    }
                    
                } else if serviceType == .getMediaIdForParticularUser {
                    
                    if json.rawString() != nil {
                        if let dict = self.convertToDictionary(text: json.rawString()!) {
                            if let success = dict["mediaIdList"] {
                                completionHandler(success as? String, nil)
                            }else {
                                let errorInfo : ErrorInfo = ErrorInfo(errorMessage: (dict["error"] as? String) ?? "", errorType: Constants.kServerError)
                                completionHandler(nil, NetworkServiceError.generic(errorInfo.errorMessage))
                            }
                        }else {
                            let errorInfo : ErrorInfo = ErrorInfo(errorMessage: Utility.localized(key: "kInternalServerError"), errorType: Constants.kServerError)
                            completionHandler(nil, NetworkServiceError.generic(errorInfo.errorMessage))
                        }
                        return
                    } else {
                        let errorInfo : ErrorInfo = ErrorInfo(errorMessage: Constants.kSomethingWentWrong, errorType: Constants.kServerError)
                        completionHandler(nil, NetworkServiceError.generic(errorInfo.errorMessage))
                        return
                    }
                    
                }
                
                else if serviceType == .addContact {
                    
                    if json.rawString() != nil {
                        if let dict = self.convertToDictionary(text: json.rawString()!) {
                            if let success = dict["contactId"] {
                                completionHandler(success as? String, nil)
                            }else {
                                let errorInfo : ErrorInfo = ErrorInfo(errorMessage: (dict["error"] as? String) ?? "", errorType: Constants.kServerError)
                                completionHandler(nil, NetworkServiceError.generic(errorInfo.errorMessage))
                            }
                        }else {
                            let errorInfo : ErrorInfo = ErrorInfo(errorMessage: Utility.localized(key: "kInternalServerError"), errorType: Constants.kServerError)
                            completionHandler(nil, NetworkServiceError.generic(errorInfo.errorMessage))
                        }
                        return
                    } else {
                        let errorInfo : ErrorInfo = ErrorInfo(errorMessage: Constants.kSomethingWentWrong, errorType: Constants.kServerError)
                        completionHandler(nil, NetworkServiceError.generic(errorInfo.errorMessage))
                        return
                    }
                    
                }
                else if serviceType == .updateContact{
                    
                    if json.rawString() != nil {
                        if let dict = self.convertToDictionary(text: json.rawString()!) {
                            if let success = dict["success"] {
                                completionHandler(success as? String, nil)
                            }else {
                                let errorInfo : ErrorInfo = ErrorInfo(errorMessage: (dict["error"] as? String) ?? "", errorType: Constants.kServerError)
                                completionHandler(nil, NetworkServiceError.generic(errorInfo.errorMessage))
                            }
                        }else {
                            let errorInfo : ErrorInfo = ErrorInfo(errorMessage: Utility.localized(key: "kInternalServerError"), errorType: Constants.kServerError)
                            completionHandler(nil, NetworkServiceError.generic(errorInfo.errorMessage))
                        }
                        return
                    } else {
                        let errorInfo : ErrorInfo = ErrorInfo(errorMessage: Constants.kSomethingWentWrong, errorType: Constants.kServerError)
                        completionHandler(nil, NetworkServiceError.generic(errorInfo.errorMessage))
                        return
                    }
                    
                }
        }
    }
    
    /*
     @description : Method is being used to cancel all the requests
     Parameters: N/A
     return : N/A
     */
    func cancelAllRequest(){
        manager.session.getTasksWithCompletionHandler { dataTasks, uploadTasks, downloadTasks in
            //dataTasks.forEach { $0.cancel() }
            uploadTasks.forEach { $0.cancel() }
            //downloadTasks.forEach { $0.cancel() }
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
    func callSecureServiceForDownLoad(_ url:String, params: Parameters?, type:HTTPMethod, completionHandler:@escaping(_ data: Data?, _ error: NetworkServiceError?)->Void)
    {
        DispatchQueue.global(qos: .background).async {
            do
            {
                let data: Data? = try Data.init(contentsOf: URL.init(string:url)!)
                DispatchQueue.main.async {
                    if let data = data{
                         completionHandler(data, nil)
                    } else {
                         let errorInfo : ErrorInfo = ErrorInfo(errorMessage: "Error", errorType: Constants.kServerError)
                         completionHandler(nil, NetworkServiceError.generic(errorInfo.errorMessage))
                    }
                }
            }
            catch {
                let errorInfo : ErrorInfo = ErrorInfo(errorMessage: "Error", errorType: Constants.kServerError)
                completionHandler(nil, NetworkServiceError.generic(errorInfo.errorMessage))
            }
        }
    }
}

extension WatchMyBackNetworkClass {
    /*
     @description : Converting json to Dictionary
     Parameters:
     text: It is type of String,
     return : Dictionary
     */
    func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
}
