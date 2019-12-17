//
//  DataManager.swift
//  WatchMyBack
//
//  Created by Chetu on 8/9/18.
//  Copyright © 2018 LocatorTechnologies. All rights reserved.
//

import Foundation
import Foundation
class DataManager{
    //varible for holding the degaults password
    static var password:String? {
        set {
            UserDefaults.standard.setValue(newValue, forKey: Constants.AppConstants.kPassword)
            UserDefaults.standard.synchronize()
        }
        get {
            return UserDefaults.standard.string(forKey: Constants.AppConstants.kPassword)
        }
    }
    //variable for holding the mediaID
    static var mediaID:String? {
        set {
            UserDefaults.standard.setValue(newValue, forKey: Constants.AppConstants.kMediaID)
            UserDefaults.standard.synchronize()
        }
        get {
            return UserDefaults.standard.string(forKey: Constants.AppConstants.kMediaID)
        }
    }
    //variable for username holding the username
    static var userName:String? {
        set {
            UserDefaults.standard.setValue(newValue, forKey: Constants.AppConstants.kUsername)
            UserDefaults.standard.synchronize()
        }
        get {
            return UserDefaults.standard.string(forKey: Constants.AppConstants.kUsername)
        }
    }
    //variable for holding the email
    static var email:String? {
        set {
            UserDefaults.standard.setValue(newValue, forKey: Constants.AppConstants.kEmail)
            UserDefaults.standard.synchronize()
        }
        get {
            return UserDefaults.standard.string(forKey: Constants.AppConstants.kEmail)
        }
    }
    //variable for holding the state of login
    static var isLogin: Bool?{
        set{
           UserDefaults.standard.setValue(newValue, forKey: Constants.AppConstants.kIsUserLoggedIn)
           UserDefaults.standard.synchronize()
        }
        get{
            return UserDefaults.standard.bool(forKey: Constants.AppConstants.kIsUserLoggedIn)
        }
    }
    
    //method is being used to deled all app persistant data
    static func clearAllPersistantData() {
        if let domain = Bundle.main.bundleIdentifier {
            UserDefaults.standard.removePersistentDomain(forName: domain)
            UserDefaults.standard.synchronize()
        }
    }
}

