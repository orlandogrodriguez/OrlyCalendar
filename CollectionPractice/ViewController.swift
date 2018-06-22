//
//  ViewController.swift
//  CollectionPractice
//
//  Created by Orlando G. Rodriguez on 6/8/18.
//  Copyright © 2018 WorlySoftware. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let countriesVisited = ["🇨🇺", "🇧🇪", "🇵🇹", "🇳🇱", "🇪🇨"]
    
    var calendarGridArray = [[String]]()

    @IBOutlet weak var oCountryCollection: UICollectionView!
    @IBOutlet weak var oCalendarCollection: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        oCountryCollection.register(UINib(nibName: "CVCell", bundle: nil), forCellWithReuseIdentifier: "CVCell")
        
        oCalendarCollection.register(UINib(nibName: "CalendarCell", bundle: nil), forCellWithReuseIdentifier: "CalendarCell")
        
        oCountryCollection.dataSource = self
        oCountryCollection.delegate = self
        oCalendarCollection.dataSource = self
        oCalendarCollection.delegate = self
        
        populateMonthArrays(year: 2018)
        
    }
    
    func populateMonthArrays(year: Int) {
        var date = createNewYearsDayFor(year: year)
        let daysInFeb = isLeapYear(year: year) ? 29 : 28
        let daysInMonth = [31, daysInFeb, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
        
        var tempMonthArray = [String]()
        
        for i in 0 ..< 12 {
            var curDay = 1
            for j in 0 ..< 42 {
                print("\(Calendar.current.component(.weekday, from: date))")
                if j < Calendar.current.component(.weekday, from: date) || curDay > daysInMonth[i] {
                    tempMonthArray.append("-")
                } else {
                    tempMonthArray.append(String(curDay))
                    date = addOneDay(date: date)
                    curDay += 1
                }
            }
            calendarGridArray.append(tempMonthArray)
            tempMonthArray = []
        }
        print(calendarGridArray)
    }
    
    func isLeapYear(year: Int) -> Bool {
        if year % 4 == 0 {
            if year % 100 == 0 {
                if year % 400 == 0 {
                    return true
                } else {
                    return false
                }
            } else {
                return true
            }
        } else {
            return false
        }
    }
    
    func createNewYearsDayFor(year: Int) -> Date {
        var timeIntervalInt = 0
        
        for i in 1970 ..< year {
            if isLeapYear(year: i) {
                timeIntervalInt += 60 * 60 * 24 * 366
            } else {
                timeIntervalInt += 60 * 60 * 24 * 365
            }
        }
        
        var timeInterval = TimeInterval(timeIntervalInt)
        return Date(timeIntervalSince1970: timeInterval)
    }
    
    func addOneDay(date: Date) -> Date {
        return Date(timeInterval: 60 * 60 * 24, since: date)
    }
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == self.oCountryCollection {
            return countriesVisited.count
        }
        
        if collectionView == self.oCalendarCollection {
            print("Calendar grid array count: \(calendarGridArray.count)")
            var totalCount: Int = 0
            for var i in 0 ..< calendarGridArray.count {
                totalCount += calendarGridArray[i].count
            }
            
            return totalCount
        }
    
        print("something whent wrong")
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == self.oCountryCollection {
            let cell = oCountryCollection.dequeueReusableCell(withReuseIdentifier: "CVCell", for: indexPath) as! CVCell
            cell.setFlag(flag: countriesVisited[indexPath.item])
            return cell
        }
        
        if collectionView == self.oCalendarCollection {
            let cell = oCalendarCollection.dequeueReusableCell(withReuseIdentifier: "CalendarCell", for: indexPath) as! CalendarCell
            cell.setDay(day: String(calendarGridArray[indexPath.item / 42][indexPath.item % 42]))
            //cell.setCountries(countries: "-")
            return cell
        }
        
        return UICollectionViewCell()
    }
}


