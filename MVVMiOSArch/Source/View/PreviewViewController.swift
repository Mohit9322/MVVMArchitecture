//
//  PreviewViewController.swift
//  WatchMyBack
//
//  Created by Chetu on 7/3/18.
//  Copyright © 2018 LocatorTechnologies. All rights reserved.
//

import UIKit

class PreviewViewController: BaseViewController {

    //MARK: IBOutlet and variable
    @IBOutlet weak var previewImageView: UIImageView!
    var urlOfSavedImage: URL!
    var mediaId: String? = nil
    var fromShareMedia = false
    var fromArchivedMedia = false
    var urlOfSharedMedia: String!
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
        if(!fromShareMedia && !fromArchivedMedia)
        {
            setBarButton()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    /*
     @description : Method is being used to manage User interface when screen will appear
     Parameters: NA
     return : NA
     */
    func setUpCommonUI() {
        if(!fromShareMedia){
            previewImageView.image = UIImage(contentsOfFile: urlOfSavedImage.path)
        }
        else{
//            previewImageView.sd_setIndicatorStyle(.gray)
//            previewImageView.sd_setShowActivityIndicatorView(true)
//            previewImageView.sd_setImage(with: URL(string: Constants.urlForDownloadImage + urlOfSharedMedia),
//                                         placeholderImage: nil,
//                                         options: .refreshCached,
//                                         completed: {(image, error, cacheType, imageURL) in
//                                            // Perform operation.
//                                            self.previewImageView.sd_removeActivityIndicator()
//                                            if (image != nil)   {
//                                                self.previewImageView.image = image
//                                            }
//            })
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
        rightButton.setTitle(Utility.localized(key: "kSync"),
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
     @description : Method is being used to save image into directory
     Parameters: NA
     return : NA
     */
    @objc func saveImageToDocumentDirectory() {
        let splitArray = urlOfSavedImage.path.components(separatedBy: "\t")
        let SeparatedateTime = splitArray[1].components(separatedBy: ".")
        let savedMediaParameter = SaveMediaParameter(email: DataManager.email ?? "", password: DataManager.password?.base64String ?? "", lat:splitArray[2], lon:splitArray[3]
            , captureDate: SeparatedateTime[0])

        HISActivityIndicator.start()
        guard let image = self.rotateImage(image: UIImage(contentsOfFile: urlOfSavedImage.path)) else {
            return
        }
        
//        if let data = UIImageJPEGRepresentation(image, 0.6) {
//            let mediaUploadViewModelObject = MediaUploadViewModel()
//            mediaUploadViewModelObject.callSecureServiceForUploadMedia(saveMediaParameter: savedMediaParameter, mediaData: data, uploadedMediaType: .photo, fileName: urlOfSavedImage.path) { [weak self] (mediaId, error) in
//                DispatchQueue.main.async {
//                    HISActivityIndicator.stop()
//                    if let strongSelf = self {
//                        if error == nil {
//                            //delete file from local after sucessful upload
//                            if let urlOfFile = strongSelf.urlOfSavedImage {
//                                DocumentDirecotoryOperations.deleteParticularFileFromDocumentDirectory(pathOfFile: urlOfFile)
//                                DocumentDirecotoryOperations.saveMediaIntoTheArchivedDirectory(typeOfMedia: .photo, controller: self!, photoVideoData: data as Data) { (isPhotoSaved) in
//                                    if !isPhotoSaved {
//                                        debugPrint("error")
//                                        
//                                    } else {
//                                        debugPrint("saved")
//                                    }
//                                }
//                            }
//                            //store latest media ID
//                            DataManager.mediaID = mediaId
//                            strongSelf.mediaId = mediaId
//                            Utility.alertContoller(title: Utility.localized(key: "kMessage"),
//                                                   message: Utility.localized(key: "kImageUploadedSuccessfully"),
//                                                   actionTitleFirst: Utility.localized(key: "kOk"),
//                                                   actionTitleSecond: "",
//                                                   firstActoin: #selector(self?.popViewController) , secondAction: nil,
//                                                   controller: strongSelf)
//                        } else {
//                            Utility.alertContoller(title: Utility.localized(key: "kMessage"),
//                                                   message: error?.description ?? "",
//                                                   actionTitleFirst: Utility.localized(key: "kOk"),
//                                                   actionTitleSecond: "", firstActoin: nil,
//                                                   secondAction: nil,
//                                                   controller: strongSelf)
//                        }
//                    }
//                }
//            }
//        }
    }
    
    /*
     @description : Method is being used to navigating back
     Parameters: NA
     return : NA
     */
    @objc func popViewController() {
        navigationController?.popViewController(animated: true)
    }
    
}
