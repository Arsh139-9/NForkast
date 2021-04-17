//
//  GetProfileDetailEntity.swift
//  Forkast
//
//  Created by Dharmani Apps mini on 3/9/21.
//

import Foundation
struct GetProfileData<T>{
  
  
//    {
//        "status": 1,
//        "message": "User profile detail.",
//        "userDetail": {
//            "userId": "13",
//            "name": "",
//            "email": "",
//            "password": "0192023a7bbd73250516f069df18b500",
//            "phone_number": "",
//            "role": "2",
//            "image": "",
//            "country": "",
//            "country_image": "",
//            "auth_token": "bcd",
//            "status": "0",
//            "is_organisation": "0",
//            "organisation_id": "0",
//            "login_status": "0",
//            "device_type": "1",
//            "device_token": "zddfdfdffs",
//            "creation_at": ""
//        }
//    }
    var status: Int
    var message: String
    var unreadCount: String
    
    var user_detail:[String:T]
    
    init?(dict:[String:T]) {
        let status  = dict["status"] as? Int ?? 0
        let alertMessage = dict["message"] as? String ?? ""
        let unreadCount = dict["unread_message_count"] as? String ?? ""

        
        let userDetailDict = dict["userDetail"] as? [String:T] ?? [:]
       
        let userDetailTStruct = GetProfileUserDetail(dict: userDetailDict)!
       
        self.status = status
        self.message = alertMessage
        self.user_detail = userDetailDict
        self.unreadCount = unreadCount

    }
}

struct GetProfileUserDetail<T>{
 
    var userId:String
    var name:String
    var email:String
    var password:String
    var phone_number:String
    var role:String
    var image:String
    var country:String
    var country_image:String
    var auth_token:String
    var status:String
    var is_organisation:String
    var organisation_id:String
    var login_status:String
    var device_type:String
    var device_token:String
    var creation_at:String
    
    init?(dict:[String:T]) {
   
        let userId = dict["userId"] as? String ?? ""
        let name = dict["name"] as? String ?? ""
        let email = dict["email"] as? String ?? ""
        let password = dict["password"] as? String ?? ""
        let phone_number = dict["phone_number"] as? String ?? ""
        let role = dict["role"] as? String ?? ""
        let image = dict["image"] as? String ?? ""
        let country = dict["country"] as? String ?? ""
        let country_image = dict["country_image"] as? String ?? ""
        let auth_token = dict["auth_token"] as? String ?? ""
        let status = dict["status"] as? String ?? ""
        let is_organisation = dict["is_organisation"] as? String ?? ""
        let organisation_id = dict["organisation_id"] as? String ?? ""
        let login_status = dict["login_status"] as? String ?? ""
        let device_type = dict["device_type"] as? String ?? ""
        let device_token = dict["device_token"] as? String ?? ""
        let creation_at = dict["creation_at"] as? String ?? ""
       

  
        self.userId = userId
        self.name = name
        self.email = email
        self.password = password
        self.phone_number = phone_number
        self.role = role
        self.image = image
        self.country = country
        self.country_image = country_image
        self.auth_token = auth_token
        self.status = status
        self.is_organisation = is_organisation
        self.organisation_id = organisation_id
        self.login_status = login_status
        self.device_type = device_type
        self.device_token = device_token
        self.creation_at = creation_at
     

    }
}
