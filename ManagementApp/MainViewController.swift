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
    
    var itemArray = try? Realm().objects(Item.self)
    var item: Item?
    var itemList: [[Item]] = [[]]
    var searchResultItemList: [[Item]] = []
    let realm = try! Realm()
    
    //MARK: - LifeCycle
    
    override func viewDidLoad() {
        setButtonBar()
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = editButtonItem
        navigationItem.leftBarButtonItem?.title = "編集"
        
        Listitem()
        self.searchResultItemList = self.itemList
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        //編集ボタンが押された画面のIndexを取得
        super.viewControllers[super.currentIndex].setEditing(editing, animated: animated)
    }
    
    //MARK: - PrivateMethod
    
    /// ListViewの配列
    func Listitem() {
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
    }
    
    /// タブのカスタム
    private func setButtonBar() {
        settings.style.buttonBarItemFont = UIFont.systemFont(ofSize: 14)
        settings.style.buttonBarItemLeftRightMargin = 8
        settings.style.buttonBarItemsShouldFillAvailableWidth =  true
        settings.style.selectedBarHeight = 2.0
        settings.style.buttonBarMinimumLineSpacing = 0
        settings.style.buttonBarLeftContentInset = 0
        settings.style.buttonBarRightContentInset = 0
        //バーの色
        settings.style.buttonBarBackgroundColor = UIColor.white
        //ボタンの色
        settings.style.buttonBarItemBackgroundColor = UIColor.white
        //        クリーム    UIColor(red: 1.000, green: 0.972, blue:0.862, alpha: 1.000)
        //セルの文字色
        settings.style.buttonBarItemTitleColor = UIColor(red: 0.286, green: 0.215, blue:0.349, alpha: 1.000)
        //セレクトバーの色
        settings.style.selectedBarBackgroundColor = UIColor(red: 0.882, green: 0.596, blue:0.705, alpha: 1.000)
        //ぴんく    UIColor(red: 0.882, green: 0.596, blue:0.705, alpha: 1.000)
        
    }
    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        let consumeVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Consume")
        let listVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "List")
        let childViewControllers: [UIViewController] = [consumeVC,listVC]
        return childViewControllers
    }
}

