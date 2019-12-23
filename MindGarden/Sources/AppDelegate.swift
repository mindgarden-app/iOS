//
//  AppDelegate.swift
//  MindGarden
//
//  Created by Sunghee Lee on 30/06/2019.
//  Copyright © 2019 Sunghee Lee. All rights reserved.
//

import UIKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func checkUpdate() -> Bool {
        guard
            let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String,
            let url = URL(string: "http://itunes.apple.com/lookup?bundleId=\(AppConstants.BundleId)"),
            let data = try? Data(contentsOf: url),
            let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any],
            let results = json["results"] as? [[String: Any]],
            results.count > 0,
            let appStoreVersion = results[0]["version"] as? String
            else { return false }
        if !(version >= appStoreVersion) { return true }
        else{ return false }
    }
    
    func openAppStore() {
        if let url = URL(string: "itms-apps://itunes.apple.com/app/apple-store/id\(AppConstants.AppId)?mt=8"),
            UIApplication.shared.canOpenURL(url){
            UIApplication.shared.open(url, options: [:]) { (opened) in
                if(opened){
                    print("App Store Opened")
                }
            }
        } else {
            print("Can't Open URL on Simulator")
        }
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // 앱 강제 업데이트
        if(checkUpdate()) {
            let alertController = UIAlertController.init(title: "안내", message: "필수 업데이트가 있습니다. \n업데이트하시겠습니까?", preferredStyle: UIAlertController.Style.alert)
            alertController.addAction(UIAlertAction.init(title: "업데이트", style: UIAlertAction.Style.default, handler: { (action) in
                self.openAppStore()
            }))
            
            let alertWindow = UIWindow(frame: UIScreen.main.bounds)
            alertWindow.rootViewController = UIViewController()
            alertWindow.windowLevel = UIWindow.Level.alert + 1;
            alertWindow.makeKeyAndVisible()
            alertWindow.rootViewController?.present(alertController, animated: true, completion: nil)
        }
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge], completionHandler: { didAllow, error in })
        application.applicationIconBadgeNumber = 0

        self.window = UIWindow(frame: UIScreen.main.bounds)
        if (UserDefaults.standard.string(forKey: "token") == nil ||
            UserDefaults.standard.string(forKey: "refreshtoken") == nil) ||
            UserDefaults.standard.string(forKey: "token")!.isEmpty &&
            UserDefaults.standard.string(forKey: "refreshtoken")!.isEmpty {
            let storyboard = UIStoryboard(name: "Auth", bundle: nil)
            let viewController = storyboard.instantiateViewController(withIdentifier: "LoginVC")
            let navigationController = UINavigationController(rootViewController: viewController)
            self.window?.rootViewController = navigationController
            self.window?.makeKeyAndVisible()
        } else {
            if UserDefaults.standard.bool(forKey: "암호 설정") {
                let dvc = UIStoryboard(name: "Lock", bundle: nil).instantiateViewController(withIdentifier: "LockVC") as! LockVC
                
                dvc.mode = LockMode.validate
                
                let navigationController = UINavigationController(rootViewController: dvc)
                self.window?.rootViewController = navigationController
                self.window?.makeKeyAndVisible()
            } else {
                let dvc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainVC")
                let navigationController = UINavigationController(rootViewController: dvc)
                self.window?.rootViewController = navigationController
                self.window?.makeKeyAndVisible()
            }
        }
    
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

