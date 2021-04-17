//
//  AddIngredientForkastVC.swift
//  Forkast
//
//  Created by Dharmani Apps mini on 3/18/21.
//

import UIKit
import Alamofire
import SVProgressHUD


class AddIngredientForkastVC: UIViewController {

    @IBOutlet weak var fullCaseUnitTF: UITextField!
    
    @IBOutlet weak var fullCasePriceTF: UITextField!
    
    @IBOutlet weak var lessCaseUnitTF: UITextField!
    
    @IBOutlet weak var lessCaseQuantityTF: UITextField!
    

    @IBOutlet weak var uncheckRadioBtn: UIButton!
    
    
    @IBOutlet weak var checkedRadioBtn: UIButton!
    
    @IBOutlet weak var mappingUnitTF: UITextField!
    
    
    @IBOutlet weak var mappingUnitCaseTF: UITextField!
    
    @IBOutlet weak var mappingWastePercentTF: UITextField!
    
    
    @IBOutlet weak var popUpView: UIView!
    
    @IBOutlet weak var popUpTBView: UITableView!
    
    @IBOutlet weak var popUpTypeLbl: UILabel!
    var unitListArr = [[String:Any]]()
    var selected = 0
    var isFCase = -1
    var isLCase = -1
    var isMCase = -1
    var ingredientName = String()
    var preferredVendor = String()
    var category = String()
    var parValue = String()
    var base64 = String()

    

    
    var inventoryCount = String()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = true
        self.popUpView.isHidden = true

