//
//  OrlyCalendar.swift
//  CollectionPractice
//
//  Created by Orlando G. Rodriguez on 6/27/18.
//  Copyright © 2018 WorlySoftware. All rights reserved.
//

import Foundation
import UIKit

class OrlyCalendar: NSObject {
    
    private(set) var currentYear: Int!
    private var calendarArray: [[String]]!
    
    init(year: Int) {
        super.init()
        self.setUpCalendarProperties(forYear: year)
    }
    
    // MARK: - Public Methdos
    func getMonthArray(month: Month) -> [String] {
        return calendarArray[month.month()]
    }
    
    enum Month: Int {
        case January
        case February
        case March
        case April
        case May
        case June
        case July
        case August
        case September
        case October
        case November
        case December
        
        func month() -> Int {
            return self.rawValue
        }
    }
    
    enum WeekDay: Int {
        case Sunday
        case Monday
        case Tuesday
        case Wednesday
        case Thursday
        case Friday
        case Saturday
        
        func weekDay() -> Int {
            return self.rawValue
        }
    }
    
    // MARK: - Private Methods
    
    private func setUpCalendarProperties(forYear year: Int) {
        currentYear = year
        calendarArray = populateMonthArrays(forYear: year)
    }
    
    private func populateMonthArrays(forYear year: Int) -> [[String]] {
        var calendarGridArray = [[String]]()
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
        return calendarGridArray
    }
    
    private func isLeapYear(year: Int) -> Bool {
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
    
    private func createNewYearsDayFor(year: Int) -> Date {
        var timeIntervalInt = 0
        
        for i in 1970 ..< year {
            if isLeapYear(year: i) {
                timeIntervalInt += 60 * 60 * 24 * 366
            } else {
                timeIntervalInt += 60 * 60 * 24 * 365
            }
        }
        
        let timeInterval = TimeInterval(timeIntervalInt)
        return Date(timeIntervalSince1970: timeInterval)
    }
    
    private func addOneDay(date: Date) -> Date {
        return Date(timeInterval: 60 * 60 * 24, since: date)
    }
    
}

class Day: NSObject {
    private let value: String       // Displays the number value of the day, (i.e. from 1 to 31 or '-')
    var detail: [String]    // Displays the countries visited during the day
    var isSelected: Bool    // becomes highlighted when selected
    var isCurrent: Bool     // becomes true if it is currently that day
    
    init(day: String) {
        value = day
        detail = []
        isSelected = false
        isCurrent = false
    }
}
