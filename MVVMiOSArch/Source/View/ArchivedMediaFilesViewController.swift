//
//  ArchivedMediaFilesViewController.swift
//  WatchMyBack
//
//  Created by Chetu on 10/31/18.
//  Copyright © 2018 LocatorTechnologies. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation
import MessageUI

class ArchivedMediaFilesViewController: BaseViewController,MFMailComposeViewControllerDelegate {
    
    //MARK: IBOutlets And variables
    @IBOutlet weak var preViewCollectionView: UICollectionView!
    var playerViewController: AVPlayerViewController! = nil
    var urlOfFiles = [URL]()
    var arrayOfSelectedMediaData = [SelectedMediaData]()
    var rightButton: UIButton! = nil
    var  isSelectedModeEnable = false
    
    //MARK: Life cycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        preViewCollectionView.delegate = self
        preViewCollectionView.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        arrayOfSelectedMediaData.removeAll()
        urlOfFiles = DocumentDirecotoryOperations.getListOfArchivedFiles(orderToFetch: .descending)
        preViewCollectionView.reloadData()
        setTitle(title: Utility.localized(key: "kArchivedMediaFiles"))
        setBackButton()
        setBarButton()
        managelBarButton()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setToolbarHidden(true, animated: true)
    }
    
    //MARK: Delegate method for the screen rotation
    override func willRotate(to toInterfaceOrientation: UIInterfaceOrientation, duration: TimeInterval) {
        preViewCollectionView.reloadData()
    }
    
    /*
     @description : Method is being used add logout bar button
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
        managelBarButton()
    }
    
    /*
     @description : Method is being used to set up mail composer controller
     Parameters: NA
     return : MFMailComposeViewController
     */
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self
//            as! MFMailComposeViewControllerDelegate
        mailComposerVC.setSubject(Utility.localized(key: "kWatchMyBagMedia"))
        for counter in 0 ..< arrayOfSelectedMediaData.count{
            if (arrayOfSelectedMediaData[counter].urlOfMedia?.path.contains(Constants.kJpg)) ?? false {
                if let image = UIImage(contentsOfFile:(arrayOfSelectedMediaData[counter].urlOfMedia?.path) ?? "") {
                    let data = UIImageJPEGRepresentation(image, 0.6)
                    mailComposerVC.addAttachmentData(data ?? Data(), mimeType: Constants.kimagejpg, fileName: "\(Utility.localized(key: "kImage"))" + "\(counter+1)")
                }
            } else if (arrayOfSelectedMediaData[counter].urlOfMedia?.path.contains(Constants.kMp4)) ?? false{
                do {
                    let data = try Data(contentsOf: arrayOfSelectedMediaData[counter].urlOfMedia ?? URL(fileURLWithPath: ""))
                    mailComposerVC.addAttachmentData(data, mimeType: Constants.kvideomp4, fileName: "\(Utility.localized(key: "kVideo"))" + "\(counter+1)")
                } catch {
                    debugPrint("error occured")
                }
            }
        }
        return mailComposerVC
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
     @description : Method is being perfome delete action on document directory file
     Parameters : N/A
     return : N/A
     */
    @objc func onClickedToolbeltButton() {
        if arrayOfSelectedMediaData.count > 0 {
            for item in arrayOfSelectedMediaData {
                if let urlOfMedia = item.urlOfMedia {
                    DocumentDirecotoryOperations.deleteParticularFileFromDocumentDirectory(pathOfFile: urlOfMedia)
                }
            }
            
            arrayOfSelectedMediaData.removeAll()
            urlOfFiles = DocumentDirecotoryOperations.getListOfArchivedFiles(orderToFetch: .descending)
            preViewCollectionView.reloadData()
            
        }
        else {
            Utility.alertContoller(title: Utility.localized(key: "kMessage"),
                                   message: Utility.localized(key: "kPleaseSelectOneMedia"),
                                   actionTitleFirst: Utility.localized(key: "kOk"),
                                   actionTitleSecond: "",
                                   firstActoin: nil,
                                   secondAction: nil,
                                   controller: self)
        }
        managelBarButton()
    }
    
    /*
     @description : Method is being used to manage bar button
     Parameters : N/A
     return : N/A
     */
    func managelBarButton()  {
        if urlOfFiles.count > 0 {
            rightButton.isHidden = false
        } else {
            rightButton.isHidden = true
            self.navigationController?.setToolbarHidden(true, animated: true)
        }
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
            preViewCollectionView.reloadData()
            setToolbarButton()
        } else {
            isSelectedModeEnable = false
            self.navigationController?.setToolbarHidden(true, animated: true)
            rightButton.setTitle(Utility.localized(key: "kSelect"), for: .normal)
            arrayOfSelectedMediaData.removeAll()
            preViewCollectionView.reloadData()
        }
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
            UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(self.openMfMailComposer))
        )
        items.append(
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        )
        items.append(
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        )
        items.append(
            UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(self.onClickedToolbeltButton))
        )
        items.append(
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        )
        
        self.navigationController?.toolbar.items = items
        disableBarButton()
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
    
}
extension ArchivedMediaFilesViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return urlOfFiles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.CellIdentifiers.kPhotoVideoCollectionViewCell, for: indexPath) as! PhotoVideoCollectionViewCell
        cell.playButton.tag = 1000 + indexPath.row
        cell.playButton.isUserInteractionEnabled = false
        if urlOfFiles[indexPath.row].absoluteString.contains(Constants.kJpg) {
            cell.playButton.isHidden = true
            cell.thumbImageView.image = UIImage(contentsOfFile: urlOfFiles[indexPath.row].path)
        } else if urlOfFiles[indexPath.row].absoluteString.contains(Constants.kMp4){
            //_ = isSelectedModeEnable ? (cell.playButton.isEnabled = false) : (cell.playButton.isEnabled = true)
            cell.playButton.isHidden = false
            cell.thumbImageView.image = Utility.generateThumbImage(urlOfFiles[indexPath.row], controller: self)
            //cell.playButton.addTarget(self, action: #selector(self.playVideo(sender:)), for: .touchUpInside)
        }
        
        //check for tick mark
        _ = SelectedMediaData(indexOfMedia: indexPath.row, urlOfMedia: urlOfFiles[indexPath.row])
        let selectedData = SelectedMediaData(indexOfMedia: indexPath.row, urlOfMedia: urlOfFiles[indexPath.row])
        if let _ = arrayOfSelectedMediaData.index(where: { $0.urlOfMedia == selectedData.urlOfMedia }) {
            cell.selectButton.setBackgroundImage(#imageLiteral(resourceName: "tickIcon"), for: UIControl.State.normal)
        } else {
            cell.selectButton.setBackgroundImage(nil, for: UIControl.State.normal)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: ((collectionView.bounds.size.width - 5) / 4), height: (collectionView.bounds.size.width - 5) / 4)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if rightButton.title(for: .normal) == Constants.kCancel {
            guard let cell = collectionView.cellForItem(at: indexPath) as? PhotoVideoCollectionViewCell else {
                return
            }
            let selectedData = SelectedMediaData(indexOfMedia: indexPath.row, urlOfMedia: urlOfFiles[indexPath.row])
            if let index = arrayOfSelectedMediaData.index(where: { $0.urlOfMedia == selectedData.urlOfMedia }) {
                arrayOfSelectedMediaData.remove(at: index)
                cell.selectButton.setBackgroundImage(nil, for: UIControl.State.normal)
            } else {
                arrayOfSelectedMediaData.append(selectedData)
                cell.selectButton.setBackgroundImage(#imageLiteral(resourceName: "tickIcon"), for: UIControl.State.normal)
            }
            
            if arrayOfSelectedMediaData.count > 0 {
                enableBarButton()
            } else {
                disableBarButton()
            }
        }else{
            if urlOfFiles[indexPath.row].path.contains(Constants.kJpg) {
                guard let vc = UIStoryboard.init(name: Constants.StoryBoardIdentifiers.kStoryboardMain,
                                                 bundle: Bundle.main).instantiateViewController(withIdentifier: Constants.ViewControllerIdentiFiers.kPreviewViewController) as? PreviewViewController else {
                                                    return
                }
                vc.urlOfSavedImage = urlOfFiles[indexPath.row]
                vc.fromArchivedMedia = true
                self.navigationController?.pushViewController(vc, animated: true)
            } else {
                guard let vc = UIStoryboard.init(name: Constants.StoryBoardIdentifiers.kStoryboardMain,
                                                 bundle: Bundle.main).instantiateViewController(withIdentifier: Constants.ViewControllerIdentiFiers.kVideoPreviewController) as? VideoPreviewController else {
                                                    return
                }
                vc.urlOfSavedVideo = urlOfFiles[indexPath.row]
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 1, bottom: 0, right: 1)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1.0
    }
}
