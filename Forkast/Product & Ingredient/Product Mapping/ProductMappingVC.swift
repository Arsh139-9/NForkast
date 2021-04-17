//
//  ProductMappingVC.swift
//  Forkast
//
//  Created by Dharmani Apps mini on 3/20/21.
//

import UIKit
import Alamofire
import SVProgressHUD


class ProductMappingVC: UIViewController {

    
    @IBOutlet weak var addIngredientPopUpView: UIView!
    
    @IBOutlet weak var addedIngredientTBView: UITableView!
    
    
    @IBOutlet weak var productNameTF: UITextField!
    
    @IBOutlet weak var popUpIngredientNameTF: UITextField!
    
    
    @IBOutlet weak var popUpQuantityTF: UITextField!
    
    @IBOutlet weak var popUpUOMTF: UITextField!
    
    @IBOutlet weak var popUpWastingFactorTf: UITextField!
    
    var productRespArray = [[String:AnyHashable]]()
    var ingredientRespArray = [[String:AnyHashable]]()
    var unitListArr = [[String:Any]]()

    var addIngredientArray = [[String:AnyHashable]]()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addedIngredientTBView.tableFooterView = UIView(frame: .zero)
        addedIngredientTBView.backgroundColor = .clear
        addIngredientPopUpView.isHidden = true
        self.tabBarController?.tabBar.isHidden = true
        removeAppDefaults(key: "Name")
        let tap = UITapGestureRecognizer(target: self, action: #selector(doubleTapped))
            tap.numberOfTapsRequired = 1
            view.addGestureRecognizer(tap)
        // Do any additional setup after loading the view.
    }
    @objc func doubleTapped() {
        // do something here
        addIngredientPopUpView.isHidden = true

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        let navBarTitle = getSAppDefault(key: "NavBarTitleLbl") as? String ?? ""
        if navBarTitle == "Products"{
            productNameTF.text = getSAppDefault(key: "PName") as? String ?? ""
        }
        else if navBarTitle == "UOM"{
            popUpUOMTF.text = getSAppDefault(key: "UName") as? String ?? ""
        }
        else{
            popUpIngredientNameTF.text = getSAppDefault(key: "IName") as? String ?? ""
        }

    }
    @IBAction func saveIngredientMappingBtnAction(_ sender: Any) {
        if popUpIngredientNameTF.text?.trimmingCharacters(in: .whitespaces) == ""{
            Alert.present(
                title: AppAlertTitle.appName.rawValue,
                message: AppSignInForgotSignUpAlertNessage.enterIngredient,
                actions: .ok(handler: {
                }),
                from: self
            )
        }else if popUpQuantityTF.text?.trimmingCharacters(in: .whitespaces) == ""{
            Alert.present(
                title: AppAlertTitle.appName.rawValue,
                message: AppSignInForgotSignUpAlertNessage.enterQuantity,
                actions: .ok(handler: {
                }),
                from: self
            )
        }else if popUpUOMTF.text?.trimmingCharacters(in: .whitespaces) == ""{
            Alert.present(
                title: AppAlertTitle.appName.rawValue,
                message: AppSignInForgotSignUpAlertNessage.enterUOM,
                actions: .ok(handler: {
                }),
                from: self
            )
        }
//        else if popUpWastingFactorTf.text?.trimmingCharacters(in: .whitespaces) == ""{
//            Alert.present(
//                title: AppAlertTitle.appName.rawValue,
//                message: AppSignInForgotSignUpAlertNessage.enterWF,
//                actions: .ok(handler: {
//                }),
//                from: self
//            )
//        }
        else{
            let ingredientID = getSAppDefault(key: "ingredientId") as? String ?? ""
             let ingredientName = getSAppDefault(key: "IName") as? String ?? ""
             let dict = [
                 "name":ingredientName,
                 "ingredientId":ingredientID,
                 "quantity":popUpQuantityTF.text ?? "",
                 "UOM":popUpUOMTF.text ?? "",
                 "waste_factor":popUpWastingFactorTf.text ?? ""
             ]
             addIngredientArray.append(dict)
             addIngredientPopUpView.isHidden = true
             addedIngredientTBView.reloadData()
        }

    }
    
    @IBAction func lineBtnAction(_ sender: Any) {
        addIngredientPopUpView.isHidden = true

    }
    
    @IBAction func selectProductListBtnAction(_ sender: Any) {
        let storyBoard = UIStoryboard(name: StoryboardName.ProductIngredients, bundle: nil)
        let CMDVC = storyBoard.instantiateViewController(withIdentifier: ViewControllerIdentifier.PopUpListVC) as? PopUpListVC
        CMDVC?.navBarTitleLbl = "Products"
        CMDVC?.delegate = self
        CMDVC?.productRespArray = productRespArray
        if let CMDVC = CMDVC {
            self.navigationController?.pushViewController(CMDVC, animated: true)
        }
        
    }
    
