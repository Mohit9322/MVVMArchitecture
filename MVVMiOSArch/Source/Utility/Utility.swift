//
//  ViewController.swift
//  WatchMyBack
//
//  Created by LocatorTechnologies on 6/25/18.
//  Copyright © 2018 LocatorTechnologies. All rights reserved.
//

import UIKit
import AVFoundation
enum TypeOfServiceCall {
    case login
    case registration
    case forgotPassword
    case getMediaIdForParticularUser
    case getcontactIdForParticalUser
    case addContact
    case updateContact
    case deleteContact
}
class Utility: NSObject {
    
    /// Date Format type
    enum DateFormatType: String {
        case time = "HH:mm:ss"
        
        case dateWithTime = "yyyy-MM-dd HH-mm-ss"
        
        case dateWithTimeZone = "yyyy-MM-dd HH-mm-ss ZZZ"
        
        case new = "EEE MMM dd HH:mm:ss zzz yyyy"
//        Fri Oct 26 20:01:23 PDT 2018
        case date = "dd-MMM-yyyy"
    }
    
    static  func isNetworkReachable() -> Bool {
        return Constants.reachabilityManager?.isReachable ?? false
    }
    
    /**
     This is class method used to get current date
     - Parameters: N/A
     - Returns: String
     */
    static func getCurrentDate() -> String {
        let date = Date()
        let formatter = DateFormatter()

        formatter.dateFormat = DateFormatType.new.rawValue
        let dateInString = formatter.string(from: date)
//        dateInString = "Fri Oct 26 20:01:23 PDT 2018"
        return dateInString
    }
    
    /**
     This is class method used to set Localizable key value
     - Parameters:
     - key: stirng key which is declare in localization file
     - Returns: return localization string
     */
    static  func localized(key:String) ->String {
        let bundle = Bundle.main
        return bundle.localizedString(forKey: key, value: "", table: nil)
    }
    
  
    /**
     This is class method used to present the alert conroller
     - Parameters:
     title: alert title,
     message: Message which will appear on alert,
     actionTitleFirst: first button title,
     actionTitleSecond: second button title,
     firstActoin: action to be performed using first button,
     secondAction: action to be performed using second button,
     controller: in which controller alert will present
     - Returns: N/A
     */
    static func alertContoller(title: String, message: String, actionTitleFirst: String, actionTitleSecond: String, firstActoin: Selector?, secondAction: Selector?,  controller: UIViewController?) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert) // 1
        guard let controller = controller else {
            return
        }
        
        if(!actionTitleFirst.isEmpty) {
            
            let firstButtonAction = UIAlertAction(title: actionTitleFirst, style: .default) { (alert: UIAlertAction!) -> Void in
                if(firstActoin != nil){
                    controller.perform(firstActoin!)
                }
            }
            
            alert.addAction(firstButtonAction)
        }
        if(!actionTitleSecond.isEmpty) {
            let secondAction = UIAlertAction(title: actionTitleSecond, style: .default) { (alert: UIAlertAction!) -> Void in
                if(secondAction != nil){
                    controller.perform(secondAction!)
                }
            }
            alert.addAction(secondAction)
        }
        
        
        controller.present(alert, animated: true, completion:nil)
    }
    
    /*
     @description : Method is being used to get thumbnail image
     Parameters: NA
     filepath: Url of source video
     return : NA
     */
    static func generateThumbImage(_ filepath: URL, controller: UIViewController?) -> UIImage {
        do {
            let asset = AVURLAsset(url: filepath , options: nil)
            let imgGenerator = AVAssetImageGenerator(asset: asset)
            imgGenerator.appliesPreferredTrackTransform = true
            let cgImage = try imgGenerator.copyCGImage(at: CMTimeMake(value: 0, timescale: 1), actualTime: nil)
            let thumbnail = UIImage(cgImage: cgImage)
            return thumbnail
        } catch let error {
            Utility.alertContoller(title:Utility.localized(key: "kMessage"),
                                   message: (error.localizedDescription),
                                   actionTitleFirst: "",
                                   actionTitleSecond: Utility.localized(key: "kOk"),
                                   firstActoin: nil,
                                   secondAction: nil,
                                   controller: controller ?? UIViewController())
            return UIImage()
        }
    }
    
    /*
     @description : Method is being used to provide video recorded time in proper format
     Parameters: NA
     time: is holding the refrence of TimeInterval
     return : String
     */
    static func timeString(time: TimeInterval) -> String {
        let hours = Int(time) / 3600
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        return String(format:"%02i:%02i:%02i", hours, minutes, seconds)
    }
    
    /*
     @description : Method is being used to provide video recorded time in proper format
     Parameters: NA
     time: is holding the refrence of TimeInterval
     return : String
     */
    static func managePhotoOrientation() -> AVCaptureVideoOrientation {
        var currentDevice: UIDevice
        currentDevice = .current
        UIDevice.current.beginGeneratingDeviceOrientationNotifications()
        var deviceOrientation: UIDeviceOrientation
        deviceOrientation = currentDevice.orientation
        var imageOrientation: AVCaptureVideoOrientation!
        if deviceOrientation == .portrait {
            imageOrientation = AVCaptureVideoOrientation.portrait
        }else if (deviceOrientation == .landscapeLeft){
            imageOrientation = AVCaptureVideoOrientation.landscapeRight
        }else if (deviceOrientation == .landscapeRight){
            imageOrientation = AVCaptureVideoOrientation.landscapeLeft
        }else if (deviceOrientation == .portraitUpsideDown){
            imageOrientation = AVCaptureVideoOrientation.portraitUpsideDown
        }else{
            imageOrientation = AVCaptureVideoOrientation.portrait
        }
        return imageOrientation
    }
    
    /*
     @description : Method is being used to generate SHA
     Parameters:
     data: data is being used to get data of media file
     return : Data
     */
