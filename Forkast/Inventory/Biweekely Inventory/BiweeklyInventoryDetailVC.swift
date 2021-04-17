//
//  BiweeklyInventoryDetailVC.swift
//  Forkast
//
//  Created by Dharmani Apps mini on 3/10/21.
//

import UIKit
import Alamofire
import SVProgressHUD
import SDWebImage



class BiweeklyInventoryDetailVC: UIViewController {
    var biweeklyId = String()
    var responseArray = [[String:Any]]()
    var delegate: SendingAddBiweekelyToBiweekelyMainPageDelegateProtocol? = nil
    var fromAppDelegate:String?

    @IBOutlet weak var biweeklyTBHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var commentTextView: UITextView!
    @IBOutlet weak var biweekelyTBView: UITableView!
    var fromNotification: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        commentTextView.textContainerInset = UIEdgeInsets(top: 13, left: 13, bottom: 13, right: 13)
        biweekelyTBView.tableFooterView = UIView()
        biweekelyTBView.estimatedRowHeight = 90
        getBiweekelyInventoryDetail()
        
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
                self.delegate?.sendDataToBiweekelyVC(myData: true)
            }
            navigationController?.popViewController(animated: true)
        }
     
    }
    open func getBiweekelyInventoryDetail(){
        let userIds = getSAppDefault(key: "UserId") as? String ?? ""
        let token = getSAppDefault(key: "AuthToken") as? String ?? ""
    
        let paramds = ["weeklyId":biweeklyId,"userId": userIds,"ingredient_detail":[],"comment":"","draft":"","is_save":""] as [String : Any]
        
        let strURL = kBASEURL + WSMethods.addBiWeeklyInventory
        
        let urlwithPercentEscapes = strURL.addingPercentEncoding( withAllowedCharacters: CharacterSet.urlQueryAllowed)
        SVProgressHUD.show()
        AF.request(urlwithPercentEscapes!, method: .post, parameters: paramds, encoding: JSONEncoding.default, headers: ["Content-Type":"application/json","Token":token])
            .responseJSON { (response) in
                SVProgressHUD.dismiss()
                switch response.result {
                case .success(let value):
                    if let JSON = value as? [String: Any] {
                        print(JSON as NSDictionary)
                        let addDailyInventoryResp =  AddDetailBiweekelyInventoryData.init(dict: JSON )
                        
                        //                let status = jsonResult?["status"] as? Int ?? 0
                        if addDailyInventoryResp?.status == 1{
                            self.responseArray = addDailyInventoryResp!.biweekelyProductDetailArr
                            let userDetailDict = addDailyInventoryResp?.biweekelyUserDetailDict as? [String:AnyHashable] ?? [:]
                            self.commentTextView.text = userDetailDict["comment"] as? String ?? ""
                            self.biweekelyTBView.reloadData()

                        }else{
                            DispatchQueue.main.async {

                            Alert.present(
                                title: AppAlertTitle.appName.rawValue,
                                message: addDailyInventoryResp?.message ?? "",
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
extension BiweeklyInventoryDetailVC:UITableViewDataSource,UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return responseArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     
        var cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as? BiweekelyInventoryDetailCell
        if cell == nil {
            let nib = Bundle.main.loadNibNamed("BiweekelyInventoryDetailCell", owner: self, options: nil)
            cell = nib?[0] as? BiweekelyInventoryDetailCell
        }
        
        
        let respDict = responseArray[indexPath.row]
        cell?.biWeeklyInventoryNameLbl.text = respDict["name"] as? String ?? ""
        cell?.biIngredientNameLbl.text = respDict["category"] as? String ?? ""
        cell?.biCaseLbl.text = respDict["mapping_unit"] as? String ?? ""
        cell?.biQuantityTF.text = respDict["total_quantity"] as? String ?? ""
        cell?.biQuantityTF.placeholder = ""
        var sPhotoStr = respDict["image"] as? String ?? ""
        sPhotoStr = sPhotoStr.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? ""
        if sPhotoStr != ""{
            cell?.biweeklyProfileImg.sd_setImage(with: URL(string: sPhotoStr), placeholderImage:nil)
        }
        cell?.increaseQuantityBtn.isHidden = true
        cell?.decreaseQuantityBtn.isHidden = true
        cell?.biQuantityTF.borderStyle = .none
//        tableView.layoutIfNeeded()
//        tableView.estimatedRowHeight = UITableView.automaticDimension
//
        DispatchQueue.main.async {
            self.biweeklyTBHeightConstraint.constant = self.biweekelyTBView.contentSize.height

        }
        
        return cell!
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UIScreen.main.bounds.height * 0.13
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
    }
}
