//
//  AddProductVC.swift
//  Forkast
//
//  Created by Dharmani Apps mini on 3/15/21.
//

import UIKit
import Alamofire
import SVProgressHUD
protocol SendingAddProductToProMainPageDelegateProtocol {
    func sendDataToProduct(myData: Bool)
}
class AddProductVC: UIViewController,UINavigationControllerDelegate,UIImagePickerControllerDelegate{

    @IBOutlet weak var productNameTF: UITextField!
    
    @IBOutlet weak var salePercentTF: UITextField!
    
    @IBOutlet weak var salePrizeTF: UITextField!
    
    var delegate: SendingAddProductToProMainPageDelegateProtocol? = nil

    @IBOutlet weak var productImgView: UIImageView!
     var chossenImage = UIImage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = true


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
        productImgView.image = chosenImage
        self.chossenImage = chosenImage!
        picker.dismiss(animated: true)

    }
    @IBAction func choosePhotoBtnAction(_ sender: Any) {
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
    
    @IBAction func backBtnAction(_ sender: Any) {
        if self.delegate != nil{
            self.delegate?.sendDataToProduct(myData: true)
        }
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func saveProductBtnAction(_ sender: Any) {
        if productNameTF.text?.trimmingCharacters(in: .whitespaces) == ""{
            Alert.present(
                title: AppAlertTitle.appName.rawValue,
                message: AppSignInForgotSignUpAlertNessage.enterProductName,
                actions: .ok(handler: {
                }),
                from: self
            )
        }
      else if salePercentTF.text?.trimmingCharacters(in: .whitespaces) == ""{
            Alert.present(
                title: AppAlertTitle.appName.rawValue,
                message: AppSignInForgotSignUpAlertNessage.enterSalePrecent,
                actions: .ok(handler: {
                }),
                from: self
            )
        }
      else if salePrizeTF.text?.trimmingCharacters(in: .whitespaces) == ""{
            Alert.present(
                title: AppAlertTitle.appName.rawValue,
                message: AppSignInForgotSignUpAlertNessage.enterSalePrize,
                actions: .ok(handler: {
                }),
                from: self
            )
      }else{
        addProductApi()
      }
    }
    
    open func addProductApi(){
        var base64 = String()
        if self.chossenImage.imageAsset == nil{
           let placeholderImg = UIImage(named:"proIngPlaceholderImg")
            let compressedData = placeholderImg?.jpegData(compressionQuality: 0.2)
            base64 = compressedData?.base64EncodedString(options: .lineLength64Characters) ?? ""
            debugPrint("base64------> \(base64)")
        }else{
            let compressedData = productImgView.image?.jpegData(compressionQuality: 0.2)
            base64 = compressedData?.base64EncodedString(options: .lineLength64Characters) ?? ""
            debugPrint("base64------> \(base64)")
        }
     
        let userIds = getSAppDefault(key: "UserId") as? String ?? ""
        let token = getSAppDefault(key: "AuthToken") as? String ?? ""
        
        
        let paramds = ["productId":"","userId": userIds,"name":productNameTF.text ?? "","salePrize":salePrizeTF.text ?? "","salePercentage":salePercentTF.text ?? "","quantity":"","image":base64] as [String : Any]
        
        let strURL = kBASEURL + WSMethods.addProduct
        
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
                         
                            if self.delegate != nil{
                                self.delegate?.sendDataToProduct(myData: false)
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
