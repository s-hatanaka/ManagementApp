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
    
    @IBOutlet weak var tableView: UITableView!
    
    //    フィルターかける
    var itemArray = try? Realm().objects(Item.self)
    var item: Item?
    let realm = try! Realm()
    
    //MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.tableView.register(UINib(nibName: "ConsumeTableViewCell", bundle: nil), forCellReuseIdentifier: "ConsumeCell")
      
        
        // Do any additional setup after loading the view.
    }
    
    /// 画面が表示される直前に更新
    /// - Parameter animated: Bool
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
        if let itemArray = self.itemArray {
            return itemArray.count
        } else {
            return 0
        }
    }
    
    /// セルの内容
    /// - Parameter tableView: UITableView
    /// - Parameter indexPath: IndexPath
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let consumeCell = tableView.dequeueReusableCell(withIdentifier: "ConsumeCell", for: indexPath) as! ConsumeTableViewCell
        
        if let unwrapItemArray = self.itemArray {
            let item = unwrapItemArray[indexPath.row]
            consumeCell.itemCellLabel.text = item.itemName
            let itemCountNum = String(item.itemCount)
            consumeCell.itemCountLabel.text! = itemCountNum
            consumeCell.iconImageView.image = item.itemImage
        }
        return consumeCell
    }
    
    
    /// セルがタップされた時
    /// - Parameter tableView: UITableView
    /// - Parameter indexPath: IndexPath
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let unwrapItemArray = self.itemArray else { return }
        performSegue(withIdentifier: "ConsumeSegue",sender: unwrapItemArray[indexPath.row])
    }
    
    
    // Delete ボタンが押された時に呼ばれるメソッド
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        // --- ここから ---
        if editingStyle == .delete {
            // データベースから削除する
            try! realm.write {
                guard let itemArray = self.itemArray else { return }
                self.realm.delete(itemArray[indexPath.row])
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        }
    }
}

