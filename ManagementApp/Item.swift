//
//  Item.swift
//  ManagementApp
//
//  Created by 畑中 彩里 on 2020/05/26.
//  Copyright © 2020 sari.hatanaka. All rights reserved.
//

import RealmSwift

class Item: Object {
    
    @objc dynamic var id = 0
    // アイテム名
    @objc dynamic var itemName = ""
    // アイテムの個数
    @objc dynamic var itemCount: Int = 0
    // 消費期間
    @objc dynamic var dayCount: Int = 0
    // 通知日
    @objc dynamic var alertDay = Date()

    override static func primaryKey() -> String? {
        return "id"
    }
}
