//
//  ConsumeViewController.swift
//  ManagementApp
//
//  Created by 畑中 彩里 on 2020/05/25.
//  Copyright © 2020 sari.hatanaka. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import RealmSwift

class ConsumeViewController: UIViewController, IndicatorInfoProvider, UITableViewDelegate, UITableViewDataSource {
    
    //MARK: - Outlet
    
    @IBOutlet private weak var tableView: UITableView! {
        didSet {
            self.tableView.delegate = self
            self.tableView.dataSource = self
        }
    }
    
    //    フィルターかける
    var itemArray = try! Realm().objects(Item.self)
    var item: Item?
    let realm = try! Realm()
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        self.tableView.register(UINib(nibName: "ConsumeTableViewCell", bundle: nil), forCellReuseIdentifier: "ConsumeCell")
        
    }
    
    /// 画面が表示される直前に更新
    /// - Parameter animated: Bool
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
//        for i in 0..<itemArray.count {
//            
//            let cal = Calendar(identifier: .japanese)
//            // 現在日時を dt に代入
//            let dt1 = Date(timeIntervalSinceNow: 60 * 60 * 9)
//            var compornents = DateComponents()
//            compornents.day = itemArray[i].dayCount
//            // ○日後を求める（60秒 × 60分 × 24時間 × dayCount）
//            let dt2 = dt1.addingTimeInterval(TimeInterval(60 * 60 * 24 * (compornents.day ?? 0)))
//            let dayArithmetic = cal.dateComponents([.day], from: dt1, to: dt2)
//            
//            try! realm.write {
//                if let dayArithmetic = dayArithmetic.day {
//                    itemArray[i].alertDay = dayArithmetic * itemArray[i].itemCount
//              
//                }
//            }
//        }
        let predicate = NSPredicate(format: "alertDay <= 14")
        self.itemArray = try! Realm().objects(Item.self).filter(predicate).sorted(byKeyPath: "alertDay", ascending: true)
        tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        let addViewController:ViewController = segue.destination as! ViewController
        
        if segue.identifier == "ConsumeSegue" {
            addViewController.item = sender as? Item
        } else {
            item = Item()
            let allItem = realm.objects(Item.self)
            if allItem.count != 0 {
                guard let items = item else { return }
                items.id = allItem.max(ofProperty: "id")! + 1
                print(allItem.self.count)
            }
            addViewController.item = item
        }
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        tableView.setEditing(editing, animated: animated)
    }
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "消費直前")
    }
    
    // MARK: - PrivateFunc
    
    ///セルの数
    /// - Parameter tableView: UITableView
    /// - Parameter section: itemArray,count
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return itemArray.count
    }
    
    /// セルの内容
    /// - Parameter tableView: UITableView
    /// - Parameter indexPath: IndexPath
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let consumeCell = tableView.dequeueReusableCell(withIdentifier: "ConsumeCell", for: indexPath) as! ConsumeTableViewCell
        
        let item = self.itemArray[indexPath.row]
        consumeCell.itemCellLabel.text = item.itemName
        //        let itemCountNum = String(item.itemCount)
        
        let cal = Calendar(identifier: .gregorian)
        // 現在日時を dt に代入
        let dt1 = Date(timeIntervalSinceNow: 60 * 60 * 9)
        let dt2 = item.saveDay
        let a = cal.dateComponents([.day], from: dt2, to: dt1 )
        
        let b = (a.day ?? 0) / item.dayCount
        let c = item.itemCount - b
        let itemCountNum =  String( c )
       
        consumeCell.itemCountLabel.text = itemCountNum
        
        consumeCell.iconImageView.image = item.itemImage
        consumeCell.alertLabel.text = ("消費期限まであと  \(item.alertDay)   日")
        
        return consumeCell
    }
    
    /// セルがタップされた時
    /// - Parameter tableView: UITableView
    /// - Parameter indexPath: IndexPath
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "ConsumeSegue",sender: self.itemArray[indexPath.row])
    }
    
    
    // Delete ボタンが押された時に呼ばれるメソッド
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {

        
        if editingStyle == .delete {
            let item = self.itemArray[indexPath.row]
            let center = UNUserNotificationCenter.current()
                center.removePendingNotificationRequests(withIdentifiers: [String(item.id)])
            // データベースから削除する
            try! realm.write {
                self.realm.delete(self.itemArray[indexPath.row])
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        }
    }
}

