//
//  ViewController.swift
//  CollectionPractice
//
//  Created by Orlando G. Rodriguez on 6/8/18.
//  Copyright © 2018 WorlySoftware. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let calendar = OrlyCalendar(year: 2018)

    @IBOutlet weak var oCalendarCollection: UICollectionView!
    @IBOutlet weak var oMonthLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        oCalendarCollection.register(UINib(nibName: "CalendarCell", bundle: nil), forCellWithReuseIdentifier: "CalendarCell")
        oCalendarCollection.dataSource = self
        oCalendarCollection.delegate = self
    }
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var totalCount: Int = 0
        for i in 0 ..< 12 {
            totalCount += calendar.getMonthArray(month: OrlyCalendar.Month(rawValue: i)!).count
        }
        return totalCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = oCalendarCollection.dequeueReusableCell(withReuseIdentifier: "CalendarCell", for: indexPath) as! CalendarCell
        let month = OrlyCalendar.Month(rawValue: indexPath.item)!
        let monthArray = calendar.getMonthArray(month: month)
        
        cell.setDay(value: monthArray[indexPath.item])
        
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
    
    }
}


