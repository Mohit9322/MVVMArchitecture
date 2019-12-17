//
//  DocumentDirecotoryOperations.swift
//  WatchMyBack
//
//  Created by Chetu on 7/2/18.
//  Copyright © 2018 LocatorTechnologies. All rights reserved.
//

import Foundation
import UIKit

enum OrderToFetch{
    case ascending
    case descending
}

class DocumentDirecotoryOperations {
    
    /**
     Description: This is class method used to get Document Directory Path
     - Parameters: N/A
     - Returns: URL
     */
    static func getDocumentDirectoryObject() -> URL? {
        let fileManager = FileManager.default
        return fileManager.urls(for: .documentDirectory, in: .userDomainMask).first
    }
    
    /**
     Description: This is class method used to get list of files
     - Parameters: N/A
     - Returns: [URL]
     */
    static func getListOfFiles(orderToFetch: OrderToFetch) -> [URL]{
        if let _ = DocumentDirecotoryOperations.getListOfFilesInStringFrom(orderToFetch: orderToFetch) {
            let fileManager = FileManager.default
            let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("\(Constants.kImageVideoStorage)\(DataManager.email ?? "")")
            //let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("\(Constants.kImageVideoStorage)")
            var urlArray = [URL]()
            let listOfFiles = getListOfFilesInStringFrom(orderToFetch: orderToFetch)
            for item in listOfFiles! {
                let urlOfFile = documentsURL.appendingPathComponent("/" + "\(item)")
                urlArray.append(urlOfFile)
            }
            return urlArray
        } else {
            return [URL]()
        }
    }
    
    /**
     Description: This is class method used to get list of files in string form
     - Parameters: N/A
     - Returns: [String]
     */
    static func getListOfFilesInStringFrom(orderToFetch: OrderToFetch) -> [String]? {
        let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("\(Constants.kImageVideoStorage)\(DataManager.email ?? "")")
        //let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("\(Constants.kImageVideoStorage)")
        if let urlArray = try? FileManager.default.contentsOfDirectory(at: directory,
                                                                       includingPropertiesForKeys: [.contentModificationDateKey],
                                                                       options:.skipsHiddenFiles) {
            if orderToFetch == .ascending {
                return urlArray.map { url in
                    (url.lastPathComponent, (try? url.resourceValues(forKeys: [.contentModificationDateKey]))?.contentModificationDate ?? Date.distantPast)
                    }
                    .sorted(by: { $1.1 > $0.1 }) // sort descending modification dates
                    .map { $0.0 } // extract file names
            } else {
                return urlArray.map { url in
                    (url.lastPathComponent, (try? url.resourceValues(forKeys: [.contentModificationDateKey]))?.contentModificationDate ?? Date.distantPast)
                    }
                    .sorted(by: { $1.1 < $0.1 }) // sort descending modification dates
                    .map { $0.0 } // extract file names
            }
            
            
        } else {
            return nil
        }
    }
    
