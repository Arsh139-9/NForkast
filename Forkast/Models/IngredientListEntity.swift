//
//  IngredientListEntity.swift
//  Forkast
//
//  Created by Dharmani Apps mini on 3/17/21.
//

import Foundation
struct IngredientListData<T>{
  
  
    //{
    //    "status": 1,
    //    "message": "New password has been sent to the entered email, please check your email."
    //}
    var status: Int
    var message: String
    var ingredientListArr:[[String:T]]
    
    init?(dict:[String:T]) {
        let status  = dict["status"] as? Int ?? 0
        let alertMessage = dict["message"] as? String ?? ""
        let ingredientListArr = dict["all_ingredient"] as? [[String:T]] ?? [[:]]

        self.status = status
        self.message = alertMessage
        self.ingredientListArr = ingredientListArr
    }
}
