//
//  ViewController.swift
//  ManagementApp
//
//  Created by 畑中 彩里 on 2020/05/21.
//  Copyright © 2020 sari.hatanaka. All rights reserved.
//

import UIKit
import RealmSwift

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var itemTextField: UITextField!
    @IBOutlet weak var itemCountTextField: UITextField!
    @IBOutlet weak var consumeDayTextField: UITextField!
    @IBOutlet weak var alertPicker: UIPickerView!
    
    
    let realm = try!Realm()
    var item: Item?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(dismissKeyboard))
        self.view.addGestureRecognizer(tapGesture)
        
        /* itemTextField.text = item.itemName
         var itemCountNum = Int(itemCountTextField.text!)
         itemCountNum! = item.itemCount
         var dayCountNum = Int(consumeDayTextField.text!)
         dayCountNum! = item.dayCount */
        
        self.alertPicker.delegate = self
        self.alertPicker.dataSource = self
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        <#code#>
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        <#code#>
    }
    
    @IBAction func iconButton(_ sender: UIButton) {
    }
    @IBAction func uploadButton(_ sender: UIButton) {
    }
    
    @IBAction func saveButton(_ sender: UIButton) {
        
        
        try! realm.write {
            self.item?.itemName = self.itemTextField.text!
            if let itemCountNum = Int(itemCountTextField.text!) {
            self.item?.itemCount = itemCountNum
            } else {
                print("入力されていません")
            }
            if let dayCountNum = Int(consumeDayTextField.text!) {
            self.item?.dayCount = dayCountNum
            } else {
                print("入力されていません")
            }
           
            if let unwrapItem = self.item{
            self.realm.add(unwrapItem, update: .modified)
        }
        }
        print("保存されました")
    }
    
    
    @IBAction func backButton(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
}

