//
//  CalendarCollectionViewFlowLayout.swift
//  CollectionPractice
//
//  Created by Orlando G. Rodriguez on 6/21/18.
//  Copyright © 2018 WorlySoftware. All rights reserved.
//

import UIKit

class OrlyCalendarCollectionViewFlowLayout: UICollectionViewFlowLayout {
    
    // MARK: - External Configuration
    @IBInspectable var minCellSize: CGSize = CGSize(width: 44, height: 44) {
        didSet {
            invalidateLayout()
        }
    }
    @IBInspectable var cellSpacing: CGFloat = 4 {
        didSet {
            invalidateLayout()
        }
    }
    
    // MARK: - Internal Metrics
    private var cellCount: Int {
        return collectionView!.dataSource!.collectionView(collectionView!, numberOfItemsInSection: 0)
    }
    private var contentSize: CGSize = CGSize.zero
    private var columns: Int = 0
    private var rows: Int = 0
    private var cellSize: CGSize = CGSize.zero
    private var cellCenterPoints: [CGPoint] = []
    
    // MARK: - Overrides
    override func prepare() {
        let collectionViewWidth = collectionView!.frame.size.width
        
        // Calculate the number of rows and columns
        columns = 7
        rows = 6
        
        // Take the remaining gap and divide it among the existing columns
        let innerWidth = (CGFloat(columns) * (minCellSize.width + cellSpacing)) + cellSpacing
        let extraWidth = collectionViewWidth - innerWidth
        let cellGrowth = extraWidth / CGFloat(columns)
        cellSize.width = floor(minCellSize.width + cellGrowth)
        cellSize.height = cellSize.width
        
        for itemIndex in 0 ..< cellCount {
            // Locate the cell's position in the grid
            let coordBreakdown = modf(CGFloat(itemIndex) / CGFloat(columns))
            let row = Int(coordBreakdown.0) + 1
            let col = Int(round(coordBreakdown.1 * CGFloat(columns))) + 1
            
            // Calculate the actual centerpoint of the cell, given its position
            var cellBottomRight = CGPoint()
            cellBottomRight.x = CGFloat(col) * (cellSpacing + cellSize.width)
            cellBottomRight.y = CGFloat(row) * (cellSpacing + cellSize.height)
            
            var cellCenter = CGPoint()
            cellCenter = CGPoint()
            cellCenter.x = cellBottomRight.x - (cellSize.width / 2.0)
            cellCenter.y = cellBottomRight.y - (cellSize.height / 2.0)
            
            cellCenterPoints.append(cellCenter)
        }
        
    }
    
    override var collectionViewContentSize: CGSize {
        let contentWidth = (cellSize.width + cellSpacing) * CGFloat(columns) + cellSpacing
        let contentHeight = (cellSize.height + cellSpacing) * CGFloat(rows) + cellSpacing
        OperationQueue.main.addOperation {
            let curCVFrame = self.collectionView!.frame
            let curX = curCVFrame.minX
            let curY = curCVFrame.minY
            let correctedWidth = contentWidth
            let correctedHeight = (self.cellSize.height + self.cellSpacing) * CGFloat(6)
            self.collectionView!.frame = CGRect(x: curX, y: curY, width: correctedWidth, height: correctedHeight)
            let aspectRatioConstraint = NSLayoutConstraint(item: self.collectionView!, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: self.collectionView!, attribute: NSLayoutAttribute.height, multiplier: correctedWidth / correctedHeight, constant: 0)
            self.collectionView!.addConstraint(aspectRatioConstraint)
        }
        let contentSize = CGSize(width: contentWidth, height: contentHeight)
        return contentSize
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var allAttributes: [UICollectionViewLayoutAttributes] = []
        
        for itemIndex in 0 ..< cellCount {
            if rect.contains(cellCenterPoints[itemIndex]) {
                let indexPath = IndexPath(item: itemIndex, section: 0)
                let attributes = layoutAttributesForItem(at: indexPath)!
                allAttributes.append(attributes)
            }
        }
        return allAttributes
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        guard let attributes = super.layoutAttributesForItem(at: indexPath) else {
            return nil
        }
        attributes.size = cellSize
        attributes.center = cellCenterPoints[indexPath.row]
        
        return attributes
    }
}
