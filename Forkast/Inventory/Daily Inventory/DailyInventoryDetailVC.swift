//
//  DailyInventoryDetailVC.swift
//  Forkast
//
//  Created by Dharmani Apps mini on 3/10/21.
//

import UIKit
import Alamofire
import SVProgressHUD


struct Category {
    let name : String
    var items : [[String:Any]]
}


class DailyInventoryDetailVC: UIViewController {
    var dailyId = String()
    var userId = String()
    var authToken = String()
    var sections = [Category]()
    var delegate: SendingAddDailyToDailyMainPageDelegateProtocol? = nil
    var fromAppDelegate: String?
    var fromNotification: String?
    var fromNotificationBool = false
    @IBOutlet weak var dailyInventoryTBHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var dailyInventoryDetailTBView: UITableView!
    
    @IBOutlet weak var commentTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
            dailyInventoryDetailApi()
        
        // Do any additional setup after loading the view.
//        dailyInventoryDetailTBView.sectionHeaderHeight = 43
        dailyInventoryDetailTBView.sectionHeaderHeight = UITableView.automaticDimension
        dailyInventoryDetailTBView.estimatedSectionHeaderHeight = 49
        commentTextView.textContainerInset = UIEdgeInsets(top: 13, left: 13, bottom: 13, right: 13)

    }
    
    @IBAction func backBtnAction(_ sender: Any) {
        if fromAppDelegate == "YES"{
            let storyBoard = UIStoryboard(name: StoryboardName.Main, bundle: nil)
            let DVC = storyBoard.instantiateViewController(withIdentifier: ViewControllerIdentifier.HomeTabVC) as? HomeTabVC
                        DVC?.selectedIndex = 0
                        if let DVC = DVC {
                            self.navigationController?.pushViewController(DVC, animated: true)
                        }
            fromAppDelegate = "NO"
        }
        else if fromNotification == "YES"{
            for controller in self.navigationController!.viewControllers as Array {
                        if controller.isKind(of: NotificationVC.self) {
                            self.navigationController!.popToViewController(controller, animated: true)
                            break
                        }
                    }
            fromNotification = "NO"
        }
        else{
            if self.delegate != nil{
                self.delegate?.sendDataToDailyVC(myData: true)
            }
            navigationController?.popViewController(animated: true)
        }
       
    }
    func dailyInventoryDetailApi(){
        let dailyIds = dailyId
        var userIds = String()
        var token = String()
        if fromAppDelegate == "YES"{
            userIds = userId
            token = authToken
        }else{
            userIds = getSAppDefault(key: "UserId") as? String ?? ""
            token = getSAppDefault(key: "AuthToken") as? String ?? ""
        }
       
        
        
        
        let paramds = ["dailyId": dailyIds,"userId": userIds,"itemId":[],"comment":"","draft":"","is_save":""] as [String : Any]
        
        let strURL = kBASEURL + WSMethods.addDailyInventoryDetail
        
        let urlwithPercentEscapes = strURL.addingPercentEncoding( withAllowedCharacters: CharacterSet.urlQueryAllowed)
        SVProgressHUD.show()
        
        AF.request(urlwithPercentEscapes!, method: .post, parameters: paramds, encoding: JSONEncoding.prettyPrinted, headers: ["Content-Type":"application/json","Token":token])
            .responseJSON { (response) in
                SVProgressHUD.dismiss()
                switch response.result {
                case .success(let value):
                    if let JSON = value as? [String: Any] {
                        print(JSON as NSDictionary)
                        let addDailyInventoryResp =  AddDetailDailyInventoryData.init(dict: JSON )
                        
                        //                let status = jsonResult?["status"] as? Int ?? 0
                        if addDailyInventoryResp?.status == 1{
                            let dailyProductDetailArr = addDailyInventoryResp!.dailyProductDetailArr
                            let specialProductDetailArr = addDailyInventoryResp!.specialProductDetailArr
                            self.sections = [Category(name:" Check if needed", items:dailyProductDetailArr),Category(name:" Special Items", items:specialProductDetailArr)
                                        ]
                            let userDetailDict = addDailyInventoryResp?.dailyUserDetailDict as? [String:AnyHashable] ?? [:]
                            self.commentTextView.text = userDetailDict["comment"] as? String ?? ""
                            self.dailyInventoryDetailTBView.reloadData()
                           
                            
                            
                        }
                        
                        
                    }
                case .failure(let error):
                    if self.fromNotificationBool == true{
                        self.fromNotificationBool = false
                        self.dailyInventoryDetailApi()
                    }else{
                    let error : NSError = error as NSError
                    print(error)
                    DispatchQueue.main.async {

                    Alert.present(
                        title: AppAlertTitle.appName.rawValue,
                        message: AppAlertTitle.connectionError.rawValue,
                        actions: .ok(handler: {
                            let storyBoard = UIStoryboard(name: StoryboardName.Main, bundle: nil)
                            let DVC = storyBoard.instantiateViewController(withIdentifier: ViewControllerIdentifier.HomeTabVC) as? HomeTabVC
                                        DVC?.selectedIndex = 0
                                        if let DVC = DVC {
                                            self.navigationController?.pushViewController(DVC, animated: true)
                                        }
                        }),
                        from: self
                    )
                    }
                    }
                }
            }
        
    }
   

}
extension DailyInventoryDetailVC:UITableViewDataSource,UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.sections.count

    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
          let items = self.sections[section].items
        return items.count
    }
 
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
       
        
        var cell: DailyInventorySection! = tableView.dequeueReusableCell(withIdentifier: "header") as? DailyInventorySection
              if cell == nil {
                  tableView.register(UINib(nibName: "DailyInventorySection", bundle: nil), forCellReuseIdentifier: "header")
                  cell = tableView.dequeueReusableCell(withIdentifier: "header") as? DailyInventorySection
              }
       
        cell?.sectionLbl.text = self.sections[section].name
       return cell
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cells") as! DailyInventoryDetailCell
        let items = self.sections[indexPath.section].items
        let item = items[indexPath.row]
        
        cell.dIIngredientNameLbl.text = item["name"] as? String ?? ""
        let checkUncheckStatus = item["checked"] as? String ?? ""
        debugPrint(checkUncheckStatus)
        if checkUncheckStatus == "True"{
            cell.checkUncheckImgView.image = #imageLiteral(resourceName: "checkImg")
        }else{
            cell.checkUncheckImgView.image = #imageLiteral(resourceName: "uncheckImg")
        }
        tableView.layoutIfNeeded()
        tableView.estimatedRowHeight = UITableView.automaticDimension
        dailyInventoryTBHeightConstraint.constant = dailyInventoryDetailTBView.contentSize.height
        return cell
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {

            return UIScreen.main.bounds.height * 0.09
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

            return UIScreen.main.bounds.height * 0.07
    
    }
    
}
