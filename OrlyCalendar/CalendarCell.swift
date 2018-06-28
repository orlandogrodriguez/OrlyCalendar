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
        guard let day = day else { return }
        oDayLabel.text = day.value
        for det in day.detail {
            oDetailLabel.text?.append(contentsOf: det)
        }
        if day.isSelected {
            self.layer.backgroundColor = UIColor.cyan.cgColor
        } else {
            self.layer.backgroundColor = UIColor.clear.cgColor
        }
    }
}
