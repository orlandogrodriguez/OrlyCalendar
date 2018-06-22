//
//  CalendarCell.swift
//  CollectionPractice
//
//  Created by Orlando G. Rodriguez on 6/11/18.
//  Copyright © 2018 WorlySoftware. All rights reserved.
//

import Foundation
import UIKit

class CalendarCell: UICollectionViewCell {
    
    @IBOutlet weak var oDayLabel: UILabel!
//    @IBOutlet weak var oCountriesVisitedLabel: UILabel!
    
    func setDay(day: String) {
        oDayLabel.text = day
    }
    
//    func setCountries(countries: String) {
//        oCountriesVisitedLabel.text = countries
//    }
}
