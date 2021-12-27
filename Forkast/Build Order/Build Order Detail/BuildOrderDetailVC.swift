//
//  BuildOrderDetailVC.swift
//  Forkast
//
//  Created by Dharmani Apps mini on 3/24/21.
//

import UIKit
import Alamofire
import SVProgressHUD
import SDWebImage

class BuildOrderDetailVC: UIViewController {
    
    @IBOutlet weak var salesSliderLbl: UILabel!
    
    @IBOutlet weak var salesSlider: UISlider!
    
    @IBOutlet weak var buildOrderDetailTBView: UITableView!
    
    @IBOutlet weak var commentTV: UITextView!
    
    @IBOutlet weak var buildOrderTBHeightConstraint: NSLayoutConstraint!
    
    var responseArray = [[String:Any]]()
    var delegate: SendingAddBOToBOMainPageDelegateProtocol? = nil
    
    
    var buildId = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        commentTV.textContainerInset = UIEdgeInsets(top: 13, left: 13, bottom: 13, right: 13)
        buildOrderDetailTBView.tableFooterView = UIView()
        buildOrderDetailTBView.estimatedRowHeight = 90
        getBuildOrderDetail()
        
    }
    
    @IBAction func backBtnAction(_ sender: Any) {
        if self.delegate != nil{
            self.delegate?.sendDataToBO(myData: true)
        }
        navigationController?.popViewController(animated: true)
    }
    
    open func getBuildOrderDetail(){
        let userIds = getSAppDefault(key: "UserId") as? String ?? ""
        let token = getSAppDefault(key: "AuthToken") as? String ?? ""
        
        
        let paramds = ["user_id": userIds,"buildId":buildId,"total_sales":"16000","item":[],"comment":"","is_save":""] as [String : Any]
        
        let strURL = kBASEURL + WSMethods.addBuildOrder
        
        let urlwithPercentEscapes = strURL.addingPercentEncoding( withAllowedCharacters: CharacterSet.urlQueryAllowed)
        SVProgressHUD.show()
        AF.request(urlwithPercentEscapes!, method: .post, parameters: paramds, encoding: JSONEncoding.default, headers: ["Content-Type":"application/json","Token":token])
            .responseJSON { (response) in
                SVProgressHUD.dismiss()
                switch response.result {
                case .success(let value):
                    if let JSON = value as? [String: Any] {
                        print(JSON as NSDictionary)
                        let addDailyInventoryResp =  BuildOrderDetailData.init(dict: JSON )
                        
                        if addDailyInventoryResp?.status == 1{
                            self.responseArray = addDailyInventoryResp!.buildOrderDetailArr
                            let userDetailDict = addDailyInventoryResp?.buildOrderDetailDict as? [String:AnyHashable] ?? [:]
                            self.commentTV.text = userDetailDict["comment"] as? String ?? ""
                            let totalSale = userDetailDict["total_sale"] as? String ?? ""
                            if totalSale == ""{
                                self.salesSliderLbl.text = "$16,000 Sales"
                            }else{
                                let fTotalSale = totalSale.replacingOccurrences(of: ",", with: "")
                                self.salesSlider.value = (fTotalSale as NSString).floatValue
                                let bigNumber = self.salesSlider.value
                                let fDec = bigNumber.rounded(rule: .plain, scale: 0)
                                let numberFormatter = NumberFormatter()
                                numberFormatter.numberStyle = .decimal
                                
                                guard let formattedNumber = numberFormatter.string(from: NSNumber(value: fDec)) else { return }
                                print(formattedNumber)
                                self.salesSliderLbl.text = "$\(formattedNumber) Sales"
                                
                            }
                            
                            self.buildOrderDetailTBView.reloadData()
                            
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
                            message:error.localizedDescription == "" ? AppAlertTitle.connectionError.rawValue : error.localizedDescription,
                            actions: .ok(handler: {
                            }),
                            from: self
                        )
                    }
                    
                }
            }
        
    }
}
extension BuildOrderDetailVC:UITableViewDataSource,UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return responseArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as? BuildOrderDetailCell
        if cell == nil {
            let nib = Bundle.main.loadNibNamed("BuildOrderDetailCell", owner: self, options: nil)
            cell = nib?[0] as? BuildOrderDetailCell
        }
        
        
        let respDict = responseArray[indexPath.row]
        cell?.buildOrderProductNameLbl.text = respDict["name"] as? String ?? ""
        cell?.buildOrderIngredientNameLbl.text = respDict["category"] as? String ?? ""
//        cell?.buildOrderCaseLbl.text = respDict["inventory_count"] as? String ?? "" == "1" ? respDict["full_unit"] as? String ?? "" : respDict["less_unit"] as? String ?? ""
        cell?.buildOrderQuantityLbl.text = respDict["onHand"] as? String ?? ""
        cell?.buildOrderTheoreticalUsageLbl.text = respDict["theoreticalValue"] as? String ?? ""
        cell?.buildOrderCaseLbl.text = respDict["inventory_method"] as? String ?? "" == "1" ? "Par" : "Forkast"
        let oQ = respDict["orderQuantity"] as? String ?? ""
        cell?.buildOrderQuantityTF.text = oQ == "0" ? "0.1" : oQ 
        let fOQ = (oQ as NSString).integerValue
        cell?.buildOrderQuantityTF.textColor = fOQ <= 0 ? UIColor(red: 0/255.0, green: 151.0/255.0, blue:40.0/255.0, alpha: 1.0) : fOQ < -1 ?  UIColor(red: 0/255.0, green: 151.0/255.0, blue:40.0/255.0, alpha: 1.0) : fOQ < 0 && fOQ > -1 ? UIColor.systemYellow : ColorCompatibility.label

        //        let oQ = respDict["orderQuantity"] as? String ?? ""
        //        let fOQ = (oQ as NSString).integerValue
        //
        //        if fOQ < -1{
        //            cell?.buildOrderQuantityTF.textColor = UIColor(red: 0/255.0, green: 151.0/255.0, blue:40.0/255.0, alpha: 1.0)
        //        }
        //        else if fOQ < 0 && fOQ > -1{
        //            cell?.buildOrderQuantityTF.textColor = UIColor.systemYellow
        //
        //        }else{
        //            if #available(iOS 13.0, *) {
        //                cell?.buildOrderQuantityTF.textColor = UIColor.label
        //            } else {
        //                // Fallback on earlier versions
        //            }
        //        }
        var sPhotoStr = respDict["image"] as? String ?? ""
        sPhotoStr = sPhotoStr.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? ""
        if sPhotoStr != ""{
            cell?.buildOrderProductImgView.sd_setImage(with: URL(string: sPhotoStr), placeholderImage:UIImage(named:"proIngPlaceholderImg"))
        }
        cell?.increaseQuantityBtn.isHidden = true
        cell?.decreaseQuantityBtn.isHidden = true
        cell?.buildOrderQuantityTF.borderStyle = .none
        //        tableView.layoutIfNeeded()
        //        tableView.estimatedRowHeight = UITableView.automaticDimension
        //
        DispatchQueue.main.async {
            self.buildOrderTBHeightConstraint.constant = self.buildOrderDetailTBView.contentSize.height
            
        }
        
        return cell!
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UIScreen.main.bounds.height * 0.19
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
