//
//  PopUpListVC.swift
//  Forkast
//
//  Created by Dharmani Apps mini on 3/20/21.
//

import UIKit
import SVProgressHUD
import Alamofire

protocol MyDataSendingDelegateProtocol {
    func sendDataToFirstViewController(productRespArray:[[String:AnyHashable]],ingredientRespArray:[[String:AnyHashable]],unitListArr:[[String:Any]])
}

class PopUpListVC: UIViewController {
    var productRespArray = [[String:AnyHashable]]()
    var ingredientRespArray = [[String:AnyHashable]]()
    var page = Int()
    var lastPage = Bool()
    var navBarTitleLbl = String()
    var delegate: MyDataSendingDelegateProtocol? = nil
    var unitListArr = [[String:Any]]()


    @IBOutlet weak var navBarLbl: UILabel!
    
    @IBOutlet weak var popUpTBView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navBarLbl.text = navBarTitleLbl
        if navBarTitleLbl == "Products"{

            if productRespArray.count == 0{
                productRespArray.removeAll()
                page = 1
                getProductListApi()
            }else{
                self.popUpTBView.reloadData()

            }
        }
        else if navBarTitleLbl == "UOM"{
            if unitListArr.count == 0{
                unitListArr.removeAll()
                getPopUpItemsApi()
            }else{
                self.popUpTBView.reloadData()
            }
        }
        else{
            if ingredientRespArray.count == 0{
                ingredientRespArray.removeAll()
                page = 1
                getIngredientListApi()
            }else{
                self.popUpTBView.reloadData()

            }
        }
        // Do any additional setup after loading the view.
        

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
       
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
                                 
//                                    self.vendorListArr = addProductDataResp?.vendorDetailArr ?? [[:]]
//                                    self.categoryListArr = addProductDataResp?.categoryDetailArr ?? [[:]]
                                    let unitArr = addProductDataResp?.unitDetailArr ?? [[:]]
                                    for i in 0..<unitArr.count{
                                        self.unitListArr.append(unitArr[i])
                                    }
                                    self.popUpTBView.reloadData()

//                                    for obj in self.unitListArr{
//
//
//                                        var respDict = obj
//                                        respDict["check"] = false
//
//
//                                    }
                                    
                                 
                                    
                                    
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
                                    message: AppAlertTitle.connectionError.rawValue,
                                    actions: .ok(handler: {
                                    }),
                                    from: self
                                )
                            }
                        }
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
                            let ingredientListArr =  dailyInventoryResp!.ingredientListArr
                            for i in 0..<ingredientListArr.count{
                                self.ingredientRespArray.append(ingredientListArr[i])
                            }
                            self.popUpTBView.reloadData()
                          
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
    open func getProductListApi(){
        
        let userId  = getSAppDefault(key: "UserId") as? String ?? ""
        let authToken  = getSAppDefault(key: "AuthToken") as? String ?? ""
        
        let params = ["userId": userId,"pageno":"\(page)","per_page":"10"]
        
        let strURL = kBASEURL + WSMethods.getAllProduct
        
        let urlwithPercentEscapes = strURL.addingPercentEncoding( withAllowedCharacters: CharacterSet.urlQueryAllowed)
        SVProgressHUD.show()
        AF.request(urlwithPercentEscapes!, method: .post, parameters: params, encoding: JSONEncoding.default, headers: ["Content-Type":"application/json","Token":authToken])
            .responseJSON { (response) in
                SVProgressHUD.dismiss()
                switch response.result {
                case .success(let value):
                    if let JSON = value as? [String: AnyHashable] {
                        print(JSON as NSDictionary)
                        let dailyInventoryResp =  ProductListData.init(dict: JSON )
                        
                        //                let status = jsonResult?["status"] as? Int ?? 0
                        if dailyInventoryResp?.status == 1{
                          
                            self.lastPage = false

                            let productListArr =  dailyInventoryResp!.productListArr
                            for i in 0..<productListArr.count{
                                self.productRespArray.append(productListArr[i])
                            }
                            
                            
                            self.popUpTBView.reloadData()

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
    @IBAction func backBtnAction(_ sender: Any) {
        if navBarTitleLbl == "Products"{
        if self.delegate != nil{
            self.delegate?.sendDataToFirstViewController(productRespArray:productRespArray, ingredientRespArray: ingredientRespArray,unitListArr:unitListArr)
        }
        }
        
        else{
            if self.delegate != nil{
                self.delegate?.sendDataToFirstViewController(productRespArray:productRespArray, ingredientRespArray: ingredientRespArray,unitListArr:unitListArr)
            }
        }
        navigationController?.popViewController(animated:true)
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
extension PopUpListVC:UITableViewDataSource,UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if navBarTitleLbl == "Products"{
            return productRespArray.count
        }
        else if navBarTitleLbl == "UOM"{
            return unitListArr.count
        }
        else{
            return ingredientRespArray.count
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as? AddIngredientPopUpTBCell
        if cell == nil {
            let nib = Bundle.main.loadNibNamed("IngredientLisCell", owner: self, options: nil)
            cell = nib?[0] as? AddIngredientPopUpTBCell
        }
        var respDict = [String:Any]()
        if navBarTitleLbl == "Products"{
       respDict = productRespArray[indexPath.row]
        }
        else if navBarTitleLbl == "UOM"{
            respDict = unitListArr[indexPath.row]

        }
        else{
            respDict = ingredientRespArray[indexPath.row]

        }
        if navBarTitleLbl == "UOM"{
            cell?.popUpItemLbl.text = respDict["unit"] as? String ?? ""

        }else{
            cell?.popUpItemLbl.text = respDict["name"] as? String ?? ""
        }
        
        let checkUncheckStatus = respDict["check"] as? Bool ?? false
        if checkUncheckStatus == true{
            cell?.checkUncheckImgView.image = #imageLiteral(resourceName: "checkImg")
        }else{
            cell?.checkUncheckImgView.image = #imageLiteral(resourceName: "uncheckImg")
        }

        
        return cell!
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UIScreen.main.bounds.size.height * 0.079
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if navBarTitleLbl == "Products"{
            for i in 0..<productRespArray.count{
                self.productRespArray[i]["check"] = false
            }
            self.productRespArray[indexPath.row]["check"] = true
            popUpTBView.reloadData()
            let respDict = productRespArray[indexPath.row]
            let name = respDict["name"] as? String ?? ""
            
            setAppDefaults(name, key: "PName")
            setAppDefaults(navBarTitleLbl, key: "NavBarTitleLbl")
            let productId  = respDict["productId"] as? String ?? ""
            setAppDefaults(productId, key: "productId")
            if self.delegate != nil{
                self.delegate?.sendDataToFirstViewController(productRespArray:productRespArray, ingredientRespArray: ingredientRespArray, unitListArr: unitListArr)
            }
        }
        else if navBarTitleLbl == "UOM"{
            for i in 0..<unitListArr.count{
                self.unitListArr[i]["check"] = false
            }
            self.unitListArr[indexPath.row]["check"] = true
            popUpTBView.reloadData()
            let respDict = unitListArr[indexPath.row]
            let name = respDict["unit"] as? String ?? ""
            
            setAppDefaults(name, key: "UName")
            setAppDefaults(navBarTitleLbl, key: "NavBarTitleLbl")
            let unitId  = respDict["id"] as? String ?? ""
            setAppDefaults(unitId, key: "unitId")
            if self.delegate != nil{
                self.delegate?.sendDataToFirstViewController(productRespArray:productRespArray, ingredientRespArray: ingredientRespArray, unitListArr: unitListArr)
            }
        }
        
        else{
            for i in 0..<ingredientRespArray.count{
                self.ingredientRespArray[i]["check"] = false
            }
            self.ingredientRespArray[indexPath.row]["check"] = true
            popUpTBView.reloadData()
            let respDict = ingredientRespArray[indexPath.row]
            let name = respDict["name"] as? String ?? ""
            
            setAppDefaults(name, key: "IName")
            setAppDefaults(navBarTitleLbl, key: "NavBarTitleLbl")
            let ingredientId  = respDict["ingredientId"] as? String ?? ""
            setAppDefaults(ingredientId, key: "ingredientId")
            if self.delegate != nil{
                self.delegate?.sendDataToFirstViewController(productRespArray:productRespArray, ingredientRespArray: ingredientRespArray, unitListArr: unitListArr)
            }
        }
        
        
      
        self.navigationController?.popViewController(animated: true)
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if navBarTitleLbl == "Products"{
            if indexPath.row == productRespArray.count - 1{
                if lastPage == false{
                    page = page + 1
                    getProductListApi()
                }
            }

        }else{
            if indexPath.row == ingredientRespArray.count - 1{
                if lastPage == false{
                    page = page + 1
                    getIngredientListApi()
                }
            }
        }
    }
}
