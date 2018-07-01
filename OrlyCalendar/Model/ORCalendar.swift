//
//  ORCalendar.swift
//  OrlyCalendar
//
//  Created by Dito on 6/29/18.
//  Copyright © 2018 WorlySoftware. All rights reserved.
//

import Foundation

class ORCalendar: NSObject {
    // MARK: - Properties
    private var currentYear: Int!
    private(set) var monthInView: Int!
    private var daysArray: [Day]!
    private var monthToStartingWeek: [Int:Int]!
    
    // MARK: - Initializers
    init(year: Int) {
        super.init()
        setUpCalendarProperties(forYear: year)
    }
    
    // Mark: - Public Methods
    func getDaysArrayForMonth(month: Int) -> [Day] {
        let startDate = monthToStartingWeek[monthInView]! * 7
        let endDate = startDate + 42
        var daysArrayForMonth: [Day] = []
        for i in startDate ..< endDate {
            var dayToAppend = daysArray[i]
            // Check if the day we're going to append is part
            // of the currently viewed month
            if Calendar.current.component(.month, from: Date(timeInterval: 60 * 60 * 24, since: dayToAppend.date)) != (monthInView + 1) {
                dayToAppend.isInCurrentMonth = false
            } else {
                dayToAppend.isInCurrentMonth = true
            }
            daysArrayForMonth.append(dayToAppend)
        }
        return daysArrayForMonth
    }
    
    func getMonthInViewAsString() -> String {
        switch monthInView {
        case 0: return "January"
        case 1: return "February"
        case 2: return "March"
        case 3: return "April"
        case 4: return "May"
        case 5: return "June"
        case 6: return "July"
        case 7: return "August"
        case 8: return "September"
        case 9: return "October"
        case 10: return "November"
        case 11: return "December"
        default: return "Month"
        }
    }
    
    func goToPreviousMonth() {
        if monthInView > 0 { monthInView = (monthInView - 1) % 12 }
    }
    
    func goToNextMonth() {
        if monthInView < 12 { monthInView = (monthInView + 1) % 12 }
    }
    
    // Mark: - Private Methods
    private func setUpCalendarProperties(forYear year: Int) {
        self.currentYear = year
        self.monthInView = 0 // TODO: Make user's current month
        
        // Create a pointer at New Years Day of the year
        var datePointer = createNewYearsDayFor(year: year)
        let offset = Calendar.current.component(.weekday, from: datePointer)
        datePointer = Date(timeInterval: TimeInterval(-1 * 60 * 60 * 24 * offset), since: datePointer)
        assert(Calendar.current.component(.weekday, from: datePointer) == 7, "Calendar's not starting on a sunday. Fix the bug.")
        
        daysArray = []
        monthToStartingWeek = [:]
        var currentMonth = 0
        var currentWeek = 0
        for i in 1 ..< 378 {
            let newDay = Day(date: datePointer)
            daysArray.append(newDay)
            currentWeek = i / 7
            if Calendar.current.component(.day, from: Date(timeInterval: 60 * 60 * 24, since: datePointer)) == 1 && monthToStartingWeek.count < 12 {
                monthToStartingWeek[currentMonth] = currentWeek
                if Calendar.current.component(.weekday, from: Date(timeInterval: 60 * 60 * 24, since: datePointer)) == 7 {
                    monthToStartingWeek[currentMonth] = currentWeek - 1
                }
                currentMonth += 1
            }
            datePointer = Date(timeInterval: 60 * 60 * 24, since: datePointer)
        }
    }
    
    private func createNewYearsDayFor(year: Int) -> Date {
        var timeIntervalInt = 0
        
        for i in 1970 ..< year {
            if isLeapYear(year: i) {
                timeIntervalInt += 60 * 60 * 24 * 366 + 1
            } else {
                timeIntervalInt += 60 * 60 * 24 * 365 + 1
            }
        }
        
        let timeInterval = TimeInterval(timeIntervalInt)
        return Date(timeIntervalSince1970: timeInterval)
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
}
