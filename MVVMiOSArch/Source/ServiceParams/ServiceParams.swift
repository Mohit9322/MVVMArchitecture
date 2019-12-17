//
//  ServiceParams.swift
//  WatchMyBack
//
//  Created by Chetu on 8/9/18.
//  Copyright © 2018 LocatorTechnologies. All rights reserved.
//

import Foundation
import Alamofire

/// UserRegisterParams - information needed to get back a single trip ticket
struct UserRegisterParams : ParamsProtocol
{
    var username : String;
    var email : String;
    var password : String;
   
    /*
     @description : Method is being used to get parameters for registration service
     Parameters:NA
     return : Parameters
     */
    
    func getParams() -> Parameters {
        return [ "username":username,
                 "email":email,
                 "password": password,
                 ];
    }
    
    /*
     @description : Method is being used to get service call type
     Parameters:NA
     return : HTTPMethod
     */
    func getMethod() -> HTTPMethod {
        return .post;
    }
}


struct ForgotPasswordParams : ParamsProtocol
{
    var email : String;

    /*
     @description : Method is being used to get parameters for forgot password service
     Parameters:NA
     return : Parameters
     */
    func getParams() -> Parameters {
        return [ "email":email,
        ];
    }
    
    /*
     @description : Method is being used to get service call type
     Parameters:NA
     return : HTTPMethod
     */
    func getMethod() -> HTTPMethod {
        return .post;
    }
}

struct MediaIdOfParticularUser {
    var email: String;
    var passWord: String;
    
    /*
     @description : Method is being used to get parameters for MediaId of particular user service
     Parameters:NA
     return : Parameters
     */
    func getParams() -> Parameters {
        return [ "email":email,
                 "password": passWord,
        ];
    }
    
    /*
     @description : Method is being used to get service call type
     Parameters:NA
     return : HTTPMethod
     */
    func getMethod() -> HTTPMethod {
        return .post;
    }
}

struct ContactIdOfParticularUser{
    var email: String;
    var passWord: String;
    
    /*
     @description : Method is being used to get parameters for Contact of particular user service
     Parameters:NA
     return : Parameters
     */
    func getParams() -> Parameters {
        return [ "email":email,
                 "password": passWord,
        ];
    }
    
    /*
     @description : Method is being used to get service call type
     Parameters:NA
     return : HTTPMethod
     */
    func getMethod() -> HTTPMethod {
        return .post;
    }
}
struct LogInParameter: ParamsProtocol {
    var email: String;
    var passWord: String;
    var isPaidUser: String;
    
    /*
     @description : Method is being used to get parameters for MediaId of Login service
     Parameters:NA
     return : Parameters
     */
    func getParams() -> Parameters {
        return [ "email":email,
                 "password": passWord,
                 "paidUser": isPaidUser
        ];
    }
    
    /*
     @description : Method is being used to get service call type
     Parameters:NA
     return : HTTPMethod
     */
    func getMethod() -> HTTPMethod {
        return .post;
    }
}


struct AddContactParams: ParamsProtocol {
    var email: String;
    var passWord: String;
    var contactName: String;
    var contactEmail: String;
    var contactPhone: String;
    
    /*
     @description : Method is being used to get parameters to add contact
     Parameters:NA
     return : Parameters
     */
    func getParams() -> Parameters {
        return [ "email":email,
                 "password": passWord,
                 "contactName": contactName,
                 "contactPhone": contactPhone,
                 "contactEmail": contactEmail
        ];
    }
    
    /*
     @description : Method is being used to get service call type
     Parameters:NA
     return : HTTPMethod
     */
    func getMethod() -> HTTPMethod {
        return .post;
    }
}
struct DeleteContactParams: ParamsProtocol{
    var email: String;
    var passWord: String;
    var contactId: String;
    
    /*
     @description : Method is being used to get parameters to delete contact
     Parameters:NA
     return : Parameters
     */
    func getParams() -> Parameters {
        return [ "email":email,
                 "password": passWord,
                 "contactId": contactId
        ];
    }
    
    /*
     @description : Method is being used to get service call type
     Parameters:NA
     return : HTTPMethod
     */
    func getMethod() -> HTTPMethod {
        return .post;
    }
}

struct EditContactParams: ParamsProtocol{
    var email: String;
    var passWord: String;
    var contactName: String;
    var contactEmail: String;
    var contactPhone: String;
    var contactId: String;
    
    /*
     @description : Method is being used to get parameters to edit contact
     Parameters:NA
     return : Parameters
     */
    func getParams() -> Parameters {
        return [ "email":email,
                 "password": passWord,
                 "contactName": contactName,
                 "contactPhone": contactPhone,
                 "contactEmail": contactEmail,
                "contactId": contactId
        ];
    }
    
    /*
     @description : Method is being used to get service call type
     Parameters:NA
     return : HTTPMethod
     */
    func getMethod() -> HTTPMethod {
        return .post;
    }
}
struct SaveMediaParameter : ParamsProtocol {
    var email : String;
    var password: String;
    var lat: String;
    var lon: String;
    var captureDate: String;
    /*
     @description : Method is being used to get parameters for Save Media Parameters
     Parameters:NA
     return : Parameters
     */
    func getParams() -> Parameters {
        return [ "email":email,
                 "password": password,
                 "lat": lat,
                 "lon": lon,
                 "captureDate": captureDate,
         ];
    }
    
    /*
     @description : Method is being used to get service call type
     Parameters:NA
     return : HTTPMethod
     */
    func getMethod() -> HTTPMethod {
        return .post
    }
}
