//
//  HomeChildTabVC.swift
//  Forkast
//
//  Created by Dharmani Apps mini on 3/10/21.
//

import UIKit
import Alamofire

class HomeChildTabVC: UIViewController {

    @IBOutlet weak var buildOrderView: UIView!
    
    @IBOutlet weak var productIngredientView: UIView!
    
    @IBOutlet weak var unreadNotifyImg: UIImageView!
    lazy var searchTimer = Timer()

    override func viewDidLoad() {
        super.viewDidLoad()
        unreadNotifyImg.isHidden = true
        let role  = getSAppDefault(key: "Role") as? String ?? ""
        if role == "2"{
            buildOrderView.isHidden = false
            productIngredientView.isHidden = false
        }else{
            buildOrderView.isHidden = true
            productIngredientView.isHidden = true
        }
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        searchTimer.invalidate()
        // reschedule the search: in 1.0 second, call the searchForKeyword: method on the new textfield content
        searchTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(getProfileDetail), userInfo:"hjg", repeats: true)
//        self.getProfileDetail()
//        NotificationCenter.default.addObserver(self, selector: #selector(applicationEnteredForeground(_:)), name: UIApplication.didBecomeActiveNotification, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(applicationEnteredForeground(_:)), name: UIApplication.didEnterBackgroundNotification, object: nil)
    }
    @objc func applicationEnteredForeground(_ notification: Notification?) {
        self.getProfileDetail()
        if traitCollection.userInterfaceStyle == .dark {
            //            pickGalleryImageBtn.setImage(UIImage(named: "addImageBtnDM"), for: .normal)
        } else {
            //            pickGalleryImageBtn.setImage(UIImage(named: "addImageBtn"), for: .normal)
        }
    }
    @objc open func getProfileDetail(){
        
        let userId = getSAppDefault(key: "UserId") as? String ?? ""

        let authToken  = getSAppDefault(key: "AuthToken") as? String ?? ""

        let paramds = ["userId":userId] as [String : Any]
        
        let strURL = kBASEURL + WSMethods.getUserDetail
        
        let urlwithPercentEscapes = strURL.addingPercentEncoding( withAllowedCharacters: CharacterSet.urlQueryAllowed)
//        SVProgressHUD.show()
        AF.request(urlwithPercentEscapes!, method: .post, parameters: paramds, encoding: JSONEncoding.default, headers: ["Content-Type":"application/json","Token":authToken])
            .responseJSON { (response) in
//                SVProgressHUD.dismiss()
                switch response.result {
                case .success(let value):
                    if let JSON = value as? [String: Any] {
                        print(JSON as NSDictionary)
                        let getProfileResp =  GetProfileData.init(dict: JSON )
                        
                        //                let status = jsonResult?["status"] as? Int ?? 0
                        if getProfileResp?.status == 1{
                            let unreadCount = getProfileResp?.unreadCount ??  ""
                            if unreadCount != "0"{
                                self.unreadNotifyImg.isHidden = false
                            }else{
                                self.unreadNotifyImg.isHidden = true
                            }
                            
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
                    print(error)
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
    
    
    @IBAction func buildOrderBtnAction(_ sender: Any) {
        Navigation.init().pushCallBack(ViewControllerIdentifier.BuildOrderListVC,StoryboardName.BuildOrder, HomeChildTabVC(),self.storyboard!, self.navigationController!)
    }
    
    @IBAction func navigateToNotificationBtnAction(_ sender: Any) {
        Navigation.init().pushCallBack(ViewControllerIdentifier.NotificationVC,StoryboardName.Main, NotificationVC(),self.storyboard!, self.navigationController!)
    }
    
    
    @IBAction func dailyInventoryBtnAction(_ sender: Any) {
        Navigation.init().pushCallBack(ViewControllerIdentifier.DailyInventoryListVC,StoryboardName.DailyInventory, HomeChildTabVC(),self.storyboard!, self.navigationController!)

    }
    
    @IBAction func biweekelyInventoryBtnAction(_ sender: Any) {
        Navigation.init().pushCallBack(ViewControllerIdentifier.BiweeklyInventoryListVC,StoryboardName.BiweekelyInventory, HomeChildTabVC(),self.storyboard!, self.navigationController!)

    }
    
    @IBAction func productIngredientBtnAction(_ sender: Any) {
        Navigation.init().pushCallBack(ViewControllerIdentifier.ProductIngredientHomeVC,StoryboardName.ProductIngredients, ProductIngredientHomeVC(),self.storyboard!, self.navigationController!)

       
    }
    

}
