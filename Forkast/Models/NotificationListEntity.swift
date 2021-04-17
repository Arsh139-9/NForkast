//
//  NotificationListEntity.swift
//  Forkast
//
//  Created by Dharmani Apps mini on 3/26/21.
//

import Foundation

struct NotificationListData<T>{
  
  
    //{
    //    "status": 1,
    //    "message": "New password has been sent to the entered email, please check your email."
    //}
    var status: Int
    var message: String
    var notificationListArr:[[String:T]]
    
    init?(dict:[String:T]) {
        let status  = dict["status"] as? Int ?? 0
        let alertMessage = dict["message"] as? String ?? ""
        let notificationListArr = dict["notification_detail"] as? [[String:T]] ?? [[:]]

       
        
        self.status = status
        self.message = alertMessage
        self.notificationListArr = notificationListArr
    }
}
