//
//  CVCell.swift
//  CollectionPractice
//
//  Created by Orlando G. Rodriguez on 6/8/18.
//  Copyright © 2018 WorlySoftware. All rights reserved.
//

import Foundation
import UIKit

class CVCell: UICollectionViewCell {
    
    @IBOutlet weak var flagLabel: UILabel!
    
    func setFlag(flag: String) {
        flagLabel.text = flag
    }
}
