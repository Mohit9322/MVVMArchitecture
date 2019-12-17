//
//  VideoRecordViewController.swift
//  WatchMyBack
//
//  Created by Chetu on 7/9/18.
//  Copyright © 2018 LocatorTechnologies. All rights reserved.
//

import UIKit
import AVKit
import CoreLocation

class VideoRecordViewController: BaseViewController {
    //MARK: IBOutlets
    @IBOutlet weak var previewImageView: UIImageView!
    @IBOutlet weak var previewView: UIView!
    @IBOutlet weak var perviewButton: UIButton!
    @IBOutlet weak var captureButton: UIButton!
    @IBOutlet weak var flipButton: UIButton!
    @IBOutlet weak var crossButton: UIButton!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var crossImageView: UIImageView!
    
    //MARK: Variables
    var urlOfFiles = [URL]()
    var captureSession : AVCaptureSession!
    var movieFileOutput : AVCaptureMovieFileOutput!
    var currentCaptureDevice: AVCaptureDevice?
    var stillImageOutput: AVCapturePhotoOutput?
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    var pinchGesture: UIPinchGestureRecognizer!
    var outputURL: URL!
    var isRecordingOn = false
    var timer = Timer()
    var seconds = 0
    let locationManager = CLLocationManager()
    var latitudeString : Double? = nil
    var longitudeString : Double? = nil
    var fileDetailsForEmergency : String = ""
    var fileDetailsForEmergencyURL : URL!
    
