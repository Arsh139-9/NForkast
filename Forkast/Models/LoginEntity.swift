//
//  LoginEntity.swift
//  Forkast
//
//  Created by Dharmani Apps mini on 2/18/21.
//

import Foundation

// MARK: Model CardModel

struct LoginRoot:Codable{
    let status: String?
    let message: String?
    let logged_id: String?
    let user_detail: LoginUserDDetail?
    enum CodingKeys:String,CodingKey{
        case status = "status"
        case message = "message"
        case logged_id = "logged_id"
        case user_detail = "user_detail"

    }
    init(from decoder:Decoder)throws{
        let values = try decoder.container(keyedBy:CodingKeys.self)
        user_detail = try values.decodeIfPresent(LoginUserDDetail.self, forKey: .user_detail)
        status = try values.decodeIfPresent(String.self, forKey: .status)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        logged_id = try values.decodeIfPresent(String.self, forKey: .logged_id)

    }
}
struct LoginUserDDetail:Codable{
    let userId:String?
    let name:String?
    let email:String?
    let password:String?
    let phone_number:String?
    let role:String?
    let image:String?
    let country:String?
    let country_image:String?
    let auth_token:String?
    let status:String?
    let is_organisation:String?
    let organisation_id:String?
    let login_status:String?
    let device_type:String?
    let device_token:String?
    let creation_at:String?
}


struct LoginData<T>{
  
  
    //{
    //    "status": 1,
    //    "message": "Logged in Successfully.",
    //    "logged_id": "1",
    //    "user_detail": {
    //        "userId": "1",
    //        "name": "aman",
    //        "email": "dharmaniz.komal@gmail.com",
    //        "password": "74be16979710d4c4e7c6647856088456",
    //        "phone_number": "7665446546",
    //        "role": "1",
    //        "image": "6018ee798626e_1612246649.png",
    //        "country": "India",
    //        "country_image": "6018ee79871e9_1612246649.png",
    //        "auth_token": "abc",
    //        "status": "0",
    //        "is_organisation": "1",
    //        "organisation_id": "13",
    //        "login_status": "1",
    //        "device_type": "0",
    //        "device_token": "",
    //        "creation_at": "1612244233"
    //    }
    //}
    var status: Int
    var message: String
    var logged_id: String
    var user_detail: LoginUserDetail<T>
    
    init?(dict:[String:T]) {
        let status  = dict["status"] as? Int ?? 0
        let alertMessage = dict["message"] as? String ?? ""
        let logged_id = dict["logged_id"] as? String ?? ""

        
        let userDetailDict = dict["user_detail"] as? [String:T] ?? [:]
       
        let userDetailTStruct = LoginUserDetail(dict: userDetailDict)!
       
        self.status = status
        self.message = alertMessage
        self.logged_id = logged_id
        self.user_detail = userDetailTStruct

    }
}

struct LoginUserDetail<T>{
 
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







//class CardModel : Identifiable, Codable, Mappable {
//
//    var id: Int
//    var name: String
//    var url: String
//
//   required init?(map: Map) {
//    }
//
//    mutating func mapping(map: Map) {
//           name     <- map["login"]
//           url     <- map["avatar_url"]
//           repos     <- map["repos_url"]
//       }
//
//}
//
