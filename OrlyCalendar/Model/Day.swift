//
//  Day.swift
//  OrlyCalendar
//
//  Created by Dito on 6/29/18.
//  Copyright © 2018 WorlySoftware. All rights reserved.
//

import Foundation

struct Day {
    var value: String               // Displays the number value of the day, (i.e. from 1 to 31 or '-')
    var detail: [String]            // Displays the countries visited during the day
    var isSelected: Bool            // becomes highlighted when selected
    var isCurrent: Bool             // becomes true if it is currently that day
    var isInCurrentMonth: Bool      // States whether the current day is part of the current month.
    var date: Date
    
    init(date: Date) {
        self.date = date
        let dateDay = Calendar.current.component(.day, from: date)
        let dateMonth = Calendar.current.component(.month, from: date)
        let dateYear = Calendar.current.component(.year, from: date)
        
        let nowDate = Date(timeIntervalSinceNow: 0)
        let nowDay = Calendar.current.component(.day, from: nowDate)
        let nowMonth = Calendar.current.component(.month, from: nowDate)
        let nowYear = Calendar.current.component(.year, from: nowDate)
        
        // Change made below: time interval back to 0
        self.value = String(Calendar.current.component(.day, from: Date(timeInterval: 0, since: date)))
        self.isCurrent = dateDay == nowDay
            && dateMonth == nowMonth
            && dateYear == nowYear
        
        self.isSelected = false
        self.detail = []
        self.isInCurrentMonth = false
    }
}
