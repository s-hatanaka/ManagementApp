//
//  MainViewController.swift
//  ManagementApp
//
//  Created by 畑中 彩里 on 2020/05/25.
//  Copyright © 2020 sari.hatanaka. All rights reserved.
//

import UIKit
import RealmSwift
import XLPagerTabStrip

class MainViewController: ButtonBarPagerTabStripViewController {
    
    var ItemArray = try? Realm().objects(Item.self)
    var item: Item?
    let realm = try! Realm()
    
    //MARK: - LifeCycle

    
    override func viewDidLoad() {
        
        setButtonBar()
        // Do any additional setup after loading the view.
        super.viewDidLoad()
      navigationItem.leftBarButtonItem = editButtonItem
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
           super.setEditing(editing, animated: animated)
           for viewController in viewControllers {
               viewController.setEditing(editing, animated: animated)
           }
       }
    /// タブのカスタム
    private func setButtonBar() {
        
        settings.style.buttonBarMinimumLineSpacing = 1
        //バーの色
        settings.style.buttonBarBackgroundColor = UIColor.white
        //ボタンの色
        settings.style.buttonBarItemBackgroundColor = UIColor.white
//        クリーム    UIColor(red: 1.000, green: 0.972, blue:0.862, alpha: 1.000)
        //セルの文字色
        settings.style.buttonBarItemTitleColor = UIColor(red: 0.286, green: 0.215, blue:0.349, alpha: 1.000)
        //セレクトバーの色
        settings.style.selectedBarBackgroundColor = UIColor(red: 0.882, green: 0.596, blue:0.705, alpha: 1.000)
//        ぴんく    UIColor(red: 0.882, green: 0.596, blue:0.705, alpha: 1.000)
        
    }
    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        let consumeVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Consume")
        let listVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "List")
        let childViewControllers: [UIViewController] = [consumeVC,listVC]
        return childViewControllers
    }
    
    
    
   
    
    /* @IBAction func addButton(_ sender: UIBarButtonItem) {
     let storyboard: UIStoryboard = UIStoryboard(name: "AddViewController", bundle: nil)
     let navigationController = storyboard.instantiateViewController(withIdentifier: "navigation") as! UINavigationController
     self.present(navigationController, animated: true, completion: nil)
     }*/
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
