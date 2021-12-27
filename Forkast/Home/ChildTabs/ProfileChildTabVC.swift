//
//  ProfileChildTabVC.swift
//  Forkast
//
//  Created by Dharmani Apps mini on 3/10/21.
//

import UIKit
import Alamofire
import SVProgressHUD

@available(iOS 13.0, *)

class ProfileChildTabVC: UIViewController {
    
    @IBOutlet weak var userNameLbl: UILabel!
    @IBOutlet weak var userEmailLbl: UILabel!
    @IBOutlet weak var phoneNumberLbl: UILabel!
    
    
    @IBOutlet weak var profileImgView: UIImageView!
    var appDel = AppDelegate()
    var userDetailDict = [String:AnyHashable]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func aboutLinkBtnAction(_ sender: Any) {
        let CMDVC = self.storyboard?.instantiateViewController(withIdentifier: ViewControllerIdentifier.LinksWebVC) as? LinksWebVC
        CMDVC?.webLinkUrlString = kBASEURL + SettingWebLinks.aboutUs
        CMDVC?.navBarTitleString = NavBarTitle.aboutUs
        if let CMDVC = CMDVC {
            navigationController?.pushViewController(CMDVC, animated: true)
        }
        
    }
    
    @IBAction func privacyPolicyLinkBtnAction(_ sender: Any) {
        let CMDVC = self.storyboard?.instantiateViewController(withIdentifier: ViewControllerIdentifier.LinksWebVC) as? LinksWebVC
        CMDVC?.webLinkUrlString = kBASEURL + SettingWebLinks.privacyPolicy
        CMDVC?.navBarTitleString = NavBarTitle.privacyPolicy
        
        if let CMDVC = CMDVC {
            navigationController?.pushViewController(CMDVC, animated: true)
        }
    }
    
    @IBAction func termsLinkBtnAction(_ sender: Any) {
        let CMDVC = self.storyboard?.instantiateViewController(withIdentifier: ViewControllerIdentifier.LinksWebVC) as? LinksWebVC
        CMDVC?.webLinkUrlString = kBASEURL + SettingWebLinks.termsAndConditions
        CMDVC?.navBarTitleString = NavBarTitle.termsAndConditions
        
        if let CMDVC = CMDVC {
            navigationController?.pushViewController(CMDVC, animated: true)
        }
    }
    
    @IBAction func logOutBtnAction(_ sender: Any) {
        let alert = UIAlertController(title: AppAlertTitle.appName.rawValue, message: "Are you sure you want to logout?", preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: { _ in
            //Cancel Action
        }))
        alert.addAction(UIAlertAction(title: "Sign out",
                                      style: UIAlertAction.Style.destructive,
                                      handler: {(_: UIAlertAction!) in
            //Sign out action
            self.logOutApi()
            
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    open func setUIValuesUpdate(dict:[String:AnyHashable]){
        userNameLbl.text = dict["name"] as? String ?? ""
        userEmailLbl.text = dict["email"] as? String ?? ""
        phoneNumberLbl.text = dict["phone_number"] as? String ?? ""
        var sPhotoStr = dict["image"] as? String ?? ""
        sPhotoStr = sPhotoStr.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? ""
        if sPhotoStr != ""{
            profileImgView.sd_setImage(with: URL(string: sPhotoStr), placeholderImage:nil)
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.tabBarController?.tabBar.isHidden = false
        getProfileDetail()
        
    }
    @IBAction func editProfileBtnAction(_ sender: Any) {
        let CMDVC = self.storyboard?.instantiateViewController(withIdentifier: ViewControllerIdentifier.EditProfileVC) as? EditProfileVC
        CMDVC?.userDetailDict = self.userDetailDict
        if let CMDVC = CMDVC {
            navigationController?.pushViewController(CMDVC, animated: true)
        }
    }
    open func logOutApi(){
        
        let userId = getSAppDefault(key: "UserId") as? String ?? ""
        
        let authToken  = getSAppDefault(key: "AuthToken") as? String ?? ""
        
        let paramds = ["userId":userId] as [String : Any]
        
        let strURL = kBASEURL + WSMethods.logOut
        
        let urlwithPercentEscapes = strURL.addingPercentEncoding( withAllowedCharacters: CharacterSet.urlQueryAllowed)
        SVProgressHUD.show()
        AF.request(urlwithPercentEscapes!, method: .post, parameters: paramds, encoding: JSONEncoding.default, headers: ["Content-Type":"application/json","Token":authToken])
            .responseJSON { (response) in
                SVProgressHUD.dismiss()
                switch response.result {
                case .success(let value):
                    if let JSON = value as? [String: Any] {
                        let getProfileResp =  ForgotPasswordData.init(dict: JSON )
                        
                        if getProfileResp?.status == 1{
                            removeAppDefaults(key:"AuthToken")
                            
                            self.appDel.logOut()
                            
                            
                            
                        }else{
                            DispatchQueue.main.async {
                                
                                Alert.present(
                                    title: AppAlertTitle.appName.rawValue,
                                    message: getProfileResp?.message ?? "",
                                    actions: .ok(handler: {
                                    }),
                                    from: self
                                )
                            }
                        }
                        
                        
                    }
                case .failure(let error):
                    let error : NSError = error as NSError
                    //                    DispatchQueue.main.async {
                    //
                    //                    Alert.present(
                    //                        title: AppAlertTitle.appName.rawValue,
                    //                        message: AppAlertTitle.connectionError.rawValue,
                    //                        actions: .ok(handler: {
                    //                        }),
                    //                        from: self
                    //                    )
                    //                    }
                }
            }
        
        
    }
    open func getProfileDetail(){
        
        let userId = getSAppDefault(key: "UserId") as? String ?? ""
        
        let authToken  = getSAppDefault(key: "AuthToken") as? String ?? ""
        
        let paramds = ["userId":userId] as [String : Any]
        
        let strURL = kBASEURL + WSMethods.getUserDetail
        
        let urlwithPercentEscapes = strURL.addingPercentEncoding( withAllowedCharacters: CharacterSet.urlQueryAllowed)
        SVProgressHUD.show()
        AF.request(urlwithPercentEscapes!, method: .post, parameters: paramds, encoding: JSONEncoding.default, headers: ["Content-Type":"application/json","Token":authToken])
            .responseJSON { (response) in
                SVProgressHUD.dismiss()
                switch response.result {
                case .success(let value):
                    if let JSON = value as? [String: Any] {
                        let getProfileResp =  GetProfileData.init(dict: JSON )
                        
                        if getProfileResp?.status == 1{
                            let userDetailDict = getProfileResp?.user_detail as? [String:AnyHashable] ?? [:]
                            self.userDetailDict = getProfileResp?.user_detail as? [String:AnyHashable] ?? [:]
                            self.setUIValuesUpdate(dict:userDetailDict)
                            
                            
                        }else{
                            DispatchQueue.main.async {
                                
                                Alert.present(
                                    title: AppAlertTitle.appName.rawValue,
                                    message: getProfileResp?.message ?? "",
                                    actions: .ok(handler: {
                                    }),
                                    from: self
                                )
                            }
                        }
                        
                        
                    }
                case .failure(let error):
                    let error : NSError = error as NSError
                    DispatchQueue.main.async {
                        
                        Alert.present(
                            title: AppAlertTitle.appName.rawValue,
                            message: error.localizedDescription == "" ? AppAlertTitle.connectionError.rawValue : error.localizedDescription,
                            actions: .ok(handler: {
                            }),
                            from: self
                        )
                    }
                }
            }
        
        
    }
    
}
