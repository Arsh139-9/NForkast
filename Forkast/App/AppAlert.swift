//
//  AppAlert.swift
//  BumpAppReplica
//
//  Created by Dharmesh Avaiya on 21/01/20..
//  Copyright © 2018 iOSDeveloper. All rights reserved.
//

import Foundation
import UIKit

enum AppAlertTitle : String {
    case appName = "Forkast"
    case connectionError = "Connection Error"
    
}

struct AppHomeTabAlertMessage {
    static let userLocationError = "Error getting the users location"
    static let appleLoginSupport = "Apple login support in iOS 13 and above"
}



struct AppSignInForgotSignUpAlertNessage {
    static let enterEmail = "Please enter email"
    static let validEmail = "Please enter valid email"
    static let enterPassword = "Please enter password"
    static let enterPhonenumber = "Please enter phone number"

    static let enterConfirmPassword = "Please enter confirm password"
    static let passwordNotMatched = "Password doesn’t match"
    static let enterDOB = "Please enter D.O.B"
    static let enterName = "Please enter name"
    static let enterProductName = "Please enter product name"
    static let enterSalePrecent = "Please enter sales percent"
    static let enterSalePrize = "Please enter sales price"
    static let enterText = "Please enter text"
    static let enterIngredientName = "Please enter ingredient name"
    static let enterPreferredVendor = "Please select preferred vendor"
    static let enterCategory = "Please select category"
    static let enterPar = "Please enter par value"
    static let enterFCUnit = "Please select full case unit"
    static let enterFCPrice = "Please enter full case price"
    static let enterLCUnit = "Please select less case unit"
    static let enterLCQuantity = "Please enter less case quantity"
    static let enterMappingUnit = "Please select mapping unit"
    static let enterMappingUnitCase = "Please enter mapping unit case"
    static let enterMappingWastePercent = "Please enter mapping waste%"
    static let enterIngredient = "Please select ingredient"
    static let enterQuantity = "Please enter quantity"
    static let enterUOM = "Please select UOM"
    static let enterWF = "Please enter waste factor"
    static let enterAddIngredient = "Please add ingredient"


}

struct AppCameraPicAlertMessage{
    static let camera = "Camera"
    static let gallery = "Gallery"
    static let cancel = "Cancel"
    static let uploadImage = "Please upload an image"
    static let noCamera = "Device has no camera"
}
struct AppInterestAlertMessage {
    static let addInterestValidation = "Please add atleast 1 interest"

}



struct Alert {
    static func present(title: String?, message: String, actions: Alert.Action..., from controller: UIViewController) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        for action in actions {
            alertController.addAction(action.alertAction)
        }
        controller.present(alertController, animated: true, completion: nil)
    }
}
extension Alert {
    enum Action {
        case ok(handler: (() -> Void)?)
        case retry(handler: (() -> Void)?)
        case close

        // Returns the title of our action button
        private var title: String {
            switch self {
            case .ok:
                return "OK"
            case .retry:
                return "Retry"
            case .close:
                return "Close"
            }
        }

        // Returns the completion handler of our button
        private var handler: (() -> Void)? {
            switch self {
            case .ok(let handler):
                return handler
            case .retry(let handler):
                return handler
            case .close:
                return nil
            }
        }

        var alertAction: UIAlertAction {
            return UIAlertAction(title: title, style: .default, handler: { _ in
                if let handler = self.handler {
                    handler()
                }
            })
        }
    }
}