    var fromEmergency : Bool = false
    //MARK: Life Cycles
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
            } else if  urlOfFiles[urlOfFiles.count - 1].path.contains(Constants.kMp4) {
                previewImageView.image = Utility.generateThumbImage(urlOfFiles[urlOfFiles.count - 1], controller: self)
            }
        } else {
            perviewButton.isHidden = true
            previewImageView.isHidden = true
        }
        loadCamera()
        if let videoLayer = self.videoPreviewLayer {
            videoLayer.frame = self.previewView.bounds
        }
        inValidateTimer()
        navigationController?.isNavigationBarHidden = true
        UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
        self.pinchGesture = UIPinchGestureRecognizer(target: self, action:#selector(pinchToZoom(_:)))
        previewView.addGestureRecognizer(self.pinchGesture)
    }
    
    @IBAction func pinchToZoom(_ sender: UIPinchGestureRecognizer) {
        let currentInput = captureSession?.inputs.first as? AVCaptureDeviceInput
        if currentInput?.device.position == .back {
            guard let device = currentCaptureDevice
                else {
                    return
            }
            if sender.state == .changed {
                let maxZoomFactor = device.activeFormat.videoMaxZoomFactor / 5.0
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
    
    //MARK: Delegate method for rotation of device
    override open var shouldAutorotate: Bool {
        return false
    }
    
    /*
     @description : Method is being used to get front camera for capturing photo
     Parameters: N/A
     return : AVCaptureDevice
     */
    func getFrontCamera() -> AVCaptureDevice?{
        
        return AVCaptureDevice.default(.builtInWideAngleCamera, for: AVMediaType.video, position: .front)
    }
    
    /*
     @description : Method is being used to get rear camera for capturing photo
     Parameters: N/A
     return : AVCaptureDevice
     */
    func getBackCamera() -> AVCaptureDevice{
        return AVCaptureDevice.default(.builtInWideAngleCamera, for: AVMediaType.video, position: .back)!
    }
    
    /*
     @description : Method is being used load camera using the catureSession
     Parameters: N/A
     return : N/A
     */
    func loadCamera() {
        captureSession = AVCaptureSession()
        do {
            captureSession.beginConfiguration()
            captureSession.sessionPreset = AVCaptureSession.Preset.medium
            currentCaptureDevice = AVCaptureDevice.default(for: AVMediaType.video)
            let cameraDeviceInput = try AVCaptureDeviceInput(device: currentCaptureDevice!)
            
            if (captureSession.canAddInput(cameraDeviceInput) == true) {
                captureSession.addInput(cameraDeviceInput)
            }
            
            let audioDevice = AVCaptureDevice.default(.builtInMicrophone, for: AVMediaType.audio, position: .unspecified)
            
            let audioDeviceInput = try AVCaptureDeviceInput(device: audioDevice!)
            if (captureSession.canAddInput(audioDeviceInput) == true) {
                captureSession.addInput(audioDeviceInput)
            }
            
            setUpCameraFrame()
            
        }
        catch let error as NSError {
            //if microphone is not applicable but camera capture is allowed show camera recording
            print("\(error), \(error.localizedDescription), \(error.code)")
            if error.code == -11852 {
                setUpCameraFrame()
            }
        }
    }
    
    
    /*
     @description : Setup camera and related variables
     Parameters: N/A
     return : N/A
     */
    
    func setUpCameraFrame()  {
        self.movieFileOutput = AVCaptureMovieFileOutput()
        self.movieFileOutput.movieFragmentInterval = CMTime.invalid
        if (self.captureSession.canAddOutput(self.movieFileOutput) == true) {
            self.captureSession.addOutput(self.movieFileOutput)
        }
        
        self.captureSession.commitConfiguration()
        self.captureSession.startRunning()
        self.videoPreviewLayer =  AVCaptureVideoPreviewLayer(session: self.captureSession)
        self.videoPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        
        if let layer = self.videoPreviewLayer{
            self.previewView.layer.addSublayer(layer)
            
            
            DispatchQueue.main.async {
                layer.frame = self.previewView.bounds
            }
        }
    }
    
    /*
     @description : Method is being used to switch the camera
     Parameters:
     sender: is holding the refrence of button
     return : N/A
     */
    @IBAction func switchButtonAction(_ sender: UIButton) {
        if Utility.checkForAccessibilityOfCamera(viewController: self) {
            setUpCamera()
        }
    }
    
    /*
     @description : Method is being used to set up the camera
     Parameters: N/A
     return : N/A
     */
    func setUpCamera() {
        captureSession?.beginConfiguration()
        let currentInput = captureSession?.inputs.first as? AVCaptureDeviceInput
        if let inputs = captureSession.inputs as? [AVCaptureDeviceInput] {
            for input in inputs {
                captureSession.removeInput(input)
            }
        }
        
        currentCaptureDevice = currentInput?.device.position == .back ? getFrontCamera() : getBackCamera()
        let newVideoInput = try? AVCaptureDeviceInput(device: currentCaptureDevice!)
        captureSession?.addInput(newVideoInput!)
        
        guard let audioDevice = AVCaptureDevice.default(.builtInMicrophone, for: AVMediaType.audio, position: .unspecified) else {
            return
        }
        
        do {
            let audioDeviceInput = try AVCaptureDeviceInput(device: audioDevice)
            if (captureSession.canAddInput(audioDeviceInput) == true) {
                captureSession.addInput(audioDeviceInput)
            }
        } catch let error as NSError {
            print("\(error), \(error.localizedDescription)")
        }
        captureSession?.commitConfiguration()
    }
    
    /*
     @description : Method is being used to navigating the previous screen
     Parameters:
     sender: is holding the refrence of UIButton
     return : N/A
     */
    @IBAction func dismissView(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    /*
     @description : Method is being used to start/stop recording
     Parameters:
     sender: is holding the refrence of UIButton
     return : N/A
     */
    @IBAction func videoCapture(_ sender: UIButton) {
        if Utility.checkForAccessibilityOfCamera(viewController: self) {
            if !isRecordingOn {
                startRecording()
            } else {
                stopRecording()
            }
        }
    }
    
    /*
     @description : Method is being used to view recent clicked image or captured video
     Parameters:
     sender: is holding the refrence of UIButton
     return : N/A
     */
    @IBAction func viewImageAction(_ sender: UIButton) {
        clearMemory()
        guard let vc = UIStoryboard.init(name: Constants.StoryBoardIdentifiers.kStoryboardMain,
                                         bundle: Bundle.main).instantiateViewController(withIdentifier: Constants.ViewControllerIdentiFiers.kPhotoVideoPreviewController) as? PhotoVideoPreviewController else {
                                            return
        }
        vc.isComingFromCamera = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    /*
     @description : Method is being used to clear the memory which occupy with the components
     Parameters: N/A
     return : N/A
     */
    func clearMemory(){
        captureSession = nil
        stillImageOutput = nil
        videoPreviewLayer = nil
        currentCaptureDevice = nil
        movieFileOutput = nil
    }
    
    /*
     @description : Method is being used to hide the components when recording is being on
     Parameters: N/A
     return : N/A
     */
    func hideComponent()  {
        flipButton.isHidden = true
        crossButton.isHidden = true
        crossImageView.isHidden = true
        previewImageView.isHidden = true
        perviewButton.isHidden = true
    }
    
    /*
     @description : Method is being used to start the recording
     Parameters: N/A
     return : N/A
     */
    func startRecording() {
        isRecordingOn = true
        captureButton.setBackgroundImage(#imageLiteral(resourceName: "recordingOn"), for: .normal)
        runTimer()
        hideComponent()
        if let photoOutputConnection = movieFileOutput?.connection(with: .video) {
            photoOutputConnection.videoOrientation = Utility.managePhotoOrientation()
        }
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("\(Constants.kImageVideoStorage)\(DataManager.email ?? "")")
        //let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("\(Constants.kImageVideoStorage)")
//        let dataPath = documentsDirectory.appendingPathComponent("\(Utility.getCurrentDate()).mp4" )
        let dataPath = documentsDirectory.appendingPathComponent("\t\(Utility.getCurrentDate())\t\(self.latitudeString!)\t\(self.longitudeString!)\t.mp4" )
        
        outputURL = dataPath
        
        movieFileOutput.startRecording(to: outputURL as URL, recordingDelegate: self)
    }
    
    /*
     @description : Method is being used to set up the camera
     Parameters: N/A
     return : N/A
     */
    func runTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: (#selector(VideoRecordViewController.updateTimer)), userInfo: nil, repeats: true)
    }
    
    /*
     @description : Method is being used to update the timer
     Parameters: N/A
     return : N/A
     */
    @objc func updateTimer() {
        seconds += 1
        timerLabel.text = Utility.timeString(time: TimeInterval(seconds))
    }
    
    /*
     @description : Method is being used to stop recording
     Parameters: N/A
     return : N/A
     */
    func stopRecording() {
        isRecordingOn = false
        captureButton.setBackgroundImage(#imageLiteral(resourceName: "recordingOff"), for: .normal)
        inValidateTimer()
        showComponent()
        movieFileOutput.stopRecording()
        let data = NSData(contentsOf: (self.outputURL) as URL)
        let videoSize: Int = data!.length
        print("size of image in KB: %f ", Double(videoSize) / 1024.0)
        //captureSession.stopRunning()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){[weak self] in
            self?.previewImageView.image = Utility.generateThumbImage((self?.outputURL)!, controller: self)
        }
        if(fromEmergency){
            fileDetailsForEmergency = (self.outputURL?.path)!
            fileDetailsForEmergencyURL = self.outputURL
            self.moveToHomeScreen()
        }
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
    /*
     @description : Method is being used to invalidate the timer
     Parameters: N/A
     return : N/A
     */
    func inValidateTimer() {
        timer.invalidate()
        seconds = 0
        timerLabel.text = Utility.timeString(time: TimeInterval(seconds))
    }
    
    /*
     @description : Method is being used to show components when recording has been stopped
     Parameters: N/A
     return : N/A
     */
    func showComponent(){
        flipButton.isHidden = false
        crossButton.isHidden = false
        crossImageView.isHidden = false
        previewImageView.isHidden = false
        perviewButton.isHidden = false
    }
}

extension VideoRecordViewController: CLLocationManagerDelegate{
    
    /*
      @description : Method is being used  method of CLLocationManager to get the current location cordinates of the user
      @parameters :
       manager : Used to hold the reference of CLLocationManager in the process
       didUpdateLocations locations : Used to hold the reference of CLLoction in order to get the updaetd location
     */
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        self.longitudeString = locValue.longitude
        self.latitudeString = locValue.latitude
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        locationManager.stopUpdatingLocation()
    }
}
extension VideoRecordViewController: AVCaptureFileOutputRecordingDelegate{
    /*
     @description : Method is being used implement the protocol method of AVCaptureFileOutputRecordingDelegate and will be called when data writing will be completed
     Parameters:
     output: is being used to hold the refrence of AVCaptureFileOutput
     outputFileURL: provide url where data has been written
     connections: will hold the array refrence of AVCaptureConnection
     connections: will hold the array refrence
     return : N/A
     */
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
//        self.stopRecording()
        if error?.localizedDescription == Constants.kOperationStopped {
            Utility.alertContoller(title: Utility.localized(key: "kMessage"),
                                   message: Utility.localized(key: "kMakeSpaceInMemory"),
                                   actionTitleFirst: Utility.localized(key: "kOk"),
                                   actionTitleSecond: "",
                                   firstActoin: nil, secondAction: nil,
                                   controller: self)
        }
        debugPrint("Video URL =\(outputFileURL)")
    }
}