    /**
     Description: This is class method used to get list of archived media files
     - Parameters: N/A
     - Returns: [URL]
     */
    static func getListOfArchivedFiles(orderToFetch: OrderToFetch) -> [URL]{
        if let _ = DocumentDirecotoryOperations.getListOfArchivedMediaFilesInStringFrom(orderToFetch: orderToFetch) {
            let fileManager = FileManager.default
            let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("\(Constants.kArchive)\(DataManager.email ?? "")")
            //let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("\(Constants.kImageVideoStorage)")
            var urlArray = [URL]()
            let listOfFiles = getListOfArchivedMediaFilesInStringFrom(orderToFetch: orderToFetch)
            for item in listOfFiles! {
                let urlOfFile = documentsURL.appendingPathComponent("/" + "\(item)")
                urlArray.append(urlOfFile)
            }
            return urlArray
        } else {
            return [URL]()
        }
    }
    /**
     Description: This is class method used to get list of archived files in string form
     - Parameters: N/A
     - Returns: [String]
     */
    static func getListOfArchivedMediaFilesInStringFrom(orderToFetch: OrderToFetch) -> [String]? {
        let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("\(Constants.kArchive)\(DataManager.email ?? "")")
        //let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("\(Constants.kImageVideoStorage)")
        if let urlArray = try? FileManager.default.contentsOfDirectory(at: directory,
                                                                       includingPropertiesForKeys: [.contentModificationDateKey],
                                                                       options:.skipsHiddenFiles) {
            if orderToFetch == .ascending {
                return urlArray.map { url in
                    (url.lastPathComponent, (try? url.resourceValues(forKeys: [.contentModificationDateKey]))?.contentModificationDate ?? Date.distantPast)
                    }
                    .sorted(by: { $1.1 > $0.1 }) // sort descending modification dates
                    .map { $0.0 } // extract file names
            } else {
                return urlArray.map { url in
                    (url.lastPathComponent, (try? url.resourceValues(forKeys: [.contentModificationDateKey]))?.contentModificationDate ?? Date.distantPast)
                    }
                    .sorted(by: { $1.1 < $0.1 }) // sort descending modification dates
                    .map { $0.0 } // extract file names
            }
            
            
        } else {
            return nil
        }
    }
    /**
     This is class method is being used to create directory of for photo and video
     - Parameters:
     typeOfMedia: whcih type media is this photo or video,
     controller: controller from which it is being called
     - Returns: N/A
     */
    static func createDirectoryForMediaStorage(typeOfMedia: SelectedMediaType, controller: UIViewController)  {
        if let documentDirectory = getDocumentDirectoryObject() {
            var filePath: URL?
            if typeOfMedia == .photo {
                //append photo folder to the document directory
                filePath =  documentDirectory.appendingPathComponent("\(Constants.kImageVideoStorage)\(DataManager.email ?? "")")
                //filePath =  documentDirectory.appendingPathComponent("\(Constants.kImageVideoStorage)")
            } else {
                //append video folder to the docuemnt directory
                filePath =  documentDirectory.appendingPathComponent("\(Constants.kImageVideoStorage)\(DataManager.email ?? "")")
                //filePath =  documentDirectory.appendingPathComponent("\(Constants.kImageVideoStorage)")
            }
            
            if let filePathCreated = (filePath?.path) {
                if !FileManager.default.fileExists(atPath: filePathCreated) {
                    do {
                        try FileManager.default.createDirectory(atPath: filePathCreated, withIntermediateDirectories: true, attributes: nil)
                    } catch {
                        Utility.alertContoller(title: Utility.localized(key: "kMessage"),
                                               message: Utility.localized(key: "kUnableToCreateDirectory"),
                                               actionTitleFirst: Utility.localized(key: "kOk"),
                                               actionTitleSecond: "",
                                               firstActoin: nil, secondAction: nil,
                                               controller: controller)
                        
                    }
                }
            }
        }
    }
    
    /**
     This is class method is being used to create directory of archived photo and video
     - Parameters:
     typeOfMedia: whcih type media is this photo or video,
     controller: controller from which it is being called
     - Returns: N/A
     @date October 31,2018
     @created Deep Chetu
     */
    static func createDirectoryForArchiveStorage(typeOfMedia: SelectedMediaType, controller: UIViewController){
        if let documentDirectory = getDocumentDirectoryObject() {
            var filePath: URL?
            if typeOfMedia == .photo {
                //append photo folder to the document directory
                filePath =  documentDirectory.appendingPathComponent("\(Constants.kArchive)\(DataManager.email ?? "")")
                //filePath =  documentDirectory.appendingPathComponent("\(Constants.kImageVideoStorage)")
            } else {
                //append video folder to the docuemnt directory
                filePath =  documentDirectory.appendingPathComponent("\(Constants.kArchive)\(DataManager.email ?? "")")
                //filePath =  documentDirectory.appendingPathComponent("\(Constants.kImageVideoStorage)")
            }
            
            if let filePathCreated = (filePath?.path) {
                if !FileManager.default.fileExists(atPath: filePathCreated) {
                    do {
                        try FileManager.default.createDirectory(atPath: filePathCreated, withIntermediateDirectories: true, attributes: nil)
                    } catch {
                        Utility.alertContoller(title: Utility.localized(key: "kMessage"),
                                               message: Utility.localized(key: "kUnableToCreateDirectory"),
                                               actionTitleFirst: Utility.localized(key: "kOk"),
                                               actionTitleSecond: "",
                                               firstActoin: nil, secondAction: nil,
                                               controller: controller)
                        
                    }
                }
            }
        }
    }
    
