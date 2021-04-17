//
//  DailyInventoryListEntity.swift
//  Forkast
//
//  Created by Dharmani Apps mini on 3/3/21.
//

import Foundation

struct DailyInventoryListData<T>{
  
  
    //{
    //    "status": 1,
    //    "message": "New password has been sent to the entered email, please check your email."
    //}
    var status: Int
    var message: String
    var dailyInventoryArr:[[String:T]]
    
    init?(dict:[String:T]) {
        let status  = dict["status"] as? Int ?? 0
        let alertMessage = dict["message"] as? String ?? ""
        let dailyInventoryArr = dict["daily_inventory_detail"] as? [[String:T]] ?? [[:]]

       
        
        self.status = status
        self.message = alertMessage
        self.dailyInventoryArr = dailyInventoryArr
    }
}

struct DailyInventoryData<T>{
    
    var dailyId:String
    var userId:String
    var organisationId:String
    var comment:String
    var draft:String
    var creation_at:String
    var title:String

    
    init?(dict:[String:T]) {
   
        let dailyId = dict["dailyId"] as? String ?? ""
        let userId = dict["userId"] as? String ?? ""
        let organisationId = dict["organisationId"] as? String ?? ""
        let comment = dict["comment"] as? String ?? ""
        let draft = dict["draft"] as? String ?? ""
        let creation_at = dict["creation_at"] as? String ?? ""
        let title = dict["title"] as? String ?? ""

        self.dailyId = dailyId
        self.userId = userId
        self.organisationId = organisationId
        self.comment = comment
        self.draft = draft
        self.creation_at = creation_at
        self.title = title

     

    }
}


//{
//            "dailyId": "6",
//            "userId": "13",
//            "organisationId": "13",
//            "comment": "1test",
//            "draft": "0",
//            "creation_at": "1613820164",
//            "title": "Daily Inventory"
//        }
struct DraftData<T>{
    
    var dailyId:String
    var userId:String
    var organisationId:String
    var comment:String
    var draft:String
    var creation_at:String
    
    
    init?(dict:[String:T]) {
   
        let dailyId = dict["dailyId"] as? String ?? ""
        let userId = dict["userId"] as? String ?? ""
        let organisationId = dict["organisationId"] as? String ?? ""
        let comment = dict["comment"] as? String ?? ""
        let draft = dict["draft"] as? String ?? ""
        let creation_at = dict["creation_at"] as? String ?? ""
 
        self.dailyId = dailyId
        self.userId = userId
        self.organisationId = organisationId
        self.comment = comment
        self.draft = draft
        self.creation_at = creation_at
       
     

    }
}
