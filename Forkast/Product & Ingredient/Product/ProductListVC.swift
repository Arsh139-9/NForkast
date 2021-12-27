//
//  ProductListVC.swift
//  Forkast
//
//  Created by Dharmani Apps mini on 3/15/21.
//

import UIKit
import Alamofire
import SVProgressHUD

class ProductListVC: UIViewController {
    var loaderBool = Bool()
    var page = Int()
    var lastPage = Bool()
    var responseArray = [[String:AnyHashable]]()
    @IBOutlet weak var productTBView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.tabBarController?.tabBar.isHidden = false
        
        if loaderBool == false{
            responseArray.removeAll()
            page = 1
            getProductListApi()
        }
        
    }
 
    @IBAction func addProductBtnAction(_ sender: Any) {
        
        let storyBoard = UIStoryboard(name: StoryboardName.ProductIngredients, bundle: nil)
            let CMDVC = storyBoard.instantiateViewController(withIdentifier: ViewControllerIdentifier.AddProductVC) as? AddProductVC
        
        CMDVC?.delegate = self
            if let CMDVC = CMDVC {
                self.navigationController?.pushViewController(CMDVC, animated: true)
            }
        
        

    }
    
   
    @IBAction func backBtnAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
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

                            let pROArr = dailyInventoryResp!.productListArr
                            for i in 0..<pROArr.count{
                                self.responseArray.append(pROArr[i])
                            }
                           
                          
                            self.productTBView.reloadData()
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
extension ProductListVC:UITableViewDataSource,UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return responseArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as? ProductListCell
        if cell == nil {
            let nib = Bundle.main.loadNibNamed("ProductListCell", owner: self, options: nil)
            cell = nib?[0] as? ProductListCell
        }
        
        let respDict = responseArray[indexPath.row]
        cell?.productNameLbl.text = respDict["name"] as? String ?? ""
        cell?.salesPriceLbl.text = "$\(respDict["salePrize"] as? String ?? "")"
        cell?.salesPrecentLbl.text = "\(respDict["salePercentage"] as? String ?? "")%"

        var sPhotoStr = respDict["image"] as? String ?? ""
        sPhotoStr = sPhotoStr.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? ""
        if sPhotoStr != ""{
            cell?.productImgView.sd_setImage(with: URL(string: sPhotoStr), placeholderImage:nil)
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
                getProductListApi()
            }
        }
    }
}
extension ProductListVC:SendingAddProductToProMainPageDelegateProtocol{
    
   
    func sendDataToProduct(myData: Bool) {
        loaderBool = myData

    }
    
    
    
}
