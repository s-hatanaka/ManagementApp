//
//  AppDelegate.swift
//  ManagementApp
//
//  Created by 畑中 彩里 on 2020/05/21.
//  Copyright © 2020 sari.hatanaka. All rights reserved.
//

import UIKit
import RealmSwift
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    
    var window: UIWindow?
    let realm = try! Realm()
    var item: Item?
    var itemArray = try! Realm().objects(Item.self)
    internal func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
       print(Realm.Configuration.defaultConfiguration.fileURL!)
        
        // 通知許可
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.badge, .sound, .alert], completionHandler: { (granted, error) in
            if error != nil {
                return
            }
            
            if granted {
                print("通知許可")
                
                let center = UNUserNotificationCenter.current()
                center.delegate = self
                
            } else {
                print("通知拒否")
            }
        })
        
               
//      カテゴリ保存
        let categoryArray = ["キッチン用品", "バス用品", "トイレ用品", "洗面用品", "美容・健康用品", "洗濯用品", "掃除用品", "その他"]
        let launchedBefore = UserDefaults.standard.bool(forKey: "launchedBefore")
        if(launchedBefore == true) {
            print("初回起動でない")
        } else {
         UserDefaults.standard.set(true, forKey: "launchedBefore")

        let category = Category()
        for categoryString in categoryArray {
            let categoryList = CategoryList()
            categoryList.categoryTitle = categoryString
            category.categories.append(categoryList)
        }
        do {
            try realm.write {
                self.realm.add(category)
                print(category)
            }
        } catch let error {
            print(error)
        }
        }
  
    return true
    }
    
    // アプリがフォアグラウンドの時に通知を受け取ると呼ばれる
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .sound])
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

