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
    @IBOutlet weak var oYearLabel: UILabel!
    @IBOutlet weak var oMonthLabel: UILabel!
    @IBOutlet weak var oWeekdayStackView: UIStackView!
    
    @IBAction func handleNextYearButtonPressed(_ sender: UIButton) {
        calendar.goToNextYear()
        updateViewFromModel(swipeDirection: .left)
    }
    @IBAction func handlePreviousYearButtonPressed(_ sender: UIButton) {
        calendar.goToPreviousYear()
        updateViewFromModel(swipeDirection: .right)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        oCalendarCollection.register(UINib(nibName: "CalendarCell", bundle: nil), forCellWithReuseIdentifier: "CalendarCell")
        oCalendarCollection.dataSource = self
        oCalendarCollection.delegate = self
        
        addGestureRecognizers()
        updateViewFromModel(swipeDirection: .none)
    }
    
    override func viewDidLayoutSubviews() {
        initializeUI()
    }
    
    // Creates gesture recognizers and cleans up viewDidLoad
    private func addGestureRecognizers() {
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(ViewController.swipeLeft))
        swipeLeft.direction = .left
        view.addGestureRecognizer(swipeLeft)
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(ViewController.swipeRight))
        swipeRight.direction = .right
        view.addGestureRecognizer(swipeRight)
    }
    
    // Executes when swiping left
    @objc func swipeLeft() {
        self.calendar.goToNextMonth()
        updateViewFromModel(swipeDirection: .left)
    }
    
    // Executes when swiping right
    @objc func swipeRight() {
        self.calendar.goToPreviousMonth()
        updateViewFromModel(swipeDirection: .right)
    }
    
    // Updates data for all UI elements in view.
    // Handles the animation when month in view changes.
    private func updateViewFromModel(swipeDirection: SwipeDirection) {
        let animationOffset: CGFloat // How much the calendar moves in animation
        switch swipeDirection { // Set offset depending on the action that caused
        case .left: animationOffset = -8  // the view update.
        case .right: animationOffset = 8
        case .none: animationOffset = 0
        }
        
        let cframe = oCalendarCollection.frame // Keep reference to calendar's original frame
        // Start the animation
        UIView.animate(withDuration: 0.1, animations: {
            self.oCalendarCollection.frame = CGRect(x: cframe.minX + animationOffset, y: cframe.minY, width: cframe.width, height: cframe.height)
            self.oCalendarCollection.layer.opacity = 0.0
            self.oMonthLabel.layer.opacity = 0.0
        }) { (finished) in  // when the animation finishes...
            // move the frame to opposite direction to fade the new month in.
            DispatchQueue.main.async {
                self.oCalendarCollection.frame = CGRect(x: cframe.minX - animationOffset, y: cframe.minY, width: cframe.width, height: cframe.height) //
                self.oCalendarCollection.reloadData() // reload the collectionview's data
                // update UI elements
                self.oMonthLabel.text = self.calendar.getMonthInViewAsString()
                self.oYearLabel.text = self.calendar.getYearInViewAsString()
                UIView.animate(withDuration: 0.1, animations: {
                    self.oCalendarCollection.frame = cframe
                    self.oCalendarCollection.layer.opacity = 1.0
                    self.oMonthLabel.layer.opacity = 1.0
                })
            }
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
    
    private enum SwipeDirection {
        case left
        case right
        case none
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
