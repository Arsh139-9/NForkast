//
//  BuildOrderListVC.swift
//  Forkast
//
//  Created by Dharmani Apps mini on 3/22/21.
//

import UIKit
import Alamofire
import SVProgressHUD
class BuildOrderListVC: UIViewController {
    var loaderBool = Bool()
    var page = Int()
    var lastPage = Bool()
    var responseArray = [[String:AnyHashable]]()
    @IBOutlet weak var buildOrderTBView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.buildOrderTBView.tableFooterView = UIView(frame: .zero)
        buildOrderTBView.backgroundColor = .clear

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        for i in 0..<responseArray.count{
            self.responseArray[i]["check"] = false
        }
        if loaderBool == false{
        responseArray.removeAll()
        page = 1
        getDailyInventoryListApi()
        }else{
            buildOrderTBView.reloadData()
        }

    }
    @IBAction func navToAddBOrderBtnAction(_ sender: Any) {
        getBuildOrderDetail(buildId:"", sliderVal:16000)
    }
    
    @IBAction func backBtnAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    open func getBuildOrderDetail(buildId:String,sliderVal:Int){
        let userIds = getSAppDefault(key: "UserId") as? String ?? ""
        let token = getSAppDefault(key: "AuthToken") as? String ?? ""
//        {
//        "user_id":"13",
//        "total_sales":"16000",
//        "comment":"",
//        "is_save":"",
//        "item":[
//
//        ]
//
//        }
        
        let paramds = ["user_id": userIds,"buildId":buildId,"total_sales":"\(sliderVal)","item":[],"comment":"","is_save":""] as [String : Any]
        
        let strURL = kBASEURL + WSMethods.addBuildOrder
        
        let urlwithPercentEscapes = strURL.addingPercentEncoding( withAllowedCharacters: CharacterSet.urlQueryAllowed)
//        SVProgressHUD.show()
        AF.request(urlwithPercentEscapes!, method: .post, parameters: paramds, encoding: JSONEncoding.default, headers: ["Content-Type":"application/json","Token":token])
            .responseJSON { (response) in
//                SVProgressHUD.dismiss()
                switch response.result {
                case .success(let value):
                    if let JSON = value as? [String: Any] {
                        print(JSON as NSDictionary)
                        let addDailyInventoryResp =  BuildOrderDetailData.init(dict: JSON )
                        
                        //                let status = jsonResult?["status"] as? Int ?? 0
                        if addDailyInventoryResp?.status == 1{
                            let storyBoard = UIStoryboard(name: StoryboardName.BuildOrder, bundle: nil)
                                let CMDVC = storyBoard.instantiateViewController(withIdentifier: ViewControllerIdentifier.AddBuildOrderVC) as? AddBuildOrderVC
                            
                            CMDVC?.delegate = self
                                if let CMDVC = CMDVC {
                                    self.navigationController?.pushViewController(CMDVC, animated: true)
                                }

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
                        message: error.localizedDescription == "" ? AppAlertTitle.connectionError.rawValue : error.localizedDescription,
                        actions: .ok(handler: {
                        }),
                        from: self
                    )
                    }

                }
            }
        
    }
    
    open func getDailyInventoryListApi(){
        
        let userId  = getSAppDefault(key: "UserId") as? String ?? ""
        let authToken  = getSAppDefault(key: "AuthToken") as? String ?? ""
//        {"userId":"13",
//        "pageno":"1",
//                "per_page":"1"
//        }
            let params = ["userId": userId, "pageno":"\(page)",
                                         "per_page":"10"]
            
            let strURL = kBASEURL + WSMethods.getAllBuildOrderDetail
            
            let urlwithPercentEscapes = strURL.addingPercentEncoding( withAllowedCharacters: CharacterSet.urlQueryAllowed)
        SVProgressHUD.show()
            AF.request(urlwithPercentEscapes!, method: .post, parameters: params, encoding: JSONEncoding.default, headers: ["Content-Type":"application/json","Token":authToken])
                .responseJSON { (response) in
                    SVProgressHUD.dismiss()
                    switch response.result {
                    case .success(let value):
                        if let JSON = value as? [String: AnyHashable] {
                            print(JSON as NSDictionary)
                            let buildOrderListResp =  BuildOrderListData.init(dict: JSON )
                            
                            //                let status = jsonResult?["status"] as? Int ?? 0
                            if buildOrderListResp?.status == 1{
                                self.lastPage = false

                                let bOArr =  buildOrderListResp!.buildOrderListArr
                                for i in 0..<bOArr.count{
                                    self.responseArray.append(bOArr[i])
                                }
                                
                                
                                self.buildOrderTBView.reloadData()
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
extension BuildOrderListVC:UITableViewDataSource,UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return responseArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as? DailyInventoryListTBCell

        let respDict = responseArray[indexPath.row]
        let checkUncheckStatus = responseArray[indexPath.row]["check"] as? Bool ?? false
        if checkUncheckStatus == true{
            cell?.mainView.backgroundColor = UIColor(red: 214.0/255.0, green: 255.0/255.0, blue:218.0/255.0, alpha: 1.0)
        }else{
            cell?.mainView.backgroundColor = .white
        }
        cell?.nameDILbl.text = respDict["title"] as? String ?? ""
        let unixtimeInterval = respDict["creationAt"] as? String ?? ""
        print(unixtimeInterval,"Timeee")
        let date = Date(timeIntervalSince1970:  unixtimeInterval.doubleValue)
        let dateFormatterD = DateFormatter()
        dateFormatterD.timeZone = .current

//        dateFormatterD.timeZone = TimeZone(abbreviation: "IST") //Set timezone that you want
        dateFormatterD.locale = NSLocale.current
        dateFormatterD.dateFormat = "MMM d" //Specify your format that you want
        let strDate = dateFormatterD.string(from: date)
        
        let dateFormatterT = DateFormatter()
        dateFormatterT.timeZone = .current

//        dateFormatterT.timeZone = TimeZone(abbreviation: "IST") //Set timezone that you want
        dateFormatterT.locale = NSLocale.current
        dateFormatterT.dateFormat = "h:mm a" //Specify your format that you want
        let strTime = dateFormatterT.string(from: date)
        let finalString = strDate + " at " + strTime
        cell?.dateTimeDILbl.text = finalString
        
        return cell!
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

//        for i in 0..<responseArray.count{
//            self.responseArray[i]["check"] = false
//        }
        self.responseArray[indexPath.row]["check"] = true
        buildOrderTBView.reloadData()
        let storyBoard = UIStoryboard(name: StoryboardName.BuildOrder, bundle: nil)
            let CMDVC = storyBoard.instantiateViewController(withIdentifier: ViewControllerIdentifier.BuildOrderDetailVC) as? BuildOrderDetailVC
            CMDVC?.buildId = self.responseArray[indexPath.row]["id"] as? String ?? ""
        CMDVC?.delegate = self
            if let CMDVC = CMDVC {
                self.navigationController?.pushViewController(CMDVC, animated: true)
            }
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == responseArray.count - 1{
            if lastPage == false{
                page = page + 1
                getDailyInventoryListApi()
            }
        }
    }
}
extension BuildOrderListVC:SendingAddBOToBOMainPageDelegateProtocol{
    
    func sendDataToBO(myData: Bool) {
        loaderBool = myData

    }
    
    
    
}
