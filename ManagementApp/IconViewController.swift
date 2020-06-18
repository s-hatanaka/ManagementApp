//
//  IconViewController.swift
//  ManagementApp
//
//  Created by 畑中 彩里 on 2020/05/29.
//  Copyright © 2020 sari.hatanaka. All rights reserved.
//

import UIKit

class IconViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    @IBOutlet weak var iconCollectionView: UICollectionView!
    
    
    private let icons = ["リンスー", "シャンプー", "ハンドソープ", "石鹸", "歯ブラシ", "歯磨き粉", "シェイバー", "柔軟剤", "食器用洗剤", "スポンジ", "除菌スプレー", "トイレットペーパー", "ボックスティッシュ","マスク", "コロコロ", "ゴミ袋", "芳香剤"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.iconCollectionView.delegate = self
        self.iconCollectionView.dataSource = self
        
        
        let Layout = UICollectionViewFlowLayout()
        Layout.itemSize = CGSize(width: 100, height: 100)
        iconCollectionView.collectionViewLayout = Layout
        
        
        // Do any additional setup after loading the view.
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.icons.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "IconCell", for: indexPath) as! IconCell
        let iconImage = UIImage(named: self.icons[indexPath.row])
        cell.iconCellImage.image = iconImage
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let iconCell = collectionView.cellForItem(at: indexPath) as! IconCell
        if iconCell.iconCellImage != nil {
            // let setIcon = Item.create()
            // setIcon.itemImage = UIImage(named: self.icons[indexPath.row])
            // setIcon.save()
            if let controller = self.presentingViewController as? ViewController {
                let iconImage = UIImage(named: self.icons[indexPath.row])
                controller.iconImageView.image = iconImage
                controller.dismiss(animated: true, completion: nil)
                
            }
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    
    /// カメラボタン
    /// - Parameter sender: UIButton
    @IBAction func cameraButton(_ sender: UIButton) {
        let sourceType:UIImagePickerController.SourceType = UIImagePickerController.SourceType.camera
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
            let pickerController = UIImagePickerController()
            pickerController.sourceType = sourceType
            pickerController.delegate = self
            present(pickerController, animated: true, completion: nil)
        }
    }
    
 
    
    @IBAction func Album(_ sender: UIButton) {
        let sourceType:UIImagePickerController.SourceType = UIImagePickerController.SourceType.photoLibrary
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary) {
            let pickerController = UIImagePickerController()
            pickerController.sourceType = sourceType
            pickerController.delegate = self
            present(pickerController, animated: true, completion: nil)
            
        }
    }
    
    /// アルバム画像
    /// - Parameter picker: UIImagePickerController
    /// - Parameter info: UIImagePickerController.InfoKey : Any
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            
            if let controller = self.presentingViewController as? ViewController {
                controller.iconImageView.image = image
                controller.dismiss(animated: true, completion: nil)
            }
     
        }
    }
    
}
