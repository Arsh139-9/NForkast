//
//  AddIngredientVC.swift
//  Forkast
//
//  Created by Dharmani Apps mini on 3/17/21.
//

import UIKit
import Alamofire
import SVProgressHUD
protocol SendingAddIngredientToIngMainPageDelegateProtocol {
    func sendDataToIngredient(myData: Bool)
}
class AddIngredientVC: UIViewController,UINavigationControllerDelegate,UIImagePickerControllerDelegate{
    
    @IBOutlet weak var ingredientNameTF: UITextField!
    @IBOutlet weak var preferredVendorTF: UITextField!
    @IBOutlet weak var categoryTF: UITextField!
    @IBOutlet weak var fullCaseUnitTF: UITextField!
    @IBOutlet weak var lessCaseUnitTF: UITextField!

    @IBOutlet weak var fullCasePriceTF: UITextField!
    
    @IBOutlet weak var lessCasePriceTF: UITextField!
    
    @IBOutlet weak var parTF: UITextField!
    
    @IBOutlet weak var popUpTBView: UITableView!
    
    @IBOutlet weak var popUpView: UIView!
    
    @IBOutlet weak var popUpTypeLbl: UILabel!
    
    @IBOutlet weak var parPopUpView: UIView!
    
    @IBOutlet weak var parPopUpHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var uncheckRadioBtn: UIButton!
    var delegate: SendingAddIngredientToIngMainPageDelegateProtocol? = nil
    @IBOutlet weak var ingredientImgView: UIImageView!

    @IBOutlet weak var checkedRadioBtn: UIButton!
    
    @IBOutlet weak var unchKRBtn: UIButton!
    
    @IBOutlet weak var cHKRBtn: UIButton!
    
