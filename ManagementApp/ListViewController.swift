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
    //  let categoryArray = ["キッチン用品", "バス用品", "トイレ用品", "洗面用品", "美容・健康用品", "洗濯用品", "掃除用品", "その他"]
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
    
    @IBOutlet private weak var ListTableView: UITableView! {
        didSet {
            self.ListTableView.delegate = self
            self.ListTableView.dataSource = self
        }
    }
    
    private var searchBar: UISearchBar!
    
    let realm = try! Realm()
    var category: Category?
    var itemArray = try? Realm().objects(Item.self)
    private var itemList: [[Item]] = [[]]
    var item: Item?
    
    
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.ListTableView.register(UINib(nibName: "ConsumeTableViewCell", bundle: nil), forCellReuseIdentifier: "ConsumeCell")
        
        
    }
    
    /// 画面が表示される直前に更新
    /// - Parameter animated: Bool
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        var items: Array<Item> = []
        guard let unwrapItemArray = self.itemArray else { return }
        for item in unwrapItemArray {
            self.itemList = [[]]
            items.append(item)
        }
        
        for category in HogeCategory.allCases {
            let items = items.filter { $0.categoryName == category.name }
            if !items.isEmpty {
                self.itemList.append(items)
            }
        }
        
        
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
    
    
    //MARK: - PrivateFunk
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "アイテム一覧")
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        // 背景色を変更する
        view.tintColor = UIColor(red: 0.733, green: 0.858, blue:0.952, alpha: 1.000)
        //            UIColor(red: 0.733, green: 0.886, blue:0.945, alpha: 1.000)
        
        let header = view as! UITableViewHeaderFooterView
        // テキスト色を変更する
        header.textLabel?.textColor = UIColor(red: 0.349, green: 0.305, blue:0.321, alpha: 1.000)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.itemList.count
    }
    
    // セクションのタイトルを返す。
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.itemList[section].first?.categoryName
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.itemList[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let consumeCell = tableView.dequeueReusableCell(withIdentifier: "ConsumeCell", for: indexPath) as! ConsumeTableViewCell
        let item = self.itemList[indexPath.section][indexPath.row]
        consumeCell.itemCellLabel.text = item.itemName
        consumeCell.itemCountLabel.text = String(item.itemCount)
        consumeCell.iconImageView.image = item.itemImage
        consumeCell.alertLabel.text = ("消費期限まであと  \(item.alertDay)   日")
        //        consumeCell.alertLabel.isHidden = true
        
        //       文字色 UIColor(red: 0.349, green: 0.345, blue:0.341, alpha: 1.000)
        return consumeCell
    }
    
    /// セルがタップされた時
    /// - Parameter tableView: UITableView
    /// - Parameter indexPath: IndexPath
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "ListSegue",sender: self.itemList[indexPath.section][indexPath.row])
    }
    
    // Delete ボタンが押された時に呼ばれるメソッド
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        
        if editingStyle == .delete {
            
            // データベースから削除する
            try! realm.write {
                let item:Item = self.itemList[indexPath.section][indexPath.row]
                let predicate = NSPredicate(format: "id = \(item.id)")
                let target = self.realm.objects(Item.self).filter(predicate)
                self.realm.delete(target)
                //itemListからのセクションを選んでおいてindexPath.rowの指定で削除
                //self.realm.delete (self.itemList[indexPath.section][indexPath.row])
                self.itemList[indexPath.section].remove(at: indexPath.row)
                tableView.reloadData()
            }
            
            // atの引数として有効でない
            //self.itemList.remove(at: [indexPath.section][indexPath.row])
            
            
        }
    }
}

//MARK: - UISearchBarDelegate

extension ListViewController: UISearchBarDelegate {
    
    
}

