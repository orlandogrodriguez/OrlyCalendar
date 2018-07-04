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
            
            //Changes made: time interval back to zero.
            if Calendar.current.component(.month, from: Date(timeInterval: 0, since: dayToAppend.date)) != (monthInView + 1) {
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
    
    // Go to previous month and wrap around to december if in january
    func goToPreviousMonth() {
        monthInView = monthInView == 0 ? 11 : monthInView - 1
    }
    
    // Go to next month and wrap around to january if in december.
    func goToNextMonth() {
        monthInView = monthInView == 11 ? 0 : monthInView + 1
    }
    
    // Mark: - Private Methods
    private func setUpCalendarProperties(forYear year: Int) {
        self.currentYear = year
        self.monthInView = 0 // TODO: Make user's current month
        
        // Create a pointer at New Years Day of the year
        var datePointer = createNewYearsDayFor(year: year)
        let offset = Calendar.current.component(.weekday, from: datePointer) - 1
        datePointer = Date(timeInterval: TimeInterval(-1 * 60 * 60 * 24 * offset), since: datePointer)
        assert(Calendar.current.component(.weekday, from: datePointer) == 1, "Calendar's not starting on a sunday. Fix the bug.")
        
        daysArray = []
        monthToStartingWeek = [:]
        var currentMonth = 0
        var currentWeek = 0
        for i in 0 ..< 378 {
            var newDay = Day(date: datePointer)
            if dateIsToday(date: datePointer) { newDay.isCurrent = true }
            daysArray.append(newDay)
            currentWeek = i / 7
            // Changes made below: time interval back to zero
            if Calendar.current.component(.day, from: Date(timeInterval: 0, since: datePointer)) == 1 && monthToStartingWeek.count < 12 {
                monthToStartingWeek[currentMonth] = currentWeek
//                if Calendar.current.component(.weekday, from: Date(timeInterval: 60 * 60 * 24, since: datePointer)) == 1 {
//                    monthToStartingWeek[currentMonth] = currentWeek - 1
//                }
                currentMonth += 1
            }
            datePointer = Date(timeInterval: 60 * 60 * 24, since: datePointer)
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
        let nyd: Date = {
            var date = Date(timeIntervalSince1970: timeInterval)
            if Calendar.current.component(.year, from: date) != year {
                date = Date(timeInterval: 60 * 60 * 24, since: date)
            }
            date = Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: date)!
            return date
        }()
        return nyd
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
    
    private func dateIsToday(date: Date) -> Bool {
        let today = Date()
        let todayDay = Calendar.current.component(.day, from: today)
        let todayMonth = Calendar.current.component(.month, from: today)
        let todayYear = Calendar.current.component(.year, from: today)
        let dateDay = Calendar.current.component(.day, from: date)
        let dateMonth = Calendar.current.component(.month, from: date)
        let dateYear = Calendar.current.component(.year, from: date)
        return todayDay == dateDay && todayMonth == dateMonth && todayYear == dateYear
    }
}
