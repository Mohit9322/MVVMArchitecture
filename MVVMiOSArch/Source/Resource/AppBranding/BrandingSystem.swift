//
//  ViewController.swift
//  WatchMyBack
//
//  Created by LocatorTechnologies on 6/25/18.
//  Copyright © 2018 LocatorTechnologies. All rights reserved.
//

import UIKit
import AVFoundation

class BrandingSystem: NSObject {
	
	/* SetGlobalUIForBrand - sets any global ui elements based on the brand
    Parameters:
    tintColor: UIColor
    foregroundColor: UIColor
    fontSize: CGFloat
    return : NA
    */
    static func SetGlobalUIFor(tintColor: UIColor, foregroundColor: UIColor?, fontSize: CGFloat)
    {
        // set navigation bar properties
        UINavigationBar.appearance().barTintColor = PrimaryColor.navyBlue(alphaValue: 1.0)
        UINavigationBar.appearance().isTranslucent = false
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
        UINavigationBar.appearance().shadowImage = UIImage()
        let fontForTitle = UIFont.systemFont(ofSize: 18)
        UINavigationBar.appearance().titleTextAttributes =
            [NSAttributedString.Key.foregroundColor: UIColor.white,
             NSAttributedString.Key.font: fontForTitle]
        
        // set up the back navigation button
        UINavigationBar.appearance().backIndicatorImage = #imageLiteral(resourceName: "backButton")
        UINavigationBar.appearance().backIndicatorTransitionMaskImage = #imageLiteral(resourceName: "backButton")
        UINavigationBar.appearance().tintColor = tintColor
        var attributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: fontForTitle]
        if let foregroundColor = foregroundColor {
            attributes[.foregroundColor] = foregroundColor
        }
        UIBarButtonItem.appearance().setTitleTextAttributes(attributes, for: .normal)
        UIBarButtonItem.appearance().setTitleTextAttributes(attributes, for: .highlighted)
    }
    
    /* setMailComposerAppearance - Method for setting appearance for the mail composer
     Parameters: NA
     return : NA
     */
    static func setMailComposerAppearance() {
        UIBarButtonItem.appearance().setTitleTextAttributes(nil, for: .normal)
        UIBarButtonItem.appearance().setTitleTextAttributes(nil, for: .highlighted)
    }
 }

