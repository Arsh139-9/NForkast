//
//  ViewController.swift
//  Forkast
//
//  Created by Apple on 08/03/21.
//

import UIKit
import SVProgressHUD

class ViewController: UIViewController,UITextFieldDelegate{

    @IBOutlet weak var userNameTF: UITextField!
    
    @IBOutlet weak var passwordTF: UITextField!
    let restL = RestManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        userNameTF.delegate = self
        passwordTF.delegate = self

        // Do any additional setup after loading the view.
    }

    @IBAction func forgotPasswordBtnAction(_ sender: Any) {
        let CMDVC = self.storyboard?.instantiateViewController(withIdentifier: ViewControllerIdentifier.ForgotPasswordVC) as? ForgotPasswordVC
        if let CMDVC = CMDVC {
            navigationController?.pushViewController(CMDVC, animated: true)
        }
    }
    //then you should implement the func named textFieldShouldReturn
     func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            textField.resignFirstResponder()
            return true
        }
    @IBAction func loginBtnAction(_ sender: Any){
            
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
            }else if passwordTF.text?.trimmingCharacters(in: .whitespaces) == ""{
                Alert.present(
                    title: AppAlertTitle.appName.rawValue,
                    message: AppSignInForgotSignUpAlertNessage.enterPassword,
                    actions: .ok(handler: {
                    }),
                    from: self
                )
            }
            //      else if !validatePasswordLength(strPassword: passwordTF.text){
            //        Alert.present(
            //            title: AppAlertTitle.appName.rawValue,
            //            message: "Please enter valid password",
            //            actions: .ok(handler: {
            //            }),
            //            from: self
            //        )
            //      }
            else{
                loginUserApi()
            }
            
     
       
    }
    public func loginUserApi(){
        guard let url = URL(string: kBASEURL + WSMethods.signIn) else { return }
     

        var deviceToken  = getSAppDefault(key: "DeviceToken") as? String ?? ""
        if deviceToken == ""{
            deviceToken = "123"
        }
        restL.requestHttpHeaders.add(value: "application/json", forKey: "Content-Type")
        restL.httpBodyParameters.add(value: userNameTF.text ?? "", forKey: "email")
        restL.httpBodyParameters.add(value: passwordTF.text ?? "", forKey: "password")
        
     
        restL.httpBodyParameters.add(value: deviceToken, forKey: "device_token")
        restL.httpBodyParameters.add(value: "1", forKey: "device_type")
        
        SVProgressHUD.show()

        
        restL.makeRequest(toURL: url, withHttpMethod: .post) { (results) in
            SVProgressHUD.dismiss()

            
            guard let response = results.response else { return }
            if response.httpStatusCode == 200 {
                guard let data = results.data else { return }
                
                let jsonResult = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String:AnyHashable] ?? [:]
                //                    let dataString = String(data: data, encoding: .utf8)
                //                    let jsondata = dataString?.data(using: .utf8)
                //                    let decoder = JSONDecoder()
                //                    let jobUser = try? decoder.decode(LoginData, from: jsondata!)
                //
                let loginResp =   LoginData.init(dict: jsonResult ?? [:])
                if loginResp?.status == 1{
                    setAppDefaults(loginResp?.user_detail.userId, key: "UserId")
                    setAppDefaults(loginResp?.user_detail.organisation_id, key: "OrganisationId")

                    setAppDefaults(loginResp?.user_detail.auth_token, key: "AuthToken")

                    setAppDefaults(loginResp?.user_detail.role, key: "Role")

                    DispatchQueue.main.async {
                     
                            let storyBoard = UIStoryboard(name: StoryboardName.Main, bundle: nil)
                            let DVC = storyBoard.instantiateViewController(withIdentifier: ViewControllerIdentifier.HomeTabVC) as? HomeTabVC
                                        DVC?.selectedIndex = 0
                                        if let DVC = DVC {
                                            self.navigationController?.pushViewController(DVC, animated: true)
                                        }

                    }
                }else{
                    DispatchQueue.main.async {
                        Alert.present(
                            title: AppAlertTitle.appName.rawValue,
                            message: loginResp?.message ?? "",
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
}

