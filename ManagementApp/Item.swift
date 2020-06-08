//
//  Item.swift
//  ManagementApp
//
//  Created by 畑中 彩里 on 2020/05/26.
//  Copyright © 2020 sari.hatanaka. All rights reserved.
//

import RealmSwift

class Category: Object {
    var categories: List<CategoryList>  = List<CategoryList>()
}

class CategoryList: Object {
    @objc dynamic var cayegoryTitle: String = ""
}

class Item: Object {
    
    static let realm = try! Realm()
    
    @objc dynamic var id = 0
    // アイテム名
    @objc dynamic var itemName: String = ""
    // アイテムの個数
    @objc dynamic var itemCount: Int = 0
//    RealmOptional<Int>()
    // 消費期間
    @objc dynamic var dayCount: Int = 0
    // 通知日
    @objc dynamic var alertDay: Date = Date()

    @objc dynamic var categoryName:String = ""
    
    @objc dynamic private var _itemImage: UIImage? = nil
    
    @objc dynamic var itemImage: UIImage? {
        set{
            self._itemImage = newValue
            if let value = newValue {
                self.itemImageData = value.jpegData(compressionQuality: 1)
            }
        }
        get{
            if let image = self._itemImage{
                return image
            }
            
            if let data = self.itemImageData {
                self._itemImage = UIImage(data: data)
                return self._itemImage
            }
            return nil
        }
    }
    @objc  dynamic private var itemImageData: Data? = nil
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    override static func ignoredProperties() -> [String] {
        return ["itenImage", "_itemImage"]
    }
    
    static func create() -> Item {
        let item = Item()
        item.id = lastId()
        return item
    }

    static func lastId() -> Int{
        if let imageData = realm.objects(Item.self).sorted(byKeyPath: "id", ascending: true).last{
            return imageData.id + 1
        }else{
            return 0
        }
    }

    func save() {
        try! Item.realm.write {
            Item.realm.add(self)
        }
    }
}


