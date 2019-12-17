//
//  DownloadedMediaFilePreview.swift
//  WatchMyBack
//
//  Created by Chetu on 8/17/18.
//  Copyright © 2018 LocatorTechnologies. All rights reserved.
//

import UIKit

class DownloadedMediaFilePreview: BaseViewController {
    //MARK: IBOutlets
    @IBOutlet weak var previewImageView: UIImageView!
    
    //MARK: life cycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setTitle(title: Utility.localized(key: "kPreview"))
        setBackButton()
        downloadImage()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
 
    /*
     @description : Method is being used to download image
     Parameters: NA
     return : NA
     */
    func downloadImage()  {
        let mediaUploadViewModelObject = MediaUploadViewModel()
        if let mediaID = DataManager.mediaID {
            HISActivityIndicator.start()
            mediaUploadViewModelObject.downloadMedia(id: mediaID) { (response, error) in
                DispatchQueue.main.async { [weak self] in
                    HISActivityIndicator.stop()
                    self?.previewImageView.image = UIImage(data: response ?? Data())
                }
            }
        }
    }
}
