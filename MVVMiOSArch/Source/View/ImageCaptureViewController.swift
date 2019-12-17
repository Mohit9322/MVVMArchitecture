//
//  ImageCaptureViewController.swift
//  WatchMyBack
//
//  Created by Chetu on 7/9/18.
//  Copyright © 2018 LocatorTechnologies. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation
import CoreLocation

class ImageCaptureViewController: UIViewController {
    //MARK: IBOutlets
    @IBOutlet weak var previewImageView: UIImageView!
    @IBOutlet weak var previewView: UIView!
    @IBOutlet weak var perviewButton: UIButton!
    @IBOutlet weak var captureButton: UIButton!
    @IBOutlet weak var flipButton: UIButton!
    @IBOutlet weak var crossButton: UIButton!
    @IBOutlet weak var crossImageview: UIImageView!
    
    //MARK: Variables
    var captureSession: AVCaptureSession?
    var stillImageOutput: AVCapturePhotoOutput?
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    var currentCaptureDevice: AVCaptureDevice?
    var usingFrontCamera = false
    var urlOfFiles = [URL]()
    var pinchGesture: UIPinchGestureRecognizer!
    let locationManager = CLLocationManager()
    var latitudeString : Double? = nil
    var longitudeString : Double? = nil
    var fileDetailsForEmergency : String = ""
    var fileDetailsForEmergencyURL : URL!
    var fromEmergency : Bool = false
    //MARK: Life cycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        // Ask for Authorisation from the User.
        self.locationManager.requestAlwaysAuthorization()
        
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        flipButton.contentEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        crossButton.contentEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        urlOfFiles = DocumentDirecotoryOperations.getListOfFiles(orderToFetch: .ascending)
        previewImageView.layer.cornerRadius = 5.0
        previewImageView.layer.masksToBounds = true
        //if there is image in the document direcotory
        if urlOfFiles.count > 0 {
            if urlOfFiles[urlOfFiles.count - 1].path.contains(Constants.kJpg) {
                previewImageView.image = UIImage(contentsOfFile: urlOfFiles[urlOfFiles.count - 1].path)
            }else if  urlOfFiles[urlOfFiles.count - 1].path.contains(Constants.kMp4) {
                previewImageView.image = Utility.generateThumbImage(urlOfFiles[urlOfFiles.count - 1],
                                                                    controller: self)
            }
        } else {
            perviewButton.isHidden = true
            previewImageView.isHidden = true
        }
        
