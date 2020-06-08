//
//  ViewController.swift
//  ManagementApp
//
//  Created by 畑中 彩里 on 2020/05/21.
//  Copyright © 2020 sari.hatanaka. All rights reserved.
//

// やってみることリスト
// カテゴリ初期値の保存場所の変更
// カテゴリを読み込む
// それができたら自分なりにコード整理

import UIKit
import RealmSwift

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
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
    var category: Category!
//    var ItemArray = try? Realm().objects(Item.self)
    var categoryname = try! Realm().objects(Category.self)
    var item: Item?
    var categoryPicker = UIPickerView() {
        didSet {
            self.categoryPicker.delegate = self
            self.categoryPicker.dataSource = self
            
        }
    }
    
    
    
    //MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(dismissKeyboard))
        self.view.addGestureRecognizer(tapGesture)
        
        if let items = item {
            self.itemTextField.text = items.itemName
            let itemCountStr = String(items.itemCount)
            self.itemCountTextField.text = itemCountStr
            let dayCountStr = String(items.dayCount)
            self.consumeDayTextField.text = dayCountStr
            self.iconImageView.image = items.itemImage
            
        } else {
            self.item = Item()
            let allitem = realm.objects(Item.self)
            if allitem.count != 0 {
                item!.id = allitem.max(ofProperty: "id")! + 1
            }
        }
        self.setCategoryPicker()
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
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
       
        let categories: List<CategoryList> = categoryname.first!.categories
        print(categories.count)
        return categories.count
    }
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let categories: List<CategoryList> = categoryname.first!.categories
        
        return categories[row].cayegoryTitle
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let categories: List<CategoryList> = categoryname.first!.categories
        self.categoryTextField.text = categories[row].cayegoryTitle
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
        guard let unwrapItem = self.item, let itemName = self.itemTextField.text, !itemName.isEmpty else {
            // ダイアログ
            let dialog = UIAlertController(title: "保存できません", message: "商品名を入力してください", preferredStyle: .alert)
            dialog.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(dialog, animated: true, completion: nil)
            
            return
        }
        
        do {
            try realm.write {
                unwrapItem.itemName = itemName
                if let itemCountNum = Int(itemCountTextField.text ??  "0") {
                    unwrapItem.itemCount = itemCountNum
                }
                if let dayCountNum = Int(consumeDayTextField.text ?? "0") {
                    unwrapItem.dayCount = dayCountNum
                }
                unwrapItem.itemImage = self.iconImageView.image
                self.realm.add(unwrapItem, update: .modified)
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

