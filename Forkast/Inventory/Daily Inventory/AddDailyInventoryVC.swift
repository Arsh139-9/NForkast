//
//  AddDailyInventoryVC.swift
//  Forkast
//
//  Created by Dharmani Apps mini on 3/10/21.
//

import UIKit
import Alamofire
import SVProgressHUD

protocol SendingAddDailyToDailyMainPageDelegateProtocol {
    func sendDataToDailyVC(myData: Bool)
}

class AddDailyInventoryVC: UIViewController {
    var sections = [Category]()
    var itemIdArr = [String]()
    var isDraftVal = String()
    var draftComment = String()
    var draftDailyId = String()
   
    @IBOutlet weak var navBarTitleLbl: UILabel!
    
    
    @IBOutlet weak var dailyInventoryTBHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var dailyInventoryDetailTBView: UITableView!
    
    @IBOutlet weak var commentTextView: UITextView!
    var delegate: SendingAddDailyToDailyMainPageDelegateProtocol? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        dailyInventoryDetailTBView.sectionHeaderHeight = UITableView.automaticDimension
        dailyInventoryDetailTBView.estimatedSectionHeaderHeight = 49
        
        commentTextView.textContainerInset = UIEdgeInsets(top: 13, left: 13, bottom: 13, right: 13)
        
