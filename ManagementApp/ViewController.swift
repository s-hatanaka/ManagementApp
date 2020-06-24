//
//  ViewController.swift
//  ManagementApp
//
//  Created by 畑中 彩里 on 2020/05/21.
//  Copyright © 2020 sari.hatanaka. All rights reserved.
//

import UIKit
import RealmSwift
import UserNotifications

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UNUserNotificationCenterDelegate {
    
    //MARK: - Outlet
    
    @IBAction func imageTap(_ sender: UITapGestureRecognizer) {
        self.performSegue(withIdentifier: "IconviewController", sender: nil)
    }
    @IBOutlet weak var itemTextField: UITextField!
    @IBOutlet weak var itemCountTextField: UITextField!
    @IBOutlet weak var consumeDayTextField: UITextField!
    @IBOutlet weak var categoryTextField: UITextField!
    @IBOutlet weak var iconImageView: UIImageView!
    
    
    let realm = try! Realm()
    var fistItem = try! Realm().objects(Item.self).first
    var category: Category?
    var categoryString = try! Realm().objects(Category.self)
    var item: Item?
    var categoryPicker = UIPickerView()
    
    
    
    //MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(dismissKeyboard))
        self.view.addGestureRecognizer(tapGesture)
        
        if let items = item {
            self.itemTextField.text = items.itemName
            let cal = Calendar(identifier: .gregorian)
            // 現在日時を dt に代入
            let dt1 = Date()
            let dt2 = items.saveDay
            let a = cal.dateComponents([.day], from: dt2, to: dt1 )
            print("差は \(a.day!) 日")
            if let a = a.day {
                let b = a / items.dayCount
                let c = items.itemCount - b
                let itemCountNum = String( c )
                self.itemCountTextField.text = itemCountNum
                let dayCountStr = String(items.dayCount)
                self.consumeDayTextField.text = dayCountStr
            } else {
                self.consumeDayTextField.text = "0"
            }
            self.iconImageView.image = items.itemImage
            self.categoryTextField.text = items.categoryName
            
        } else {
            self.item = Item()
            guard let items = item else { return }
            let allitem = realm.objects(Item.self)
            if allitem.count != 0 {
                items.id = allitem.max(ofProperty: "id")! + 1
            }
        }
        
        self.setCategoryPicker()
        self.categoryPicker.delegate = self
        self.categoryPicker.dataSource = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        let itemArray = try! Realm().objects(Item.self)
        for i in 0..<itemArray.count {
            
            let cal = Calendar(identifier: .japanese)
            // 現在日時を dt に代入
            let dt1 = Date(timeIntervalSinceNow: 60 * 60 * 9)
            var compornents = DateComponents()
            compornents.day = itemArray[i].dayCount
            // ○日後を求める（60秒 × 60分 × 24時間 × dayCount）
            let dt2 = dt1.addingTimeInterval(TimeInterval(60 * 60 * 24 * (compornents.day ?? 0)))
            let dayArithmetic = cal.dateComponents([.day], from: dt1, to: dt2)
            
            try! realm.write {
                if let dayArithmetic = dayArithmetic.day {
                    itemArray[i].alertDay = dayArithmetic * itemArray[i].itemCount
                    
                }
            }
        }
    }
    //MARK: - PrivateMethod
    
    private func setCategoryPicker() {
        let toolbar = UIToolbar()
        toolbar.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 44)
        let doneItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(ViewController.done))
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let cancelItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(ViewController.cancel))
        toolbar.setItems([cancelItem, space, doneItem], animated: true)
        self.categoryTextField.inputView = categoryPicker
        self.categoryTextField.inputAccessoryView = toolbar
    }
    
    // ローカル通知の表示内容
    private func setNotification(item: Item) {
        let content = UNMutableNotificationContent()
        guard let item = self.item else { return }
        content.title = ("消費予定日 \(item.alertDay) 日前です！")
        content.body = ("\(item.itemName) の在庫はありますか？" )
        content.sound = UNNotificationSound.default
        
        //通知する日付を設定
        let dt1 = item.saveDay
        var compornents = DateComponents()
        compornents.day = item.dayCount - 1
        
        // ○日後を求める（60秒 × 60分 × 24時間 × dayCount）
        if let comporentDay = compornents.day  {
            let dt2 = dt1.addingTimeInterval(TimeInterval(60 * 60 * 24 * comporentDay ))
            if item.itemCount <= 1 {
                let component = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: dt2 )
                let trigger = UNCalendarNotificationTrigger.init(dateMatching: component, repeats: false)
                //                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5.0, repeats: false)
                let request = UNNotificationRequest(identifier: String(item.id), content: content, trigger: trigger)
                UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
            }
        }
    }
    
    //MARK: - DelegateMethod
    
    /// pickerの列
    /// - Parameter pickerView: pickerView
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    /// pickerの行
    /// - Parameter pickerView: pickerView
    /// - Parameter component: categories.count
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        let categories: List<CategoryList> = categoryString.first!.categories
        return categories.count
    }
    
    /// pickerの内容
    /// - Parameter pickerView: pickerView
    /// - Parameter row: categories
    /// - Parameter component: categoryTitle
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let categories: List<CategoryList> = categoryString.first!.categories
        return categories[row].categoryTitle
    }
    
    
    /// カテゴリ選択時
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let categories: List<CategoryList> = categoryString.first!.categories
        self.categoryTextField.text = categories[row].categoryTitle
    }
    
    @objc func cancel() {
        self.categoryTextField.text = ""
        self.categoryTextField.endEditing(true)
    }
    
    @objc func done() {
        self.categoryTextField.endEditing(true)
    }
    
    
    //MARK: - Action
    
    @IBAction func saveButton(_ sender: UIButton) {
        guard let items = self.item, let itemName = self.itemTextField.text, !itemName.isEmpty,
            let categoryName = self.categoryTextField.text, !categoryName.isEmpty else {
                // ダイアログ
                let dialog = UIAlertController(title: "保存できません", message: "商品名orカテゴリーを入力してください", preferredStyle: .alert)
                dialog.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(dialog, animated: true, completion: nil)
                
                return
        }
        do {
            try realm.write {
                items.itemName = itemName
                if let itemCountNum = Int(itemCountTextField.text ??  "0") {
                    items.itemCount = itemCountNum
                }
                if let dayCountNum = Int(consumeDayTextField.text ?? "0") {
                    items.dayCount = dayCountNum
                }
                items.itemImage = self.iconImageView.image
                items.categoryName = categoryName
                let today = Date(timeIntervalSinceNow: 60 * 60 * 9)
                items.saveDay = today
                print(items.saveDay)
                self.realm.add(items, update: .modified)
                //通知セット
                setNotification(item: items)
            }
        } catch let error {
            let dialog = UIAlertController(title: "保存できません", message: "商品名を入力してください", preferredStyle: .alert)
            dialog.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(dialog, animated: true, completion: nil)
            // ダイアログ表示
            print(error)
        }
        self.dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func backButton(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

