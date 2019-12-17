//
//  ViewController.swift
//  WatchMyBack
//
//  Created by LocatorTechnologies on 6/25/18.
//  Copyright © 2018 LocatorTechnologies. All rights reserved.
//

import Foundation
import UIKit

extension String
{
    //Variable is being used to check the whether mail is valid or not
    var isValidEmail: Bool {
        let emailRegEx = Constants.CharacterSetForValidation.emailCharacterSet
        let emailTest = NSPredicate(format:"\(Constants.kselfMatch) %@", emailRegEx)
        return emailTest.evaluate(with: self)
    }
    
    //variable for converting string to base 64 string
    var base64String: String {
        let data = (self).data(using: String.Encoding.utf8)
        let base64 = data!.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
        return base64
    }
    //Variable to check whether password is valid or not
    var isValidPassword: Bool {
        let decimalCharacters = CharacterSet.decimalDigits
        let decimalRange = self.rangeOfCharacter(from: decimalCharacters)
        let characterset = CharacterSet(charactersIn: Constants.CharacterSetForValidation.characterSet)
        let characterRange = self.rangeOfCharacter(from: characterset)
        if decimalRange != nil && characterRange != nil {
            return true
        } else {
            return false
        }
    }
    
    //Variable is being used to check the current textfield is empty or not
    var isEmpty: Bool {
        if self == "" || self.trimmingCharacters(in: .whitespaces) == "" {
            return true
        }
        return false
    }
    
    /*
    @description : Method is being used to calculate the height of the string
    Parameters:
    width: width of string
    font: font size of string using that height will be calculated
    return : CGFloat
    */
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        
        return ceil(boundingBox.height)
    }
    
    /*
     @description : Method is being used to calculate the width of the string
     Parameters:
     height: height of string
     font: font size of string using that height will be calculated
     return : CGFloat
     */
    func width(withConstraintedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        
        return ceil(boundingBox.width)
    }
    
    /*
     @description : Method is being used to get the capitalized first letter of current string
     Parameters: NA
     return : String
     */
    func capitalizingFirstLetter() -> String {
        return prefix(1).uppercased() + dropFirst()
    }
    
    /*
     @description : Method is being used to remove the whitespaces from the string
     Parameters: NA
     return : String
     */
    func removingWhitespaces() -> String {
        return components(separatedBy: .whitespaces).joined()
    }

    
    /*
     @description : Method is being used to get the capitalized first letter of current string
     Parameters: NA
     return : NA
     */
    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}
