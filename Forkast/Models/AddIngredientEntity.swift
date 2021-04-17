//
//  AddIngredientEntity.swift
//  Forkast
//
//  Created by Dharmani Apps mini on 3/19/21.
//

import Foundation

struct AddIngredientData<T>{
  
  
    //{
    //    "status": 1,
    //    "message": "New password has been sent to the entered email, please check your email."
    //}
    var status: Int
    var message: String
    var ingredientDetail:[String:T]
    
    init?(dict:[String:T]) {
        let status  = dict["status"] as? Int ?? 0
        let alertMessage = dict["message"] as? String ?? ""
        let ingredientDetail = dict["ingredient_detail"] as? [String:T] ?? [:]

        self.status = status
        self.message = alertMessage
        self.ingredientDetail = ingredientDetail
    }
}



//{
//    "status": 1,
//    "message": "Ingedient updated successfully.",
//    "ingredient_detail": {
//        "ingredientId": "1",
//        "name": "rtyty",
//        "vendor": "Wheat",
//        "category": "ABC",
//        "image": "https://www.dharmani.com/forkast/admin/Ingredient/https://www.dharmani.com/forkast/admin/Ingredient/https://www.dharmani.com/forkast/admin/Ingredient/https://www.dharmani.com/forkast/admin/Ingredient/6024c65beb420_1613022811.png",
//        "inventory_method": "2",
//        "parValue": "",
//        "full_unit": "Case",
//        "full_price": "50",
//        "less_unit": "Bag",
//        "less_quantity": "1",
//        "inventory_count": "2",
//        "mapping_unit": "Count",
//        "mapping_unit_case": "80",
//        "waste_factor": "2",
//        "organisation_id": "1",
//        "position": "4",
//        "status": "0",
//        "is_remove": "0",
//        "creationAt": "1612864025"
//    }
//}