    var vendorListArr = [[String:Any]]()
    var categoryListArr = [[String:Any]]()
    var unitListArr = [[String:Any]]()
    var fullCaseUnitArr = [[String:Any]]()
    var lessCaseUnitArr = [[String:Any]]()
    var mappingCaseUnitArr = [[String:Any]]()
    var isPar = false
    var chossenImage = UIImage()
    var selected = 0
    var isFCase = -1
    var isLCase = -1
    var isPVCase = -1
    var isCCase = -1
    var inventoryCount = String()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.parPopUpHeightConstraint.constant = 0
        self.parPopUpView.isHidden = true
        self.tabBarController?.tabBar.isHidden = true
        self.popUpView.isHidden = true
    }
    open func takePhoto() {
        if !UIImagePickerController.isSourceTypeAvailable(.camera) {
            let alert = UIAlertController(
                title: "Error",
                message: "Device has no camera",
                preferredStyle: .alert)
            
            let cancel = UIAlertAction(
                title: "OK",
                style: .default,
                handler: { action in
                    alert.dismiss(animated: true)
                })
            alert.addAction(cancel)
            present(alert, animated: true)
        } else {
            let picker = UIImagePickerController()
            picker.delegate = self
            picker.allowsEditing = true
            picker.sourceType = .camera
            present(picker, animated: true)
        }
    }
    open func choosePhoto() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        picker.sourceType = .photoLibrary
        present(picker, animated: true)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let chosenImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
        ingredientImgView.image = chosenImage
        self.chossenImage = chosenImage!
        picker.dismiss(animated: true)

    }
    
    @IBAction func selectIngredientImageBtnAction(_ sender: Any) {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
            
            // Cancel button tappped do nothing.
            actionSheet.dismiss(animated: true)
            
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { action in
            
            // take photo button tapped.
            self.takePhoto()
            
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { action in
            
            // choose photo button tapped.
            self.choosePhoto()
            
        }))
        
        
        if UI_USER_INTERFACE_IDIOM() == .pad {
            actionSheet.modalPresentationStyle = .popover
            let popPresenter = actionSheet.popoverPresentationController
            let directions = UIPopoverArrowDirection(rawValue: 0)
            actionSheet.popoverPresentationController?.permittedArrowDirections = directions
            
            popPresenter?.sourceView = view
            popPresenter?.sourceRect = CGRect(x: view.bounds.size.width / 2.0, y: view.bounds.size.height / 2.0, width: 1.0, height: 1.0) // You can set position of popover
            present(actionSheet, animated: true)
        } else {
            present(actionSheet, animated: true)
        }
    }
    
    
    open func addParForekstIngredientApi(inventoryMethod:String){
        //        let compressedData = productImgView.image?.jpegData(compressionQuality: 0.2)
        //        let base64:String = compressedData?.base64EncodedString(options: .lineLength64Characters) ?? ""
        //        debugPrint("base64------> \(base64)")
        let userIds = getSAppDefault(key: "UserId") as? String ?? ""
        let token = getSAppDefault(key: "AuthToken") as? String ?? ""
        //        {
        //                "name":"Meatballs",
        //                "vendor":"SYSCO",
        //                "category":"MEATS",
        //                "inventory_method":"1",
        //                "parValue":"20",
        //                "image":"",
        //                "ingredientId":"1",
        //        "userId":"1",
        //        }
        
        var base64 = String()
        if self.chossenImage.cgImage == nil{
           let placeholderImg = UIImage(named:"proIngPlaceholderImg")
            let compressedData = placeholderImg?.jpegData(compressionQuality: 0.2)
            base64 = compressedData?.base64EncodedString(options: .lineLength64Characters) ?? ""
            debugPrint("base64------> \(base64)")
        }else{
            let compressedData = ingredientImgView.image?.jpegData(compressionQuality: 0.2)
            base64 = compressedData?.base64EncodedString(options: .lineLength64Characters) ?? ""
            debugPrint("base64------> \(base64)")
        }
        
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
        
        let paramds = ["userId": userIds,"name":ingredientNameTF.text ?? "","vendor": preferredVendorTF.text ?? "","category":categoryTF.text ?? "","inventory_method":inventoryMethod,"inventory_count":inventoryCount,"full_unit":fullCaseUnitTF.text ?? "","full_price":fullCasePriceTF.text ?? "","less_unit":lessCaseUnitTF.text ?? "","less_quantity":lessCasePriceTF.text ?? "","parValue":parTF.text ?? "","image":base64,"ingredientId":"","mapping_unit":"","mapping_unit_case":"","waste_factor":""] as [String : Any]
        
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
                        let addProductDataResp =  AddIngredientData.init(dict: JSON )
                        
                        if addProductDataResp?.status == 1{
                            if self.delegate != nil{
                                self.delegate?.sendDataToIngredient(myData: false)
                            }
                            
                            self.navigationController?.popViewController(animated: true)
                           
                            
                            
                            
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
    @IBAction func selectPreferredVendorBtnAction(_ sender: Any) {
        selected = 3
        popUpView.isHidden = false
        popUpTypeLbl.text = "Vendor"
        popUpTBView.reloadData()
        self.view.endEditing(true)

    }
    
    
    @IBAction func selectCategoryBtnAction(_ sender: Any) {
        selected = 4
        popUpView.isHidden = false
        popUpTypeLbl.text = "Category"
        popUpTBView.reloadData()
        self.view.endEditing(true)

        
    }
    
    @IBAction func uncheckRadioBtnAction(_ sender: UIButton) {
        isPar = true
        parTF.isUserInteractionEnabled = true
        uncheckRadioBtn.setImage(UIImage(named: "checkRadioBtnImg"), for:UIControl.State.normal)
        checkedRadioBtn.setImage(UIImage(named: "unCheckRadioBtnImg"), for:UIControl.State.normal)
        self.parPopUpHeightConstraint.constant = 667.0
        self.parPopUpView.isHidden = false


    }
    
    @IBAction func checkRadioBtnAction(_ sender: UIButton) {
        isPar = false
        parTF.isUserInteractionEnabled = false
        uncheckRadioBtn.setImage(UIImage(named: "unCheckRadioBtnImg"), for:UIControl.State.normal)
        checkedRadioBtn.setImage(UIImage(named: "checkRadioBtnImg"), for:UIControl.State.normal)
        self.parPopUpHeightConstraint.constant = 0
        self.parPopUpView.isHidden = true

    }
    
    @IBAction func popUpViewCrossBtnAction(_ sender: Any) {
        popUpView.isHidden = true
    }
    @IBAction func backBtnAction(_ sender: Any) {
        if self.delegate != nil{
            self.delegate?.sendDataToIngredient(myData: true)
        }
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func unchekRadioBtnAction(_ sender: UIButton) {
        inventoryCount = "2"
        unchKRBtn.setImage(UIImage(named: "checkRadioBtnImg"), for:UIControl.State.normal)
        cHKRBtn.setImage(UIImage(named: "unCheckRadioBtnImg"), for:UIControl.State.normal)
    }
    
    @IBAction func chckRadioBtnAction(_ sender: UIButton) {
        inventoryCount = "1"
        unchKRBtn.setImage(UIImage(named: "unCheckRadioBtnImg"), for:UIControl.State.normal)
        cHKRBtn.setImage(UIImage(named: "checkRadioBtnImg"), for:UIControl.State.normal)
    
    }

    
    @IBAction func saveParIngredientBtnAction(_ sender: Any) {
        if isPar == true{
            if ingredientNameTF.text?.trimmingCharacters(in: .whitespaces) == ""{
                Alert.present(
                    title: AppAlertTitle.appName.rawValue,
                    message: AppSignInForgotSignUpAlertNessage.enterIngredientName,
                    actions: .ok(handler: {
                    }),
                    from: self
                )
            }
            else if preferredVendorTF.text?.trimmingCharacters(in: .whitespaces) == ""{
                Alert.present(
                    title: AppAlertTitle.appName.rawValue,
                    message: AppSignInForgotSignUpAlertNessage.enterPreferredVendor,
                    actions: .ok(handler: {
                    }),
                    from: self
                )
            }
            else if categoryTF.text?.trimmingCharacters(in: .whitespaces) == ""{
                Alert.present(
                    title: AppAlertTitle.appName.rawValue,
                    message: AppSignInForgotSignUpAlertNessage.enterCategory,
                    actions: .ok(handler: {
                    }),
                    from: self
                )
            }
            else if parTF.text?.trimmingCharacters(in: .whitespaces) == ""{
                Alert.present(
                    title: AppAlertTitle.appName.rawValue,
                    message: AppSignInForgotSignUpAlertNessage.enterPar,
                    actions: .ok(handler: {
                    }),
                    from: self
                )
            }
           else if fullCaseUnitTF.text?.trimmingCharacters(in: .whitespaces) == ""{
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
//            else if lessCaseUnitTF.text?.trimmingCharacters(in: .whitespaces) == ""{
//                Alert.present(
//                    title: AppAlertTitle.appName.rawValue,
//                    message: AppSignInForgotSignUpAlertNessage.enterLCUnit,
//                    actions: .ok(handler: {
//                    }),
//                    from: self
//                )
//            }
//            else if lessCasePriceTF.text?.trimmingCharacters(in: .whitespaces) == ""{
//                Alert.present(
//                    title: AppAlertTitle.appName.rawValue,
//                    message: AppSignInForgotSignUpAlertNessage.enterLCQuantity,
//                    actions: .ok(handler: {
//                    }),
//                    from: self
//                )
//            }
            
            else{
                addParForekstIngredientApi(inventoryMethod:"1")
            }
        }else{
            if ingredientNameTF.text?.trimmingCharacters(in: .whitespaces) == ""{
                Alert.present(
                    title: AppAlertTitle.appName.rawValue,
                    message: AppSignInForgotSignUpAlertNessage.enterIngredientName,
                    actions: .ok(handler: {
                    }),
                    from: self
                )
            }
            else if preferredVendorTF.text?.trimmingCharacters(in: .whitespaces) == ""{
                Alert.present(
                    title: AppAlertTitle.appName.rawValue,
                    message: AppSignInForgotSignUpAlertNessage.enterPreferredVendor,
                    actions: .ok(handler: {
                    }),
                    from: self
                )
            }
            else if categoryTF.text?.trimmingCharacters(in: .whitespaces) == ""{
                Alert.present(
                    title: AppAlertTitle.appName.rawValue,
                    message: AppSignInForgotSignUpAlertNessage.enterCategory,
                    actions: .ok(handler: {
                    }),
                    from: self
                )
            }
            else{
//                addParForekstIngredientApi(inventoryMethod:"2")
                let storyBoard = UIStoryboard(name: StoryboardName.ProductIngredients, bundle: nil)
                let CMDVC = storyBoard.instantiateViewController(withIdentifier: ViewControllerIdentifier.AddIngredientForkastVC) as? AddIngredientForkastVC

                CMDVC?.ingredientName = ingredientNameTF.text ?? ""
                CMDVC?.preferredVendor = preferredVendorTF.text ?? ""
                CMDVC?.category = categoryTF.text ?? ""
                CMDVC?.parValue = parTF.text ?? ""
                var base64 = String()
                if self.chossenImage.cgImage == nil{
                   let placeholderImg = UIImage(named:"proIngPlaceholderImg")
                    let compressedData = placeholderImg?.jpegData(compressionQuality: 0.2)
                    base64 = compressedData?.base64EncodedString(options: .lineLength64Characters) ?? ""
                    debugPrint("base64------> \(base64)")
                }else{
                    let compressedData = ingredientImgView.image?.jpegData(compressionQuality: 0.2)
                    base64 = compressedData?.base64EncodedString(options: .lineLength64Characters) ?? ""
                    debugPrint("base64------> \(base64)")
                }
                CMDVC?.base64 = base64
                CMDVC?.unitListArr = self.unitListArr
                CMDVC?.lessCaseUnitArr = self.lessCaseUnitArr
                CMDVC?.fullCaseUnitArr = self.fullCaseUnitArr
                CMDVC?.mappingCaseUnitArr = self.mappingCaseUnitArr

                if let CMDVC = CMDVC {
                    self.navigationController?.pushViewController(CMDVC, animated: true)
                }
               
            }
        }
        
    }
    
}
extension AddIngredientVC:UITableViewDataSource,UITableViewDelegate{
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if selected == 1{
            return fullCaseUnitArr.count
        }
        else if selected == 2{
            return lessCaseUnitArr.count
        }
        else if selected == 3{
            return vendorListArr.count
        }
        else{
            return categoryListArr.count
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! AddIngredientPopUpTBCell
        var item = [String:Any]()
        
        if selected == 1{
            cell.checkUncheckImgView.image = isFCase == indexPath.row ? #imageLiteral(resourceName: "checkImg") : #imageLiteral(resourceName: "uncheckImg")
            item = fullCaseUnitArr[indexPath.row]
            
             cell.popUpItemLbl.text = item["unit"] as? String ?? ""
        }else if selected == 2{
            cell.checkUncheckImgView.image = isLCase == indexPath.row ? #imageLiteral(resourceName: "checkImg") : #imageLiteral(resourceName: "uncheckImg")
            item = lessCaseUnitArr[indexPath.row]
            
             cell.popUpItemLbl.text = item["unit"] as? String ?? ""
        }else if selected == 3{
            cell.checkUncheckImgView.image = isPVCase == indexPath.row ? #imageLiteral(resourceName: "checkImg") : #imageLiteral(resourceName: "uncheckImg")
            item = vendorListArr[indexPath.row]
            
             cell.popUpItemLbl.text = item["name"] as? String ?? ""
        }else if selected == 4{
            cell.checkUncheckImgView.image = isCCase == indexPath.row ? #imageLiteral(resourceName: "checkImg") : #imageLiteral(resourceName: "uncheckImg")
            item = categoryListArr[indexPath.row]
            
             cell.popUpItemLbl.text = item["name"] as? String ?? ""
        }
        
        
     
     
        //        tableView.layoutIfNeeded()
        //        tableView.estimatedRowHeight = UITableView.automaticDimension
        //        dailyInventoryTBHeightConstraint.constant = dailyInventoryDetailTBView.contentSize.height + 17
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UIScreen.main.bounds.size.height * 0.1
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if selected == 1{
            isFCase = indexPath.row
            fullCaseUnitTF.text = self.fullCaseUnitArr[indexPath.row]["unit"] as? String ?? ""
            
        }else if selected == 2{
            isLCase = indexPath.row
            lessCaseUnitTF.text = self.lessCaseUnitArr[indexPath.row]["unit"] as? String ?? ""
        }
        else if selected == 3{
            isPVCase = indexPath.row
            preferredVendorTF.text = self.vendorListArr[indexPath.row]["name"] as? String ?? ""
        }
        else if selected == 4{
            isCCase = indexPath.row
            categoryTF.text = self.categoryListArr[indexPath.row]["name"] as? String ?? ""
        }
        self.popUpTBView.reloadData()
        popUpView.isHidden = true
    
        
        
    }
    
}
// MARK: TextField Delegates
extension AddIngredientVC:UITextFieldDelegate{
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        return true
    }
    
}
