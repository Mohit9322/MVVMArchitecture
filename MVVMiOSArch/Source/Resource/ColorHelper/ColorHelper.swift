//
//  ViewController.swift
//  WatchMyBack
//
//  Created by LocatorTechnologies on 6/25/18.
//  Copyright © 2018 LocatorTechnologies. All rights reserved.
//

import Foundation
import UIKit

struct PrimaryColor {
    
    /* navyBlue - managing the color on the User Interface
     Parameters:
     alphaValue: CGFloat
     return : UIColor
     */
    static func navyBlue(alphaValue: CGFloat) -> UIColor {
        return UIColor(red: 0/255.0, green: 102.0/255.0, blue: 132.0/255.0, alpha: CGFloat(alphaValue))
    }
    
    /* Red - managing the color on the User Interface
     Parameters:
     alphaValue: CGFloat
     return : UIColor
     */
    static func red(alphaValue: CGFloat) -> UIColor {
        return UIColor(red: 235/255.0, green: 74.0/255.0, blue: 71.0/255.0, alpha: CGFloat(alphaValue))
    }
    /* Dark Gray - managing the color on the User Interface
     Parameters:
     alphaValue: CGFloat
     return : UIColor
     */
    static func darkGray(alphaValue: CGFloat) -> UIColor {
        return UIColor(red: 169.0/255.0, green: 169.0/255.0, blue: 169.0/255.0, alpha: CGFloat(alphaValue))
    }
}



