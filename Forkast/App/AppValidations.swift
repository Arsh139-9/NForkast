//
//  SignInVC.swift
//  BumpAppReplica
//
//  Created by Dharmesh Avaiya on 21/01/20..
//  Copyright © 2018 iOSDeveloper. All rights reserved.
//

import Foundation

func validateInputField(strInput: String?) -> Bool {
    let inputRegex = "([A-Za-z0-9.%+_]{2,25}))"
    let inputPredicate = NSPredicate(format: "SELF MATCHES %@",inputRegex)
    return inputPredicate.evaluate(with: strInput!)
}

func validateEmail(strEmail: String?) -> Bool {
    let emailRegex = "((([A-Za-z0-9.%+_])+@([A-Za-z0-9]+\\.)([A-Za-z]{2,4}))|(([A-Za-z0-9.%+_])+@([A-Za-z0-9]+\\.)([A-Za-z]{2,4})+\\.([A-Za-z]{2,4})))"
    let emailPredicate = NSPredicate(format: "SELF MATCHES %@",emailRegex)
    return emailPredicate.evaluate(with: strEmail!)
}


func validatePasswordLength(strPassword: String?) -> Bool {
    
    if strPassword!.count > 0 {
        
        let passwordRegex = "^(.{0,7}|[^0-9]*|[^a-zA-Z]*|[^\\W]*)$"
        //let passwordRegex = "((?=.*[0-9])(?=.*[a-z])(?=.*[A-Z])(?=.*[\\W])){7,32}"

        
        let passwordPredicate = NSPredicate(format: "SELF MATCHES %@",passwordRegex)
        let isValid = passwordPredicate.evaluate(with: strPassword!)
        if isValid {
            return false
        } else {
            return true
        }
    } else {
        return false
    }
    
}

func matchesRegex(strPassword: String?,strRegex: String) -> Bool {
    
    if strPassword!.count > 0 {
        
        let passwordRegex = strRegex
        
        let passwordPredicate = NSPredicate(format: "SELF MATCHES %@",passwordRegex)
        let isValid = passwordPredicate.evaluate(with: strPassword!)
        if isValid {
            return false
        } else {
            return true
        }
    } else {
        return false
    }
}


func comparePasswordValidation(strPassword: String,strConfirmPassword: String) -> Bool {
    // strPassword can be NEW password or OLD Password.
    // StrConfirmPassword can confirm Password OR NEW Password to match with OLD Password.
    
    var isPasswordMatched : Bool = false
    
    if strPassword.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines) == strConfirmPassword.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines) {
        isPasswordMatched = true
    }
    return isPasswordMatched
}
