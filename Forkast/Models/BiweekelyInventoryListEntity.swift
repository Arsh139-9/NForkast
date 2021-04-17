//
//  BiweekelyInventoryListEntity.swift
//  Forkast
//
//  Created by Dharmani Apps mini on 3/3/21.
//

import Foundation
struct BiweekelyInventoryListData<T>{
  
  
    //{
    //    "status": 1,
    //    "message": "New password has been sent to the entered email, please check your email."
    //}
    var status: Int
    var message: String
    var biweekelyInventoryArr:[[String:T]]
    
    init?(dict:[String:T]) {
        let status  = dict["status"] as? Int ?? 0
        let alertMessage = dict["message"] as? String ?? ""
        let biweekelyInventoryArr = dict["BiWeekly_detail"] as? [[String:T]] ?? [[:]]

       
        
        self.status = status
        self.message = alertMessage
        self.biweekelyInventoryArr = biweekelyInventoryArr
    }
}
