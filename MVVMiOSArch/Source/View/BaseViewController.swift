//
//  ViewController.swift
//  WatchMyBack
//
//  Created by LocatorTechnologies on 6/25/18.
//  Copyright © 2018 LocatorTechnologies. All rights reserved.
//

import UIKit

//case for selected media
enum SelectedMediaType : String {
    case video = "video"
    case photo = "photo"
}

//case for picking media type
enum MediaSelectionType{
    case camera
    case gallery
}

//Methods for imagepicker delegate
protocol ImagePickerDelegate {
    func didPickImage(_ image: UIImage)
    func didPickVideo(_ pathOfVideo: URL)
}

class BaseViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    //MARK: Image and Video Picking Method
    var imagePickerDelegate: ImagePickerDelegate?
    var imagePicker = UIImagePickerController()
    let backButton = UIButton() //Custom back Button
    
    //MARK: Life cycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
     @description : Method is being used to set the title of the navigation bar
     Parameters:
     title : view controller's title String
     return : NA
     */
    func setBackButton(){
        backButton.frame = CGRect(x: 0, y: 0, width: 42, height: 36)
        backButton.setImage(#imageLiteral(resourceName: "backButton"), for: UIControl.State.normal)
        backButton.contentEdgeInsets = UIEdgeInsets(top: backButton.contentEdgeInsets.top,left: backButton.contentEdgeInsets.left,bottom: backButton.contentEdgeInsets.bottom,right: 20)
        
        backButton .addTarget(self, action: #selector(self.backButtonAction), for: UIControl.Event.touchUpInside)
        let leftBarButton = UIBarButtonItem()
        leftBarButton.customView = backButton
        self.navigationItem.leftBarButtonItem = leftBarButton
        let negativeSpacer =  UIBarButtonItem.init(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        negativeSpacer.width = -10;
        self.navigationItem.setLeftBarButtonItems([negativeSpacer, leftBarButton], animated: false)
    }
    
    /*
     @description : Method is being used to set the title of the navigation bar
     Parameters:
     title : view controller's title String
     return : NA
     */
    func setTitle(title: String) {
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.layer.shadowColor = UIColor.black.cgColor
        self.navigationController?.navigationBar.layer.shadowOffset = .zero
        self.navigationController?.navigationBar.layer.shadowOpacity = 0.4
        self.navigationController?.navigationBar.layer.shadowRadius = 10.0
        self.navigationController?.navigationBar.barTintColor = PrimaryColor.navyBlue(alphaValue: 1.0)
        
        let titleLabel = UILabel(frame: CGRect(x: 50, y:5, width:100, height:18))
        titleLabel.textAlignment = .center
        titleLabel.text = title
        titleLabel.textColor = UIColor.white
        titleLabel.font = UIFont.systemFont(ofSize: 18)
        self.navigationItem.titleView = titleLabel
    }
    
    /*
     @description : Selector method is being used to pop the current view controller
     Parameters: NA
     return : NA
     */
    @objc func backButtonAction() {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    /*
     @description : Method is being used to set image picker controller from the child view controller
     Parameters:
     viewController: is being used to hold the refrence of child view controller
     typeOfMedia: is being used to which type of media we need to present from the picker
     return : NA
     */
    func setUpImagePicker(viewController: UIViewController, typeOfMedia: MediaSelectionType)  {
        imagePicker.delegate = self
        imagePicker.isEditing = true
        if typeOfMedia == .gallery{
            imagePicker.sourceType = .photoLibrary;
        }else{
            //check for camera availability
            if UIImagePickerController.isSourceTypeAvailable(.camera){
                imagePicker.sourceType = .camera
            }else{
                Utility.alertContoller(title: Utility.localized(key: "kMessage"),
                                       message: Utility.localized(key: "kCameraNotAvailable"),
                                       actionTitleFirst: Utility.localized(key: "kOk"),
                                       actionTitleSecond: Utility.localized(key: "kCancel"),
                                       firstActoin: nil,
                                       secondAction: nil,
                                       controller: viewController)
            }
        }
        imagePicker.allowsEditing = true
        viewController.present(imagePicker,
                               animated: true,
                               completion: nil)
    }
    
    /*
     @description : ImagePicker delegate method will be called after picking media
     Parameters:
     picker: controller for picking media
     info: It will provide information about media
     return : NA
     */
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        self.dismiss(animated: false, completion: { () -> Void in
            self.imagePicker.allowsEditing = false
//            if let mediaType = info[UIImagePickerController.InfoKey.mediaType] {
//                //For photo
//                if mediaType  == Constants.kPublicImage {
//                    if (info[UIImagePickerController.InfoKey.originalImage] as? UIImage) != nil{
//                        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
//                        self.imagePickerDelegate?.didPickImage(image)
//                        //Store image to Document directory
//                    }
//                }
//                //For video
//                if mediaType == Constants.kPublicMovie {
//                    let pathOfVideo = info[UIImagePickerControllerMediaURL]
//                        as? URL
//                    do {
//                        //Store video to document directory
//                        let videoData = try Data(contentsOf:pathOfVideo!)
//                        let documentsDirectory = DocumentDirecotoryOperations.getDocumentDirectoryObject()
//                        let filePath =  documentsDirectory?.appendingPathComponent("\(Constants.kVideoStorage)")
//                        let fileURLAlongwithAddedDate = "file://" + ((filePath?.appendingPathComponent("\(Utility.getCurrentDate()).mp4"))?.absoluteString)!
//                        let didPickVideo = NSURL(string: fileURLAlongwithAddedDate)
//                        do{
//                            try videoData.write(to: didPickVideo! as URL)
//                            self.imagePickerDelegate?.didPickVideo(didPickVideo! as URL)
//
//                        }catch {
//                            //alert to show error
//                            Utility.alertContoller(title:Utility.localized(key: "kMessage"),
//                                                   message: (error.localizedDescription),
//                                                   actionTitleFirst: "",
//                                                   actionTitleSecond: Utility.localized(key: "kOk"),
//                                                   firstActoin: nil,
//                                                   secondAction: nil,
//                                                   controller: self)
//                        }
//                    } catch {
//                        Utility.alertContoller(title:Utility.localized(key: "kMessage"),
//                                               message: (error.localizedDescription),
//                                               actionTitleFirst: "",
//                                               actionTitleSecond: Utility.localized(key: "kOk"),
//                                               firstActoin: nil,
//                                               secondAction: nil,
//                                               controller: self)
//                    }
//                }
//            }
        })
    }
}
