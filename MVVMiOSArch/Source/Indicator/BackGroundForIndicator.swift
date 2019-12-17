//
//  DocumentDirecotoryOperations.swift
//  WatchMyBack
//
//  Created by Chetu on 7/2/18.
//  Copyright © 2018 LocatorTechnologies. All rights reserved.

import Foundation
import UIKit


class HISActivityIndicator: NSObject {
    
    /**
     This Property Observer define the IndicatorView Class which is used for showing on the Window
     - Returns: Void
     - Remark: This Add the IndicatorLoaderView on the Window and start the animation
     */
    static let window = UIApplication.shared.keyWindow!
    
    ///IndicatorView
    static var indicatorView = IndicatorLoaderView()
    /**
     This function is used for start the animation of the indicatorView class
     - Returns: Void
     - Remark:
     */
    static func start() {
        indicatorView.frame = window.frame
        window.addSubview(indicatorView)
        indicatorView.startAnimation()
    }
    
    /**
     This function is used for stop the animation of the indicatorView class
     - Returns: Void
     - Remark:
     */
    static func stop() {
        //indicatorView.removeFromSuperview()
        indicatorView.stopAnimation()
    }
}

/**
 This class define the **IndicatorLoaderView** class which contain the **InstagramActivityIndictor** Class
 - Date: July 4, 2018
 - Copyright: © 2018 HaloInnovativeSolutions. All rights reserved.
 */
class IndicatorLoaderView: UIView {
    var indicator = InstagramActivityIndicator()
    
    //convenience method of the class
    convenience init(){
        self.init(frame: CGRect.zero)
    }
    
    //designated method of the class
    override init(frame: CGRect) {
        super.init(frame: CGRect.zero)
        self.backgroundColor =  .gray
        self.alpha = 0.5
        initViews()
    }
    
    /**
     This function set the indicator frame of the ActivityIndicator View.
     - Returns: Void
     - Remark:This function the frame add on the view
     */
    func initViews() {
        addSubview(indicator)
    }
    
    //Required Method of the class
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    ///This function start the animation of the indicatorView
    func startAnimation() {
        indicator.startAnimating()
        self.isHidden = false
    }
    
    ///This function stop the animation of the indicatorView
    func stopAnimation() {
        indicator.stopAnimating()
        self.isHidden = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        addConstraintToFillSuperview()
        addConstraintSameCenterXY(self, and: indicator)
        _ = indicator.addConstraintForWidth(100)
        _ = indicator.addConstraintForHeight(100)
    }
}
