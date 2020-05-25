//
//  MainViewController.swift
//  ManagementApp
//
//  Created by 畑中 彩里 on 2020/05/25.
//  Copyright © 2020 sari.hatanaka. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class MainViewController: ButtonBarPagerTabStripViewController {

    override func viewDidLoad() {
        
       setButtonBar()
        // Do any additional setup after loading the view.
            super.viewDidLoad()
    
    }

    private func setButtonBar() {
           settings.style.buttonBarBackgroundColor = .clear
           settings.style.selectedBarBackgroundColor = .orange
           settings.style.buttonBarMinimumLineSpacing = 2
       }
    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        let consumeVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Consume")
        let listVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "List")
        let childViewControllers: [UIViewController] = [consumeVC,listVC]
        return childViewControllers
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
