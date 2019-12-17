//
//  HomeViewController.swift
//  WatchMyBack
//
//  Created by Chetu on 6/26/18.
//  Copyright © 2018 LocatorTechnologies. All rights reserved.
//

import UIKit
import CoreLocation
import MessageUI


class HomeViewController: BaseViewController {
    
    //MARK: IBOutlets
    @IBOutlet weak var capturePhotoButton: UIButton!
    @IBOutlet weak var captureVideoButton: UIButton!
    @IBOutlet weak var savedPhotoVideoButton: UIButton!
    @IBOutlet weak var syncDataButton: UIButton!
    @IBOutlet weak var badgeButton: UIButton!
    @IBOutlet weak var downloadMediaFile: UIButton!
    
    @IBOutlet weak var emergency: UIButton!
    @IBOutlet weak var archivedMediaFile: UIButton!
    @IBOutlet weak var activityI: UIActivityIndicatorView!
    //MARK: Variable
    var isSyncDataRunning: Bool! = false
    let locationManager = CLLocationManager()
    var fileDetailsForEmergency : String = ""
    var fromEmergency : Bool = false
    var fileDetailsForEmergencyURL : URL!
    //MARK: Life Cycle methods
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.locationManager.requestAlwaysAuthorization()
        
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self as? CLLocationManagerDelegate
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        if(fromEmergency){
            if(fileDetailsForEmergency.contains(".mp4"))
            {
                sendVideoMessage()
            }
            else{
                sendMessage()
            }
            
        }
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        AppUtility.lockOrientation(.all)
        self.activityI.isHidden = true
        self.syncDataButton.addSubview(self.activityI)
        self.activityI.frame.origin.x = syncDataButton.frame.width*0.65;
        self.activityI.frame.origin.y = 7;
        
