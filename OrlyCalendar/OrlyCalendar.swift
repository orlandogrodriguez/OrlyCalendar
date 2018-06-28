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
    private var calendarArray: [[Day]]!
    var currentMonth: Month!                // The month the user is currently looking at
    
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
    
    init(year: Int) {
        super.init()
        self.setUpCalendarProperties(forYear: year)
    }
    
    // MARK: - Public Methdos
    func getMonthArray(month: Month) -> [Day] {
        return calendarArray[month.month()]
    }
    
    // MARK: - Private Methods
    private func setUpCalendarProperties(forYear year: Int) {
        currentYear = year
        calendarArray = populateMonthArrays(forYear: year)
        currentMonth = {
            let now = Date()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "LLLL"
            return OrlyCalendar.Month(rawValue: monthAsInt(month: dateFormatter.string(from: now)))
        }()
    }
    
    private func populateMonthArrays(forYear year: Int) -> [[Day]] {
        var calendarGridArray = [[Day]]()
        var date = createNewYearsDayFor(year: year)
        let daysInFeb = isLeapYear(year: year) ? 29 : 28
        let daysInMonth = [31, daysInFeb, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
        var tempMonthArray = [Day]()
        for i in 0 ..< 12 {
            var curDay = Day(day: "1")
            for j in 0 ..< 42 {
                //print("\(Calendar.current.component(.weekday, from: date))")
                if j < Calendar.current.component(.weekday, from: date) || Int(curDay.value)! > daysInMonth[i] {
                    curDay.value = "-"
                    tempMonthArray.append(curDay)
                } else {
                    tempMonthArray.append(curDay)
                    date = addOneDay(date: date)
                    curDay.value = String(Int(curDay.value)! + 1)
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
    
    private func monthAsInt(month: String) -> Int {
        switch month {
        case "January":
            return 0
        case "February":
            return 1
        case "March":
            return 2
        case "April":
            return 3
        case "May":
            return 4
        case "June":
            return 5
        case "July":
            return 6
        case "August":
            return 7
        case "September":
            return 8
        case "October":
            return 9
        case "November":
            return 10
        case "December":
            return 11
        default:
            return -1
        }
    }
}

struct Day {
    var value: String               // Displays the number value of the day, (i.e. from 1 to 31 or '-')
    var detail: [String]            // Displays the countries visited during the day
    var isSelected: Bool            // becomes highlighted when selected
    var isCurrent: Bool             // becomes true if it is currently that day
    
    init(day: String) {
        self.value = day
        self.detail = []
        self.isSelected = false
        self.isCurrent = false
    }
}
