//
//  ViewController.swift
//  WatchMyBack
//
//  Created by LocatorTechnologies on 6/25/18.
//  Copyright © 2018 LocatorTechnologies. All rights reserved.
//

import Foundation
import UIKit

extension UITextField{
    /*
     @description : Method is being used to set the placeholder color of the current text field
     Parameters:
     text: text in which property will apply 
     color: color to be apply on string
     return : NA
     */
    func setTextFieldPlaceHolderColor(text: String, color: UIColor) {
        self.attributedPlaceholder = NSAttributedString(string: text,
                                                        attributes: [NSAttributedString.Key.foregroundColor: color])
    }
    
    //Variable is being used to check the whether mail is valid or not
    var isValidEmail: Bool {
        let emailRegEx = Constants.CharacterSetForValidation.emailCharacterSet
        let emailTest = NSPredicate(format:"\(Constants.kselfMatch) %@", emailRegEx)
        return emailTest.evaluate(with: self.text!)
    }
    
    //Variable to check whether password is valid or not
    var isValidPassword: Bool {
        let decimalCharacters = CharacterSet.decimalDigits
        let decimalRange = self.text?.rangeOfCharacter(from: decimalCharacters)
        let characterset = CharacterSet(charactersIn: Constants.CharacterSetForValidation.characterSet)
        let characterRange = self.text?.rangeOfCharacter(from: characterset)
        if decimalRange != nil && characterRange != nil {
            return true
        } else {
            return false
        }
    }
    
    //Variable is being used to check the current textfield is empty or not
    var isEmpty: Bool {
        if self.text == nil || self.text == "" || self.text!.trimmingCharacters(in: .whitespaces) == "" {
            return true
        }
        return false
    }
}
