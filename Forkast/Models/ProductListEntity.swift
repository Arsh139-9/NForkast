//
//  ProductListEntity.swift
//  Forkast
//
//  Created by Dharmani Apps mini on 3/15/21.
//

import Foundation


struct ProductListData<T>{
  
  
    //{
    //    "status": 1,
    //    "message": "New password has been sent to the entered email, please check your email."
    //}
    var status: Int
    var message: String
    var productListArr:[[String:T]]
    
    init?(dict:[String:T]) {
        let status  = dict["status"] as? Int ?? 0
        let alertMessage = dict["message"] as? String ?? ""
        let productListArr = dict["all_product"] as? [[String:T]] ?? [[:]]

        self.status = status
        self.message = alertMessage
        self.productListArr = productListArr
    }
}


//{
//    "status": 1,
//    "message": "All Product detail.",
//    "all_product": [
//        {
//            "productId": "32",
//            "name": "rt",
//            "salePrize": "2",
//            "salePercentage": "4",
//            "image": "https://www.dharmani.com/forkast/admin/Product/0d134540db29804637b4d88c117477eb.jpg",
//            "quantity": "",
//            "organisation_id": "13",
//            "enable": "0",
//            "creationAt": "1615182398"
//        },
//        {
//            "productId": "31",
//            "name": "ffff",
//            "salePrize": "2",
//            "salePercentage": "2",
//            "image": "https://www.dharmani.com/forkast/admin/Product/0ff9f99955fb8161d8d54aafdeea8860.jpg",
//            "quantity": "",
//            "organisation_id": "13",
//            "enable": "0",
//            "creationAt": "1615182373"
//        },
//        {
//            "productId": "30",
//            "name": "dfsd",
//            "salePrize": "2",
//            "salePercentage": "1",
//            "image": "https://www.dharmani.com/forkast/admin/Product/03048c6b80cad851dfce5ed879bc4076.png",
//            "quantity": "",
//            "organisation_id": "13",
//            "enable": "0",
//            "creationAt": "1615182342"
//        },
//        {
//            "productId": "29",
//            "name": "test1",
//            "salePrize": "2",
//            "salePercentage": "2",
//            "image": "https://www.dharmani.com/forkast/admin/Product/0d134540db29804637b4d88c117477eb.jpg",
//            "quantity": "",
//            "organisation_id": "13",
//            "enable": "0",
//            "creationAt": "1615182323"
//        },
//        {
//            "productId": "27",
//            "name": "123test",
//            "salePrize": "11.20",
//            "salePercentage": "12.20",
//            "image": "https://www.dharmani.com/forkast/admin/Product/8b57396a90ccc5ca9d87ce8e2a5ac962.jpg",
//            "quantity": "2",
//            "organisation_id": "13",
//            "enable": "0",
//            "creationAt": "1614857163"
//        },
//        {
//            "productId": "26",
//            "name": "Sandwich",
//            "salePrize": "14.50",
//            "salePercentage": "20.30",
//            "image": "https://www.dharmani.com/forkast/admin/Product/11f3d693a1a4b3072f992d5311d98836.jpg",
//            "quantity": "50",
//            "organisation_id": "13",
//            "enable": "0",
//            "creationAt": "1614759794"
//        },
//        {
//            "productId": "23",
//            "name": "Biryani",
//            "salePrize": "220.60",
//            "salePercentage": "60.30",
//            "image": "https://www.dharmani.com/forkast/admin/Product/ffef1a3ad60e56599206296e7b8457ac.jpg",
//            "quantity": "20",
//            "organisation_id": "13",
//            "enable": "0",
//            "creationAt": "1614340438"
//        },
//        {
//            "productId": "22",
//            "name": "Burger",
//            "salePrize": "30",
//            "salePercentage": "30",
//            "image": "https://www.dharmani.com/forkast/admin/Product/4815728d35cc9510fa5e2fc4f16203d0.jpg",
//            "quantity": "10",
//            "organisation_id": "13",
//            "enable": "0",
//            "creationAt": "1614340340"
//        },
//        {
//            "productId": "11",
//            "name": "Meatballs",
//            "salePrize": "6.95",
//            "salePercentage": "2",
//            "image": "https://www.dharmani.com/forkast/admin/Product/89081ff5c87f5a2ab952239cf2c2b092.jpg",
//            "quantity": "10",
//            "organisation_id": "13",
//            "enable": "0",
//            "creationAt": "1612780499"
//        },
//        {
//            "productId": "3",
//            "name": "Pasta",
//            "salePrize": "4",
//            "salePercentage": "30",
//            "image": "https://www.dharmani.com/forkast/admin/Product/f5f2c1e24b535ceb8199cb2d0805340e.jpg",
//            "quantity": "55",
//            "organisation_id": "13",
//            "enable": "0",
//            "creationAt": "1612780499"
//        },
//        {
//            "productId": "1",
//            "name": "pizza",
//            "salePrize": "19.73",
//            "salePercentage": "42.60",
//            "image": "https://www.dharmani.com/forkast/admin/Product/f97fcb777fbc60235e7cfdf991cb0cfa.jpg",
//            "quantity": "12",
//            "organisation_id": "13",
//            "enable": "0",
//            "creationAt": "1612773826"
//        }
//    ]
//}
