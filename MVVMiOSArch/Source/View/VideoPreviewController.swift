//
//  VideoPreviewController.swift
//  WatchMyBack
//
//  Created by Chetu on 7/4/18.
//  Copyright © 2018 LocatorTechnologies. All rights reserved.
//

import UIKit
import MediaPlayer
import AVKit

class VideoPreviewController: BaseViewController {
    //MARK: IBOutlets
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var thumbnailImageView: UIImageView!
    
    //MARK: Variables
    var urlOfSavedVideo: URL!
    var playerViewController: AVPlayerViewController! = nil
    
    //MARK: Life cycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpCommonUI()
        setTitle(title: Utility.localized(key: "kPreview"))
        setBackButton()
        setBarButton()
    }

    /*
     @description : Method is being used to manage User interface when screen will appear
     Parameters: NA
     return : NA
     */
    func setUpCommonUI() {
        if let urlOfVideo = urlOfSavedVideo {
            DispatchQueue.main.async { [weak self] in
            self?.thumbnailImageView.image = Utility.generateThumbImage(urlOfVideo, controller: self)
            }
        }
    }
    
    /*
     @description : Method is being used add save bar button
     Parameters: NA
     return : NA
     */
    func setBarButton() {
        let negativeSpacer = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.fixedSpace,
                                             target: nil,
                                             action: nil)
        negativeSpacer.width = -10;
        //Set Profile Icon Button
        let rightButton = UIButton(type: .system)
        rightButton.frame =  CGRect(origin: CGPoint(x: 0,y :0),
                                    size: CGSize(width: 50, height: 30))
        rightButton.setTitle( Utility.localized(key: "kSync"),
                              for: UIControl.State.normal)
        rightButton.setTitleColor(UIColor.white, for: UIControl.State.normal)

        rightButton.addTarget(self, action: #selector(self.saveImageToDocumentDirectory),
                              for: UIControl.Event.touchUpInside)
        let rightBarButton = UIBarButtonItem()
        rightBarButton.customView = rightButton
        self.navigationItem.rightBarButtonItem = rightBarButton
        self.navigationItem.setRightBarButtonItems([negativeSpacer, rightBarButton],
                                                   animated: false)
    }
    
    /*
     @description : Method is being used to save image into directory
     Parameters: NA
     return : NA
     */
    @objc func saveImageToDocumentDirectory() {
//        let savedMediaParameter = SaveMediaParameter(email: DataManager.email ?? "", password: DataManager.password?.base64String ?? "", lat: "", lon: "", captureDate: "de")
        let splitArray = urlOfSavedVideo.path.components(separatedBy: "\t")
        let savedMediaParameter = SaveMediaParameter(email: DataManager.email ?? "", password: DataManager.password?.base64String ?? "", lat:splitArray[2], lon:splitArray[3]
            , captureDate: splitArray[1])
        HISActivityIndicator.start()
        if let videodata = try? Data(contentsOf: urlOfSavedVideo) {
            let mediaUploadViewModelObject = MediaUploadViewModel()
            mediaUploadViewModelObject.callSecureServiceForUploadMedia(saveMediaParameter: savedMediaParameter, mediaData: videodata, uploadedMediaType: .video, fileName: urlOfSavedVideo.path) { [weak self] (registerResponse, error) in
                DispatchQueue.main.async {
                    HISActivityIndicator.stop()
                    if let strongSelf = self {
                        if error == nil {
                            //delete file from local after sucessful upload
                            if let urlOfFile = strongSelf.urlOfSavedVideo {
                                DocumentDirecotoryOperations.deleteParticularFileFromDocumentDirectory(pathOfFile: urlOfFile)
                                DocumentDirecotoryOperations.saveMediaIntoTheArchivedDirectory(typeOfMedia: .video
                                , controller: self!, photoVideoData: videodata as Data) { (isPhotoSaved) in
                                    if !isPhotoSaved {
                                        debugPrint("error")
                                        
                                    } else {
                                        debugPrint("saved")
                                    }
                                }
                            }
                            Utility.alertContoller(title: Utility.localized(key: "kMessage"),
                                                   message: Utility.localized(key: "kVideoUploadedSuccessfully"),
                                                   actionTitleFirst: Utility.localized(key: "kOk"),
                                                   actionTitleSecond: "",
                                                   firstActoin: #selector(self?.popViewController), secondAction: nil,
                                                   controller: self)
                        } else {
                            Utility.alertContoller(title: Utility.localized(key: "kMessage"),
                                                   message: error?.description ?? "",
                                                   actionTitleFirst: Utility.localized(key: "kOk"),
                                                   actionTitleSecond: "", firstActoin: nil,
                                                   secondAction: nil,
                                                   controller: strongSelf)
                        }
                    }
                }
            }
        }
    }
    
    /*
     @description : Method is being used to navigating back
     Parameters: NA
     return : NA
     */
    @objc func popViewController() {
        navigationController?.popViewController(animated: true)
    }
    
    
    /*
     @description : Method is being used to play the saved video
     Parameters: NA
     sender: Uibutton is being used to
     return : NA
     */
    @IBAction func videoPlayAction(_ sender: Any) {
        if let url = urlOfSavedVideo {
            let player = AVPlayer(url: url)
            playerViewController = AVPlayerViewController()
            playerViewController.player = player
        }
        self.present(playerViewController, animated: true) {
            self.playerViewController.player?.play()
            self.playerViewController.addObserver(self, forKeyPath: #keyPath(UIViewController.view.frame), options: [.old, .new], context: nil)
        }
    }
    
    /*
     @description : Method is being used to hold the observer value
     Parameters:
     keyPath : for which properties corresponding we are observing the property,
     of object:
     change: is being used to hold the refrence of state,
     context: is being used to hold pointer
     return : NA
     */
    override func observeValue(forKeyPath keyPath: String?,
                               of object: Any?,
                               change: [NSKeyValueChangeKey : Any]?,
                               context: UnsafeMutableRawPointer?)
    {
        //Player view is out of the screen and
        //You can do your custom actions
        playerViewController.removeObserver(self, forKeyPath: #keyPath(UIViewController.view.frame))
    }
    
}

