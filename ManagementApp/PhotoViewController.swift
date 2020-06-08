//
//  PhotoViewController.swift
//  ManagementApp
//
//  Created by 畑中 彩里 on 2020/06/08.
//  Copyright © 2020 sari.hatanaka. All rights reserved.
//

import UIKit

class PhotoViewController: UIViewController {

    @IBOutlet weak var photoImage: UIImageView!
    
    var image: UIImage? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func saveButton(_ sender: Any) {
        if let controller = self.presentingViewController as? ViewController {
            controller.iconImageView.image = photoImage.image
            controller.dismiss(animated: true, completion: nil)
            
        }
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
