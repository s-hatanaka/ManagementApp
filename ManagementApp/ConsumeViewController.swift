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
    
    private enum HogeCategory: Int, CaseIterable {
          case kitchen
          case bath
          case toilet
          case washbasin
          case beauty
          case washing
          case cleanUp
          case other
          
          var name: String {
              switch self {
              case .kitchen: return "キッチン用品"
              case .bath: return "バス用品"
              case .toilet: return "トイレ用品"
              case .washbasin: return "洗面用品"
              case .beauty: return "美容・健康用品"
              case .washing: return "洗濯用品"
              case .cleanUp: return "掃除用品"
              case .other: return "その他"
              }
          }
      }
    //MARK: - Outlet
    
    @IBOutlet private weak var tableView: UITableView! {
        didSet {
            self.tableView.delegate = self
            self.tableView.dataSource = self
            self.tableView.register(UINib(nibName: "ConsumeTableViewCell", bundle: nil), forCellReuseIdentifier: "ConsumeCell")
        }
    }
    
    let realm = try! Realm()
    var itemArray = try! Realm().objects(Item.self)
    var item: Item?
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
    
    // MARK: - DelegateMethod
    
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
        if item.itemCount > 0 {
            let cal = Calendar(identifier: .gregorian)
            // 現在日時を dt に代入
            let dt1 = Date(timeIntervalSinceNow: 60 * 60 * 9)
            let dt2 = item.saveDay
            let a = cal.dateComponents([.day], from: dt2, to: dt1 )
            let b = (a.day ?? 0) / item.dayCount
            let c = item.itemCount - b
            let itemCountNum =  String( c )
            consumeCell.itemCountLabel.text = itemCountNum
        } else {
            consumeCell.itemCellLabel.text  = "0"
        }
        consumeCell.iconImageView.image = item.itemImage
        consumeCell.alertLabel.text = ("消費予定日まであと  \(item.alertDay)   日")
        
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

