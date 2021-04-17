//
//  NotificationVC.swift
//  Forkast
//
//  Created by Dharmani Apps mini on 3/26/21.
//

import UIKit
import Alamofire
import SVProgressHUD
import SDWebImage
class NotificationVC: UIViewController {

    @IBOutlet weak var notificationTBView: UITableView!
    var page = Int()
    var lastPage = Bool()
    var responseArray = [[String:Any]]()
    override func viewDidLoad() {
        super.viewDidLoad()
        responseArray.removeAll()
        page = 1
        DispatchQueue.global(qos: .background).async {
            self.getNotificationListApi()
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
       

    }
    open func getNotificationListApi(){
        
        let userId  = getSAppDefault(key: "UserId") as? String ?? ""
        let authToken  = getSAppDefault(key: "AuthToken") as? String ?? ""
//        {"userId":"13",
//        "pageno":"1",
//                "per_page":"1"
//        }
            let params = ["userId": userId, "pageno":"\(page)",
                                         "per_page":"10"]
            
            let strURL = kBASEURL + WSMethods.getNotificationDetailById
            
            let urlwithPercentEscapes = strURL.addingPercentEncoding( withAllowedCharacters: CharacterSet.urlQueryAllowed)
        SVProgressHUD.show()
            AF.request(urlwithPercentEscapes!, method: .post, parameters: params, encoding: JSONEncoding.prettyPrinted, headers: ["Content-Type":"application/json","Token":authToken])
                .responseJSON { (response) in
                    SVProgressHUD.dismiss()
                    switch response.result {
                    case .success(let value):
                        if let JSON = value as? [String: AnyHashable] {
                            print(JSON as NSDictionary)
                            let buildOrderListResp =  NotificationListData.init(dict: JSON )
                            
                            //                let status = jsonResult?["status"] as? Int ?? 0
//                            self.responseArray.removeAll()
                            if buildOrderListResp?.status == 1{
                                self.lastPage = false

                                let notifyArr =  buildOrderListResp!.notificationListArr
                                
                                for i in 0..<notifyArr.count{
                                    self.responseArray.append(notifyArr[i])
                                }
                               
                                self.notificationTBView.reloadData()
                            }else{
                                self.lastPage = true

                                if self.page == 1{
                                DispatchQueue.main.async {
                                    
                                    Alert.present(
                                        title: AppAlertTitle.appName.rawValue,
                                        message: buildOrderListResp?.message ?? "",
                                        actions: .ok(handler: {
                                        }),
                                        from: self
                                    )
                                }
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
                            }),
                            from: self
                        )
                        }
                    }
                }
              
        
    }
    @IBAction func backBtnAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
 
}
extension NotificationVC:UITableViewDataSource,UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return responseArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     
        var cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as? NotificationTBCell
        if cell == nil {
            let nib = Bundle.main.loadNibNamed("NotificationTBCell", owner: self, options: nil)
            cell = nib?[0] as? NotificationTBCell
        }
        
        
        let respDict = responseArray[indexPath.row]
        cell?.notificationNameLbl.text = respDict["title"] as? String ?? ""
        cell?.notificationDescriptionLbl.text = respDict["message"] as? String ?? ""
        let unixtimeInterval = respDict["creation_at"] as? String ?? ""
        print(unixtimeInterval,"Timeee")
        let date = Date(timeIntervalSince1970:  unixtimeInterval.doubleValue)
        let dateFormatterD = DateFormatter()
        dateFormatterD.timeZone = TimeZone(abbreviation: "IST") //Set timezone that you want
        dateFormatterD.locale = NSLocale.current
        //dd.MM.yy
        dateFormatterD.dateFormat = "dd/MM/yy" //Specify your format that you want
        let strDate = dateFormatterD.string(from: date)
        
        let dateFormatterT = DateFormatter()
        dateFormatterT.timeZone = TimeZone(abbreviation: "IST") //Set timezone that you want
        dateFormatterT.locale = NSLocale.current
        dateFormatterT.dateFormat = "h:mm a" //Specify your format that you want
        let strTime = dateFormatterT.string(from: date)
        let finalString = strDate + " " + strTime
        cell?.notificationDateLbl.text = finalString
        
        
    

//        var sPhotoStr = respDict["image"] as? String ?? ""
//        sPhotoStr = sPhotoStr.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? ""
//        if sPhotoStr != ""{
//            cell?.notificationImgView.sd_setImage(with: URL(string: sPhotoStr), placeholderImage:UIImage(named:"proIngPlaceholderImg"))
//        }
     
//        tableView.layoutIfNeeded()
//        tableView.estimatedRowHeight = UITableView.automaticDimension
//
       
        
        return cell!
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      let pushType =   self.responseArray[indexPath.row]["push_type"] as? String ?? ""
        if pushType == "1"{
            let storyBoard = UIStoryboard(name: StoryboardName.DailyInventory, bundle: nil)
                let CMDVC = storyBoard.instantiateViewController(withIdentifier: ViewControllerIdentifier.DailyInventoryDetailVC) as? DailyInventoryDetailVC
            CMDVC?.fromNotification = "YES"
                CMDVC?.dailyId = self.responseArray[indexPath.row]["inventory_id"] as? String ?? ""
    //        CMDVC?.delegate = self
                if let CMDVC = CMDVC {
                    self.navigationController?.pushViewController(CMDVC, animated: true)
                }
        }else if pushType == "2"{
            let storyBoard = UIStoryboard(name: StoryboardName.BiweekelyInventory, bundle: nil)
                let CMDVC = storyBoard.instantiateViewController(withIdentifier: ViewControllerIdentifier.BiweeklyInventoryDetailVC) as? BiweeklyInventoryDetailVC
            CMDVC?.fromNotification = "YES"
                CMDVC?.biweeklyId = self.responseArray[indexPath.row]["inventory_id"] as? String ?? ""
    //        CMDVC?.delegate = self
                if let CMDVC = CMDVC {
                    self.navigationController?.pushViewController(CMDVC, animated: true)
                }
        }
       
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == responseArray.count - 1{
            if lastPage == false{
                page = page + 1
                getNotificationListApi()
            }
        }
    }
    
}