        loadCamera()
        navigationController?.isNavigationBarHidden = true
        UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue,
                                  forKey: "orientation")
        
        self.pinchGesture = UIPinchGestureRecognizer(target: self, action:#selector(pinchToZoom(_:)))
        previewView.addGestureRecognizer(self.pinchGesture)
    }
    
    /*
     @description : Method is being used to for managing pinch gesture
     Parameters:
     sender: is holding the refrence of pinch gesture
     return : N/A
     */
    @IBAction func pinchToZoom(_ sender: UIPinchGestureRecognizer) {
        let currentInput = captureSession?.inputs.first as? AVCaptureDeviceInput
        if currentInput?.device.position == .back {
            guard let device = currentCaptureDevice else { return }
            if sender.state == .changed {
                let maxZoomFactor = device.activeFormat.videoMaxZoomFactor / 50.0
                let pinchVelocityDividerFactor: CGFloat = 25.0
                do {
                    try device.lockForConfiguration()
                    defer { device.unlockForConfiguration() }
                    
                    let desiredZoomFactor = device.videoZoomFactor + atan2(sender.velocity, pinchVelocityDividerFactor)
                    device.videoZoomFactor = max(1.0, min(desiredZoomFactor, maxZoomFactor))
                    
                } catch {
                    debugPrint(error)
                }
            }
        }
    }
    
    
    //MARK: Delegate method for rotating the screen
    override open var shouldAutorotate: Bool {
        return false
    }
    
    /*
     @description : Method is being used to switch the camera to front or Rear
     Parameters:
     sender: is holding the refrence of UIButton
     return : N/A
     */
    @IBAction func switchButtonAction(_ sender: UIButton) {
        if Utility.checkForAccessibilityOfCamera(viewController: self) {
            captureSession?.beginConfiguration()
            let currentInput = captureSession?.inputs.first as? AVCaptureDeviceInput
            if let inputs = captureSession?.inputs as? [AVCaptureDeviceInput] {
                for input in inputs {
                    captureSession?.removeInput(input)
                }
            }
            //captureSession?.removeInput(currentInput!)
            currentCaptureDevice = currentInput?.device.position == .back ? getFrontCamera() : getBackCamera()
            let newVideoInput = try? AVCaptureDeviceInput(device: currentCaptureDevice!)
            captureSession?.addInput(newVideoInput!)
            captureSession?.commitConfiguration()
        }
    }
    
    /*
     @description : Method is being used to capture the photo
     Parameters:
     sender: is being hold the UIbutton refrence
     return : N/A
     */
    @IBAction func capturePhotoAction(_ sender: UIButton) {
        //_ = managePhotoOrientation()
        if Utility.checkForAccessibilityOfCamera(viewController: self) {
            if let photoOutputConnection = stillImageOutput?.connection(with: .video) {
                photoOutputConnection.videoOrientation = Utility.managePhotoOrientation()
            }
            let settings = AVCapturePhotoSettings()
            let previewPixelType = settings.availablePreviewPhotoPixelFormatTypes.first!
            let previewFormat = [kCVPixelBufferPixelFormatTypeKey as String: previewPixelType,
                                 kCVPixelBufferWidthKey as String: 160,
                                 kCVPixelBufferHeightKey as String: 160,
                                 ]
            settings.previewPhotoFormat = previewFormat
            stillImageOutput?.capturePhoto(with: settings, delegate: self)
        }
    }
    
    
    /*
     @description : Method is being used view recent clicked photo or capture video
     Parameters:
     sender: is being hold the UIbutton refrence
     return : N/A
     */
    @IBAction func viewImageAction(_ sender: Any) {
        captureSession = nil
        stillImageOutput = nil
        videoPreviewLayer = nil
        currentCaptureDevice = nil
        guard let vc = UIStoryboard.init(name: Constants.StoryBoardIdentifiers.kStoryboardMain,
                                         bundle: Bundle.main).instantiateViewController(withIdentifier: Constants.ViewControllerIdentiFiers.kPhotoVideoPreviewController) as? PhotoVideoPreviewController else {
                                            return
        }
        vc.isComingFromCamera = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    /*
     @description : Method is being used navigating back to the previous screen
     Parameters:
     sender: is being hold the UIbutton refrence
     return : N/A
     */
    @IBAction func dismissView(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    /*
     @description : Method is being used to open the front camera
     Parameters: N/A
     return : N/A
     */
    func getFrontCamera() -> AVCaptureDevice?{
        return AVCaptureDevice.default(.builtInWideAngleCamera,
                                       for: AVMediaType.video,
                                       position: .front)
    }
    
    /*
     @description : Method is being used to open the rear camera
     Parameters: N/A
     return : N/A
     */
    func getBackCamera() -> AVCaptureDevice{
        return AVCaptureDevice.default(.builtInWideAngleCamera,
                                       for: AVMediaType.video,
                                       position: .back)!
    }
    
    /*
     @description : Method is being used load the camera
     Parameters: N/A
     return : N/A
     */
    func loadCamera() {
        if(captureSession == nil){
            captureSession = AVCaptureSession()
            captureSession!.sessionPreset = AVCaptureSession.Preset.photo
        }
        var error: NSError?
        var input: AVCaptureDeviceInput!
        debugPrint(usingFrontCamera)
        currentCaptureDevice = (usingFrontCamera ? getFrontCamera() : getBackCamera())
        
        do {
            input = try AVCaptureDeviceInput(device: currentCaptureDevice!)
        } catch let error1 as NSError {
            error = error1
            input = nil
            print(error!.localizedDescription)
        }
        
        for i : AVCaptureDeviceInput in (self.captureSession?.inputs as! [AVCaptureDeviceInput]){
            self.captureSession?.removeInput(i)
        }
        if error == nil && captureSession!.canAddInput(input) {
            captureSession!.addInput(input)
            stillImageOutput = AVCapturePhotoOutput()
            let settings = AVCapturePhotoSettings()
            if #available(iOS 11.0, *) {
                settings.livePhotoVideoCodecType = .jpeg
            } else {
                // Fallback on earlier versions
            }
            if captureSession!.canAddOutput(stillImageOutput!) {
                captureSession!.addOutput(stillImageOutput!)
                self.captureSession!.startRunning()
                videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession!)
                videoPreviewLayer!.videoGravity = AVLayerVideoGravity.resizeAspectFill
                videoPreviewLayer!.connection?.videoOrientation = AVCaptureVideoOrientation.portrait
                previewView.layer.addSublayer(videoPreviewLayer!)
            }
            
            if let videoLayer = self.videoPreviewLayer {
                //                DispatchQueue.main.async {
                //                    videoLayer.frame = self.previewView.bounds
                //                }
                videoLayer.frame = CGRect(x: 0,
                                          y: 0,
                                          width: UIScreen.main.bounds.width,
                                          height: self.previewView.frame.size.height)
            }
        }
    }
    
    /*
     @description : Method is being used to check the accessibility/authorisation of camera
     Parameters: N/A
     return : Bool
     */
    func checkForAccessibilityOfCamera() -> Bool
    {
        let authStatus = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
        if authStatus == AVAuthorizationStatus.denied || authStatus == AVAuthorizationStatus.notDetermined {
            // Denied access to camera
            // Explain that we need camera access and how to change it.
            Utility.alertContoller(title: Utility.localized(key: "kMessage"),
                                   message: Utility.localized(key: "kAccessCameraFromSetting"),
                                   actionTitleFirst: Utility.localized(key: "kOk"),
                                   actionTitleSecond: "",
                                   firstActoin: nil, secondAction: nil,
                                   controller: self)
            return false
        } else {
            return true
        }
    }

    /*
     @description : Method is being used to rotate an UIImage
     Parameters: N/A
     return : UIImage
     */
    
    func rotateImage(image: UIImage?) -> UIImage? {
        guard let image = image else {
            return UIImage()
        }
        if (image.imageOrientation == UIImage.Orientation.up ) {
            return image
        }
        UIGraphicsBeginImageContext(image.size)
        image.draw(in: CGRect(origin: CGPoint.zero, size: image.size))
        let copy = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return copy
    }
    
    /*
     @description : Method is being used to navigate home screen
     Parameters: NA
     return : NA
     */
    func moveToHomeScreen(){
        guard let vc = UIStoryboard.init(name: Constants.StoryBoardIdentifiers.kStoryboardMain,
                                         bundle: Bundle.main).instantiateViewController(withIdentifier: Constants.ViewControllerIdentiFiers.kHomeViewController) as? HomeViewController else {
                                            return
        }
        vc.fileDetailsForEmergency = fileDetailsForEmergency
        vc.fileDetailsForEmergencyURL = fileDetailsForEmergencyURL
        vc.fromEmergency = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
extension ImageCaptureViewController: CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        self.longitudeString = locValue.longitude
        self.latitudeString = locValue.latitude
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        locationManager.stopUpdatingLocation()
    }
}
extension ImageCaptureViewController: AVCapturePhotoCaptureDelegate {
    /*
     @description : Method is being used to open the front camera
     Parameters:
     captureOutput: will provide the captured output
     photoSampleBuffer: will managed the buffer,
     previewPhotoSampleBuffer: will managed the sample buffer
     resolvedSettings: will hold the setting,
     bracketSettings: will hold the captured still image setting,
     error: is being used to hold the error refrence
     return : N/A
     */
    
