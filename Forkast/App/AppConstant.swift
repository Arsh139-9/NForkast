//
//  AppConstant.swift
//  ChanceUpon
//
//  Created by Dharmani Apps mini on 11/20/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import Foundation

import UIKit

let DeviceSize = UIScreen.main.bounds.size
@available(iOS 13.0, *)
let appDel = (UIApplication.shared.delegate as! AppDelegate)
@available(iOS 13.0, *)
let appScene = (UIApplication.shared.delegate as! SceneDelegate)

struct WSMethods {
    static let signIn = "Login.php"
    static let signUp = "signUp.php"
    static let getAllDailyInventoryDetail = "GetAllDailyInventoryDetail.php"
    static let getAllBiweeklyInventoryDetail = "GetAllBiweeklyInventoryDetail.php"
    static let addDailyInventoryDetail = "AddDailyInventory.php"
    static let addBiWeeklyInventory = "AddBiWeeklyInventory.php"
    static let getAllProduct = "GetAllProduct.php"
    static let addProduct = "AddProduct.php"
    static let getAllIngredient = "GetAllIngredient.php"
    static let getListOfItem = "GetListOfItem.php"
    static let addIngredient = "AddIngredient.php"
    static let addIngredientProductDetail = "AddIngredientProductDetail.php"
    static let addMaping = "AddMaping.php"
    static let getAllBuildOrderDetail = "GetAllBuildOrderDetail.php"
    static let addBuildOrder = "AddBuildOrder.php"
    static let getNotificationDetailById = "GetNotificationDetailById.php"

    
    static let logOut = "Logout.php"
    static let getUserDetail = "GetProfileDetail.php"
    static let editProfile = "EditUserProfile.php"
    static let forgotPassword = "ForgetPassword.php"
   
    
}


let WS_Live = ""
let WS_Staging = "https://www.dharmani.com/forkast/WebServices/"

let kBASEURL = WS_Staging


struct SettingWebLinks {
    static let privacyPolicy = "PrivacyPolicy.php"
    static let aboutUs = "AboutUs.php"
    static let termsAndConditions = "TermsAndCondition.php"
}
struct NavBarTitle {
    static let privacyPolicy = "Privacy policy"
    static let aboutUs = "About"
    static let termsAndConditions = "Terms and condition"
}

struct ViewControllerIdentifier {
    static let SignUpVC = "SignUpVC"
    static let HomeTabVC = "HomeTabVC"
    static let HomeChildTabVC = "HomeChildTabVC"
    static let ForgotPasswordVC = "ForgotPasswordVC"
    static let ViewController = "ViewController"
    static let DailyInventoryListVC = "DailyInventoryListVC"
    static let BiweeklyInventoryListVC = "BiweeklyInventoryListVC"
    static let BuildOrderListVC = "BuildOrderListVC"
    static let BuildOrderDetailVC = "BuildOrderDetailVC"
    static let AddBuildOrderVC = "AddBuildOrderVC"
    static let NotificationVC = "NotificationVC"

    
    
    
    static let EditProfileVC = "EditProfileVC"
    static let ProfileChildTabVC = "ProfileChildTabVC"
    static let DailyInventoryDetailVC = "DailyInventoryDetailVC"
    static let BiweeklyInventoryDetailVC = "BiweeklyInventoryDetailVC"
    static let AddBiweeklyInventoryVC = "AddBiweeklyInventoryVC"
    static let AddDailyInventoryVC = "AddDailyInventoryVC"
    static let LinksWebVC = "LinksWebVC"
    static let ProductIngredientHomeVC = "ProductIngredientHomeVC"
    static let ProductListVC = "ProductListVC"
    static let AddProductVC = "AddProductVC"
    static let IngredientListVC = "IngredientListVC"
    static let AddIngredientVC = "AddIngredientVC"
    static let AddIngredientForkastVC = "AddIngredientForkastVC"
    static let ProductMappingVC = "ProductMappingVC"
    static let PopUpListVC = "PopUpListVC"

    
}
struct StoryboardName {
    static let Main = "Main"
    static let DailyInventory = "DailyInventory"
    static let BiweekelyInventory = "BiweekelyInventory"
    static let ProductIngredients = "ProductIngredients"
    static let BuildOrder = "BuildOrder"

}


struct PhoneNumberFormat {
    static let uk = "+NN NNN NNN NNNN"
}

struct InputFiledFormat {
    static let passport = "xxxxxxxxxxxxxxxxxxxxxxxxx"
    static let licence = "xxxxxxxxxxxxxxxxxxxxxxxxx"
    static let Insurance = "xx xx xx xx x"
}


struct PostCodeFormat {
    static let chars7 = "xxxx xxx"
    static let chars6 = "xxx xxx"
    static let chars5 = "xxx xx"
}

struct AppInputRestrictions {
    static let _charNumbers = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-/ "
    static let charNumbersOnly = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
    static let charOnly = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"
    static let numbersOnly = "0123456789"
}

struct AppRegex {
    static let minOneCapitalChar = "([^A-Z]{1,})"
    static let minOneDigitChar = "([^0-9]{1,})"
    static let minOneSpecialChar = "([^\\W]{1,})"
}

struct AppNotifications {
    static let signInInputs = NSNotification.Name(rawValue: "nc_signIn")
    static let signUpInputs = NSNotification.Name(rawValue: "nc_signUp")
    static let otpInputs = NSNotification.Name(rawValue: "nc_otpInput")
    static let idAddressInputs = NSNotification.Name(rawValue: "nc_address")
    static let idPassportInputs = NSNotification.Name(rawValue: "nc_passport")
    static let setSecurityInputs = NSNotification.Name(rawValue: "nc_setQues")
    static let forgotpassswordSecurityInputs = NSNotification.Name(rawValue: "nc_fpSecurityQues")
    
    static let nonregisteredUser = NSNotification.Name(rawValue: "nc_helpNonRegisteredUser")
    static let registeredUserSignInInputs = NSNotification.Name(rawValue: "nc_helpRegisteredUserSignIn")
    
    static let setTradingPin = NSNotification.Name(rawValue: "nc_setPin")
    static let setConfirmPin = NSNotification.Name(rawValue: "nc_setConfirmPin")
    static let insertPasscode = NSNotification.Name(rawValue: "nc_insertPasscode")
    static let forgotPasswordInputs = NSNotification.Name(rawValue: "nc_forgotPasswordInputs")
    static let signUpPassword = NSNotification.Name(rawValue: "passwordChanged")
    static let newPassword = NSNotification.Name(rawValue: "newPasswordChanged")
}

let kZoomDelta : Float = 100000000.0
let kRadiusInMeters  = 2
let kRadiusInKm  = 1000
let kRadiusInMiles = 1609.34
let kRegionDefaultValue = 100
let kMapPinAnnotIdentifier = "pinAnnot"
