//
//  ListViewController.swift
//  ManagementApp
//
//  Created by 畑中 彩里 on 2020/05/25.
//  Copyright © 2020 sari.hatanaka. All rights reserved.
//

import UIKit
import RealmSwift
import XLPagerTabStrip

class ListViewController: UIViewController, IndicatorInfoProvider, UITableViewDelegate, UITableViewDataSource {
    
    //MARK: - Outlet
    
    @IBOutlet private weak var ListTableView: UITableView! {
        didSet {
            self.ListTableView.delegate = self
            self.ListTableView.dataSource = self
            self.ListTableView.register(UINib(nibName: "ConsumeTableViewCell", bundle: nil), forCellReuseIdentifier: "ConsumeCell")
        }
    }
    @IBOutlet private weak var searchBar: UISearchBar! {
        didSet {
            self.searchBar.delegate = self
        }
    }
    
    let realm = try! Realm()
//    var category: Category?
    var itemArray = try? Realm().objects(Item.self)
    var searchResultItemList: [[Item]] = []
    var item: Item?
    let VC = MainViewController()
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        VC.Listitem()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
         VC.Listitem()
        self.searchResultItemList = VC.itemList
        self.ListTableView.reloadData()
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        let addViewController:ViewController = segue.destination as! ViewController
        
        if segue.identifier == "ListSegue" {
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
        self.ListTableView.setEditing(editing, animated: animated)
    }
    
    //MARK: - PrivateMethod
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "アイテム一覧")
    }
    
    //MARK: - DelegateMethod
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        // 背景色を変更する
        view.tintColor = UIColor(red: 0.733, green: 0.858, blue:0.952, alpha: 1.000)
        // UIColor(red: 0.733, green: 0.886, blue:0.945, alpha: 1.000)
        
        let header = view as! UITableViewHeaderFooterView
        // テキスト色を変更する
        header.textLabel?.textColor = UIColor(red: 0.349, green: 0.305, blue:0.321, alpha: 1.000)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.searchResultItemList.count
    }
    
    // セクションのタイトルを返す。
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.searchResultItemList[section].first?.categoryName
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.searchResultItemList[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let consumeCell = tableView.dequeueReusableCell(withIdentifier: "ConsumeCell", for: indexPath) as! ConsumeTableViewCell
        let item = self.searchResultItemList[indexPath.section][indexPath.row]
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
            consumeCell.itemCountLabel.text = "0"
        }
        consumeCell.iconImageView.image = item.itemImage
        consumeCell.alertLabel.text = ("消費予定日まであと  \(item.alertDay)   日")
        
        //文字色 UIColor(red: 0.349, green: 0.345, blue:0.341, alpha: 1.000)
        return consumeCell
    }
    
    /// セルがタップされた時
    /// - Parameter tableView: UITableView
    /// - Parameter indexPath: IndexPath
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "ListSegue",sender: self.searchResultItemList[indexPath.section][indexPath.row])
        
    }
    
    // Delete ボタンが押された時に呼ばれるメソッド
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        
        if editingStyle == .delete {
            
            let item:Item = self.searchResultItemList[indexPath.section][indexPath.row]
            let center = UNUserNotificationCenter.current()
            center.removePendingNotificationRequests(withIdentifiers: [String(item.id)])
            
            // データベースから削除する
            try! realm.write {
                let item:Item = self.searchResultItemList[indexPath.section][indexPath.row]
                let predicate = NSPredicate(format: "id = \(item.id)")
                let target = self.realm.objects(Item.self).filter(predicate)
                self.realm.delete(target)
                //itemListからのセクションを選んでおいてindexPath.rowの指定で削除
                //self.realm.delete (self.itemList[indexPath.section][indexPath.row])
                self.searchResultItemList[indexPath.section].remove(at: indexPath.row)
                tableView.reloadData()
            }
            
            // atの引数として有効でない
            //self.itemList.remove(at: [indexPath.section][indexPath.row])
            
            
        }
    }
}


//MARK: - UISearchBarDelegate

extension ListViewController: UISearchBarDelegate {
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.showsCancelButton = true
        return true
    }
    
    // キャンセルボタン
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        // キャンセルボタンを無効
        searchBar.showsCancelButton = false
        searchBar.resignFirstResponder()
    }
    //検索ボタン
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        //キーボードを閉じる。
        searchBar.endEditing(true)
        searchBar.showsCancelButton = false
    }
    
    //検索入力時
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // searchBarにtextが入力されている場合
        guard let searchBarText = self.searchBar.text, !searchBarText.isEmpty else {
            self.searchResultItemList.removeAll()
            self.searchResultItemList = VC.itemList
            self.ListTableView.reloadData()
            return
        }
        
        self.searchResultItemList.removeAll()
        for item in VC.itemList {
            let items = item.filter { $0.itemName.contains(searchBarText) }
            if !items.isEmpty {
                self.searchResultItemList.append(items)
            }
        }
        self.ListTableView.reloadData()
    }
}
