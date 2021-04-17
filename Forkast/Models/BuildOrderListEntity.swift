//
//  BuildOrderListEntity.swift
//  Forkast
//
//  Created by Dharmani Apps mini on 3/22/21.
//

import Foundation
struct BuildOrderListData<T>{
  
  
    //{
    //    "status": 1,
    //    "message": "New password has been sent to the entered email, please check your email."
    //}
    var status: Int
    var message: String
    var buildOrderListArr:[[String:T]]
    
    init?(dict:[String:T]) {
        let status  = dict["status"] as? Int ?? 0
        let alertMessage = dict["message"] as? String ?? ""
        let buildOrderListArr = dict["build_order"] as? [[String:T]] ?? [[:]]

       
        
        self.status = status
        self.message = alertMessage
        self.buildOrderListArr = buildOrderListArr
    }
}
