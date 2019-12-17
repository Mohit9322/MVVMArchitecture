//
//  Share.swift
//  Vistana
//
//  Created by MBP02 on 10/19/17.
//  Copyright © 2017 starwoodvo. All rights reserved.
//

import Foundation
import UIKit

protocol Shareable where Self : UIViewController
{
    func openShareSheet(gestureRecognizer: UITapGestureRecognizer)
}

struct Share
{
    /*
     @description : Method is being used to share text using the sharesheet
     Parameters:
     parent : view controller in which sharesheet is appearing
     message : Message which we are going to share
     return : NA
     */
    static func shareText(parent: UIViewController, message:String)
    {
        let strToShare = [message]
        let activityViewController = UIActivityViewController(activityItems: strToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = parent.view // so that iPads won't crash
        
        // exclude some activity types from the list (optional)
        activityViewController.excludedActivityTypes = [UIActivity.ActivityType.airDrop, UIActivity.ActivityType.mail, UIActivity.ActivityType.copyToPasteboard]
        activityViewController.completionWithItemsHandler = { (activityType, completed:Bool, returnedItems:[Any]?, error: Error?) in
           
        }
        // present the view controller
        parent.present(activityViewController, animated: true, completion: nil)
        
    }
    
    
    /*
     @description : Method is being used to share text using the sharesheet
     Parameters:
     parent : view controller in which sharesheet is appearing
     title : title of the post
     description : description of the post
     url : Url which we are going to share
     return : NA
     */
    static func shareTextImage(parent: UIViewController, title: String, description: String, url: String){
        var activityViewController = UIActivityViewController(activityItems: [], applicationActivities: nil)
		activityViewController = UIActivityViewController(activityItems: [title, description , url], applicationActivities: nil)
        
        activityViewController.popoverPresentationController?.sourceView = parent.view // so that iPads won't crash
        
        // exclude some activity types from the list (optional)
        activityViewController.excludedActivityTypes = [UIActivity.ActivityType.airDrop,
                                                        UIActivity.ActivityType.copyToPasteboard,
                                                        UIActivity.ActivityType.postToFacebook,
                                                        UIActivity.ActivityType.postToTwitter,
                                                        UIActivity.ActivityType.message,
                                                        UIActivity.ActivityType.mail,
                                                        UIActivity.ActivityType.print,
                                                        UIActivity.ActivityType.postToFlickr,
                                                        UIActivity.ActivityType.postToVimeo]
        
        activityViewController.completionWithItemsHandler = { (activityType, completed:Bool, returnedItems:[Any]?, error: Error?) in
           
        }
        // present the view controller
        parent.present(activityViewController, animated: true, completion: nil)
    }
    
}