    /**
     This is class method is being used to save photo and video into directory
     - Parameters:
     typeOfMedia: whcih type media is this photo or video,
     controller: controller from which it is being called
     - Returns: N/A
     */
    static func saveMediaIntoTheLocalDirectory(typeOfMedia: SelectedMediaType, controller: UIViewController, photoVideoData: Data,lat : Double, long : Double ,completion: (Bool, URL?) -> ()) {
        let documentsDirectory = getDocumentDirectoryObject()
        do {
            var filePath: URL!
            if typeOfMedia == .photo {
                //append photo folder to the document directory
                filePath =  documentsDirectory?.appendingPathComponent("\(Constants.kImageVideoStorage)\(DataManager.email ?? "")")
                //filePath =  documentsDirectory?.appendingPathComponent("\(Constants.kImageVideoStorage)")
                if let fileURLAlongwithAddedDate = filePath?.appendingPathComponent("\t\(Utility.getCurrentDate()).jpg\t\(lat)\t\(long)") {
                    try photoVideoData.write(to: fileURLAlongwithAddedDate)
                    completion(true,fileURLAlongwithAddedDate)
                } else {
                    completion(false,nil)
                }
            } else {
                //append video folder to the docuemnt directory
                filePath =  documentsDirectory?.appendingPathComponent("\(Constants.kImageVideoStorage)\(DataManager.email ?? "")")
                //filePath =  documentsDirectory?.appendingPathComponent("\(Constants.kImageVideoStorage)")
                if let fileURLAlongwithAddedDate = filePath?.appendingPathComponent("\(Utility.getCurrentDate()).mp4" ) {
                    try photoVideoData.write(to: fileURLAlongwithAddedDate)
                    completion(true,fileURLAlongwithAddedDate)
                } else {
                    completion(false,nil)
                }
            }
        } catch {
            debugPrint(error.localizedDescription)
            completion(false,nil)
        }
    }
    /**
     This is class method is being used to save photo and video into archived directory
     - Parameters:
     typeOfMedia: whcih type media is this photo or video,
     controller: controller from which it is being called
     - Returns: N/A
     */
    static func saveMediaIntoTheArchivedDirectory(typeOfMedia: SelectedMediaType, controller: UIViewController, photoVideoData: Data, completion: (Bool) -> ()) {
        let documentsDirectory = getDocumentDirectoryObject()
        do {
            var filePath: URL!
            if typeOfMedia == .photo {
                //append photo folder to the document directory
                filePath =  documentsDirectory?.appendingPathComponent("\(Constants.kArchive)\(DataManager.email ?? "")")
                //filePath =  documentsDirectory?.appendingPathComponent("\(Constants.kImageVideoStorage)")
                if let fileURLAlongwithAddedDate = filePath?.appendingPathComponent("\(Utility.getCurrentDate()).jpg" ) {
                    try photoVideoData.write(to: fileURLAlongwithAddedDate)
                    completion(true)
                } else {
                    completion(false)
                }
            } else {
                //append video folder to the docuemnt directory
                filePath =  documentsDirectory?.appendingPathComponent("\(Constants.kArchive)\(DataManager.email ?? "")")
                //filePath =  documentsDirectory?.appendingPathComponent("\(Constants.kImageVideoStorage)")
                if let fileURLAlongwithAddedDate = filePath?.appendingPathComponent("\(Utility.getCurrentDate()).mp4" ) {
                    try photoVideoData.write(to: fileURLAlongwithAddedDate)
                    completion(true)
                } else {
                    completion(false)
                }
            }
        } catch {
            debugPrint(error.localizedDescription)
            completion(false)
        }
    }
    
    /**
     This is class method is being used to delete the particular file from  the document directory
     - Parameters:
     pathOfFile: is the path of that particular file
     - Returns: N/A
     */
    static func deleteParticularFileFromDocumentDirectory(pathOfFile: URL) {
        do {
            try FileManager.default.removeItem(at: pathOfFile)
        } catch {
            //handle error
            debugPrint(error.localizedDescription)
        }
    }
    
    static func addContactInCache(contactDetails: NSMutableArray){
        UserDefaults().set(contactDetails, forKey: "contactCache")
    }
    
    static func removeContacts(){
        let prefs = UserDefaults.standard
        prefs.removeObject(forKey: "contactCache")

    }
    
    static func getContactFromCache()->NSArray{
        if let contactCache =  UserDefaults.standard.array(forKey: "contactCache") as NSArray?{
            return contactCache
        }
        else{
            return [String]() as NSArray
        }
        
    }
    
    static func fetchContactDetailsPredicate(id : String,fetchContactArray: NSArray )->NSArray{
        let searchPredicate = NSPredicate(format: "id CONTAINS[C] %@", id as CVarArg)
        let array = (fetchContactArray as NSArray).filtered(using: searchPredicate) as NSArray
        return array
    }
    static func fetchContactNumbers()->NSMutableArray{
        let MyContactArray  = [] as NSMutableArray
        if let contactCache =  UserDefaults.standard.array(forKey: "contactCache") as NSArray?{
            for index in 0..<contactCache.count {
                let conDetail = contactCache.object(at: index) as! NSDictionary
                MyContactArray.add(conDetail.value(forKey: "phone")!)
            }
            return MyContactArray
        }
        else{
            return [String]() as! NSMutableArray
        }
    }
    
}

