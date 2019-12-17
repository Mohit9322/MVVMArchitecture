//
//  DownloadPreviewViewController.swift
//  WatchMyBack
//
//  Created by Chetu on 8/16/18.
//  Copyright © 2018 LocatorTechnologies. All rights reserved.
//

import UIKit
import MessageUI
struct SelectedMediaThumbnail {
    var indexOfMedia: Int?
    var urlOfMedia: URL?
}

class ShareMediaThumbnailPreviewController: BaseViewController {
        //MARK: Outlets and variable
    @IBOutlet weak var previewImageView: UIImageView!
    @IBOutlet weak var collectionViewForThumbnailOfMedia: UICollectionView!
    var arrayOfSelectedMediaData = [SelectedMediaThumbnail]()
    var  isSelectedModeEnable = false
    var rightButton: UIButton! = nil
    var idArray = [String]()
    
    //MARK: Life cycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        getAllMediaID()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setTitle(title: Utility.localized(key: "kMediaLink"))
        setBackButton()
        setBarButton()
        self.navigationController?.setToolbarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setToolbarHidden(true, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*@description : Method is being used add logout bar button
     Parameters: NA
     return : NA
     */
    func setBarButton() {
        let negativeSpacer = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        negativeSpacer.width = -10;
        //Set Profile Icon Button
        rightButton = UIButton(type: .system)
        rightButton.setBarButton()
        rightButton.addTarget(self, action: #selector(self.selectMedia), for: UIControl.Event.touchUpInside)
        let rightBarButton = UIBarButtonItem()
        rightBarButton.customView = rightButton
        self.navigationItem.rightBarButtonItem = rightBarButton
        self.navigationItem.setRightBarButtonItems([negativeSpacer, rightBarButton], animated: false)
    }
    
    /*
     @description : Method is being manage action on bar button
     Parameters : N/A
     return : N/A
     */
    @objc func selectMedia()  {
        if rightButton.title(for: .normal) == Constants.kSelect {
            isSelectedModeEnable = true
            self.navigationController?.setToolbarHidden(false, animated: true)
            rightButton.setTitle(Utility.localized(key: "kCancel"), for: .normal)
            collectionViewForThumbnailOfMedia.reloadData()
            setToolbarButton()
        } else {
            isSelectedModeEnable = false
            self.navigationController?.setToolbarHidden(true, animated: true)
            rightButton.setTitle(Utility.localized(key: "kSelect"), for: .normal)
            arrayOfSelectedMediaData.removeAll()
            collectionViewForThumbnailOfMedia.reloadData()
        }
    }
    
    /*
     @description : Selector Method is being used to open mail composer controller
     Parameters: NA
     return : NA
     */
    @objc func openMfMailComposer(){
        if arrayOfSelectedMediaData.count > 0 {
            let mailComposeViewController = configuredMailComposeViewController()
            if MFMailComposeViewController.canSendMail() {
                self.present(mailComposeViewController, animated: false, completion: nil)
            } else {
                self.showSendMailErrorAlert()
            }
        } else {
            Utility.alertContoller(title: Utility.localized(key: "kMessage"),
                                   message: Utility.localized(key: "kPleaseSelectOneMedia"),
                                   actionTitleFirst: Utility.localized(key: "kOk"),
                                   actionTitleSecond: "",
                                   firstActoin: nil,
                                   secondAction: nil,
                                   controller: self)
        }
    }
    
    
    
    /*
     @description : Method is being used to show alert controller
     Parameters: NA
     return : NA
     */
    func showSendMailErrorAlert() {
        Utility.alertContoller(title: Utility.localized(key: "kMessage"),
                               message: Utility.localized(key: "kCheckConfiguration"),
                               actionTitleFirst: Utility.localized(key: "kOk"),
                               actionTitleSecond: "",
                               firstActoin: nil,
                               secondAction: nil,
                               controller: self)
    }
    
    /*
     @description : Method is being used to set up mail composer controller
     Parameters: NA
     return : MFMailComposeViewController
     */
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self
        mailComposerVC.setSubject(Utility.localized(key: "kWatchMyBagMedia"))
        var linkOfMedia = ""
        var counter = 1
        for item in arrayOfSelectedMediaData {
            linkOfMedia += "<a href=\"\(item.urlOfMedia?.absoluteString ?? "")\">Media\(counter)</a><p></p>"
            counter = counter + 1
        }
        mailComposerVC.setMessageBody(linkOfMedia, isHTML: true)
        return mailComposerVC
    }
    
    /*
     @description : Method is being used to set tool bar button
     Parameters : N/A
     return : N/A
     */
    func setToolbarButton()  {
        
        var items = [UIBarButtonItem]()
        items.append(
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        )
        items.append(
            UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(self.openMfMailComposer))
        )
        items.append(
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        )
        items.append(
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        )
        items.append(
            UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(self.shareOnSocialMedia))
        )
        items.append(
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        )
        
