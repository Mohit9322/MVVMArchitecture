//
//  ViewContactViewController.swift
//  WatchMyBack
//
//  Created by Chetu on 11/12/18.
//  Copyright © 2018 LocatorTechnologies. All rights reserved.
//

import UIKit

class ViewContactViewController: BaseViewController {
    
    @IBOutlet weak var ContactListTableView: UITableView!
    var arrayContact: NSArray = []
    var isContactCompleted : Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getAllContactID()
        ContactListTableView.delegate = self
        ContactListTableView.dataSource = self
        ContactListTableView.rowHeight = 50
        ContactListTableView.separatorStyle = .none
        self.setBarButton()
        self.setBackButton()
        setTitle(title: Utility.localized(key: "kContact"))
        
        // Do any additional setup after loading the view.
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
    /*
     @description : Method is being used manage back button action
     Parameters: N/A
     return : N/A
     */
    override func backButtonAction() {
        guard let vc = UIStoryboard.init(name: Constants.StoryBoardIdentifiers.kStoryboardMain,
                                         bundle: Bundle.main).instantiateViewController(withIdentifier: Constants.ViewControllerIdentiFiers.kHomeViewController) as? HomeViewController else {
                                            return
        }
        self.navigationController?.pushViewController(vc, animated: false)
        
    }
    
    /*
     @description : Method is being used add Save/Edit bar button
     Parameters: NA
     return : NA
     */
    func setBarButton(){
        
        let negativeSpacer = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.fixedSpace,
                                             target: nil,
                                             action: nil)
        negativeSpacer.width = -10;
        //Set Profile Icon Button
        let rightButton = UIButton(type: .system)
        rightButton.frame =  CGRect(origin: CGPoint(x: 0,y :0),
                                    size: CGSize(width: 50, height: 30))
        
        rightButton.setTitleColor(UIColor.white, for: UIControl.State.normal)
        rightButton.setImage(UIImage(named: "plus"), for: UIControl.State.normal)
        rightButton.addTarget(self, action: #selector(self.addContact),
                              for: UIControl.Event.touchUpInside)
        let rightBarButton = UIBarButtonItem()
        rightBarButton.customView = rightButton
        self.navigationItem.rightBarButtonItem = rightBarButton
        self.navigationItem.setRightBarButtonItems([negativeSpacer, rightBarButton],
                                                   animated: false)
    }
    
    
    @objc func addContact(){
        if(!isContactCompleted){
            guard let vc = UIStoryboard.init(name: Constants.StoryBoardIdentifiers.kStoryboardMain,
                                             bundle: Bundle.main).instantiateViewController(withIdentifier: Constants.ViewControllerIdentiFiers.kAddContactViewController) as? AddContactViewController else {
                                                return
            }
            vc.fromAdd = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else{
            Utility.alertContoller(title: Utility.localized(key: "kMessage"),
                                   message: Utility.localized(key: "kContactLimitOf10PersonExceeded"),
                                   actionTitleFirst: Utility.localized(key: "kOk"),
                                   actionTitleSecond: "", firstActoin: nil,
                                   secondAction: nil,
                                   controller: self)
        }
    }
    func getAllContactID(){
        HISActivityIndicator.start()
        let userLogInParams = ContactIdOfParticularUser(email: DataManager.email ?? "", passWord: DataManager.password?.base64String ?? "")
        let logInViewModel = LoginViewModel()
        
        logInViewModel.getContactID(getContactIdOfUser: userLogInParams, serviceType: .getcontactIdForParticalUser) { [weak self] (response, error) in
            DispatchQueue.main.async {
                HISActivityIndicator.stop()
                if let strongSelf = self {
                    if error == nil {
                        strongSelf.arrayContact = response!
                        if(strongSelf.arrayContact.count == 10){
                            self!.isContactCompleted = true
                        }
                        if (strongSelf.arrayContact.count) > 0 {
                            strongSelf.ContactListTableView.reloadData()
                            UserDefaults().set(strongSelf.arrayContact.mutableCopy() as! NSMutableArray, forKey: "contactCache")
                        }else {
                            
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
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
extension ViewContactViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayContact.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : ConatctTableViewCell = self.ContactListTableView.dequeueReusableCell(withIdentifier: Constants.CellIdentifiers.kConatctTableViewCell)! as! ConatctTableViewCell
        
        cell.configureCell(indexPath: indexPath as NSIndexPath,arrayContact: NSArray(array: arrayContact))
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let vc = UIStoryboard.init(name: Constants.StoryBoardIdentifiers.kStoryboardMain,
                                         bundle: Bundle.main).instantiateViewController(withIdentifier: Constants.ViewControllerIdentiFiers.kAddContactViewController) as? AddContactViewController else {
                                            return
        }
        vc.fromAdd = false
        vc.contactDetails = arrayContact.object(at: indexPath.row) as! NSDictionary
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
