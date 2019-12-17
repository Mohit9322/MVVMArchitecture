//
//  AddContactViewController.swift
//  WatchMyBack
//
//  Created by Deepc/Chetu on 11/6/18.
//  Copyright © 2018 LocatorTechnologies. All rights reserved.
//

import UIKit

class AddContactViewController: BaseViewController {
    
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    var fromAdd : Bool = false
    var contactDetails : NSDictionary = [:]
    
    @IBOutlet weak var phone: UITextField!
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var email: UITextField!
    var addContactViewModel = AddContactViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setUpCommonUI()
        
        // Do any additional setup after loading the view.
    }
    
    /*
     @description : Method is being used to manage User interface when screen will appear
     Parameters: NA
     return : NA
     */
    func setUpCommonUI() {
        
        if(self.fromAdd){
            self.disableEnableButtonText(isTrue: true)
        }
        else{
            self.disableEnableButtonText(isTrue: false)
            self.name.text = (contactDetails.value(forKey:Utility.localized(key: "kName") ) as! String)
            self.email.text = (contactDetails.value(forKey:Utility.localized(key: "kemail") ) as! String)
            self.phone.text = (contactDetails.value(forKey:Utility.localized(key: "kphone") ) as! String)
            
            deleteButton.setButtonProperty(title: Utility.localized(key: "kDeleteContact"),
                                           FontSize: Int(18.0),
                                           cornerRadius: 10.0,
                                           backgroundColor: PrimaryColor.red(alphaValue: 1.0))
            
        }
        
    }
    
    /*
     @description : Method is being used to enable/disable textfield and buttons in case of edit/unedit mode switches
     Parameters: isTrue to check whether the enable be switched on or not
     return : NA
     */
    
    func disableEnableButtonText(isTrue : Bool)
    {
        self.phone.isEnabled = isTrue
        self.email.isEnabled = isTrue
        self.name.isEnabled = isTrue
        self.saveButton.isEnabled = isTrue
        self.deleteButton.isHidden = isTrue
        self.setAddBarButton(isTrue: isTrue)
    }
    
    /*
     @description : Method is being used add save/edit bar button
     Parameters: isTrue to check whether the barbutton added should be add or edit
     return : NA
     */
    
    func setAddBarButton(isTrue : Bool) {
        
        let negativeSpacer = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.fixedSpace,
                                             target: nil,
                                             action: nil)
        negativeSpacer.width = -10;
        //Set Profile Icon Button
        let rightButton = UIButton(type: .system)
        rightButton.frame =  CGRect(origin: CGPoint(x: 0,y :0),
                                    size: CGSize(width: 50, height: 30))
        if(isTrue){
            rightButton.setTitle(Utility.localized(key: "kSave"),
                                 for: UIControl.State.normal)
            rightButton.addTarget(self, action: #selector(self.saveContact),
                                  for: UIControl.Event.touchUpInside)
            saveButton.setButtonProperty(title: Utility.localized(key: "kSaveContact"),
                                         FontSize: Int(18.0),
                                         cornerRadius: 10.0,
                                         backgroundColor: PrimaryColor.navyBlue(alphaValue: 1.0))
        }
        else{
            rightButton.setTitle(Utility.localized(key: "kEdit"),
                                 for: UIControl.State.normal)
            rightButton.addTarget(self, action: #selector(self.edit),
                                  for: UIControl.Event.touchUpInside)
            saveButton.setButtonProperty(title: Utility.localized(key: "kSaveContact"),
                                         FontSize: Int(18.0),
                                         cornerRadius: 10.0,
                                         backgroundColor: PrimaryColor.darkGray(alphaValue: 1.0))
        }
        rightButton.setTitleColor(UIColor.white, for: UIControl.State.normal)
        
        
        let rightBarButton = UIBarButtonItem()
        rightBarButton.customView = rightButton
        self.navigationItem.rightBarButtonItem = rightBarButton
        self.navigationItem.setRightBarButtonItems([negativeSpacer, rightBarButton],
                                                   animated: false)
        
        let newBtn = UIBarButtonItem(title: "", style: .plain, target: self, action: #selector(back))
        
        self.navigationItem.leftItemsSupplementBackButton = true
        self.navigationItem.leftBarButtonItem = newBtn
    }
    
    /*
     @description : Method is being used manage back button action
     Parameters: N/A
     return : N/A
     */
    override func backButtonAction() {
        self.moveToViewContactScreen()
    }
    
    /*
     @description : Method is being used to set the title of the navigation bar
     Parameters:
     title : view controller's title String
     return : NA
     */
    override func setBackButton(){
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
    /*!
     @author chetu/deepc
     @date 15th November 2018
     @description This method is called to check the validatioon of the entry of the data of the user and also checks whether the add option is enabkled or edit options is enabled
     */
    @objc func saveContact() {
        if(isEntriesValid(nameTextField: name, phoneTextField: phone, emailTextField: email)){
            if(fromAdd)
            {
                callSaveContact()
            }
            else{
                editSaveContact()
            }
            
        }
        
    }
    
    /*!
     @author chetu/deepc
     @date 15th November 2018
     @description This method is called to hit the api of delete contact to dete the contact along with its details
     */
    
    func callDeleteContact(){
        HISActivityIndicator.start()
        
        let deleteContactParams = DeleteContactParams(email: DataManager.email!, passWord: (DataManager.password?.base64String)!,contactId:contactDetails.value(forKey: "id") as! String)
        let addContactViewModel = AddContactViewModel()
        
        addContactViewModel.deleteContacServiceCall(deleteContactParameter: deleteContactParams, serviceType: .deleteContact) { [weak self] (response, error) in
            DispatchQueue.main.async {
                HISActivityIndicator.stop()
                if let strongSelf = self {
                    if error == nil {
                        
                        if let fetchContactArray = DocumentDirecotoryOperations.getContactFromCache() as NSArray?{
                            let fetchContactArrayM = fetchContactArray.mutableCopy() as! NSMutableArray
                            
                            let contactDetails = DocumentDirecotoryOperations.fetchContactDetailsPredicate(id: self?.contactDetails.value(forKey: "id") as! String, fetchContactArray: fetchContactArray) as NSArray
                            fetchContactArrayM.remove(contactDetails.firstObject!)
                            DocumentDirecotoryOperations.addContactInCache(contactDetails: fetchContactArrayM)
                            
                        }
                        
                        self?.moveToViewContactScreen()
                        Utility.alertContoller(title: Utility.localized(key: "kDeletedSuccessfully"),
                                               message: error?.description ?? "",
                                               actionTitleFirst: Utility.localized(key: "kOk"),
                                               actionTitleSecond: "", firstActoin: nil,
                                               secondAction: nil,
                                               controller: strongSelf)
                        print("success")
                        print("success")
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
    
    /*!
     @author chetu/deepc
     @date 15th November 2018
     @description This method is called to hit the api of add contact to add the contact details
     */
    
    func callSaveContact(){
        HISActivityIndicator.start()
        
        let addContactParams = AddContactParams(email: DataManager.email!, passWord: (DataManager.password?.base64String)!, contactName: self.name.text!, contactEmail: self.email.text!, contactPhone: self.phone.text!)
        let addContactViewModel = AddContactViewModel()
        
        addContactViewModel.addContacServiceCall(addContactParameter: addContactParams, serviceType: .addContact) { [weak self] (response, error) in
            DispatchQueue.main.async {
                HISActivityIndicator.stop()
                if let strongSelf = self {
                    if error == nil {
                        var contactArrayM: NSMutableArray = []
                        if let contactA = DocumentDirecotoryOperations.getContactFromCache() as NSArray?{
                            contactArrayM = contactA.mutableCopy() as! NSMutableArray
                            
                        }
                        
                        let contactD : NSDictionary
                        
                        contactD = Utility.createDictionaryToSaveContactLocally(name: self?.name.text as! String, phone: self?.phone.text as! String, email: self?.email.text as! String, id: response as! String)
                        
                        contactArrayM.add(contactD)
                        
                        DocumentDirecotoryOperations.addContactInCache(contactDetails: contactArrayM)
                        
                        
                        self?.moveToViewContactScreen()
                        Utility.alertContoller(title: Utility.localized(key: "kAddedSuccessfully"),
                                               message: error?.description ?? "",
                                               actionTitleFirst: Utility.localized(key: "kOk"),
                                               actionTitleSecond: "", firstActoin: nil,
                                               secondAction: nil,
                                               controller: strongSelf)
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
    
    /*!
     @author chetu/deepc
     @date 15th November 2018
     @description This method is called to hit the api of update contact to modify the contact details
     */
    
    func editSaveContact(){
        HISActivityIndicator.start()
        
        let editContactParams = EditContactParams(email: DataManager.email!, passWord: (DataManager.password?.base64String)!, contactName: self.name.text!, contactEmail: self.email.text!, contactPhone: self.phone.text!, contactId: contactDetails.value(forKey: "id") as! String )
        let addContactViewModel = AddContactViewModel()
        
        addContactViewModel.editContacServiceCall(editContactParameter: editContactParams, serviceType: .updateContact) { [weak self] (response, error) in
            DispatchQueue.main.async {
                HISActivityIndicator.stop()
                if let strongSelf = self {
                    if error == nil {
                        
                        
                        if let fetchContactArray = DocumentDirecotoryOperations.getContactFromCache() as NSArray?{
                            let fetchContactArrayM = fetchContactArray.mutableCopy() as! NSMutableArray
                            
                            let contactDetails = DocumentDirecotoryOperations.fetchContactDetailsPredicate(id: self?.contactDetails.value(forKey: "id") as! String, fetchContactArray: fetchContactArray) as NSArray
                            fetchContactArrayM.remove(contactDetails.firstObject!)
                            
                            let contactD : NSDictionary
                            
                            contactD = Utility.createDictionaryToSaveContactLocally(name: self?.name.text as! String, phone: self?.phone.text as! String, email: self?.email.text as! String, id: self!.contactDetails.value(forKey: "id") as! String)
                            
                            fetchContactArrayM.add(contactD)
                            
                            DocumentDirecotoryOperations.addContactInCache(contactDetails: fetchContactArrayM)
                            
                        }
                        
                        
                        
                        
                        self?.moveToViewContactScreen()
                        Utility.alertContoller(title: Utility.localized(key: "kEditedSuccessfully"),
                                               message: error?.description ?? "",
                                               actionTitleFirst: Utility.localized(key: "kOk"),
                                               actionTitleSecond: "", firstActoin: nil,
                                               secondAction: nil,
                                               controller: strongSelf)
                        print("success")
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
    @objc func edit() {
        self.disableEnableButtonText(isTrue: true)
    }
    
    @IBAction func saveAction(_ sender: Any) {
        self.saveContact()
    }
    
    @IBAction func deleteAction(_ sender: Any) {
        callDeleteContact()
    }
    
    /*
     @description : Method is being used to manage back button section and navigate the screen to View Contact Screen
     Parameters: N/A
     return : N/A
     */
    @objc func back(){
        self.moveToViewContactScreen()
        
    }
    /*
     @description : Method is being used to validate entries in textfields
     Parameters:
     nameTextField: name text field UITextField
     phoneTextField: phone text field UITextField
     emailTextField: email text field UITextField
     return : Bool
     */
    func isEntriesValid(nameTextField: UITextField, phoneTextField: UITextField,emailTextField: UITextField) -> Bool {
        let addContact = AddContactFormData(name: nameTextField.text ?? "", phone: phoneTextField.text ?? "", email: emailTextField.text ?? "")
        return addContactViewModel.validateEntries(data: addContact, viewController: self)
    }
    
    /*!
     @author chetu/deepc
     @date 15th November 2018
     @description This method is called to navigate the view controller to the View Contact list screen
     */
    func moveToViewContactScreen(){
        guard let vc = UIStoryboard.init(name: Constants.StoryBoardIdentifiers.kStoryboardMain,
                                         bundle: Bundle.main).instantiateViewController(withIdentifier: Constants.ViewControllerIdentiFiers.kViewContactViewController) as? ViewContactViewController else {
                                            return
        }
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
