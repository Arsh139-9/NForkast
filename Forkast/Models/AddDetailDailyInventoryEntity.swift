//
//  AddDetailDailyInventoryEntity.swift
//  Forkast
//
//  Created by Dharmani Apps mini on 3/3/21.
//

import Foundation

struct AddDetailDailyInventoryData<T>{
  
  
    //{
    //    "status": 1,
    //    "message": "New password has been sent to the entered email, please check your email."
    //}
    var status: Int
    var message: String
    var dailyUserDetailDict:[String:T]
    var dailyProductDetailArr:[[String:T]]
    var specialProductDetailArr:[[String:T]]
    
    init?(dict:[String:T]) {
        let status  = dict["status"] as? Int ?? 0
        let alertMessage = dict["message"] as? String ?? ""
        let dailyProductDetailArr = dict["Daily_Product_detail"] as? [[String:T]] ?? [[:]]
        let specialProductDetailArr = dict["special_product"] as? [[String:T]] ?? [[:]]
        let dailyUserDetailDict = dict["detail"] as? [String:T] ?? [:]

       
        
        self.status = status
        self.message = alertMessage
        self.dailyUserDetailDict = dailyUserDetailDict
        self.dailyProductDetailArr = dailyProductDetailArr
        self.specialProductDetailArr = specialProductDetailArr
    }
}
