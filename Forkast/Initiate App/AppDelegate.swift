//
//  AppDelegate.swift
//  Forkast
//
//  Created by Apple on 08/03/21.
//

import UIKit
import IQKeyboardManagerSwift

@available(iOS 13.0, *)
@UIApplicationMain

//@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        sleep(1)
        IQKeyboardManager.shared.enable = true
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor(red: 0/255.0, green: 151.0/255.0, blue:40.0/255.0, alpha: 1.0)], for: .selected)
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        appDelegate?.window = self.window
        let authToken  = getSAppDefault(key: "AuthToken") as? String ?? ""
        if authToken != ""{
            //            if occupation == ""{
            //                appDelegate?.loginToVCPage()
            //            }else{
            appDelegate?.loginToHomePage()
            
            // }
        }else{
            appDelegate?.logOut()
        }
        
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
        } else {
            let settings: UIUserNotificationSettings =
            UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        application.registerForRemoteNotifications()
        
        if launchOptions != nil
        {
            // opened from a push notification when the app is closed
            let userInfo = launchOptions?[UIApplication.LaunchOptionsKey.remoteNotification] as? [AnyHashable : Any]
            if (userInfo != nil){
                if let apnsData = userInfo?["aps"] as? [String:Any]{
                    if let dataObj = apnsData["data"] as? [String:Any]{
                        let notificationType = dataObj["push_type"] as? String
                        let state = UIApplication.shared.applicationState
                        if state != .active{
                            
                            if notificationType == "1"{
                                let storyBoard = UIStoryboard.init(name:StoryboardName.DailyInventory, bundle: nil)
                                let rootVc = storyBoard.instantiateViewController(withIdentifier:ViewControllerIdentifier.DailyInventoryDetailVC) as! DailyInventoryDetailVC
                                rootVc.dailyId = dataObj["inventory_id"] as? String ?? ""
                                rootVc.userId = dataObj["user_id"] as? String ?? ""
                                rootVc.authToken = dataObj["auth_token"] as? String ?? ""
                                
                                rootVc.fromAppDelegate = "YES"
                                
                                let nav =  UINavigationController(rootViewController: rootVc)
                                nav.isNavigationBarHidden = true
                                if #available(iOS 13.0, *){
                                    if let scene = UIApplication.shared.connectedScenes.first{
                                        let windowScene = (scene as? UIWindowScene)
                                        let window: UIWindow = UIWindow(frame: (windowScene?.coordinateSpace.bounds)!)
                                        window.windowScene = windowScene //Make sure to do this
                                        window.rootViewController = nav
                                        window.makeKeyAndVisible()
                                        self.window = window
                                    }
                                } else {
                                    self.window?.rootViewController = nav
                                    self.window?.makeKeyAndVisible()
                                }
                            }
                            
                            else if notificationType == "2"{
                                let storyBoard = UIStoryboard.init(name:StoryboardName.BiweekelyInventory, bundle: nil)
                                let rootVc = storyBoard.instantiateViewController(withIdentifier:ViewControllerIdentifier.BiweeklyInventoryDetailVC) as! BiweeklyInventoryDetailVC
                                rootVc.biweeklyId = dataObj["inventory_id"] as? String ?? ""
                                rootVc.fromAppDelegate = "YES"
                                
                                
                                let nav =  UINavigationController(rootViewController: rootVc)
                                nav.isNavigationBarHidden = true
                                if #available(iOS 13.0, *){
                                    if let scene = UIApplication.shared.connectedScenes.first{
                                        let windowScene = (scene as? UIWindowScene)
                                        let window: UIWindow = UIWindow(frame: (windowScene?.coordinateSpace.bounds)!)
                                        window.windowScene = windowScene //Make sure to do this
                                        window.rootViewController = nav
                                        window.makeKeyAndVisible()
                                        self.window = window
                                    }
                                } else {
                                    self.window?.rootViewController = nav
                                    self.window?.makeKeyAndVisible()
                                }
                            }
                            
                        }
                    }
                }
            }
            
        }
        
        return true
    }
    //MARK:-  Login Functionality
    func loginToHomePage(){
        let appdelegate = UIApplication.shared.delegate as! AppDelegate
        let mainStoryboard: UIStoryboard = UIStoryboard(name: StoryboardName.Main, bundle: nil)
        let homeViewController = mainStoryboard.instantiateViewController(withIdentifier: ViewControllerIdentifier.HomeTabVC) as! HomeTabVC
        homeViewController.selectedIndex = 0
        let nav = UINavigationController(rootViewController: homeViewController)
        nav.setNavigationBarHidden(true, animated: true)
        appdelegate.window?.rootViewController = nav
    }
    
    func loginToVCPage(){
        let storyBoard = UIStoryboard.init(name: StoryboardName.Main, bundle: nil)
        let rootVc = storyBoard.instantiateViewController(withIdentifier: ViewControllerIdentifier.ViewController) as! ViewController
        let nav = UINavigationController(rootViewController: rootVc)
        nav.isNavigationBarHidden = true
        self.window?.rootViewController = nav
        self.window?.makeKeyAndVisible()
    }
    //MARK:-  Logout Functionality
    func logOut(){
        let appdelegate = UIApplication.shared.delegate as! AppDelegate
        let mainStoryboard: UIStoryboard = UIStoryboard(name: StoryboardName.Main, bundle: nil)
        let homeViewController = mainStoryboard.instantiateViewController(withIdentifier: ViewControllerIdentifier.ViewController) as! ViewController
        let nav = UINavigationController(rootViewController: homeViewController)
        nav.setNavigationBarHidden(true, animated: true)
        appdelegate.window?.rootViewController = nav
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let deviceTokenString = deviceToken.map { String(format: "%02x", $0) }.joined()
        debugPrint("device token is \(deviceTokenString)")
        setAppDefaults(deviceTokenString, key: "DeviceToken")
    }
    // MARK: UISceneSession Lifecycle
    @available(iOS 13.0, *)
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    @available(iOS 13.0, *)
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    
}

