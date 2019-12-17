//
//  MediaUploadViewModel.swift
//  WatchMyBack
//
//  Created by Chetu on 8/13/18.
//  Copyright © 2018 LocatorTechnologies. All rights reserved.
//

import Foundation
import Alamofire

open class MediaUploadViewModel {
    public init(){}
    
    
    /// - Parameters:
    //saveMediaParameter: parameter for webservice call,
    //mediaData: data for api call,
    //uploadedMediaType: type of media,
    //fileName: file name
    ///   - completion: callback
    func callSecureServiceForUploadMedia(saveMediaParameter: SaveMediaParameter, mediaData: Data, uploadedMediaType: SelectedMediaType, fileName: String, completionHandler:@escaping(_ registerationResponse: String?, _ error: NetworkServiceError?)->Void){
    
        ApplicationState.sharedAppState.appDataStore.serviceForUploadMedia(mediaData: mediaData, uploadMediaType: uploadedMediaType, nameOfFile: fileName, saveMediaParameter: saveMediaParameter) { (registerResponse, error) in
            completionHandler(registerResponse, error)
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
    func downloadMedia(id: String, completionHandler:@escaping(_ downloadResponse: Data?, _ error: NetworkServiceError?)->Void) {
        ApplicationState.sharedAppState.appDataStore.downloadData(id: id) { (downloadResponse, error) in
            completionHandler(downloadResponse, error)
        }
    }
    
    /*
     @description : Method is being used to cancel all the requests
     Parameters: N/A
     return : N/A
     */
    func cancelAllRequest(){
        ApplicationState.sharedAppState.appDataStore.cancelAllRequest()
    }
}
