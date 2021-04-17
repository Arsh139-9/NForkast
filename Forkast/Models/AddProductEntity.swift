//
//  AddProductEntity.swift
//  Forkast
//
//  Created by Dharmani Apps mini on 3/16/21.
//

import Foundation

struct AddProductData<T>{
  
//    {
//        "status": 1,
//        "message": "product added successfully.",
//        "product_detail": {
//            "productId": "39",
//            "name": "loveCake",
//            "salePrize": "111",
//            "salePercentage": "333",
//            "image": "https://www.dharmani.com/forkast/admin/Product/605042868ed60_1615872646.png",
//            "quantity": "2",
//            "organisation_id": "13",
//            "enable": "0",
//            "creationAt": "1615872646"
//        }
//    }
//
    var status: Int
    var message: String
    var productDetailDict:[String:T]
    
    init?(dict:[String:T]) {
        let status  = dict["status"] as? Int ?? 0
        let alertMessage = dict["message"] as? String ?? ""
        let productDetailDict = dict["product_detail"] as? [String:T] ?? [:]

        self.status = status
        self.message = alertMessage
        self.productDetailDict = productDetailDict
    }
}