        // Do any additional setup after loading the view.
    }
    @IBAction func popUpViewCrossBtnAction(_ sender: Any) {
        popUpView.isHidden = true
    }
    @IBAction func backBtnAction(_ sender: Any) {
        
        navigationController?.popViewController(animated: true)
    }
    open func addProductDetailIngredientApi(){
        //        let compressedData = productImgView.image?.jpegData(compressionQuality: 0.2)
        //        let base64:String = compressedData?.base64EncodedString(options: .lineLength64Characters) ?? ""
        //        debugPrint("base64------> \(base64)")
        let token = getSAppDefault(key: "AuthToken") as? String ?? ""
//        {
//        "full_unit":"Case",
//        "full_price":"50",
//        "less_unit":"Bag",
//        "less_quantity":"1",
//        "inventory_count":"2",
//        "mapping_unit":"Count",
//        "mapping_unit_case":"80",
//        "waste_factor":"2%",
//        "ingredientId":"1"
//        }
        
        
        
//        {
//                "name":"Meatballs123",
//                "vendor":"SYSCO",
//                "category":"MEATS",
//                "inventory_method":"2",
//                "parValue":"",
//                "userId":"13",
//                "image":"",
        
        
//                "full_unit":"Case",
//        "full_price":"80",
//        "less_unit":"Bag",
//        "less_quantity":"5",
//        "inventory_count":"2",
//        "mapping_unit":"Ounces",
//        "mapping_unit_case":"480",
//        "waste_factor":"5%",
//        }
        //    let paramds = ["userId": userIds,"name":ingredientNameTF.text ?? "","vendor": preferredVendorTF.text ?? "","category":categoryTF.text ?? "","inventory_method":inventoryMethod,"parValue":parTF.text ?? "","image":"","ingredientId":""] as [String : Any]
        let userIds = getSAppDefault(key: "UserId") as? String ?? ""

        let paramds = ["userId": userIds,"name":ingredientName,"vendor":preferredVendor,"category":category,"inventory_method":"2","parValue":parValue,"image":base64,"ingredientId": "","full_unit":fullCaseUnitTF.text ?? "","full_price": fullCasePriceTF.text ?? "","less_unit":lessCaseUnitTF.text ?? "","less_quantity":lessCaseQuantityTF.text ?? "","inventory_count":inventoryCount,"mapping_unit":mappingUnitTF.text ?? "","mapping_unit_case":mappingUnitCaseTF.text ?? "","waste_factor":mappingWastePercentTF.text ?? ""] as [String : Any]

        let strURL = kBASEURL + WSMethods.addIngredient

        let urlwithPercentEscapes = strURL.addingPercentEncoding( withAllowedCharacters: CharacterSet.urlQueryAllowed)
        SVProgressHUD.show()

        AF.request(urlwithPercentEscapes!, method: .post, parameters: paramds, encoding: JSONEncoding.default, headers: ["Content-Type":"application/json","Token":token])
            .responseJSON { (response) in
                SVProgressHUD.dismiss()
                switch response.result {
                case .success(let value):
                    if let JSON = value as? [String: Any] {
                        print(JSON as NSDictionary)
                        let addProductDataResp =  AddProductData.init(dict: JSON )

                        if addProductDataResp?.status == 1{

                           
                            for vc in  self.navigationController!.viewControllers {
                                           if vc is IngredientListVC {
                                                self.navigationController?.popToViewController(vc, animated: false)
                                           }
                                       }


                        }else{
                            DispatchQueue.main.async {

                                Alert.present(
                                    title: AppAlertTitle.appName.rawValue,
                                    message: addProductDataResp?.message ?? "",
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
    @IBAction func selectFullCaseUnitBtnAction(_ sender: Any) {
        selected = 1
        popUpView.isHidden = false
        popUpTypeLbl.text = "Full Case"
        popUpTBView.reloadData()
        self.view.endEditing(true)
    }
    
    @IBAction func selectLessCaseUnitBtnAction(_ sender: Any) {
        selected = 2
        popUpView.isHidden = false
        popUpTypeLbl.text = "Less Case"
        popUpTBView.reloadData()
        self.view.endEditing(true)

    }
    
    @IBAction func selectMappingUnitBtnAction(_ sender: Any) {
        selected = 3
        popUpView.isHidden = false
        popUpTypeLbl.text = "Mapping Units"
        popUpTBView.reloadData()
        self.view.endEditing(true)

    }
    
    @IBAction func uncheckRadioBtnAction(_ sender: UIButton) {
        inventoryCount = "2"
        uncheckRadioBtn.setImage(UIImage(named: "checkRadioBtnImg"), for:UIControl.State.normal)
        checkedRadioBtn.setImage(UIImage(named: "unCheckRadioBtnImg"), for:UIControl.State.normal)
    }
    
    @IBAction func checkRadioBtnAction(_ sender: UIButton) {
        inventoryCount = "1"
        uncheckRadioBtn.setImage(UIImage(named: "unCheckRadioBtnImg"), for:UIControl.State.normal)
        checkedRadioBtn.setImage(UIImage(named: "checkRadioBtnImg"), for:UIControl.State.normal)
    
    }
    
    @IBAction func saveForekastIngredientBtnAction(_ sender: Any) {
        if fullCaseUnitTF.text?.trimmingCharacters(in: .whitespaces) == ""{
            Alert.present(
                title: AppAlertTitle.appName.rawValue,
                message: AppSignInForgotSignUpAlertNessage.enterFCUnit,
                actions: .ok(handler: {
                }),
                from: self
            )
        }
        else if fullCasePriceTF.text?.trimmingCharacters(in: .whitespaces) == ""{
            Alert.present(
                title: AppAlertTitle.appName.rawValue,
                message: AppSignInForgotSignUpAlertNessage.enterFCPrice,
                actions: .ok(handler: {
                }),
                from: self
            )
        }
        else if lessCaseUnitTF.text?.trimmingCharacters(in: .whitespaces) == ""{
            Alert.present(
                title: AppAlertTitle.appName.rawValue,
                message: AppSignInForgotSignUpAlertNessage.enterLCUnit,
                actions: .ok(handler: {
                }),
                from: self
            )
        }
        else if lessCaseQuantityTF.text?.trimmingCharacters(in: .whitespaces) == ""{
            Alert.present(
                title: AppAlertTitle.appName.rawValue,
                message: AppSignInForgotSignUpAlertNessage.enterLCQuantity,
                actions: .ok(handler: {
                }),
                from: self
            )
        }
        else if mappingUnitTF.text?.trimmingCharacters(in: .whitespaces) == ""{
            Alert.present(
                title: AppAlertTitle.appName.rawValue,
                message: AppSignInForgotSignUpAlertNessage.enterMappingUnit,
                actions: .ok(handler: {
                }),
                from: self
            )
        }
        else if mappingUnitCaseTF.text?.trimmingCharacters(in: .whitespaces) == ""{
            Alert.present(
                title: AppAlertTitle.appName.rawValue,
                message: AppSignInForgotSignUpAlertNessage.enterMappingUnitCase,
                actions: .ok(handler: {
                }),
                from: self
            )
        }
        else if mappingWastePercentTF.text?.trimmingCharacters(in: .whitespaces) == ""{
            Alert.present(
                title: AppAlertTitle.appName.rawValue,
                message: AppSignInForgotSignUpAlertNessage.enterMappingWastePercent,
                actions: .ok(handler: {
                }),
                from: self
            )
        }else{
            addProductDetailIngredientApi()
        }
        
    }
    
}
extension AddIngredientForkastVC:UITableViewDataSource,UITableViewDelegate{
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return unitListArr.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! AddIngredientPopUpTBCell
        var item = [String:Any]()
            item = unitListArr[indexPath.row]
       
        cell.popUpItemLbl.text = item["unit"] as? String ?? ""
        if selected == 1{
            cell.checkUncheckImgView.image = isFCase == indexPath.row ? #imageLiteral(resourceName: "checkImg") : #imageLiteral(resourceName: "uncheckImg")
        }else if selected == 2{
            cell.checkUncheckImgView.image = isLCase == indexPath.row ? #imageLiteral(resourceName: "checkImg") : #imageLiteral(resourceName: "uncheckImg")
        }else if selected == 3{
            cell.checkUncheckImgView.image = isMCase == indexPath.row ? #imageLiteral(resourceName: "checkImg") : #imageLiteral(resourceName: "uncheckImg")
        }

        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UIScreen.main.bounds.size.height * 0.1
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if selected == 1{
            isFCase = indexPath.row
            fullCaseUnitTF.text = self.unitListArr[indexPath.row]["unit"] as? String ?? ""
            
        }else if selected == 2{
            isLCase = indexPath.row
            lessCaseUnitTF.text = self.unitListArr[indexPath.row]["unit"] as? String ?? ""
        }
        else if selected == 3{
            isMCase = indexPath.row
            mappingUnitTF.text = self.unitListArr[indexPath.row]["unit"] as? String ?? ""
        }
        self.popUpTBView.reloadData()
        popUpView.isHidden = true
    }
    
}
// MARK: TextField Delegates
extension AddIngredientForkastVC:UITextFieldDelegate{
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        return true
    }
    
}
