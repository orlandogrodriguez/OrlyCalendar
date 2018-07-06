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
    
    var day: Day!
    
    @IBOutlet weak var oDayLabel: UILabel!
    @IBOutlet weak var oDetailLabel: UILabel!
    
    func setDay(value: Day) {
        day = value
        updateViewFromModel()
    }
    
    private func updateViewFromModel() {
        guard let day = self.day else { return }
        let date = day.date
        self.oDayLabel.text = String(Calendar.current.component(.day, from:
            Date(timeInterval: 0, since: date)))
        self.oDetailLabel.text = String(day.detail)
        if day.isSelected {
            self.layer.backgroundColor = UIColor.cyan.cgColor
        } else {
            self.layer.backgroundColor = UIColor.clear.cgColor
        }
        if day.isCurrent && day.isInCurrentMonth {
            oDayLabel.textColor = UIColor.red
        } else {
            oDayLabel.textColor = UIColor.black
        }
        self.oDayLabel.layer.opacity = day.isInCurrentMonth ? 1.0 : 0.25
        self.oDetailLabel.layer.opacity = day.isInCurrentMonth ? 1.0 : 0.25
    }
    
}
