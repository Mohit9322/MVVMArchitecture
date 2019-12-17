//
//  ViewController.swift
//  WatchMyBack
//
//  Created by LocatorTechnologies on 6/25/18.
//  Copyright © 2018 LocatorTechnologies. All rights reserved.
//

import Foundation
import UIKit

extension UIButton{
    
    /*
     @description : Method is being used to set the button UI
     Parameters:
     title: title to be shown in button
     FontSize: font size for the text
     cornerRadius: corner radius to be applied into the button
     backgroundColor: background color of button
     return : NA
     */
    func setButtonProperty(title: String, FontSize: Int, cornerRadius: Float, backgroundColor: UIColor) {
        self.setTitle(title, for: .normal)
        self.setTitleColor(UIColor.white, for: UIControl.State.normal)
        self.titleLabel?.font = UIFont.systemFont(ofSize: CGFloat(FontSize))
        self.layer.cornerRadius = self.frame.size.height/2
        self.layer.borderColor = UIColor.white.cgColor
        self.layer.borderWidth = 2.0
        self.clipsToBounds = true
        self.backgroundColor = backgroundColor
    }

    /*
     @description : Method is being used to set the bar button
     Parameters: NA
     return : NA
     */
    func setBarButton(){
        self.frame =  CGRect(origin: CGPoint(x: 0,y :0), size: CGSize(width: 50, height: 30))
        self.setTitle(Utility.localized(key: "kSelect"), for: .normal)
        self.titleLabel?.font = UIFont.boldSystemFont(ofSize: 12)
        self.setTitleColor(UIColor.white, for: UIControl.State.normal)
    }
}