    func photoOutput(_ captureOutput: AVCapturePhotoOutput, didFinishProcessingPhoto photoSampleBuffer: CMSampleBuffer?, previewPhoto previewPhotoSampleBuffer: CMSampleBuffer?, resolvedSettings: AVCaptureResolvedPhotoSettings, bracketSettings: AVCaptureBracketedStillImageSettings?, error: Error?){
//        if let error = error {
//            print(error.localizedDescription)
//        }
//        if let sampleBuffer = photoSampleBuffer, let previewBuffer = previewPhotoSampleBuffer, let dataImage = AVCapturePhotoOutput.jpegPhotoDataRepresentation(forJPEGSampleBuffer: sampleBuffer, previewPhotoSampleBuffer: previewBuffer) {
//
//            let options = [kCGImageSourceShouldCache as String: kCFBooleanFalse]
//            if let data = UIImageJPEGRepresentation(UIImage(data: dataImage)!, 1), let imgSrc = CGImageSourceCreateWithData(data as CFData, options as CFDictionary) {
//                let metadata = CGImageSourceCopyPropertiesAtIndex(imgSrc, 0, options as CFDictionary) as? [String : AnyObject]
//                if let gpsData = metadata?[kCGImagePropertyGPSDictionary as String] {
//                    print(gpsData)
//                    //do interesting stuff here
//                }
//            }
//
//            perviewButton.isHidden = false
//            previewImageView.isHidden = false
//            previewImageView.image =  UIImage(data: dataImage)
//
//            DocumentDirecotoryOperations.saveMediaIntoTheLocalDirectory(typeOfMedia: .photo, controller: self, photoVideoData: dataImage as Data, lat: self.latitudeString!, long: self.longitudeString!) { (isPhotoSaved, fileDetails) in
//                if !isPhotoSaved {
//
//                    debugPrint("error")
//
//                } else {
//                    debugPrint("saved")
//                    if(fromEmergency){
//                        fileDetailsForEmergency = (fileDetails?.path)!
//                        fileDetailsForEmergencyURL = fileDetails
//                        self.moveToHomeScreen()
//                    }
//                }
//            }
//        } else {
//            //unable to capture photo
//        }
    }
    
    
}
