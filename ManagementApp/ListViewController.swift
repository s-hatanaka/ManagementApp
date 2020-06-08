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
    
    @IBOutlet weak var ListTableView: UITableView!
    
    let realm = try! Realm()
    var ItemArray = try? Realm().objects(Item.self)
    var categoryArray = try? Realm().objects(Category.self)
    var item: Item?
    
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.ListTableView.delegate = self
        self.ListTableView.dataSource = self
        
        
        // Do any additional setup after loading the view.
    }
    
    
    
    //MARK: - PrivateFunk
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "一覧")
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let listCell = tableView.dequeueReusableCell(withIdentifier: "ListCell", for: indexPath)
        return listCell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       guard let items = self.item else {
           print("アイテムがありません")
           return 0
       }
       
       return items.categoryName.count
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
