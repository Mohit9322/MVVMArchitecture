//
//  ViewController.swift
//  WatchMyBack
//
//  Created by LocatorTechnologies on 6/25/18.
//  Copyright © 2018 LocatorTechnologies. All rights reserved.
//
import Foundation
import CoreGraphics
import Alamofire
struct Constants
{
    //Common constants
    //static let reachabilityManager = Alamofire.NetworkReachabilityManager(host: "www.apple.com")
    static let kMediaMetaDataStorage = "MetaDataStorage"
    static let kselfMatch  = "SELF MATCHES"
    static let kwatchMyBack = "WatchMyBack"
    static let kPublicImage = "public.image"
    static let kPublicMovie = "public.movie"
    static let kImageVideoStorage = "MediaStorage"
    static let kArchive = "archiveStorage"
    static let kVideoStorage = "videoStorage"
    static let kLocalFileFormat = "file://"
    static let kJpg = ".jpg"
    static let kMp4 = ".mp4"
    static let kOperationStopped = "Operation Stopped"
    static let kSelect = "SELECT"
    static let kCancel = "CANCEL"
    static let kimagejpg = "image/jpg"
    static let kvideomp4 = "video/mp4"
    static let reachabilityManager = Alamofire.NetworkReachabilityManager(host: "www.apple.com")
//    static let baseURL = "http://64.93.69.46:8080/wmbserver/api/";
//    static let urlForDownloadImage = "http://64.93.69.46:8080/wmbserver/api/thumbnail160/"
//    static let urlForThumbnailImage = "http://64.93.69.46:8080/wmbserver/api/displayMedia/"
    static let baseURL = "https://watchmyback.org/wmbserver/api/";
    static let urlForDownloadImage = "https://watchmyback.org/wmbserver/api/thumbnail160/"
    static let urlForThumbnailImage = "https://watchmyback.org/wmbserver/api/displayMedia/"
    static let contentType = "Content-Type"
    static let contentTypeParameter = "application/json"
    static let contentAccept = "accept"
    static let kSomethingWentWrong = "Something went wrong"
    static let kServerError = "Server error"
    static let kCancelByUser = "Cancelled by user."
    static let kCancelError = "cancelled"
    static let kMediaUploaded = "Media has been uploaded."
    
    //Service string
    struct ServicesStrings {
        // device auth service
        static let registerSvc : String = baseURL + "register";
        static let saveMedia : String = baseURL + "saveMedia";
        static let downloadMedia : String = baseURL + "displayPhoto/";
        static let forgotPassword: String = baseURL + "forgotPassword"
        static let userLogIn: String = baseURL + "login"
        static let getContacts: String = baseURL + "getContacts"
        static let addContacts: String = baseURL + "addContact"
        static let updateContacts: String = baseURL + "updateContact"
        static let deleteContact: String = baseURL + "deleteContact"

    }
    
    // errors
    struct ServiceErrorMsg {
        static let errorMsg_Generic = "Error";
        static let errorMsg_Unauthorized = "Unauthorized";
        static let errorMsg_BadRequest = "Bad Request";
        static let errorMsg_Unavailable = "Unavailable";
        static let errorMsg_InvalidFormat = "Oops! Something went wrong.\nPlease try again later.";
        static let errorMsg_NoDataReturned = "Cannot load screen. Please pull down to refresh."
        static let errorMsg_InvalidToken = "Sorry, your session has expired."
        static let errorMsg_SomethingWrong = "Oops! Something went wrong.\nPlease try again later."
        static let errorMsg_NoDataReturned_NoPullToRefresh = "There was a problem loading this. Please try again later."
    }
    
    //screen size height constants
    struct screenSizeHeight {
        static let iPhoneSmall: CGFloat = 568.0
        static let iPhoneRegular: CGFloat = 667.0
        static let iPhonePlus: CGFloat = 736.0
        static let iPhoneX : CGFloat = 812.0
    }
    
    //cell identifiers
    struct CellIdentifiers {
        static let kPreviewCollectionCell = "PreviewCollectionCell"
        static let kPhotoVideoCollectionViewCell = "PhotoVideoCollectionViewCell"
        static let kConatctTableViewCell = "ConatctTableViewCell"
    }
    
    //ViewController identifiers
    struct  ViewControllerIdentiFiers {
        static let kLoginViewController = "LoginViewController"
        static let kForgotPasswordViewController = "ForgotPasswordViewController"
        static let kRegisterViewController = "RegisterViewController"
        static let kHomeViewController = "HomeViewController"
        static let kPreviewViewController = "PreviewViewController"
        static let kVideoPreviewController = "VideoPreviewController"
        static let kImageCaptureViewController = "ImageCaptureViewController"
        static let kVideoRecordViewController = "VideoRecordViewController"
        static let kPhotoVideoPreviewController = "PhotoVideoPreviewController"
        static let kPhotoVideoCollectionViewController = "PhotoVideoCollectionViewController"
        static let kDownloadPreviewViewController = "DownloadPreviewViewController"
        static let kShareMediaThumbnailPreviewController = "ShareMediaThumbnailPreviewController"
        static let kArchivedMediaFilesViewController = "ArchivedMediaFilesViewController"
        static let kAddContactViewController = "AddContactViewController"
        static let kViewContactViewController = "ViewContactViewController"
        
    }
    
    //Storyboard identifiers
    struct  StoryBoardIdentifiers {
        static let kStoryboardMain = "Base"
    }
    
    //Character set constants
    struct CharacterSetForValidation {
        static let characterSet = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
        static let emailCharacterSet = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
    }
    
    struct AppConstants {
        static let kPassword = "PASSWORD"
        static let kMediaID = "MEDIAID"
        static let kUsername = "USERNAME"
        static let kEmail = "EMAIL"
        static let kIsUserLoggedIn = "USER_LOGGED_IN"
    }
}
