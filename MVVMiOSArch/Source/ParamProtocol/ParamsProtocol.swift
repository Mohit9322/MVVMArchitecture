//
//  ParamsProtocol.swift
//  WatchMyBack
//
//  Created by Chetu on 8/9/18.
//  Copyright © 2018 LocatorTechnologies. All rights reserved.
//

import Foundation
import Alamofire

//Protocol is being used to get parameters and method type in network calls
protocol ParamsProtocol
{
    
    mutating func getParams() -> Parameters;
    
    func getMethod() -> HTTPMethod;
}