//    static func sha256(data : Data) -> Data {
//        var hash = [UInt8](repeating: 0,  count: Int(CC_SHA256_DIGEST_LENGTH))
//        data.withUnsafeBytes {
//            _ = CC_SHA256($0, CC_LONG(data.count), &hash)
//        }
     //   return Data(bytes: hash)
//    }
    
    
    static func checkForAccessibilityOfCamera(viewController: UIViewController) -> Bool{
        let authStatus = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
        if authStatus == AVAuthorizationStatus.denied || authStatus == AVAuthorizationStatus.notDetermined {
            // Denied access to camera
            // Explain that we need camera access and how to change it.
            Utility.alertContoller(title: Utility.localized(key: "kMessage"),
                                   message: Utility.localized(key: "kAccessCameraFromSetting"),
                                   actionTitleFirst: Utility.localized(key: "kOk"),
                                   actionTitleSecond: "",
                                   firstActoin: nil, secondAction: nil,
                                   controller: viewController)
            return false
        } else {
            return true
        }
    }
    
    static func createDictionaryToSaveContactLocally(name: String, phone : String, email : String, id: String)->NSDictionary{
        let contactD : NSDictionary
        contactD = ["name": name, "email": email , "id": id, "phone": phone]
        return contactD
    }
}

struct AppUtility {
    /*
     @description : Class Method is being used to manage the orientation of screen in particular screen
     Parameters: NA
     orientation: is being used to hold the orientation refrence
     return : N/A
     */
    static func lockOrientation(_ orientation: UIInterfaceOrientationMask) {
        if let delegate = UIApplication.shared.delegate as? AppDelegate {
        //    delegate.orientationLock = orientation
        }
    }
    
    /*
     @description : Class Method is being used to manage the orientation of screen in particular screen
     Parameters: NA
     orientation: is being used to hold the orientation refrence
     return : N/A
     */
    static func lockOrientation(_ orientation: UIInterfaceOrientationMask, andRotateTo rotateOrientation:UIInterfaceOrientation) {
        self.lockOrientation(orientation)
        UIDevice.current.setValue(rotateOrientation.rawValue, forKey: "orientation")
    }
    
    
    
}
