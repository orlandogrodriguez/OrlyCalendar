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
    
    private var year: Int
    
    init(year: Int) {
        self.year = year
    }
    
    private enum Month: String {
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
        
        func month() -> String {
            return self.rawValue
        }
    }
    
}
