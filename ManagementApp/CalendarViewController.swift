//
//  CalendarViewController.swift
//  ManagementApp
//
//  Created by 畑中 彩里 on 2020/06/15.
//  Copyright © 2020 sari.hatanaka. All rights reserved.
//

import UIKit
import FSCalendar
import RealmSwift

class CalendarViewController: UIViewController, FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance, UITableViewDelegate, UITableViewDataSource {
    

    @IBOutlet weak var calendar: FSCalendar!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    let realm = try! Realm()
    var item: Item?
    var itemArray = Array(try! Realm().objects(Item.self))
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.calendar.dataSource = self
        self.calendar.delegate = self
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.dateLabel.backgroundColor = UIColor(red: 0.349, green: 0.305, blue:0.321, alpha: 1.000)
        self.dateLabel.textColor = UIColor.white
       
        itemArray = Array()
        
        let  formatter = DateFormatter()
        formatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "ydMMM", options: 0, locale: Locale(identifier: "ja_JP"))
        self.dateLabel.text = formatter.string(from: Date())
       
//        for i in 0..<itemArray.count {
//              // 現在日時を dt に代入
//              let dt1 = Date(timeIntervalSinceNow: 60 * 60 * 9)
//              var compornents = DateComponents()
//              compornents.day = itemArray[i].dayCount * itemArray[i].itemCount
//              // ○日後を求める（60秒 × 60分 × 24時間 × dayCount）
//              let dt2 = dt1.addingTimeInterval(TimeInterval(60 * 60 * 24 * (compornents.day ?? 0)))
//              let formatter = DateFormatter()
//              formatter.dateFormat = "yyyy年M月dd日"
//              let dt3 = "\(formatter.string(from:dt2))"
//              try! realm.write {
//                      itemArray[i].consumeDay = dt3
//              }
//          }
        
        self.week()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let itemArray = Array(try! Realm().objects(Item.self))
        for i in 0..<itemArray.count {
            // 現在日時を dt に代入
            let dt1 = Date(timeIntervalSinceNow: 60 * 60 * 9)
            var compornents = DateComponents()
            compornents.day = itemArray[i].dayCount * itemArray[i].itemCount
            // ○日後を求める（60秒 × 60分 × 24時間 × dayCount）
            let dt2 = dt1.addingTimeInterval(TimeInterval(60 * 60 * 24 * (compornents.day ?? 0)))
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy年M月dd日"
            let dt3 = "\(formatter.string(from:dt2))"
            try! realm.write {
                itemArray[i].consumeDay = dt3
            }
        }
        
        
        tableView.reloadData()
    }

    func week() {
        self.calendar.calendarWeekdayView.weekdayLabels[0].text = "日"
        self.calendar.calendarWeekdayView.weekdayLabels[1].text = "月"
        self.calendar.calendarWeekdayView.weekdayLabels[2].text = "火"
        self.calendar.calendarWeekdayView.weekdayLabels[3].text = "水"
        self.calendar.calendarWeekdayView.weekdayLabels[4].text = "木"
        self.calendar.calendarWeekdayView.weekdayLabels[5].text = "金"
        self.calendar.calendarWeekdayView.weekdayLabels[6].text = "土"
        
    }
    
//    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
//        return
//    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.itemArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let item = self.itemArray[indexPath.row]
        cell.textLabel?.text = ("\(item.itemName)の消費期限")
     

        return cell
    }

//    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
//        let realm = try! Realm()
//        var result = realm.objects(Item.self)
//       
//        result = result.filter("consumeDay = '\(self.dateLabel.text!)'")
//
//        return result.count
//    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
           let clDate = Calendar(identifier: .gregorian)
           let year = clDate.component(.year, from: date)
           let month = clDate.component(.month, from: date)
           let day = clDate.component(.day, from: date)
           let da = "\(year)年\(month)月\(day)日"
           self.dateLabel.text = da
           
//           let result = Array(try! Realm().objects(Item.self).filter("consumeDay  == %@", da))
          
        let realm = try! Realm()
        var result = realm.objects(Item.self)
        result = result.filter("consumeDay = '\(da)'")
       
        
        itemArray.removeAll()
        for i in result {
            if i.consumeDay == da {
                itemArray.append(i)
                
            }
        }
                  tableView.reloadData()

               }
 
    
}
