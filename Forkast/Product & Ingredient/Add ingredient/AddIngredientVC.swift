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
    @IBOutlet weak var parTF: UITextField!
    
    @IBOutlet weak var popUpTBView: UITableView!
    
    @IBOutlet weak var popUpView: UIView!
    
    @IBOutlet weak var popUpTypeLbl: UILabel!
    
    @IBOutlet weak var uncheckRadioBtn: UIButton!
    var delegate: SendingAddIngredientToIngMainPageDelegateProtocol? = nil
    @IBOutlet weak var ingredientImgView: UIImageView!

    @IBOutlet weak var checkedRadioBtn: UIButton!
    var vendorListArr = [[String:Any]]()
    var categoryListArr = [[String:Any]]()
    var unitListArr = [[String:Any]]()
    var fullCaseUnitArr = [[String:Any]]()
    var lessCaseUnitArr = [[String:Any]]()
    var mappingCaseUnitArr = [[String:Any]]()
    var isCategory = false
    var isPar = false
    var chossenImage = UIImage()

    override func viewDidLoad() {
        super.viewDidLoad()
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
        let paramds = ["userId": userIds,"name":ingredientNameTF.text ?? "","vendor": preferredVendorTF.text ?? "","category":categoryTF.text ?? "","inventory_method":inventoryMethod,"parValue":parTF.text ?? "","image":base64,"ingredientId":""] as [String : Any]
        
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
    
    @IBAction func selectPreferredVendorBtnAction(_ sender: Any) {
        isCategory = false
        popUpView.isHidden = false
        popUpTypeLbl.text = "Vendor"
        popUpTBView.reloadData()
        self.view.endEditing(true)

    }
    
    
    @IBAction func selectCategoryBtnAction(_ sender: Any) {
        popUpView.isHidden = false
        isCategory = true
        popUpTypeLbl.text = "Category"
        popUpTBView.reloadData()
        self.view.endEditing(true)

        
    }
    
    @IBAction func uncheckRadioBtnAction(_ sender: UIButton) {
        isPar = true
        parTF.isUserInteractionEnabled = true
        uncheckRadioBtn.setImage(UIImage(named: "checkRadioBtnImg"), for:UIControl.State.normal)
        checkedRadioBtn.setImage(UIImage(named: "unCheckRadioBtnImg"), for:UIControl.State.normal)
    }
    
    @IBAction func checkRadioBtnAction(_ sender: UIButton) {
        isPar = false
        parTF.isUserInteractionEnabled = false
        uncheckRadioBtn.setImage(UIImage(named: "unCheckRadioBtnImg"), for:UIControl.State.normal)
        checkedRadioBtn.setImage(UIImage(named: "checkRadioBtnImg"), for:UIControl.State.normal)
        
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
            }else{
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
        if isCategory == true{
            return categoryListArr.count
        }else{
            return vendorListArr.count
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! AddIngredientPopUpTBCell
        var item = [String:Any]()
        if isCategory == true{
            item = categoryListArr[indexPath.row]
        }else{
            item = vendorListArr[indexPath.row]
        }
        cell.popUpItemLbl.text = item["name"] as? String ?? ""
        let checkUncheckStatus = item["check"] as? Bool ?? false
        if checkUncheckStatus == true{
            cell.checkUncheckImgView.image = #imageLiteral(resourceName: "checkImg")
        }else{
            cell.checkUncheckImgView.image = #imageLiteral(resourceName: "uncheckImg")
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
        if isCategory == true{
            for i in 0..<categoryListArr.count{
                self.categoryListArr[i]["check"] = false
            }
            self.categoryListArr[indexPath.row]["check"] = true
            categoryTF.text = self.categoryListArr[indexPath.row]["name"] as? String ?? ""
            
        }else{
            for i in 0..<vendorListArr.count{
                self.vendorListArr[i]["check"] = false
            }
            self.vendorListArr[indexPath.row]["check"] = true
            preferredVendorTF.text = self.vendorListArr[indexPath.row]["name"] as? String ?? ""
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