@available(iOS 13.0, *)
extension AppDelegate : UNUserNotificationCenterDelegate {
    
    // Receive displayed notifications for iOS 10 devices.
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        if let userInfo = notification.request.content.userInfo as? [String:Any]{
            if let apnsData = userInfo["aps"] as? [String:Any]{
                if let dataObj = apnsData["data"] as? [String:Any]{
                    let notificationType = dataObj["notification_type"] as? String
                    let state = UIApplication.shared.applicationState
                }
            }
        }
        
        
        
        
        // Print full message.
        //        print("user info is \(userInfo)")
        
        // Change this to your preferred presentation option
        // completionHandler([])
        //Show Push notification in foreground
        //        completionHandler([.alert, .badge, .sound])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        if let userInfo = response.notification.request.content.userInfo as? [String:Any]{
            print(userInfo)
            if let apnsData = userInfo["aps"] as? [String:Any]{
                if let dataObj = apnsData["data"] as? [String:Any]{
                    let notificationType = dataObj["push_type"] as? String
                    let state = UIApplication.shared.applicationState
                    if state != .active{
                        
                        if notificationType == "1"{
                            let storyBoard = UIStoryboard.init(name:StoryboardName.DailyInventory, bundle: nil)
                            let rootVc = storyBoard.instantiateViewController(withIdentifier:ViewControllerIdentifier.DailyInventoryDetailVC) as! DailyInventoryDetailVC
                            rootVc.dailyId = dataObj["inventory_id"] as? String ?? ""
                            rootVc.userId = dataObj["user_id"] as? String ?? ""
                            rootVc.authToken = dataObj["auth_token"] as? String ?? ""
                            rootVc.fromNotificationBool = true
                            rootVc.fromAppDelegate = "YES"
                            
                            let nav =  UINavigationController(rootViewController: rootVc)
                            nav.isNavigationBarHidden = true
                            if #available(iOS 13.0, *){
                                if let scene = UIApplication.shared.connectedScenes.first{
                                    guard let windowScene = (scene as? UIWindowScene) else { return }
                                    let window: UIWindow = UIWindow(frame: windowScene.coordinateSpace.bounds)
                                    window.windowScene = windowScene //Make sure to do this
                                    window.rootViewController = nav
                                    window.makeKeyAndVisible()
                                    self.window = window
                                }
                            } else {
                                self.window?.rootViewController = nav
                                self.window?.makeKeyAndVisible()
                            }
                        }
                        
                        else if notificationType == "2"{
                            let storyBoard = UIStoryboard.init(name:StoryboardName.BiweekelyInventory, bundle: nil)
                            let rootVc = storyBoard.instantiateViewController(withIdentifier:ViewControllerIdentifier.BiweeklyInventoryDetailVC) as! BiweeklyInventoryDetailVC
                            rootVc.biweeklyId = dataObj["inventory_id"] as? String ?? ""
                            rootVc.fromAppDelegate = "YES"
                            
                            
                            let nav =  UINavigationController(rootViewController: rootVc)
                            nav.isNavigationBarHidden = true
                            if #available(iOS 13.0, *){
                                if let scene = UIApplication.shared.connectedScenes.first{
                                    guard let windowScene = (scene as? UIWindowScene) else { return }
                                    let window: UIWindow = UIWindow(frame: windowScene.coordinateSpace.bounds)
                                    window.windowScene = windowScene //Make sure to do this
                                    window.rootViewController = nav
                                    window.makeKeyAndVisible()
                                    self.window = window
                                }
                            } else {
                                self.window?.rootViewController = nav
                                self.window?.makeKeyAndVisible()
                            }
                        }
                        
                    }
                }
            }
        }
        completionHandler()
    }
    
    func convertStringToDictionary(json: String) -> [String: AnyObject]? {
        if let data = json.data(using: String.Encoding.utf8) {
            let json = try? JSONSerialization.jsonObject(with: data, options:.mutableContainers) as? [String: AnyObject]
            
            return json!
        }
        return nil
    }
    
}
