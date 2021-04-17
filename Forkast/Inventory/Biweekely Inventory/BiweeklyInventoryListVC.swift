//
//  BiweeklyInventoryListVC.swift
//  Forkast
//
//  Created by Dharmani Apps mini on 3/10/21.
//

import UIKit
import Alamofire
import SVProgressHUD
class BiweeklyInventoryListVC: UIViewController {
    var page = Int()
    var lastPage = Bool()
    var responseArray = [[String:AnyHashable]]()
    var loaderBool = Bool()
    @IBOutlet weak var biweekelyInventoryTBView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.biweekelyInventoryTBView.tableFooterView = UIView(frame: .zero)
        biweekelyInventoryTBView.backgroundColor = .clear
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        for i in 0..<responseArray.count{
            self.responseArray[i]["check"] = false
        }
        if loaderBool == false{
        page = 1
        responseArray.removeAll()
        getBiweekelyInventoryListApi()
        }else{
            biweekelyInventoryTBView.reloadData()
        }
        
    }
    @IBAction func navToBIDetailBtnAction(_ sender: Any) {
        let storyBoard = UIStoryboard(name: StoryboardName.BiweekelyInventory, bundle: nil)
        let CMDVC = storyBoard.instantiateViewController(withIdentifier: ViewControllerIdentifier.AddBiweeklyInventoryVC) as? AddBiweeklyInventoryVC
         
        CMDVC?.delegate = self
        if let CMDVC = CMDVC {
            self.navigationController?.pushViewController(CMDVC, animated: true)
        }
    }
    @objc func editBtnAction(_ sender: UIButton?) {
        var parentCell = sender?.superview

        while !(parentCell is BiweeklyInventoryListCell) {
            parentCell = parentCell?.superview
        }
        var indexPath: IndexPath? = nil
        let cell1 = parentCell as? BiweeklyInventoryListCell
        indexPath = biweekelyInventoryTBView.indexPath(for: cell1!)
        let respDict = responseArray[indexPath!.row]
        let storyBoard = UIStoryboard(name: StoryboardName.BiweekelyInventory, bundle: nil)
            let CMDVC = storyBoard.instantiateViewController(withIdentifier: ViewControllerIdentifier.AddBiweeklyInventoryVC) as? AddBiweeklyInventoryVC
        CMDVC?.isDraftVal = respDict["draft"] as? String ?? ""
        CMDVC?.draftComment = respDict["comment"] as? String ?? ""
        CMDVC?.draftBiweeklyId = respDict["weeklyId"] as? String ?? ""
        CMDVC?.delegate = self
            if let CMDVC = CMDVC {
                self.navigationController?.pushViewController(CMDVC, animated: true)
            }

      
       

    }
    @IBAction func backBtnAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    open func getBiweekelyInventoryListApi(){
        
        let userId  = getSAppDefault(key: "UserId") as? String ?? ""
        let authToken  = getSAppDefault(key: "AuthToken") as? String ?? ""
        
        let params = ["userId": userId, "pageno":"\(page)",
                                     "per_page":"10"]
        let strURL = kBASEURL + WSMethods.getAllBiweeklyInventoryDetail
        
        let urlwithPercentEscapes = strURL.addingPercentEncoding( withAllowedCharacters: CharacterSet.urlQueryAllowed)
        SVProgressHUD.show()
        AF.request(urlwithPercentEscapes!, method: .post, parameters: params, encoding: JSONEncoding.default, headers: ["Content-Type":"application/json","Token":authToken])
            .responseJSON { (response) in
                SVProgressHUD.dismiss()
                switch response.result {
                case .success(let value):
                    if let JSON = value as? [String: AnyHashable] {
                        print(JSON as NSDictionary)
                        let dailyInventoryResp =  BiweekelyInventoryListData.init(dict: JSON )
                        
                        //                let status = jsonResult?["status"] as? Int ?? 0
                        if dailyInventoryResp?.status == 1{
                        
                            self.lastPage = false

                            let dALyArr =  dailyInventoryResp!.biweekelyInventoryArr
                            for i in 0..<dALyArr.count{
                                self.responseArray.append(dALyArr[i])
                            }
                            
                           
                            self.biweekelyInventoryTBView.reloadData()
                        }else{
                            self.lastPage = true
                            if self.page == 1{
                            DispatchQueue.main.async {
                                
                                Alert.present(
                                    title: AppAlertTitle.appName.rawValue,
                                    message: dailyInventoryResp?.message ?? "",
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
}
extension BiweeklyInventoryListVC:UITableViewDataSource,UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return responseArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as? BiweeklyInventoryListCell
        
        if responseArray.count > 0{
        let respDict = responseArray[indexPath.row]
        let checkUncheckStatus = responseArray[indexPath.row]["check"] as? Bool ?? false
        if checkUncheckStatus == true{
            cell?.mainView.backgroundColor = UIColor(red: 214.0/255.0, green: 255.0/255.0, blue:218.0/255.0, alpha: 1.0)
        }else{
            cell?.mainView.backgroundColor = .white
        }
        let draftVal = respDict["draft"] as? String ?? ""
        if draftVal == "1"{
            cell?.editBtn.isHidden = false
            cell?.editBtnImgView.isHidden = false

            cell?.editBtn?.addTarget(self, action: #selector(editBtnAction(_:)), for: .touchUpInside)

        }else{
            cell?.editBtn.isHidden = true
            cell?.editBtnImgView.isHidden = true

        }
        cell?.nameBILbl.text = respDict["title"] as? String ?? ""
        let unixtimeInterval = respDict["creationAt"] as? String ?? ""
        print(unixtimeInterval,"Timeee")
        let date = Date(timeIntervalSince1970:  unixtimeInterval.doubleValue)
        let dateFormatterD = DateFormatter()
        dateFormatterD.timeZone = TimeZone(abbreviation: "IST") //Set timezone that you want
        dateFormatterD.locale = NSLocale.current
        dateFormatterD.dateFormat = "MMM d" //Specify your format that you want
        let strDate = dateFormatterD.string(from: date)
        
        let dateFormatterT = DateFormatter()
        dateFormatterT.timeZone = TimeZone(abbreviation: "IST") //Set timezone that you want
        dateFormatterT.locale = NSLocale.current
        dateFormatterT.dateFormat = "h:mm a" //Specify your format that you want
        let strTime = dateFormatterT.string(from: date)
        let finalString = strDate + " at " + strTime
        
            cell?.dateTimeBILbl.text = finalString
            
        }
        
        return cell!
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        for i in 0..<responseArray.count{
//            self.responseArray[i]["check"] = false
//        }
        if self.responseArray.count > 0{
        self.responseArray[indexPath.row]["check"] = true
        biweekelyInventoryTBView.reloadData()
        let storyBoard = UIStoryboard(name: StoryboardName.BiweekelyInventory, bundle: nil)
        let CMDVC = storyBoard.instantiateViewController(withIdentifier: ViewControllerIdentifier.BiweeklyInventoryDetailVC) as? BiweeklyInventoryDetailVC
        CMDVC?.biweeklyId = self.responseArray[indexPath.row]["weeklyId"] as? String ?? ""
        CMDVC?.delegate = self
        if let CMDVC = CMDVC {
            self.navigationController?.pushViewController(CMDVC, animated: true)
        }
        }
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == responseArray.count - 1{
            if lastPage == false{
                page = page + 1
                getBiweekelyInventoryListApi()
            }
        }
    }
}
extension BiweeklyInventoryListVC:SendingAddBiweekelyToBiweekelyMainPageDelegateProtocol{
    func sendDataToBiweekelyVC(myData: Bool) {
        loaderBool = myData
    }  
    
    
}
