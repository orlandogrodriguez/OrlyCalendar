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
        DispatchQueue.main.async {
            guard let day = self.day else { return }
            let date = day.date
            self.oDayLabel.text = String(Calendar.current.component(.day, from: Date(timeInterval: 60 * 60 * 24, since: date)))
            for det in day.detail {
                self.oDetailLabel.text?.append(contentsOf: det)
            }
            if day.isSelected {
                self.layer.backgroundColor = UIColor.cyan.cgColor
            } else {
                self.layer.backgroundColor = UIColor.clear.cgColor
            }
            self.oDayLabel.layer.opacity = day.isInCurrentMonth ? 1.0 : 0.25
        }
    }
}
