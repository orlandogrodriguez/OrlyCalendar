//
//  ViewController.swift
//  CollectionPractice
//
//  Created by Orlando G. Rodriguez on 6/8/18.
//  Copyright © 2018 WorlySoftware. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let calendar = ORCalendar(year: 2018)

    @IBOutlet weak var oCalendarCollection: UICollectionView!
    @IBOutlet weak var oMonthLabel: UILabel!
    @IBOutlet weak var oWeekdayStackView: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        oCalendarCollection.register(UINib(nibName: "CalendarCell", bundle: nil), forCellWithReuseIdentifier: "CalendarCell")
        oCalendarCollection.dataSource = self
        oCalendarCollection.delegate = self
        
        addGestureRecognizers()
    }
    
    override func viewDidLayoutSubviews() {
        initializeUI()
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
        let swipeL = view.gestureRecognizers![view.gestureRecognizers!.count - 2]
        let swipeR = view.gestureRecognizers![view.gestureRecognizers!.count - 1]
        let cframe = oCalendarCollection.frame
        UIView.animate(withDuration: 0.1, animations: {
            self.oCalendarCollection.frame = CGRect(x: cframe.minX + 8, y: cframe.minY, width: cframe.width, height: cframe.height)
            self.oCalendarCollection.layer.opacity = 0.0
            self.oMonthLabel.layer.opacity = 0.0
        }) { (finished) in
            self.oCalendarCollection.frame = CGRect(x: cframe.minX - 8, y: cframe.minY, width: cframe.width, height: cframe.height)
            self.oCalendarCollection.reloadData()
            self.oMonthLabel.text = self.calendar.getMonthInViewAsString()
            UIView.animate(withDuration: 0.1, animations: {
                self.oCalendarCollection.frame = cframe
                self.oCalendarCollection.layer.opacity = 1.0
                self.oMonthLabel.layer.opacity = 1.0
            })
        }
    }
    
    private func initializeUI() {
        // Set up stack view's bottom border.
        let stackViewBottomBorder = CALayer()
        let stackViewBottomBorderWidth = CGFloat(1.0)
        stackViewBottomBorder.borderColor = UIColor.gray.cgColor
        stackViewBottomBorder.frame = CGRect(x: 0, y: oCalendarCollection.frame.minY, width: self.view.frame.size.width, height: stackViewBottomBorderWidth)
        stackViewBottomBorder.borderWidth = stackViewBottomBorderWidth
        self.view.layer.addSublayer(stackViewBottomBorder)
        self.view.layer.masksToBounds = true
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


