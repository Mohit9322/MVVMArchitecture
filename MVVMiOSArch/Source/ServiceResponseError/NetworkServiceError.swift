//
//  NetworkServiceError.swift
//  WatchMyBack
//
//  Created by Chetu on 8/9/18.
//  Copyright © 2018 LocatorTechnologies. All rights reserved.
//

import Foundation
import SwiftyJSON
//enum for holdign the network error
enum NetworkServiceError : Error {
    case serviceError(String),
    invalidToken,
    unauthorized(String),
    generic(String),
    idpGeneral(String),
    idperror(String, String), // description, fields
    cancelled(String)
    
    //holding the different state of the errors
    public var description : String {
        switch self {
        case let .serviceError(desc): return desc
        case .invalidToken: return "Invalid token"
        case let .unauthorized(desc): return desc
        case let .generic(desc): return desc
        case let .idpGeneral(desc): return desc
        case let .idperror(desc, _): return desc
        case let .cancelled(desc): return desc
        }
    }
}
