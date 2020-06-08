//
//  AppDelegate.swift
//  ManagementApp
//
//  Created by 畑中 彩里 on 2020/05/21.
//  Copyright © 2020 sari.hatanaka. All rights reserved.
//

import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    let realm = try! Realm()
    
    internal func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
      
        // Override point for customization after application launch.
      
        print(Realm.Configuration.defaultConfiguration.fileURL!)
        let categoryArray = ["キッチン用品", "バス用品", "トイレ用品", "洗剤", "その他"]
        
        let category = Category()
        for categoryStr in categoryArray {
            let categoryList = CategoryList()
            categoryList.cayegoryTitle = categoryStr
            category.categories.append(categoryList)
           
        }
        //            let dictionary: [String: Any] =
        //                ["category": "カテゴリー",
        //                 "categories": [["categoryTitle": "キッチン用品"],
        //                                  ["categoryTitle": "バス用品"],
        //                                  ["categoryTitle": "トイレ用品"],
        //                                  ["categoryTitle": "洗剤"],
        //                                  ["categoryTitle": "その他"]]
        //            ]
        //
        //            let category = Category(value: dictionary)
        //
        do {
            try realm.write {
                self.realm.add(category)
                print(category)
            }
        } catch let error {
            print(error)
        }
        
        return true
    }
    
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    
    
}
