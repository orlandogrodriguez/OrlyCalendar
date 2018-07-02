//
//  ViewController.swift
//  CollectionPractice
//
//  Created by Orlando G. Rodriguez on 6/8/18.
//  Copyright © 2018 WorlySoftware. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    // let calendar = OrlyCalendar(year: 2018)
    let calendar = ORCalendar(year: 2018)

    @IBOutlet weak var oCalendarCollection: UICollectionView!
    @IBOutlet weak var oMonthLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        oCalendarCollection.register(UINib(nibName: "CalendarCell", bundle: nil), forCellWithReuseIdentifier: "CalendarCell")
        oCalendarCollection.dataSource = self
        oCalendarCollection.delegate = self
        
        addGestureRecognizers()
        
    }
    
    private func addGestureRecognizers() {
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(ViewController.swipeLeft))
        swipeLeft.direction = .left
        view.addGestureRecognizer(swipeLeft)
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(ViewController.swipeRight))
        swipeRight.direction = .right
        view.addGestureRecognizer(swipeRight)
    }
    
    @objc func swipeLeft() {
        self.calendar.goToNextMonth()
        print("Swiped left.")
        updateViewFromModel()
    }
    
    @objc func swipeRight() {
        self.calendar.goToPreviousMonth()
        print("Swiped right")
        updateViewFromModel()
    }
    
    func updateViewFromModel() {
        UIView.animate(withDuration: 0.1, animations: {
            self.oCalendarCollection.layer.opacity = 0.0
            self.oMonthLabel.layer.opacity = 0.0
        }) { (finished) in
            self.oCalendarCollection.reloadData()
            self.oMonthLabel.text = self.calendar.getMonthInViewAsString()
            UIView.animate(withDuration: 0.1, animations: {
                self.oCalendarCollection.layer.opacity = 1.0
                self.oMonthLabel.layer.opacity = 1.0
            })
        }
    }
    
    
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 42
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = oCalendarCollection.dequeueReusableCell(withReuseIdentifier: "CalendarCell", for: indexPath) as! CalendarCell
        var monthArray = calendar.getDaysArrayForMonth(month: calendar.monthInView)
        cell.setDay(value: monthArray[indexPath.item])
        return cell
    }
    
}