    @IBAction func selectIngredientListBtnAction(_ sender: Any) {
        let storyBoard = UIStoryboard(name: StoryboardName.ProductIngredients, bundle: nil)
        let CMDVC = storyBoard.instantiateViewController(withIdentifier: ViewControllerIdentifier.PopUpListVC) as? PopUpListVC
        CMDVC?.navBarTitleLbl = "Ingredients"
        CMDVC?.delegate = self
        CMDVC?.ingredientRespArray = ingredientRespArray

        if let CMDVC = CMDVC {
            self.navigationController?.pushViewController(CMDVC, animated: true)
        }
    }
    
    @IBAction func selectUOMBtnAction(_ sender: Any) {
        let storyBoard = UIStoryboard(name: StoryboardName.ProductIngredients, bundle: nil)
        let CMDVC = storyBoard.instantiateViewController(withIdentifier: ViewControllerIdentifier.PopUpListVC) as? PopUpListVC
        CMDVC?.navBarTitleLbl = "UOM"
        CMDVC?.delegate = self
        CMDVC?.unitListArr = unitListArr

        if let CMDVC = CMDVC {
            self.navigationController?.pushViewController(CMDVC, animated: true)
        }
    }
    
    @IBAction func addIngredientBtnAction(_ sender: Any) {
        removeAppDefaults(key: "Name")
        popUpIngredientNameTF.text = ""
        popUpQuantityTF.text = ""
        popUpWastingFactorTf.text = ""
        popUpUOMTF.text = ""
        addIngredientPopUpView.isHidden = false
        ingredientRespArray.removeAll()
    }
    open func saveProductMappingApi(){
        //        let compressedData = productImgView.image?.jpegData(compressionQuality: 0.2)
        //        let base64:String = compressedData?.base64EncodedString(options: .lineLength64Characters) ?? ""
        //        debugPrint("base64------> \(base64)")
        let userId  = getSAppDefault(key: "UserId") as? String ?? ""

        let token = getSAppDefault(key: "AuthToken") as? String ?? ""
//        {
//                "productId":"1",
//                "userId":"13",
//                "ingredient_detail":[
//        {
//                "ingredientId":"1",
//                "quantity":"10",
//                "UOM":"Count",
//                "waste_factor":"2%"
//        },
//        {
//                "ingredientId":"3",
//                "quantity":"5",
//                "UOM":"Count",
//                "waste_factor":"3%"
//        }
//        ]
//        }
        let productId = getSAppDefault(key: "productId") as? String ?? ""

        let paramds = ["productId": productId,"userId":userId,"ingredient_detail":addIngredientArray] as [String : Any]

        let strURL = kBASEURL + WSMethods.addMaping

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
                                           if vc is ProductIngredientHomeVC {
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
    @IBAction func saveProductMappingBtnAction(_ sender: Any) {
        if productNameTF.text?.trimmingCharacters(in: .whitespaces) == ""{
            Alert.present(
                title: AppAlertTitle.appName.rawValue,
                message: AppSignInForgotSignUpAlertNessage.enterProductName,
                actions: .ok(handler: {
                }),
                from: self
            )
        }
        else if addIngredientArray.count == 0{
            Alert.present(
                title: AppAlertTitle.appName.rawValue,
                message: AppSignInForgotSignUpAlertNessage.enterAddIngredient,
                actions: .ok(handler: {
                }),
                from: self
            )
        }
        
        else{
            saveProductMappingApi()
        }
    }
  
    
    @IBAction func backBtnAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    

}
extension ProductMappingVC:UITableViewDataSource,UITableViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return addIngredientArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cellp") as? AddedIngredientTBCell
//        if cell == nil {
//            let nib = Bundle.main.loadNibNamed("IngredientLisCell", owner: self, options: nil)
//            cell = nib?[0] as? AddIngredientPopUpTBCell
//        }
        
        let respDict = addIngredientArray[indexPath.row]
        cell?.ingredientNameLbl.text = respDict["name"] as? String ?? ""
        
        cell?.ingredientRateLbl.text = "\(respDict["quantity"] as? String ?? "")/\(respDict["UOM"] as? String ?? "")"

      

        
        return cell!
    }
   
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UIScreen.main.bounds.size.height * 0.1
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
    }
}
extension ProductMappingVC:MyDataSendingDelegateProtocol{
    func sendDataToFirstViewController(productRespArray: [[String : AnyHashable]], ingredientRespArray: [[String : AnyHashable]], unitListArr: [[String : Any]]) {
        self.productRespArray = productRespArray
        self.ingredientRespArray = ingredientRespArray
        self.unitListArr = unitListArr
    }
    

    
}