        self.navigationController?.toolbar.items = items
        disableBarButton()
    }
    
    
    /*
     @description : Selector Method is being used to open mail composer controller
     Parameters: NA
     return : NA
     */
    @objc func shareOnSocialMedia(){
        if arrayOfSelectedMediaData.count > 1 {
            Utility.alertContoller(title: Utility.localized(key: "kMessage"),
                                   message: Utility.localized(key: "kOnlySingleMediaSharable"),
                                   actionTitleFirst: Utility.localized(key: "kCancel"),
                                   actionTitleSecond: Utility.localized(key: "kOk"),
                                   firstActoin: nil,
                                   secondAction: #selector(ShareMediaThumbnailPreviewController.openActivityShareSheet),
                                   controller: self)
        } else if arrayOfSelectedMediaData.count == 1{
            openActivityShareSheet()
        } else {
            Utility.alertContoller(title: Utility.localized(key: "kMessage"),
                                   message: Utility.localized(key: "kPleaseSelectOneMedia"),
                                   actionTitleFirst: Utility.localized(key: "kOk"),
                                   actionTitleSecond: "",
                                   firstActoin: nil,
                                   secondAction: nil,
                                   controller: self)
        }
    }
    
    /*
     @description : Open sharesheet for the for sharing URL
     Parameters : N/A
     return : N/A
     */
    @objc func openActivityShareSheet(){
        let linkOfMedia = arrayOfSelectedMediaData[arrayOfSelectedMediaData.count - 1].urlOfMedia!
        //let linkOfMedia = "\(arrayOfSelectedMediaData[arrayOfSelectedMediaData.count - 1].urlOfMedia!)"
        let activityViewController = UIActivityViewController(activityItems: [Utility.localized(key: "kMessage"), Utility.localized(key: "kMediaLink"), linkOfMedia], applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
        
        // exclude some activity types from the list (optional)
        activityViewController.excludedActivityTypes = [UIActivity.ActivityType.airDrop,
                                                        UIActivity.ActivityType.copyToPasteboard,
                                                        UIActivity.ActivityType.postToFacebook,
                                                        UIActivity.ActivityType.postToTwitter,
                                                        UIActivity.ActivityType.mail,
                                                        UIActivity.ActivityType.print,
                                                        UIActivity.ActivityType.postToFlickr,
                                                        UIActivity.ActivityType.postToVimeo]
        
        activityViewController.completionWithItemsHandler = { (activityType, completed:Bool, returnedItems:[Any]?, error: Error?) in
            self.arrayOfSelectedMediaData.removeAll()
            self.collectionViewForThumbnailOfMedia.reloadData()
            self.disableBarButton()
            self.viewWillAppear(true)
        }
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    /*
     @description : Method is being used to disable toolbar button
     Parameters : N/A
     return : N/A
     */
    func disableBarButton(){
        for item in (self.navigationController?.toolbar.items)! {
            item.isEnabled = false
        }
    }
    
    
    /*
     @description : Method is being used to enable toolbar button
     Parameters : N/A
     return : N/A
     */
    func enableBarButton(){
        for item in (self.navigationController?.toolbar.items)! {
            item.isEnabled = true
        }
    }
    
    //MARK: Delegate method for the screen rotation
    override func willRotate(to toInterfaceOrientation: UIInterfaceOrientation, duration: TimeInterval) {
        let xPtOffset = xOffSet()
        let app = UIApplication.shared
        switch app.statusBarOrientation {
        case .portrait:
            collectionViewForThumbnailOfMedia.reloadData()
        case .portraitUpsideDown:
            collectionViewForThumbnailOfMedia.reloadData()
            
        case .landscapeLeft:
            collectionViewForThumbnailOfMedia.reloadData()
            
        case .landscapeRight:
            collectionViewForThumbnailOfMedia.reloadData()
            
        default:
            collectionViewForThumbnailOfMedia.reloadData()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.0) { [weak self] in
            self?.collectionViewForThumbnailOfMedia.contentOffset = CGPoint(x: CGFloat(UIScreen.main.bounds.width * xPtOffset), y: (self?.collectionViewForThumbnailOfMedia.contentOffset.y) ?? 0)
        }
    }
    
    
    /*
     @description : Method is being used to provide the x point offset of collection view
     Parameters: N/A
     return : N/A
     */
    func xOffSet() -> CGFloat{
        return collectionViewForThumbnailOfMedia.contentOffset.x / UIScreen.main.bounds.width
    }
    
    /*
     @description : Method is being used to get all media ID
     Parameters: N/A
     return : N/A
     */
    func getAllMediaID()  {
        HISActivityIndicator.start()
        let userLogInParams = MediaIdOfParticularUser(email: DataManager.email ?? "", passWord: DataManager.password?.base64String ?? "")
        let logInViewModel = LoginViewModel()
        
        logInViewModel.getMediaID(getMediaIdOfUser: userLogInParams, serviceType: .getMediaIdForParticularUser) { [weak self] (response, error) in
            DispatchQueue.main.async {
                HISActivityIndicator.stop()
                if let strongSelf = self {
                    if error == nil {
                        strongSelf.idArray = (response?.components(separatedBy: ",")) ?? []
                        if (strongSelf.idArray.count) > 0 && !(strongSelf.idArray[0].isEmpty){
                            strongSelf.collectionViewForThumbnailOfMedia.reloadData()
                        }else {
                            strongSelf.rightButton.isHidden = true
                            strongSelf.navigationController?.setToolbarHidden(true, animated: true)
                            Utility.alertContoller(title: Utility.localized(key: "kMessage"),
                                                   message: Utility.localized(key: "kNoMediaAvailable"),
                                                   actionTitleFirst: Utility.localized(key: "kOk"),
                                                   actionTitleSecond: "", firstActoin: nil,
                                                   secondAction: nil,
                                                   controller: strongSelf)
                        }
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

//MARK: Collection view delegate and datasource method
extension ShareMediaThumbnailPreviewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return idArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.CellIdentifiers.kPhotoVideoCollectionViewCell, for: indexPath) as! PhotoVideoCollectionViewCell
        
        cell.playButton.tag = 1000 + indexPath.row
        cell.playButton.isUserInteractionEnabled = false
        cell.playButton.isHidden = true
    //    cell.thumbImageView.sd_setIndicatorStyle(.gray)
   //     cell.thumbImageView.sd_setShowActivityIndicatorView(true)
 //       cell.thumbImageView.sd_setImage(with: URL(string: Constants.urlForDownloadImage + idArray[indexPath.row]),
//                                        placeholderImage: nil,
//                                        options: .refreshCached,
//                                        completed: {(image, error, cacheType, imageURL) in
//                                            // Perform operation.
//                                            cell.thumbImageView.sd_removeActivityIndicator()
//                                            if (image != nil)   {
//                                                cell.thumbImageView.image = image
//                                            }
//        })
        
        //check for tick mark
        let selectedData = SelectedMediaThumbnail(indexOfMedia: indexPath.row, urlOfMedia: URL(string: Constants.urlForThumbnailImage + idArray[indexPath.row]))
        if let _ = arrayOfSelectedMediaData.index(where: { $0.urlOfMedia == selectedData.urlOfMedia }) {
            cell.selectButton.setBackgroundImage( #imageLiteral(resourceName: "tickIcon"), for: UIControl.State.normal)
        } else {
            cell.selectButton.setBackgroundImage(nil, for: UIControl.State.normal)
        }
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if rightButton.title(for: .normal) == Constants.kCancel {
            guard let cell = collectionView.cellForItem(at: indexPath) as? PhotoVideoCollectionViewCell else {
                return
            }
            let selectedData = SelectedMediaThumbnail(indexOfMedia: indexPath.row, urlOfMedia: URL(string: Constants.urlForThumbnailImage + idArray[indexPath.row]))
            if let index = arrayOfSelectedMediaData.index(where: { $0.urlOfMedia == selectedData.urlOfMedia }) {
                arrayOfSelectedMediaData.remove(at: index)
                cell.selectButton.setBackgroundImage(nil, for: UIControl.State.normal)
            } else {
                arrayOfSelectedMediaData.append(selectedData)
                cell.selectButton.setBackgroundImage( #imageLiteral(resourceName: "tickIcon"), for: UIControl.State.normal)
            }
            
            if arrayOfSelectedMediaData.count > 0 {
                enableBarButton()
            } else {
                disableBarButton()
            }
        }
        else{
            
                guard let vc = UIStoryboard.init(name: Constants.StoryBoardIdentifiers.kStoryboardMain,
                                                 bundle: Bundle.main).instantiateViewController(withIdentifier: Constants.ViewControllerIdentiFiers.kPreviewViewController) as? PreviewViewController else {
                                                    return
                }
                vc.urlOfSharedMedia = idArray[indexPath.row]
                vc.fromShareMedia = true
                self.navigationController?.pushViewController(vc, animated: true)
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: ((collectionView.bounds.size.width - 5) / 4), height: (collectionView.bounds.size.width - 5) / 4)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 1, bottom: 0, right: 1)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1.0
    }
}

//MARK: MFMailcomposer delegate methods
extension ShareMediaThumbnailPreviewController: MFMailComposeViewControllerDelegate{
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        arrayOfSelectedMediaData.removeAll()
        collectionViewForThumbnailOfMedia.reloadData()
        switch result {
        case .cancelled:
            controller.dismiss(animated: true, completion: nil)
            break
            
        case .failed:
            controller.dismiss(animated: true, completion: nil)
            
            break
            
        case .saved:
            controller.dismiss(animated: true, completion: nil)
            break
            
        case .sent:
            controller.dismiss(animated: true, completion: nil)
            break
        }
    }
}