        if isDraftVal == "1"{
            navBarTitleLbl.text = "Edit Daily Hot List"
        commentTextView.text = draftComment
        dailyInventoryDetailApi(dailyId: draftDailyId)
        }else{
            navBarTitleLbl.text = "Add Daily Hot List"

            dailyInventoryDetailApi(dailyId: "")
        }
      

            
        

    }
    @IBAction func backBtnAction(_ sender: Any) {
        if self.delegate != nil{
            self.delegate?.sendDataToDailyVC(myData: true)
        }
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func submitInventoryBtnAction(_ sender: Any) {
        if self.sections.count > 0{
        itemIdArr.removeAll()
          for obj in self.sections[0].items{
              let checkUncheckStatus = obj["checked"] as? String ?? ""
              if checkUncheckStatus == "True"{

            let itemId = obj["itemId"] as? String ?? ""
              itemIdArr.append(itemId)
              }
        }
          for obj in self.sections[1].items{
              let checkUncheckStatus = obj["checked"] as? String ?? ""
              if checkUncheckStatus == "True"{

            let itemId = obj["itemId"] as? String ?? ""
              itemIdArr.append(itemId)
              }
        }
        if itemIdArr.count == 0{
                Alert.present(
                    title: AppAlertTitle.appName.rawValue,
                    message: "Please select item",
                    actions: .ok(handler: {
                    }),
                    from: self
                )
            
        }else{
            addDailyInventoryDetailApi(draft: "", isSave: "1")

        }
        }

    }
    
    @IBAction func saveDraftBtnAction(_ sender: Any) {
        itemIdArr.removeAll()
          for obj in self.sections[0].items{
              let checkUncheckStatus = obj["checked"] as? String ?? ""
              if checkUncheckStatus == "True"{

            let itemId = obj["itemId"] as? String ?? ""
              itemIdArr.append(itemId)
              }
        }
          for obj in self.sections[1].items{
              let checkUncheckStatus = obj["checked"] as? String ?? ""
              if checkUncheckStatus == "True"{

            let itemId = obj["itemId"] as? String ?? ""
              itemIdArr.append(itemId)
              }
        }
//        if itemIdArr.count == 0{
//                Alert.present(
//                    title: AppAlertTitle.appName.rawValue,
//                    message: "Please select item",
//                    actions: .ok(handler: {
//                    }),
//                    from: self
//                )
            
//        }else{
            addDailyInventoryDetailApi(draft: "1", isSave: "1")

       // }
        

    }
    open  func addDailyInventoryDetailApi(draft:String,isSave:String){
     
      let userIds = getSAppDefault(key: "UserId") as? String ?? ""
      let token = getSAppDefault(key: "AuthToken") as? String ?? ""
       
        let paramds = ["dailyId": draftDailyId,"userId": userIds,"itemId":itemIdArr,"comment":commentTextView.text ?? "","draft":draft,"is_save":isSave] as [String : Any]


          
          let strURL = kBASEURL + WSMethods.addDailyInventoryDetail
          
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
                            if self.delegate != nil{
                                self.delegate?.sendDataToDailyVC(myData: false)
                            }
                              self.navigationController?.popViewController(animated: true)
                              
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
                          }),
                          from: self
                      )
                      }
                  }
              }
          
      }
    open func dailyInventoryDetailApi(dailyId:String){
        let userIds = getSAppDefault(key: "UserId") as? String ?? ""
        let token = getSAppDefault(key: "AuthToken") as? String ?? ""
        
        
        let paramds = ["dailyId": dailyId,"userId": userIds,"itemId":[],"comment":"","draft":"","is_save":""] as [String : Any]
        
        let strURL = kBASEURL + WSMethods.addDailyInventoryDetail
        
        let urlwithPercentEscapes = strURL.addingPercentEncoding( withAllowedCharacters: CharacterSet.urlQueryAllowed)
//        SVProgressHUD.show()
        
        AF.request(urlwithPercentEscapes!, method: .post, parameters: paramds, encoding: JSONEncoding.default, headers: ["Content-Type":"application/json","Token":token])
            .responseJSON { (response) in
//                SVProgressHUD.dismiss()
                switch response.result {
                case .success(let value):
                    if let JSON = value as? [String: Any] {
                        print(JSON as NSDictionary)
                        let addDailyInventoryResp =  AddDetailDailyInventoryData.init(dict: JSON )
                        
                        //                let status = jsonResult?["status"] as? Int ?? 0
                        if addDailyInventoryResp?.status == 1{
                            let dailyProductDetailArr = addDailyInventoryResp!.dailyProductDetailArr
                            let specialProductDetailArr = addDailyInventoryResp!.specialProductDetailArr
                            self.sections = [Category(name:"Check if needed", items:dailyProductDetailArr),Category(name:"Special Items", items:specialProductDetailArr)
                                        ]
                            let userDetailDict = addDailyInventoryResp?.dailyUserDetailDict as? [String:AnyHashable] ?? [:]
                            self.commentTextView.text = userDetailDict["comment"] as? String ?? ""
                            self.dailyInventoryDetailTBView.reloadData()
//                            self.dailyInventoryData = DailyInventoryData(["dailyProductDetailArr":dailyProductDetailArr])
                           
                            
                            
                        }
                        
                        
                    }
                case .failure(let error):
                    let error : NSError = error as NSError
                    print(error)
                    
                }
            }
        
    }
   

}
extension AddDailyInventoryVC:UITableViewDataSource,UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.sections.count

    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.sections[section].name
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cells") as! AddDailyInventoryCell
        let items = self.sections[indexPath.section].items
        let item = items[indexPath.row]
        
        cell.dAIIngredientNameLbl.text = item["name"] as? String ?? ""
        let checkUncheckStatus = item["checked"] as? String ?? ""
        debugPrint(checkUncheckStatus)
        if checkUncheckStatus == "True"{
            cell.checkUncheckAImgView.image = #imageLiteral(resourceName: "checkImg")
        }else{
            cell.checkUncheckAImgView.image = #imageLiteral(resourceName: "uncheckImg")
        }
        DispatchQueue.main.async {
            self.dailyInventoryTBHeightConstraint.constant = self.dailyInventoryDetailTBView.contentSize.height
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {

            return UIScreen.main.bounds.height * 0.09
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        return UIScreen.main.bounds.height * 0.07

    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.sections[indexPath.section].items[indexPath.row]["checked"] = self.sections[indexPath.section].items[indexPath.row]["checked"] as? String ?? "" == "True" ? "False" : "True"
        self.dailyInventoryDetailTBView.reloadData()
    }
    
}
