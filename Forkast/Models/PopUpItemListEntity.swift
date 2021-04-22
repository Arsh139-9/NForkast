//
//  PopUpItemListEntity.swift
//  Forkast
//
//  Created by Dharmani Apps mini on 3/18/21.
//

import Foundation
struct PopUpItemListData<T>{
  
  
    //{
    //    "status": 1,
    //    "message": "New password has been sent to the entered email, please check your email."
    //}
    var status: Int
    var message: String
    var categoryDetailArr:[[String:T]]
    var vendorDetailArr:[[String:T]]
    var unitDetailArr:[[String:T]]
    var fullCaseUnitDetailArr:[[String:T]]
    var lessCaseUnitDetailArr:[[String:T]]
    var uOMDetailArr:[[String:T]]
    var mappingDetailArr:[[String:T]]

    init?(dict:[String:T]) {
        let status  = dict["status"] as? Int ?? 0
        let alertMessage = dict["message"] as? String ?? ""
        let category_detail = dict["category_detail"] as? [[String:T]] ?? [[:]]
        let vendor_detail = dict["vendor_detail"] as? [[String:T]] ?? [[:]]
        let unit_detail = dict["unit_detail"] as? [[String:T]] ?? [[:]]
        let fullCaseUnitDetail = dict["full_case_unit"] as? [[String:T]] ?? [[:]]
        let lessCaseUnitDetail = dict["less_case_unit"] as? [[String:T]] ?? [[:]]
        let uomDetail = dict["UOM"] as? [[String:T]] ?? [[:]]
        let mappingUnitDetail = dict["mapping_unit"] as? [[String:T]] ?? [[:]]

        self.status = status
        self.message = alertMessage
        self.categoryDetailArr = category_detail
        self.vendorDetailArr = vendor_detail
        self.unitDetailArr = unit_detail
       self.fullCaseUnitDetailArr = fullCaseUnitDetail
        self.lessCaseUnitDetailArr = lessCaseUnitDetail
        self.uOMDetailArr = uomDetail
        self.mappingDetailArr = mappingUnitDetail

    }
}
