//
//  PhotoVideoPreviewController.swift
//  WatchMyBack
//
//  Created by Chetu on 7/10/18.
//  Copyright © 2018 LocatorTechnologies. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

class PhotoVideoPreviewController: BaseViewController {
    
    //MARK: IBOutlets
    @IBOutlet weak var preViewCollectionView: UICollectionView!
    
    //MARK: Variables
    var playerViewController: AVPlayerViewController! = nil
    var urlOfFiles = [URL]()
    var isComingFromCamera = false
    var xPtOffset: CGFloat! = 0.0

    //MARK: Life cycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        preViewCollectionView.delegate = self
        preViewCollectionView.dataSource = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        AppUtility.lockOrientation(.all)
        setUpCommonUI()
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        urlOfFiles = DocumentDirecotoryOperations.getListOfFiles(orderToFetch: .ascending)
        preViewCollectionView.reloadData()
    }
    
    /*
     @description : Method is being used manage back button action
     Parameters: N/A
     return : N/A
     */
    override func backButtonAction() {
        AppUtility.lockOrientation(.portrait)
        navigationController?.popViewController(animated: true)
    }
    
    /*
     @description : Method is being used to set the UI components
     Parameters: N/A
     return : N/A
     */
    func setUpCommonUI()  {
        navigationController?.isNavigationBarHidden = false
        preViewCollectionView.isPagingEnabled = true
        preViewCollectionView.reloadData()
        setTitle(title: Utility.localized(key: "kPreview"))
        setBackButton()

        if isComingFromCamera {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.0) { [weak self] in
                self?.preViewCollectionView?.scrollToItem(at:IndexPath(item: (self?.urlOfFiles.count)! - 1, section: 0), at: .left, animated: false)
            }
        }else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.0) { [weak self] in
                self?.preViewCollectionView.contentOffset = CGPoint(x: CGFloat(UIScreen.main.bounds.width * (self?.xPtOffset ?? 0.0)), y: (self?.preViewCollectionView.contentOffset.y) ?? 0)
            }
        }
        isComingFromCamera = false
    }
    
    //MARK: Delegate method for the screen rotation
    override func willRotate(to toInterfaceOrientation: UIInterfaceOrientation, duration: TimeInterval) {
        let xPtOffset = xOffSet()
        let app = UIApplication.shared
        switch app.statusBarOrientation {
        case .portrait:
            preViewCollectionView.reloadData()
        case .portraitUpsideDown:
            preViewCollectionView.reloadData()

        case .landscapeLeft:
            preViewCollectionView.reloadData()

        case .landscapeRight:
            preViewCollectionView.reloadData()

        default:
            preViewCollectionView.reloadData()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.0) { [weak self] in
            self?.preViewCollectionView.contentOffset = CGPoint(x: CGFloat(UIScreen.main.bounds.width * xPtOffset), y: (self?.preViewCollectionView.contentOffset.y) ?? 0)
        }
    }
    
    /*
     @description : Method is being used to provide the x point offset of collection view
     Parameters: N/A
     return : N/A
     */
    func xOffSet() -> CGFloat{
        return self.preViewCollectionView.contentOffset.x / UIScreen.main.bounds.width
    }
}

//MARK: Collection view delegate and datasource method
extension PhotoVideoPreviewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return urlOfFiles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.CellIdentifiers.kPreviewCollectionCell, for: indexPath) as? PreviewCollectionCell else {
            return UICollectionViewCell()
        }
        cell.playButton.tag = 1000 + indexPath.row
        if urlOfFiles[indexPath.row].absoluteString.contains(Constants.kJpg) {
            cell.thumbImageView.contentMode = .scaleAspectFit
            cell.playButton.isHidden = true
            cell.thumbImageView.image = UIImage(contentsOfFile: urlOfFiles[indexPath.row].path)
        } else if urlOfFiles[indexPath.row].absoluteString.contains(Constants.kMp4){
            cell.playButton.isHidden = false
            cell.thumbImageView.contentMode = .scaleAspectFill

            cell.thumbImageView.image = Utility.generateThumbImage(urlOfFiles[indexPath.row], controller: self)
            cell.playButton.addTarget(self, action: #selector(self.playVideo(sender:)), for: .touchUpInside)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height - (navigationController?.navigationBar.frame.height ?? 0.0) )
    }
    
    
}

extension PhotoVideoPreviewController {
    /*
     @description : Method is being used to Play the local stored video
     Parameters:
     sender: is holding the refrence of uibutton
     return : N/A
     */
    @objc func playVideo(sender: UIButton)  {
        if !urlOfFiles[sender.tag - 1000].path.isEmpty {
            let player = AVPlayer(url: urlOfFiles[sender.tag - 1000])
            playerViewController = AVPlayerViewController()
            playerViewController.player = player
            self.xPtOffset = xOffSet()
            self.present(playerViewController, animated: true)
            self.playerViewController.player?.play()
            self.playerViewController.addObserver(self, forKeyPath: #keyPath(UIViewController.view.frame), options: [.old, .new], context: nil)
        } else{
            Utility.alertContoller(title: Utility.localized(key: "kMessage"),
                                   message: Utility.localized(key: "kNoVideoAvailable"),
                                   actionTitleFirst: "",
                                   actionTitleSecond: Utility.localized(key: "kOk"),
                                   firstActoin: nil,
                                   secondAction: nil,
                                   controller: self)
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
                               context: UnsafeMutableRawPointer?){
        playerViewController.removeObserver(self, forKeyPath: #keyPath(UIViewController.view.frame))
    }
}

extension PhotoVideoPreviewController : UINavigationBackButtonCheck {
    /*
    @description : Is being used to provide the implementation of navigation controller
    Parameters: NA
    return : Bool
    */
    func shouldPopViewController() -> Bool{
        AppUtility.lockOrientation(.portrait)
        navigationController?.popViewController(animated: true)
        return false
    }
}
