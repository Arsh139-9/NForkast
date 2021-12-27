//
//  IngredientListVC.swift
//  Forkast
//
//  Created by Dharmani Apps mini on 3/17/21.
//

import UIKit
import Alamofire
import SVProgressHUD
class IngredientListVC: UIViewController {
    var responseArray = [[String:AnyHashable]]()
    var vendorListArr = [[String:Any]]()
    var categoryListArr = [[String:Any]]()
    var unitListArr = [[String:Any]]()
    var fullCaseUnitArr = [[String:Any]]()
    var lessCaseUnitArr = [[String:Any]]()
    var mappingCaseUnitArr = [[String:Any]]()
    var uOMCaseUnitArr = [[String:Any]]()

    var loaderBool = Bool()
    var page = Int()
    var lastPage = Bool()
    @IBOutlet weak var ingredientTBView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
      getPopUpItemsApi()
    }
    open func getPopUpItemsApi(){
     
                let userIds = getSAppDefault(key: "UserId") as? String ?? ""
                let token = getSAppDefault(key: "AuthToken") as? String ?? ""
              
//               let organisationId = getSAppDefault(key: "OrganisationId") as? String ?? ""
                
        let paramds = ["userId": userIds] as [String : Any]
                
                let strURL = kBASEURL + WSMethods.getListOfItem
                
                let urlwithPercentEscapes = strURL.addingPercentEncoding( withAllowedCharacters: CharacterSet.urlQueryAllowed)
//                SVProgressHUD.show()
                
                AF.request(urlwithPercentEscapes!, method: .post, parameters: paramds, encoding: JSONEncoding.default, headers: ["Content-Type":"application/json","Token":token])
                    .responseJSON { (response) in
//                        SVProgressHUD.dismiss()
                        switch response.result {
                        case .success(let value):
                            if let JSON = value as? [String: Any] {
                                print(JSON as NSDictionary)
                                let addProductDataResp =  PopUpItemListData.init(dict: JSON )
                                
                                if addProductDataResp?.status == 1{
                                 
                                    self.vendorListArr = addProductDataResp?.vendorDetailArr ?? [[:]]
                                    self.categoryListArr = addProductDataResp?.categoryDetailArr ?? [[:]]
                                    self.unitListArr = addProductDataResp?.unitDetailArr ?? [[:]]
                                    self.fullCaseUnitArr = addProductDataResp?.fullCaseUnitDetailArr ?? [[:]]
                                    self.lessCaseUnitArr = addProductDataResp?.lessCaseUnitDetailArr ?? [[:]]
                                    self.mappingCaseUnitArr = addProductDataResp?.mappingDetailArr ?? [[:]]
                                    self.uOMCaseUnitArr = addProductDataResp?.uOMDetailArr ?? [[:]]
                                    for obj in self.unitListArr{
                                     
                                      
                                        var respDict = obj
                                        respDict["check"] = false
                                      

                                    }
                                    
                                    for obj in self.vendorListArr{
                                     
                                      
                                        var respDict = obj
                                        respDict["check"] = false
                                      

                                    }
                                    for obj in self.categoryListArr{
                                        var respDict = obj
                                        respDict["check"] = false

                                    }
                                    for obj in self.fullCaseUnitArr{
                                        var respDict = obj
                                        respDict["check"] = false

                                    }
                                    for obj in self.lessCaseUnitArr{
                                        var respDict = obj
                                        respDict["check"] = false

                                    }
                                    for obj in self.mappingCaseUnitArr{
                                        var respDict = obj
                                        respDict["check"] = false

                                    }
                                    for obj in self.uOMCaseUnitArr{
                                                                           var respDict = obj
                                                                           respDict["check"] = false

                                                                       }
                                    
                                }else{
//                                    DispatchQueue.main.async {
//
//                                        Alert.present(
//                                            title: AppAlertTitle.appName.rawValue,
//                                            message: addProductDataResp?.message ?? "",
//                                            actions: .ok(handler: {
//                                            }),
//                                            from: self
//                                        )
//                                    }
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

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.tabBarController?.tabBar.isHidden = false

        if loaderBool == false{
            page = 1
            self.responseArray.removeAll()
            getIngredientListApi()
        }
    }
    @IBAction func backBtnAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }

    @IBAction func addIngredientBtnAction(_ sender: Any) {
        let storyBoard = UIStoryboard(name: StoryboardName.ProductIngredients, bundle: nil)
        let CMDVC = storyBoard.instantiateViewController(withIdentifier: ViewControllerIdentifier.AddIngredientVC) as? AddIngredientVC
        CMDVC?.vendorListArr = vendorListArr
        CMDVC?.categoryListArr = categoryListArr
        CMDVC?.unitListArr = unitListArr
     
        CMDVC?.fullCaseUnitArr = fullCaseUnitArr
        CMDVC?.lessCaseUnitArr = lessCaseUnitArr
        CMDVC?.mappingCaseUnitArr = mappingCaseUnitArr

        
        CMDVC?.delegate = self
        if let CMDVC = CMDVC {
            self.navigationController?.pushViewController(CMDVC, animated: true)
        }
  
    }
    open func getIngredientListApi(){
        
        let userId  = getSAppDefault(key: "UserId") as? String ?? ""
        let authToken  = getSAppDefault(key: "AuthToken") as? String ?? ""
        
        let params = ["userId": userId,"pageno":"\(page)","per_page":"10"]
        
        let strURL = kBASEURL + WSMethods.getAllIngredient
        
        let urlwithPercentEscapes = strURL.addingPercentEncoding( withAllowedCharacters: CharacterSet.urlQueryAllowed)
        SVProgressHUD.show()
        AF.request(urlwithPercentEscapes!, method: .post, parameters: params, encoding: JSONEncoding.default, headers: ["Content-Type":"application/json","Token":authToken])
            .responseJSON { (response) in
                SVProgressHUD.dismiss()
                switch response.result {
                case .success(let value):
                    if let JSON = value as? [String: AnyHashable] {
                        print(JSON as NSDictionary)
                        let dailyInventoryResp =  IngredientListData.init(dict: JSON )
                        
                        //                let status = jsonResult?["status"] as? Int ?? 0
                        if dailyInventoryResp?.status == 1{
                          
                           
                            
                            self.lastPage = false
                            let ingListArr = dailyInventoryResp!.ingredientListArr
                            for i in 0..<ingListArr.count{
                                self.responseArray.append(ingListArr[i])
                            }
                            self.ingredientTBView.reloadData()
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
extension IngredientListVC:UITableViewDataSource,UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return responseArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as? IngredientLisCell
        if cell == nil {
            let nib = Bundle.main.loadNibNamed("IngredientLisCell", owner: self, options: nil)
            cell = nib?[0] as? IngredientLisCell
        }
        
        let respDict = responseArray[indexPath.row]
        cell?.ingredientName.text = respDict["name"] as? String ?? ""
        cell?.vendorName.text = respDict["vendor"] as? String ?? ""

        var sPhotoStr = respDict["image"] as? String ?? ""
        sPhotoStr = sPhotoStr.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? ""
        if sPhotoStr != ""{
            cell?.ingredientImgView.sd_setImage(with: URL(string: sPhotoStr), placeholderImage:nil)
        }

        
        return cell!
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UIScreen.main.bounds.size.height * 0.13
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == responseArray.count - 1{
            if lastPage == false{
                page = page + 1
                getIngredientListApi()
            }
        }
    }
}
extension Dictionary where Key == String, Value == Any {
    
    mutating func append(anotherDict:[String:Any]) {
        for (key, value) in anotherDict {
            self.updateValue(value, forKey: key)
        }
    }
}
extension IngredientListVC:SendingAddIngredientToIngMainPageDelegateProtocol{
  
    
    
   
    func sendDataToIngredient(myData: Bool) {
        loaderBool = myData

    }
    
    
    
}
