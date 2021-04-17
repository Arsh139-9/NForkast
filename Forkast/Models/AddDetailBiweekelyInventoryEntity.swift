//
//  AddDetailBiweekelyInventoryEntity.swift
//  Forkast
//
//  Created by Dharmani Apps mini on 3/4/21.
//
import Foundation

struct AddDetailBiweekelyInventoryData<T>{
  
  
    //{
    //    "status": 1,
    //    "message": "New password has been sent to the entered email, please check your email."
    //}
    var status: Int
    var message: String
    var biweekelyUserDetailDict:[String:T]
    var biweekelyProductDetailArr:[[String:T]]
    
    init?(dict:[String:T]) {
        let status  = dict["status"] as? Int ?? 0
        let alertMessage = dict["message"] as? String ?? ""
        let biweekelyUserDetailDict = dict["detail"] as? [String:T] ?? [:]

        let biweekelyProductDetailArr = dict["Biweekly_detail"] as? [[String:T]] ?? [[:]]

       
        
        self.status = status
        self.message = alertMessage
        
        self.biweekelyUserDetailDict = biweekelyUserDetailDict
        self.biweekelyProductDetailArr = biweekelyProductDetailArr
    }
}
