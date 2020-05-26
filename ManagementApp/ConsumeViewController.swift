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

    @IBOutlet weak var tableView: UITableView!
    
//    フィルターかける
    var ItemArray = try! Realm().objects(Item.self).sorted(byKeyPath: "alertDay", ascending: true)
    
    let realm = try! Realm()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        let nib = UINib(nibName: "ConsumeTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "ConsumeCell")

        // Do any additional setup after loading the view.
    }
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
          return IndicatorInfo(title: "消費直前")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ItemArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let consumeCell = tableView.dequeueReusableCell(withIdentifier: "ConsumeCell", for: indexPath)
        return consumeCell
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
