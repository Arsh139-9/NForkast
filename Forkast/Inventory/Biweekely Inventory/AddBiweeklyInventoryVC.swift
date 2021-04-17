//
//  AddBiweeklyInventoryVC.swift
//  Forkast
//
//  Created by Dharmani Apps mini on 3/10/21.
//

import UIKit
import Alamofire
import SVProgressHUD
import SDWebImage
protocol SendingAddBiweekelyToBiweekelyMainPageDelegateProtocol {
    func sendDataToBiweekelyVC(myData: Bool)
}

class AddBiweeklyInventoryVC: UIViewController {
    var responseArray = [[String:Any]]()
    var count = Int()
    var countArr = [Int]()
    var delegate: SendingAddBiweekelyToBiweekelyMainPageDelegateProtocol? = nil
    var isDraftVal = String()
    var draftComment = String()
    var draftBiweeklyId = String()
    @IBOutlet weak var biweeklyTBHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var navBarTitleLbl: UILabel!

    @IBOutlet weak var commentTextView: UITextView!
    @IBOutlet weak var biweekelyTBView: UITableView!
    var quantityIDDictArr = [[String:AnyHashable]]()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        commentTextView.textContainerInset = UIEdgeInsets(top: 13, left: 13, bottom: 13, right: 13)
        biweekelyTBView.tableFooterView = UIView()
        biweekelyTBView.estimatedRowHeight = 90
        
