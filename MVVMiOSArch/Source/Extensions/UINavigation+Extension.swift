//
//  ViewController.swift
//  WatchMyBack
//
//  Created by LocatorTechnologies on 6/25/18.
//  Copyright © 2018 LocatorTechnologies. All rights reserved.
//

import Foundation
import UIKit

//UINavigationBackButtonCheck protocol is being used to customize the navigation back button functionality
protocol UINavigationBackButtonCheck {
	func shouldPopViewController() -> Bool
}

extension UINavigationController: UINavigationBarDelegate  {
	
	/// shouldPop - should the navBar allow the pop/back to occur
	///
	/// - Parameters:
	///   - navigationBar: the navbar
	///   - item: which item was selected
	/// - Returns: true/false
	public func navigationBar(_ navigationBar: UINavigationBar, shouldPop item: UINavigationItem) -> Bool {
		
		if viewControllers.count < (navigationBar.items?.count) ?? 0 {
			return true
		}
		
		// default is to allow the back button to work
		var shouldPopViewController : Bool = true
		
		// check to see if the topviewcontroller has overridden the back button
		if let topViewController = self.topViewController as? UINavigationBackButtonCheck {
			// determine if this viewcontroller wants the back button to work
			shouldPopViewController = topViewController.shouldPopViewController()
		}
		
		// if we should go back
		if (shouldPopViewController) {
			// trigger the pop of the top view controller
			DispatchQueue.main.async { [weak self] in
				self?.popViewController(animated: true)
            }
		}

		// always return false since we are controlling the pop ourselves
		return false
	}
}

