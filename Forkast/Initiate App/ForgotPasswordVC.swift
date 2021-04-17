//
//  ForgotPasswordVC.swift
//  Forkast
//
//  Created by Dharmani Apps mini on 3/10/21.
//

import UIKit
import SVProgressHUD

class ForgotPasswordVC: UIViewController,UITextFieldDelegate{
    
    @IBOutlet weak var userNameTF: UITextField!
    let restF = RestManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        userNameTF.delegate = self
        
        // Do any additional setup after loading the view.
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
           textField.resignFirstResponder()
           return true
       }
    @IBAction func forgotPasswordBtnAction(_ sender: Any) {
        if userNameTF.text?.trimmingCharacters(in: .whitespaces) == ""{
            Alert.present(
                title: AppAlertTitle.appName.rawValue,
                message: AppSignInForgotSignUpAlertNessage.enterEmail,
                actions: .ok(handler: {
                }),
                from: self
            )
        }
        else  if !validateEmail(strEmail: userNameTF.text ?? ""){
            Alert.present(
                title: AppAlertTitle.appName.rawValue,
                message: AppSignInForgotSignUpAlertNessage.validEmail,
                actions: .ok(handler: {
                }),
                from: self
            )
        }else{
        forgotPasswordApi()
        }
    }
    open func forgotPasswordApi(){
        
        
        guard let url = URL(string: WS_Staging + WSMethods.forgotPassword) else { return }
    
        restF.requestHttpHeaders.add(value: "application/json", forKey: "Content-Type")
        restF.httpBodyParameters.add(value:userNameTF.text ?? "", forKey:"email")

       
        SVProgressHUD.show()
        
        restF.makeRequest(toURL: url, withHttpMethod: .post) { (results) in

            SVProgressHUD.dismiss()
            guard let response = results.response else { return }
            if response.httpStatusCode == 200 {
                guard let data = results.data else { return }
                
                let jsonResult = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String:AnyHashable] ?? [:]
                
                let forgotResp = ForgotPasswordData.init(dict: jsonResult ?? [:])

                if forgotResp?.status == 1{
                    DispatchQueue.main.async {
                        Alert.present(
                            title: AppAlertTitle.appName.rawValue,
                            message: forgotResp?.message ?? "",
                            actions: .ok(handler: {
                                self.navigationController?.popViewController(animated: true)
                            }),
                            from: self
                        )
                    }                }else{
                    DispatchQueue.main.async {

                    Alert.present(
                        title: AppAlertTitle.appName.rawValue,
                        message: forgotResp?.message ?? "",
                        actions: .ok(handler: {
                        }),
                        from: self
                    )
                    }
                }

               
            }else{
                DispatchQueue.main.async {

                Alert.present(
                    title: AppAlertTitle.appName.rawValue,
                    message: AppAlertTitle.connectionError.rawValue,
                    actions: .ok(handler: {
                    }),
                    from: self
                )
                }
            }
        }
    }
    @IBAction func backButtonAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    

}
