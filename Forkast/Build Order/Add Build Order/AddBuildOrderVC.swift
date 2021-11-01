//
//  AddBuildOrderVC.swift
//  Forkast
//
//  Created by Dharmani Apps mini on 3/25/21.
//

import UIKit
import Alamofire
import SVProgressHUD
import SDWebImage
protocol SendingAddBOToBOMainPageDelegateProtocol {
    func sendDataToBO(myData: Bool)
}
class AddBuildOrderVC: UIViewController,UITextFieldDelegate{

    
    @IBOutlet weak var salesPriceTF: UITextField!
    @IBOutlet weak var saleSlider: UISlider!
    var responseArray = [[String:Any]]()
    @IBOutlet weak var buildOrderTBHeightConstraint: NSLayoutConstraint!
    var delegate: SendingAddBOToBOMainPageDelegateProtocol? = nil

    
    @IBOutlet weak var addBuildOrderTBView: UITableView!
    
    @IBOutlet weak var commentTV: UITextView!
    var quantityIDDictArr = [[String:AnyHashable]]()
    var totalSale = String()
    override func viewDidLoad() {
        super.viewDidLoad()
//        let prefix = UILabel()
//        prefix.text = "$"
//        // set font, color etc.
//        prefix.textAlignment = .right
//        prefix.font = UIFont(name: "Lato-Bold", size: 21.0)
//        prefix.sizeToFit()
//        salesPriceTF.leftView = prefix
//        salesPriceTF.leftViewMode = .always // or .always
//        let suffix = UILabel()
//        suffix.text = "Sales"
//        // set font, color etc.
//        suffix.textAlignment = .left
//        suffix.font = UIFont(name: "Lato-Bold", size: 21.0)
//        suffix.sizeToFit()
//        salesPriceTF.rightView = suffix
//        salesPriceTF.rightViewMode = .always // or .always
        commentTV.textContainerInset = UIEdgeInsets(top: 13, left: 13, bottom: 13, right: 13)
        addBuildOrderTBView.tableFooterView = UIView()
        addBuildOrderTBView.estimatedRowHeight = 90
        saleSlider.isContinuous = false
        saleSlider.addTarget(self, action: #selector(onSliderValChanged(slider:event:)), for: .valueChanged)
        saleSlider.value = 16000
        totalSale = "16000"
        getBuildOrderDetail(buildId:"", sliderVal:16000)
        salesPriceTF.delegate = self
//        salesPriceTF.addTarget(self, action: #selector(sLtextFieldDidChange(theTextField:)), for: .editingChanged)
        // Do any additional setup after loading the view.
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        textField.maxLength = 5
         // Uses the number format corresponding to your Locale
         let formatter = NumberFormatter()
         formatter.numberStyle = .decimal
         formatter.locale = Locale.current
         formatter.maximumFractionDigits = 0


        // Uses the grouping separator corresponding to your Locale
        // e.g. "," in the US, a space in France, and so on
        if let groupingSeparator = formatter.groupingSeparator {

            if string == groupingSeparator {
                return true
            }


            if let textWithoutGroupingSeparator = textField.text?.replacingOccurrences(of: groupingSeparator, with: "") {
                var totalTextWithoutGroupingSeparators = textWithoutGroupingSeparator + string
                if string.isEmpty { // pressed Backspace key
                    totalTextWithoutGroupingSeparators.removeLast()
                }
                if let numberWithoutGroupingSeparator = formatter.number(from: totalTextWithoutGroupingSeparators),
                    let formattedText = formatter.string(from: numberWithoutGroupingSeparator) {

                    textField.text = formattedText
              
                    let ftext = formattedText.replacingOccurrences(of: groupingSeparator, with: "")
                    saleSlider.value = (ftext as NSString).floatValue
                    getBuildOrderDetail(buildId:"", sliderVal:(numberWithoutGroupingSeparator).intValue)
//                getBuildOrderDetail(buildId:"", sliderVal:(ftext as NSString).integerValue)
                    return false
                }
            }
        }
        return true
    }

    
    @objc func onSliderValChanged(slider: UISlider, event: UIEvent) {
        if let touchEvent = event.allTouches?.first {
            switch touchEvent.phase {
            case .began: break
                // handle drag began
            case .moved: break
                // handle drag moved
            case .ended:
                let bigNumber = slider.value
                let fDec = bigNumber.rounded(rule: .plain, scale: 0)
                let numberFormatter = NumberFormatter()
                numberFormatter.numberStyle = .decimal
                
                guard let formattedNumber = numberFormatter.string(from: NSNumber(value: fDec)) else { return }
                print(formattedNumber)
              
                salesPriceTF.text = "\(formattedNumber)"
                totalSale = "\(formattedNumber)"

                getBuildOrderDetail(buildId:"", sliderVal: (Int(slider.value)))
                // handle drag ended
            default:
                break
            }
        }
    }
    @IBAction func backBtnAction(_ sender: Any) {
        if self.delegate != nil{
            self.delegate?.sendDataToBO(myData: true)
        }
        navigationController?.popViewController(animated: true)
    }
    open func getBuildOrderDetail(buildId:String,sliderVal:Int){
        let userIds = getSAppDefault(key: "UserId") as? String ?? ""
        let token = getSAppDefault(key: "AuthToken") as? String ?? ""
//        {
//        "user_id":"13",
//        "total_sales":"16000",
//        "comment":"",
//        "is_save":"",
//        "item":[
//
//        ]
//
//        }
        
        let paramds = ["user_id": userIds,"buildId":buildId,"total_sales":"\(sliderVal)","item":[],"comment":"","is_save":""] as [String : Any]
        
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
                        
                        //                let status = jsonResult?["status"] as? Int ?? 0
                        if addDailyInventoryResp?.status == 1{
                            
                            self.responseArray = addDailyInventoryResp!.buildOrderDetailArr
                            let userDetailDict = addDailyInventoryResp?.buildOrderDetailDict as? [String:AnyHashable] ?? [:]
                            self.commentTV.text = userDetailDict["comment"] as? String ?? ""
//                            for i in 0..<self.responseArray.count{
//                                self.responseArray[i]["orderQuantity"] = "0"
//                            }

                      
                            self.addBuildOrderTBView.reloadData()

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
    @objc func textFieldDidChange(theTextField:UITextField){
        var parentCell = theTextField.superview

        while !(parentCell is AddBuildOrderTBCell) {
            parentCell = parentCell?.superview
        }
        var indexPath: IndexPath? = nil
        let cell1 = parentCell as? AddBuildOrderTBCell
        indexPath = addBuildOrderTBView.indexPath(for: cell1!)
        if theTextField.text != ""{
            responseArray[indexPath!.row]["orderQuantity"] = theTextField.text
        }
       
    }
    @objc func increaseQuantity(_ sender: UIButton?) {
        var parentCell = sender?.superview

        while !(parentCell is AddBuildOrderTBCell) {
            parentCell = parentCell?.superview
        }
        var indexPath: IndexPath? = nil
        let cell1 = parentCell as? AddBuildOrderTBCell
        indexPath = addBuildOrderTBView.indexPath(for: cell1!)
        let respDict = responseArray[indexPath!.row] as? [String:AnyHashable] ?? [:]
        var number = (respDict["orderQuantity"] as! NSString).integerValue
        number += 1

        responseArray[indexPath!.row]["orderQuantity"] = "\(number)"
        cell1?.buildOrderQuantityTF.text = "\(number)"
       
 
    }
    @objc func decreaseQuantity(_ sender: UIButton?) {
        
        var parentCell = sender?.superview

        while !(parentCell is AddBuildOrderTBCell) {
            parentCell = parentCell?.superview
        }
        var indexPath: IndexPath? = nil
         let cell1 = parentCell as? AddBuildOrderTBCell
        indexPath = addBuildOrderTBView.indexPath(for: cell1!)
        let respDict = responseArray[indexPath!.row] as? [String:AnyHashable] ?? [:]
        var number = (respDict["orderQuantity"] as! NSString).integerValue
        if number != 0{
            number -= 1
        }
        responseArray[indexPath!.row]["orderQuantity"] = "\(number)"
        cell1?.buildOrderQuantityTF.text = "\(number)"
      
    }
    
   
  
    
    @IBAction func saveBuildOrderBtnAction(_ sender: UIButton) {
        quantityIDDictArr.removeAll()
        var selected = false
        for i in 0..<responseArray.count{
            if responseArray[i]["orderQuantity"] as? String != "0"{
                selected = true
//                return
            }
            if selected == true{
              
                let ingredientId = responseArray[i]["ingredientId"] as? String ?? ""
                let quantity = responseArray[i]["orderQuantity"] as? String ?? ""
                
                let formatter = NumberFormatter()
                formatter.minimumFractionDigits = 0
                formatter.maximumFractionDigits = 2

                // Avoid not getting a zero on numbers lower than 1
                // Eg: .5, .67, etc...
                formatter.numberStyle = .decimal

                let floatOQ = (quantity as NSString).floatValue

                let finalOQ = formatter.string(from: floatOQ as NSNumber)
                let theoreticalValue = responseArray[i]["theoreticalValue"] as? String ?? ""
                let onHand = responseArray[i]["onHand"] as? String ?? ""
                let wasteQuantity = responseArray[i]["wasteQuantity"] as? String ?? ""

                let ingQuantityDict = ["ingredientId":ingredientId,"orderQuantity":finalOQ ?? "","theoreticalValue":theoreticalValue,"onHand":onHand,"wasteQuantity":wasteQuantity]
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
          
                saveBuildOrderApi(isSave: "1")
              
              
           
        }

    }
    open func saveBuildOrderApi(isSave:String){
        
        
        let userIds = getSAppDefault(key: "UserId") as? String ?? ""
        let token = getSAppDefault(key: "AuthToken") as? String ?? ""
        let paramds = ["user_id": userIds,"buildId":"","total_sales":totalSale,"item":quantityIDDictArr,"comment":commentTV.text ?? "","is_save":isSave] as [String : Any]
            
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
                            
                            //                let status = jsonResult?["status"] as? Int ?? 0
                            if addDailyInventoryResp?.status == 1{
                                if self.delegate != nil{
                                    self.delegate?.sendDataToBO(myData: false)
                                }
                                
//                                if self.delegate != nil{
//                                    self.delegate?.sendDataToBiweekelyVC(myData: false)
//                                }
//                                if isClear == "1"{
//                                    self.responseArray = addDailyInventoryResp!.buildOrderDetailArr
//                                    let userDetailDict = addDailyInventoryResp?.buildOrderDetailDict as? [String:AnyHashable] ?? [:]
//                                    self.commentTV.text = userDetailDict["comment"] as? String ?? ""
//                                    let totalSale = userDetailDict["total_sale"] as? String ?? ""
//                                    if totalSale == ""{
//                                        self.salesPriceLbl.text = "$16,000 Sales"
//                                        self.saleSlider.value = 16000
//                                    }else{
//                                        self.salesPriceLbl.text = "$\(totalSale) Sales"
//                                        self.saleSlider.value = (totalSale as NSString).floatValue
//                                    }
//                                    self.addBuildOrderTBView.reloadData()
//                                }else{
                                    self.navigationController?.popViewController(animated: true)
                                //}
                                
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
   
    @IBAction func clearValuesBtnAction(_ sender: Any) {
        saleSlider.value = 16000
        getBuildOrderDetail(buildId:"", sliderVal:16000)
        salesPriceTF.text = "\(Int(saleSlider.value))"

//        saveBuildOrderApi(isSave: "", isClear: "1")

    }
    
}
extension AddBuildOrderVC:UITableViewDataSource,UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return responseArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     
        var cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as? AddBuildOrderTBCell
        if cell == nil {
            let nib = Bundle.main.loadNibNamed("AddBuildOrderTBCell", owner: self, options: nil)
            cell = nib?[0] as? AddBuildOrderTBCell
        }
        
        
        let respDict = responseArray[indexPath.row]
        cell?.buildOrderProductNameLbl.text = respDict["name"] as? String ?? ""
        cell?.buildOrderIngredientNameLbl.text = respDict["category"] as? String ?? ""
        cell?.buildOrderCaseLbl.text = respDict["mapping_unit"] as? String ?? ""
        cell?.buildOrderQuantityLbl.text = respDict["onHand"] as? String ?? ""
        cell?.buildOrderTheoreticalUsageLbl.text = respDict["theoreticalValue"] as? String ?? ""
        let oQ = respDict["orderQuantity"] as? String ?? ""
        let fOQ = (oQ as NSString).integerValue

        if fOQ < -1{
            cell?.buildOrderQuantityTF.textColor = UIColor(red: 0/255.0, green: 151.0/255.0, blue:40.0/255.0, alpha: 1.0)
        }
        else if fOQ < 0 && fOQ > -1{
            cell?.buildOrderQuantityTF.textColor = UIColor.systemYellow

        }else{
            if #available(iOS 13.0, *) {
                cell?.buildOrderQuantityTF.textColor = UIColor.label
            } else {
                // Fallback on earlier versions
            }
        }
        let orderQuantity = respDict["orderQuantity"] as? String ?? ""
        
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 2

        // Avoid not getting a zero on numbers lower than 1
        // Eg: .5, .67, etc...
        formatter.numberStyle = .decimal

        let floatOQ = (orderQuantity as NSString).floatValue

        let finalOQ = formatter.string(from: floatOQ as NSNumber)
        
       
        
        cell?.buildOrderQuantityTF.text = finalOQ ?? ""
        cell?.buildOrderQuantityTF.delegate = self
        cell?.buildOrderQuantityTF.addTarget(self, action: #selector(textFieldDidChange(theTextField:)), for: .editingChanged)
        
//        cell?.buildorder.text = respDict["theoreticalValue"] as? String ?? ""
        cell?.increaseQuantityBtn?.addTarget(self, action: #selector(increaseQuantity(_:)), for: .touchUpInside)
        cell?.decreaseQuantityBtn?.addTarget(self, action: #selector(decreaseQuantity(_:)), for: .touchUpInside)
        var sPhotoStr = respDict["image"] as? String ?? ""
        sPhotoStr = sPhotoStr.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? ""
        if sPhotoStr != ""{
            cell?.buildOrderProductImgView.sd_setImage(with: URL(string: sPhotoStr), placeholderImage:UIImage(named:"proIngPlaceholderImg"))
        }
        
//        tableView.layoutIfNeeded()
//        tableView.estimatedRowHeight = UITableView.automaticDimension
//
        DispatchQueue.main.async {
            self.buildOrderTBHeightConstraint.constant = self.addBuildOrderTBView.contentSize.height

        }
        
        return cell!
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UIScreen.main.bounds.height * 0.19
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
    }
}


extension Float {
    func rounded(rule: NSDecimalNumber.RoundingMode, scale: Int) -> Float {
        var result: Decimal = 0
        var decimalSelf = NSNumber(value: self).decimalValue
        NSDecimalRound(&result, &decimalSelf, scale, rule)
        return (result as NSNumber).floatValue
    }
}