        if isDraftVal == "1"{
            navBarTitleLbl.text = "Edit Inventory"
        commentTextView.text = draftComment
            getBiweekelyInventoryDetail(weeklyId:draftBiweeklyId)

        }else{
            navBarTitleLbl.text = "Add Inventory"

            getBiweekelyInventoryDetail(weeklyId: "")
        }
        
        
        
        
    }
    @objc func increaseQuantity(_ sender: UIButton?) {
        var parentCell = sender?.superview

        while !(parentCell is BiweekelyInventoryDetailCell) {
            parentCell = parentCell?.superview
        }
        var indexPath: IndexPath? = nil
        let cell1 = parentCell as? BiweekelyInventoryDetailCell
        indexPath = biweekelyTBView.indexPath(for: cell1!)
        let respDict = responseArray[indexPath!.row] as? [String:AnyHashable] ?? [:]
        var number = Int(respDict["total_quantity"] as? String ?? "0") ?? 0
        number += 1

        responseArray[indexPath!.row]["total_quantity"] = "\(number )"
        cell1?.biQuantityTF.text = "\(number)"
       
 
    }
    @objc func decreaseQuantity(_ sender: UIButton?) {
        
        var parentCell = sender?.superview

        while !(parentCell is BiweekelyInventoryDetailCell) {
            parentCell = parentCell?.superview
        }
        var indexPath: IndexPath? = nil
         let cell1 = parentCell as? BiweekelyInventoryDetailCell
        indexPath = biweekelyTBView.indexPath(for: cell1!)
        let respDict = responseArray[indexPath!.row] as? [String:AnyHashable] ?? [:]
        var number = Int(respDict["total_quantity"] as? String ?? "0") ?? 0
        if number != 0{
            number -= 1
        }
        responseArray[indexPath!.row]["total_quantity"] = "\(number)"
        cell1?.biQuantityTF.text = "\(number)"
      
    }
    @IBAction func backBtnAction(_ sender: Any) {
        if self.delegate != nil{
            self.delegate?.sendDataToBiweekelyVC(myData: true)
        }
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func submitInventoryBtnAction(_ sender: UIButton) {
        quantityIDDictArr.removeAll()
        var selected = false
        for i in 0..<responseArray.count{
            if responseArray[i]["total_quantity"] as? String != ""{
                selected = true
//                return
            }
            if selected == true{
                let ingredientId = responseArray[i]["ingredientId"] as? String ?? ""
            var quantity = responseArray[i]["total_quantity"] as? String ?? "0"
            if quantity == ""{
                quantity = "0"
            }
                let ingQuantityDict = ["ingredientId":ingredientId,"quantity":quantity]
                quantityIDDictArr.append(ingQuantityDict)
            }
        }

       
        if quantityIDDictArr.count == 0{
                Alert.present(
                    title: AppAlertTitle.appName.rawValue,
                    message: "Please select item",
                    actions: .ok(handler: {
                    }),
                    from: self
                )
            
        }else{
            if sender.tag == 0{
                addBiweekelyInventoryDetailApi(draft: "", isSave: "1")

                sender.isUserInteractionEnabled = false
                sender.tag = 1
            }else{
                sender.isUserInteractionEnabled = true
                sender.tag = 0

            }
        }

    }
    
    
    @IBAction func saveDraftInventoryBtnAction(_ sender: UIButton) {
        quantityIDDictArr.removeAll()
        var selected = false
        for i in 0..<responseArray.count{
            if responseArray[i]["total_quantity"] as? String != ""{
//                selected = true
//                return
            }
//            if selected == true{
                let ingredientId = responseArray[i]["ingredientId"] as? String ?? ""
            var quantity = responseArray[i]["total_quantity"] as? String ?? "0"
            if quantity == ""{
                quantity = "0"
            }
                let ingQuantityDict = ["ingredientId":ingredientId,"quantity":quantity]
                quantityIDDictArr.append(ingQuantityDict)
           // }
        }
    //    if quantityIDDictArr.count == 0{
//                Alert.present(
//                    title: AppAlertTitle.appName.rawValue,
//                    message: "Please enter ingredient detail ",
//                    actions: .ok(handler: {
//                    }),
//                    from: self
//                )
            
      //  }
      //  else{
            if sender.tag == 0{
                addBiweekelyInventoryDetailApi(draft: "1", isSave: "1")

                sender.isUserInteractionEnabled = false
                sender.tag = 1
            }else{
                sender.isUserInteractionEnabled = true
                sender.tag = 0

            }
            
       // }
    }
  open  func addBiweekelyInventoryDetailApi(draft:String,isSave:String){
   
      
    let userIds = getSAppDefault(key: "UserId") as? String ?? ""
    let token = getSAppDefault(key: "AuthToken") as? String ?? ""
  
    let paramds = ["weeklyId":draftBiweeklyId ,"userId": userIds,"ingredient_detail":quantityIDDictArr,"comment":commentTextView.text ?? "","draft":draft,"is_save":isSave] as [String : Any]
        
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
                            if self.delegate != nil{
                                self.delegate?.sendDataToBiweekelyVC(myData: false)
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
    open func getBiweekelyInventoryDetail(weeklyId:String){
        let userIds = getSAppDefault(key: "UserId") as? String ?? ""
        let token = getSAppDefault(key: "AuthToken") as? String ?? ""
    
        let paramds = ["weeklyId":weeklyId,"userId": userIds,"ingredient_detail":[],"comment":"","draft":"","is_save":""] as [String : Any]
        
        let strURL = kBASEURL + WSMethods.addBiWeeklyInventory
        
        let urlwithPercentEscapes = strURL.addingPercentEncoding( withAllowedCharacters: CharacterSet.urlQueryAllowed)
//        SVProgressHUD.show()
        AF.request(urlwithPercentEscapes!, method: .post, parameters: paramds, encoding: JSONEncoding.default, headers: ["Content-Type":"application/json","Token":token])
            .responseJSON { (response) in
//                SVProgressHUD.dismiss()
                switch response.result {
                case .success(let value):
                    if let JSON = value as? [String: Any] {
                        print(JSON as NSDictionary)
                        let addDailyInventoryResp =  AddDetailBiweekelyInventoryData.init(dict: JSON )
                        
                        //                let status = jsonResult?["status"] as? Int ?? 0
                        if addDailyInventoryResp?.status == 1{
                            self.responseArray = addDailyInventoryResp!.biweekelyProductDetailArr
                            let userDetailDict = addDailyInventoryResp?.biweekelyUserDetailDict as? [String:AnyHashable] ?? [:]
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
                        }),
                        from: self
                    )
                    }

                }
            }
        
    }
    

   

}
extension AddBiweeklyInventoryVC:UITableViewDataSource,UITableViewDelegate{
    
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

        cell?.increaseQuantityBtn?.addTarget(self, action: #selector(increaseQuantity(_:)), for: .touchUpInside)
        cell?.decreaseQuantityBtn?.addTarget(self, action: #selector(decreaseQuantity(_:)), for: .touchUpInside)

       
        var sPhotoStr = respDict["image"] as? String ?? ""
        sPhotoStr = sPhotoStr.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? ""
        if sPhotoStr != ""{
            cell?.biweeklyProfileImg.sd_setImage(with: URL(string: sPhotoStr), placeholderImage:nil)
        }

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
