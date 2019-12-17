//
//  ApplicationState.swift
//  WatchMyBack
//
//  Created by Chetu on 8/9/18.
//  Copyright © 2018 LocatorTechnologies. All rights reserved.
//

import Foundation
import Foundation

final class ApplicationState
{
    // services
    var appDataStore : AppDataStore!
    
    open static let sharedAppState : ApplicationState = {
        let instance = ApplicationState();
        return instance;
    }()
    
    private init() {
        appDataStore = AppDataStore()
    }
}