        setUpCommonUI()
        setBarButton()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
//        syncDataButton.setTitle(Utility.localized(key: "kSyncData"), for: .normal)
//        if isSyncDataRunning == true {
//            //cancel all request
//            isSyncDataRunning = false
//            let mediaUploadViewModelObject = MediaUploadViewModel()
//            mediaUploadViewModelObject.cancelAllRequest()
//        }
    }
    
    /*
     @description : Method is being used to manage User interface when screen will appear
     Parameters: NA
     return : NA
     */
    func setUpCommonUI() {
        navigationController?.navigationBar.isHidden = false
        setTitle(title: Utility.localized(key: "kHome"))
        navigationItem.setHidesBackButton(true, animated:true);
        badgeButton.setButtonProperty(title: "",
                                      FontSize: Int(12),
                                      cornerRadius: Float(badgeButton.frame.size.height / 2),
                                      backgroundColor: .red)
        if (DocumentDirecotoryOperations.getListOfFiles(orderToFetch: .ascending).count) > 0{
            badgeButton.isHidden = false
            badgeButton.setTitle("\(DocumentDirecotoryOperations.getListOfFiles(orderToFetch: .ascending).count)", for: .normal)
        } else {
            badgeButton.isHidden = true
        }
        
        capturePhotoButton.setButtonProperty(title: Utility.localized(key: "kCapture_Photo"),
                                             FontSize: Int(18.0),
                                             cornerRadius: 10.0,
                                             backgroundColor: PrimaryColor.navyBlue(alphaValue: 1.0))
        captureVideoButton.setButtonProperty(title: Utility.localized(key: "kCapture_Video"),
                                             FontSize: Int(18.0),
                                             cornerRadius: 10.0,
                                             backgroundColor: PrimaryColor.navyBlue(alphaValue: 1.0))
        savedPhotoVideoButton.setButtonProperty(title: Utility.localized(key: "kGetSavedPhotoVideo"),
                                                FontSize: Int(18.0),
                                                cornerRadius: 10.0,
                                                backgroundColor: PrimaryColor.navyBlue(alphaValue: 1.0))
        syncDataButton.setButtonProperty(title: Utility.localized(key: "kSyncData"),
                                         FontSize: Int(18.0),
                                         cornerRadius: 10.0,
                                         backgroundColor: PrimaryColor.navyBlue(alphaValue: 1.0))
        downloadMediaFile.setButtonProperty(title: Utility.localized(key: "kShareMediaLink"),
                                            FontSize: Int(18.0),
                                            cornerRadius: 10.0,
                                            backgroundColor: PrimaryColor.navyBlue(alphaValue: 1.0))
        archivedMediaFile.setButtonProperty(title: Utility.localized(key: "kArchivedMediaFiles"),
                                            FontSize: Int(18.0),
                                            cornerRadius: 10.0,
                                            backgroundColor: PrimaryColor.navyBlue(alphaValue: 1.0))
        emergency.setButtonProperty(title: Utility.localized(key: "kEmergency"),
                                    FontSize: Int(18.0),
                                    cornerRadius: 10.0,
                                    backgroundColor: PrimaryColor.navyBlue(alphaValue: 1.0))
    }
    
    /*
     @description : Method is being used add logout bar button
     Parameters: NA
     return : NA
     */
    func setBarButton() {
        let negativeSpacer = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.fixedSpace,
                                             target: nil,
                                             action: nil)
        negativeSpacer.width = -10;
        
        
        
        
        //self.navigationItem.leftBarButtonItems = [n
        //Set Profile Icon Button
        let rightButton = UIButton(type: .system)
        rightButton.frame =  CGRect(origin: CGPoint(x: 0,y :0),
                                    size: CGSize(width: 40, height: 30))
        
        let image = #imageLiteral(resourceName: "logout").withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        
        rightButton.setImage(image ,
                             for: UIControl.State.normal)
        rightButton.addTarget(self,
                              action: #selector(self.moveToLoginScreen),
                              for: UIControl.Event.touchUpInside)
        let rightBarButton = UIBarButtonItem()
        rightBarButton.customView = rightButton
        self.navigationItem.rightBarButtonItem = rightBarButton
        self.navigationItem.setRightBarButtonItems([negativeSpacer, rightBarButton],
                                                   animated: false)
        
        
        //Set Setting Left Bar Button
        let leftButton = UIButton(type: .system)
        leftButton.frame =  CGRect(origin: CGPoint(x: 0,y :0),
                                    size: CGSize(width: 40, height: 30))
        let settingImage = #imageLiteral(resourceName: "setting").withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        
        leftButton.setImage(settingImage ,
                            for: UIControl.State.normal)
        leftButton.addTarget(self,
                              action: #selector(self.moveToSettingContactScreen),
                              for: UIControl.Event.touchUpInside)
        let leftBarButton = UIBarButtonItem()
        leftBarButton.customView = leftButton
        self.navigationItem.leftBarButtonItem = leftBarButton
        self.navigationItem.setLeftBarButtonItems([negativeSpacer, leftBarButton],
                                                   animated: false)
    }
    
    /*
     @description : Method is being used to manage action on logout button
     Parameters: NA
     return : NA
     */
    @objc func moveToLoginScreen() {
        DataManager.isLogin = false
        DocumentDirecotoryOperations.removeContacts()
        //        navigationController?.popViewController(animated: true)
        guard let vc = UIStoryboard.init(name: Constants.StoryBoardIdentifiers.kStoryboardMain,
                                         bundle: Bundle.main).instantiateViewController(withIdentifier: Constants.ViewControllerIdentiFiers.kLoginViewController) as? LoginViewController else {
                                            return
        }
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
   
    /*
     @description : Method is being used to capture photo
     Parameters: NA
     sender: Uibutton is being used to 
     return : NA
     */
    @IBAction func capturePhotoAction(_ sender: UIButton) {
        AppUtility.lockOrientation(.portrait)
        
        guard let vc = UIStoryboard.init(name: Constants.StoryBoardIdentifiers.kStoryboardMain,
                                         bundle: Bundle.main).instantiateViewController(withIdentifier: Constants.ViewControllerIdentiFiers.kImageCaptureViewController) as? ImageCaptureViewController else {
                                            return
        }
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    /*
     @description : Method is being used to capture video
     Parameters: NA
     sender: Uibutton is being used to
     return : NA
     */
    @IBAction func captureVideoAction(_ sender: UIButton) {
        AppUtility.lockOrientation(.portrait)
        
        guard let vc = UIStoryboard.init(name: Constants.StoryBoardIdentifiers.kStoryboardMain,
                                         bundle: Bundle.main).instantiateViewController(withIdentifier: Constants.ViewControllerIdentiFiers.kVideoRecordViewController) as? VideoRecordViewController else {
                                            return
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    /*
     @description : Method is being used to capture video
     Parameters: NA
     sender: Uibutton is being used to
     return : NA
     */
    @IBAction func getSavedPhotoVideoAction(_ sender: UIButton) {
        let urlOfFiles = DocumentDirecotoryOperations.getListOfFiles(orderToFetch: .ascending)
        if urlOfFiles.count > 0 {
            guard let vc = UIStoryboard.init(name: Constants.StoryBoardIdentifiers.kStoryboardMain,
                                             bundle: Bundle.main).instantiateViewController(withIdentifier: Constants.ViewControllerIdentiFiers.kPhotoVideoCollectionViewController) as? PhotoVideoCollectionViewController else {
                                                return
            }
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            Utility.alertContoller(title: Utility.localized(key: "kMessage"),
                                   message: Utility.localized(key: "kNoLoacalFile"),
                                   actionTitleFirst: Utility.localized(key: "kOk"),
                                   actionTitleSecond: "",
                                   firstActoin: nil, secondAction: nil,
                                   controller: self)
        }
    }
    
    /*
     @description : Mehtod is being used to open thumbnail screen
     Parameters: NA
     sender: Uibutton is being used to
     return : NA
     */
    @IBAction func downloadMediaFileAction(_ sender: Any) {
        guard let vc = UIStoryboard.init(name: Constants.StoryBoardIdentifiers.kStoryboardMain,
                                         bundle: Bundle.main).instantiateViewController(withIdentifier: Constants.ViewControllerIdentiFiers.kShareMediaThumbnailPreviewController) as? ShareMediaThumbnailPreviewController else {
                                            return
        }
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    /*
     @description : Method is being used to sync data which is right now locally
     Parameters: NA
     sender: Uibutton is being used to
     return : NA
     */
    @IBAction func syncDataAction(_ sender: UIButton) {
        let urlOfFiles = DocumentDirecotoryOperations.getListOfFiles(orderToFetch: .ascending)
        if urlOfFiles.count > 0 {
            if isSyncDataRunning == false {
                HISActivityIndicator.start()
                isSyncDataRunning = true
                self.activityI.isHidden = true
                activityI.startAnimating()
                syncDataButton.setTitle(Utility.localized(key: "kSynching"), for: .normal)
                //initially first index will be passed
                callApiForUpload(index: 0)
            } else {
                HISActivityIndicator.stop()
                activityI.stopAnimating()
                activityI.isHidden = true
                syncDataButton.setTitle(Utility.localized(key: "kSyncData"), for: .normal)
                if isSyncDataRunning == true {
                    //cancel all request
                    let mediaUploadViewModelObject = MediaUploadViewModel()
                    mediaUploadViewModelObject.cancelAllRequest()
                }
                isSyncDataRunning = false
            }
        }
    }
    /*
     @created Deep Chetu
     @description : Mehtod is being used to open archived images
     Parameters: NA
     sender: Uibutton is being used to
     return : NA
     */
    @IBAction func ArchivedMediaAction(_ sender: UIButton) {
        let urlOfFiles = DocumentDirecotoryOperations.getListOfArchivedFiles(orderToFetch: .ascending)
        if urlOfFiles.count > 0 
        {
//            guard let vc = UIStoryboard.init(name: Constants.StoryBoardIdentifiers.kStoryboardMain,
//                                             bundle: Bundle.main).instantiateViewController(withIdentifier: Constants.ViewControllerIdentiFiers.kArchivedMediaFilesViewController) as? ArchivedMediaFilesViewController else {
//                                                return
//            }
//            self.navigationController?.pushViewController(vc, animated: true)
        }
        else {
            Utility.alertContoller(title: Utility.localized(key: "kMessage"),
                                   message: Utility.localized(key: "kNoLoacalFile"),
                                   actionTitleFirst: Utility.localized(key: "kOk"),
                                   actionTitleSecond: "",
                                   firstActoin: nil, secondAction: nil,
                                   controller: self)
        }
    }
    
    /*
     @description : Method is being used manage orientation of image
     Parameters:
     UIImage: image which is fetched
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
     @description : API is being used to upload the photo
     Parameters: NA
     return : NA
     */
    func callApiForUpload(index: Int)
    {
        let urlOfFiles = DocumentDirecotoryOperations.getListOfFiles(orderToFetch: .ascending)
        var data = Data()
        var dataType: SelectedMediaType!
        let savedMediaParameter : SaveMediaParameter
//        if urlOfFiles.count > 0 {
//            if urlOfFiles[index].absoluteString.contains(Constants.kJpg) {
//                dataType = .photo
//                guard let image = self.rotateImage(image: UIImage(contentsOfFile: urlOfFiles[index].path)) else {
//                    return
//                }
//                data = UIImageJPEGRepresentation(image, 0.6)!
//                let splitArray = urlOfFiles[index].path.components(separatedBy: "\t")
//                let SeparatedateTime = splitArray[1].components(separatedBy: ".")
//                savedMediaParameter = SaveMediaParameter(email: DataManager.email ?? "", password: DataManager.password?.base64String ?? "", lat:splitArray[2], lon:splitArray[3]
//                    , captureDate: SeparatedateTime[0])
//            } else /*if urlOfFiles[index].absoluteString.contains(Constants.kMp4)*/{
//                if let videoData = try? Data(contentsOf: urlOfFiles[index]) {
//                    data = videoData
//                }
//                dataType = .video
//                let splitArray = urlOfFiles[index].path.components(separatedBy: "\t")
//                savedMediaParameter = SaveMediaParameter(email: DataManager.email ?? "", password: DataManager.password?.base64String ?? "", lat:splitArray[2], lon:splitArray[3]
//                    , captureDate: splitArray[1])
//            }
//
//
//            let mediaUploadViewModelObject = MediaUploadViewModel()
//            debugPrint(urlOfFiles[index].path)
//            mediaUploadViewModelObject.callSecureServiceForUploadMedia(saveMediaParameter: savedMediaParameter, mediaData: data, uploadedMediaType: dataType, fileName: urlOfFiles[index].path) { [weak self] (registerResponse, error) in
//                DispatchQueue.main.async {
//                    if let strongSelf = self {
//                        if error == nil {
//                            //delete file from local after successful upload
//                            debugPrint("file to be delete" + urlOfFiles[index].path)
//                            DocumentDirecotoryOperations.deleteParticularFileFromDocumentDirectory(pathOfFile: urlOfFiles[index])
//                            DocumentDirecotoryOperations.saveMediaIntoTheArchivedDirectory(typeOfMedia: dataType, controller: self!, photoVideoData: data as Data) { (isPhotoSaved) in
//                                if !isPhotoSaved {
//                                    debugPrint("error")
//
//                                } else {
//                                    debugPrint("saved")
//                                }
//                            }
//                            strongSelf.badgeButton.setTitle("\(DocumentDirecotoryOperations.getListOfFiles(orderToFetch: .ascending).count)", for: .normal)
//                            strongSelf.callApiForUpload(index: index)
//                        } else {
//                            if (error?.description ?? "") != Constants.kCancelByUser {
//                                debugPrint("error occured")
//                                //if fail then pass the next media to server
//                                if index + 1 < urlOfFiles.count {
//                                    strongSelf.callApiForUpload(index: index + 1)
//                                } else {
//                                    //if all index has been gone through the server then reset the setting
//                                    if urlOfFiles.count == 0 {
//                                        strongSelf.badgeButton.isHidden = true
//                                    }
//                                    strongSelf.isSyncDataRunning = false
//                                    self?.activityI.stopAnimating()
//                                    self?.activityI.isHidden = true
//                                    //                                    DocumentDirecotoryOperations.deleteParticularFileFromDocumentDirectory(pathOfFile: urlOfFiles[index])
//                                    //                                    DocumentDirecotoryOperations.saveMediaIntoTheArchivedDirectory(typeOfMedia: dataType, controller: self!, photoVideoData: data as Data) { (isPhotoSaved) in
//                                    //                                        if !isPhotoSaved {
//                                    //                                            debugPrint("error")
//                                    //
//                                    //                                        } else {
//                                    //                                            debugPrint("saved")
//                                    //                                        }
//                                    //                                    }
//                                    HISActivityIndicator.stop()
//                                    strongSelf.syncDataButton.setTitle(Utility.localized(key: "kSyncData"), for: .normal)
//                                }
//                            }
//                        }
//                    }
//                }
//            }
//        } else {
//            HISActivityIndicator.stop()
//            self.activityI.stopAnimating()
//            self.activityI.isHidden = true
//
//            badgeButton.isHidden = true
//            isSyncDataRunning = false
//            syncDataButton.setTitle(Utility.localized(key: "kSyncData"), for: .normal)
//        }
    }
    
    /*
     @description : API is being used to upload the emergency image
     Parameters: NA
     return : NA
     */
    
    func uploadEmergencyImage()
    {
//        var data = Data()
//        var dataType: SelectedMediaType!
//        let savedMediaParameter : SaveMediaParameter
//        
//        dataType = .photo
//        guard let image = self.rotateImage(image: UIImage(contentsOfFile: fileDetailsForEmergency)) else {
//            return
//        }
//        data = UIImageJPEGRepresentation(image, 0.6)!
//        let splitArray = fileDetailsForEmergency.components(separatedBy: "\t")
//        let SeparatedateTime = splitArray[1].components(separatedBy: ".")
//        savedMediaParameter = SaveMediaParameter(email: DataManager.email ?? "", password: DataManager.password?.base64String ?? "", lat:splitArray[2], lon:splitArray[3]
//            , captureDate: SeparatedateTime[0])
        
        
//        let mediaUploadViewModelObject = MediaUploadViewModel()
//        mediaUploadViewModelObject.callSecureServiceForUploadMedia(saveMediaParameter: savedMediaParameter, mediaData: data, uploadedMediaType: dataType, fileName: fileDetailsForEmergency) { [weak self] (registerResponse, error) in
//            DispatchQueue.main.async {
//                if let strongSelf = self {
//                    if error == nil {
//                        //delete file from local after successful upload
//                        //                        debugPrint("file to be delete" + self?.fileDetailsForEmergency)
//                        DocumentDirecotoryOperations.deleteParticularFileFromDocumentDirectory(pathOfFile: self!.fileDetailsForEmergencyURL!)
//                        DocumentDirecotoryOperations.saveMediaIntoTheArchivedDirectory(typeOfMedia: dataType, controller: self!, photoVideoData: data as Data) { (isPhotoSaved) in
//                            if !isPhotoSaved {
//                                debugPrint("error")
//
//                            } else {
//                                debugPrint("saved")
//                            }
//                        }
//                        if((DocumentDirecotoryOperations.getListOfFiles(orderToFetch: .ascending).count) == 0){
//                            strongSelf.badgeButton.isHidden = true
//                        }
//                        else{
//                            strongSelf.badgeButton.setTitle("\(DocumentDirecotoryOperations.getListOfFiles(orderToFetch: .ascending).count)", for: .normal)
//                        }
//
//                    } else {
//                    }
//                }
//            }
//        }
    }
    /*
     @description : API is being used to upload the emergency video
     Parameters: NA
     return : NA
     */
    
    func uploadEmergencyVideo(){
        var data = Data()
        var dataType: SelectedMediaType!
        let savedMediaParameter : SaveMediaParameter
        
        if let videoData = try? Data(contentsOf: fileDetailsForEmergencyURL) {
            data = videoData
        }
        dataType = .video
        let splitArray = fileDetailsForEmergencyURL.path.components(separatedBy: "\t")
        savedMediaParameter = SaveMediaParameter(email: DataManager.email ?? "", password: DataManager.password?.base64String ?? "", lat:splitArray[2], lon:splitArray[3]
            , captureDate: splitArray[1])
        
        
        let mediaUploadViewModelObject = MediaUploadViewModel()
        mediaUploadViewModelObject.callSecureServiceForUploadMedia(saveMediaParameter: savedMediaParameter, mediaData: data, uploadedMediaType: dataType, fileName: fileDetailsForEmergency) { [weak self] (registerResponse, error) in
            DispatchQueue.main.async {
                if let strongSelf = self {
                    if error == nil {
                        //delete file from local after successful upload
                        //                        debugPrint("file to be delete" + self?.fileDetailsForEmergency)
                        DocumentDirecotoryOperations.deleteParticularFileFromDocumentDirectory(pathOfFile: self!.fileDetailsForEmergencyURL)
                        DocumentDirecotoryOperations.saveMediaIntoTheArchivedDirectory(typeOfMedia: dataType, controller: self!, photoVideoData: data as Data) { (isPhotoSaved) in
                            if !isPhotoSaved {
                                debugPrint("error")
                                
                            } else {
                                debugPrint("saved")
                            }
                        }
                        if((DocumentDirecotoryOperations.getListOfFiles(orderToFetch: .ascending).count) == 0){
                            strongSelf.badgeButton.isHidden = true
                        }
                        else{
                            strongSelf.badgeButton.setTitle("\(DocumentDirecotoryOperations.getListOfFiles(orderToFetch: .ascending).count)", for: .normal)
                        }
                        
                    } else {
                    }
                }
            }
        }
    }
    
    @IBAction func emergencyButtonAction(_ sender: UIButton) {
        
        
        let actionSheetController: UIAlertController = UIAlertController(title: Utility.localized(key: "kChooseMedia"), message: "", preferredStyle: .actionSheet)
        
        let cancelActionButton = UIAlertAction(title: Utility.localized(key: "kCancel"), style: .cancel) { _ in
        }
        actionSheetController.addAction(cancelActionButton)
        
        let takePhotoActionButton = UIAlertAction(title: Utility.localized(key: "kCapture_Photo"), style: .default)
        { _ in
            AppUtility.lockOrientation(.portrait)
            if(DocumentDirecotoryOperations.getContactFromCache().count > 0){
                guard let vc = UIStoryboard.init(name: Constants.StoryBoardIdentifiers.kStoryboardMain,
                                                 bundle: Bundle.main).instantiateViewController(withIdentifier: Constants.ViewControllerIdentiFiers.kImageCaptureViewController) as? ImageCaptureViewController else {
                                                    return
                }
                vc.fromEmergency = true
                self.navigationController?.pushViewController(vc, animated: true)
            }
            else {
                guard let vc = UIStoryboard.init(name: Constants.StoryBoardIdentifiers.kStoryboardMain,
                                                 bundle: Bundle.main).instantiateViewController(withIdentifier: Constants.ViewControllerIdentiFiers.kAddContactViewController) as? AddContactViewController else {
                                                    return
                }
                vc.fromAdd = true
                self.navigationController?.pushViewController(vc, animated: true)
                Utility.alertContoller(title: Utility.localized(key: "kMessage"),
                                       message: Utility.localized(key: "kPleaseAddContactToEnableThisFeature"),
                                       actionTitleFirst: Utility.localized(key: "kOk"),
                                       actionTitleSecond: "",
                                       firstActoin: nil, secondAction: nil,
                                       controller: self)
            }
        }
        actionSheetController.addAction(takePhotoActionButton)
        
        let takeVideoActionButton = UIAlertAction(title: Utility.localized(key: "kCapture_Video"), style: .default)        { _ in
            AppUtility.lockOrientation(.portrait)
            if(DocumentDirecotoryOperations.getContactFromCache().count > 0){
                guard let vc = UIStoryboard.init(name: Constants.StoryBoardIdentifiers.kStoryboardMain,
                                                 bundle: Bundle.main).instantiateViewController(withIdentifier: Constants.ViewControllerIdentiFiers.kVideoRecordViewController) as? VideoRecordViewController else {
                                                    return
                }
                vc.fromEmergency = true
                
                self.navigationController?.pushViewController(vc, animated: true)
            }
            else{
                guard let vc = UIStoryboard.init(name: Constants.StoryBoardIdentifiers.kStoryboardMain,
                                                 bundle: Bundle.main).instantiateViewController(withIdentifier: Constants.ViewControllerIdentiFiers.kAddContactViewController) as? AddContactViewController else {
                                                    return
                }
                vc.fromAdd = true
                self.navigationController?.pushViewController(vc, animated: true)
                Utility.alertContoller(title: Utility.localized(key: "kMessage"),
                                       message: Utility.localized(key: "kPleaseAddContactToEnableThisFeature"),
                                       actionTitleFirst: Utility.localized(key: "kOk"),
                                       actionTitleSecond: "",
                                       firstActoin: nil, secondAction: nil,
                                       controller: self)
            }
        }
        actionSheetController.addAction(takeVideoActionButton)
        
        let addContactActionButton = UIAlertAction(title: Utility.localized(key: "kViewContact"), style: .destructive)
        { _ in
            guard let vc = UIStoryboard.init(name: Constants.StoryBoardIdentifiers.kStoryboardMain,
                                             bundle: Bundle.main).instantiateViewController(withIdentifier: Constants.ViewControllerIdentiFiers.kViewContactViewController) as? ViewContactViewController else {
                                                return
            }
            self.navigationController?.pushViewController(vc, animated: true)
        }
        actionSheetController.addAction(addContactActionButton)
        self.present(actionSheetController, animated: true, completion: nil)
    }
    /*
     @description : Method is being used to redirect the user to contact screen.
     Parameters: NA
     return : NA
     */
    @objc func moveToSettingContactScreen() {
        
        guard let contactVc = UIStoryboard.init(name: Constants.StoryBoardIdentifiers.kStoryboardMain,
                                                bundle: Bundle.main).instantiateViewController(withIdentifier: Constants.ViewControllerIdentiFiers.kViewContactViewController) as? ViewContactViewController else {
                                                    return
        }
        self.navigationController?.pushViewController(contactVc, animated: true)
    }
    
    
    func sendMessage(){
        if (MFMessageComposeViewController.canSendText()) {
          
            UIBarButtonItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.black], for: [])
            let controller = MFMessageComposeViewController()
            
            guard let image = self.rotateImage(image: UIImage(contentsOfFile: fileDetailsForEmergency)) else {
                return
            }
            if(MFMessageComposeViewController.canSendAttachments()){
                print("ok")
            }
            let  dataImg = image.pngData() as! Data;//Add the image as attachment
            
            controller.addAttachmentData(dataImg, typeIdentifier: Utility.localized(key: "kpublic.data"), filename: Utility.localized(key: "kimage.png"))
            
            controller.recipients = (DocumentDirecotoryOperations.fetchContactNumbers() as! [String])
            controller.messageComposeDelegate = self
            self.present(controller, animated: true, completion: nil)
        }
    }
    func sendVideoMessage(){
        if (MFMessageComposeViewController.canSendText()) {
            UIBarButtonItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.black], for: [])

            let controller = MFMessageComposeViewController()
            
            var data : Data? = nil
            if let videoData = try? Data(contentsOf: fileDetailsForEmergencyURL) as Data
            {
                data = videoData
            }
            controller.addAttachmentData(data as! Data, typeIdentifier: Utility.localized(key: "kpublic.data"), filename: Utility.localized(key: "kvideo.mp4"))
            
            controller.recipients = (DocumentDirecotoryOperations.fetchContactNumbers() as! [String])
            controller.messageComposeDelegate = self
            self.present(controller, animated: true, completion: nil)
        }
    }
}
//MARK: Custom Image Picker Delegatesextension
extension HomeViewController : ImagePickerDelegate {
    /*
     @description : deleegate method to get the path of video
     Parameters:
     pathOfVideo: path of video
     return : NA
     */
    func didPickVideo(_ pathOfVideo: URL) {
        guard let vc = UIStoryboard.init(name: Constants.StoryBoardIdentifiers.kStoryboardMain,
                                         bundle: Bundle.main).instantiateViewController(withIdentifier: Constants.ViewControllerIdentiFiers.kVideoPreviewController) as? VideoPreviewController else {
                                            return
        }
        vc.urlOfSavedVideo = pathOfVideo
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    /*
     @description : deleegate method to get the path of video
     Parameters:
     image: image which is fetched
     return : NA
     */
    func didPickImage(_ image: UIImage) {
        guard let vc = UIStoryboard.init(name: Constants.StoryBoardIdentifiers.kStoryboardMain,
                                         bundle: Bundle.main).instantiateViewController(withIdentifier: Constants.ViewControllerIdentiFiers.kPreviewViewController) as? PreviewViewController else {
                                            return
        }
        //vc.previewImage = image
        self.navigationController?.pushViewController(vc, animated: true)        
    }
    
}
extension HomeViewController : MFMessageComposeViewControllerDelegate {
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        print(result)
        //        print("Emailing attempt, error="+(error?.localizedDescription)!)
        switch (result){
        case .cancelled:
            print("Message cancelled");
            break;
        case .sent:
            if(fileDetailsForEmergency.contains(".mp4"))
            {
                uploadEmergencyVideo()
            }
            else{
                uploadEmergencyImage()
            }
            print("Mail sent");
            
            break;
        case .failed:
            print("Mail sent failure: %@", "error?.localizedDescription");
            break;
        default:
            break;
        }
        // Close the Mail Interface
        controller.dismiss(animated: true)
        UIBarButtonItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.black], for: [])

    }
    
    
}
