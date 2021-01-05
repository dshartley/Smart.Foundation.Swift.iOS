//
//  SFCollectionViewLayout.swift
//  SFView
//
//  Created by David on 29/06/2017.
//  Copyright © 2017 com.smartfoundation. All rights reserved.
//

import UIKit

/// Encapsulates layout for a SFCollectionView
public class SFCollectionViewLayout: UICollectionViewLayout {
	
	// MARK: - Private Stored Properties
	
	fileprivate var attributesCache:		[SFCollectionViewLayoutAttributes]	= [SFCollectionViewLayoutAttributes]()
	fileprivate var contentLayout:			ContentLayoutWrapper? = nil
	

	// MARK: Public Stored Properties
	
	public weak var delegate:				SFProtocolCollectionViewLayoutDelegate!

	public var attributesDeletedYN:			Bool = false
	public var columnsYN:					Bool = false
	public var minColumnWidth:				CGFloat = 150
	public var maxColumnWidth:				CGFloat = 200
	public var maxNumberofColumns:			Int = 4
	public var dynamicCellWidthYN:			Bool = false
	public var cellWidth:					CGFloat = 0
	public var cellHeight:					CGFloat = 0
	public var cellPadding:					CGFloat = 6
	
	
	// MARK: - Public Methods
	
	public func deleteAttributes(at indexPaths: [IndexPath]) {
		
		var result = [SFCollectionViewLayoutAttributes]()
		
		// Create array of indexes
		var indexes = [Int]()
		for indexPath in indexPaths {
			
			indexes.append(indexPath.item)
		}
		
		// Go through each item in attributesCache
		for item in self.attributesCache {

			// If not in the indexes array then add to result array
			if (!indexes.contains(item.indexPath.item)) {
				
				result.append(item)
			}
		}
		
		self.attributesCache		= result
		
		self.attributesDeletedYN	= true
	}
	
	
	// MARK: - Override Methods
	
//	public override func prepare_old() {
//
//		//self.collectionView?.frame
//		self.contentWidth 		= 0
//		self.contentHeight 		= 0
//
//		// Get number of columns
//		let maxWidthAvailable: 	CGFloat 	= collectionView!.bounds.width
//		var numberOfColumns:	Int			= min(Int(floor(maxWidthAvailable / self.minColumnWidth)), self.maxNumberofColumns)
//
//		// Get column width
//		var totalPaddingSpace: 	CGFloat 	= 0
//		var columnWidth:		CGFloat		= 0
//
//		// Get column width
////		totalPaddingSpace 	= self.cellPadding * CGFloat(numberOfColumns)
////		columnWidth			= min((maxWidthAvailable - totalPaddingSpace) / CGFloat(numberOfColumns), self.maxColumnWidth)
//
//		repeat {
//
//			// Increment numberOfColumns at each subsequent iteration
//			if (columnWidth > 0) { numberOfColumns -= 1 }
//
//			// Get column width
//			totalPaddingSpace 	= self.cellPadding * CGFloat(numberOfColumns)
//			columnWidth			= min((maxWidthAvailable - totalPaddingSpace) / CGFloat(numberOfColumns), self.maxColumnWidth)
//
//		} while (columnWidth < minColumnWidth)	// Check minColumnWidth
//
//
//		// Get contentWidth
//		self.contentWidth 		= (columnWidth * CGFloat(numberOfColumns)) + totalPaddingSpace
//
//		// Set contentInset to position content
//		self.setContentInset()
//
//		// Get xOffsets for each column
//		var xOffset:			[CGFloat]	= [CGFloat]()
//
//		for column in 0 ..< numberOfColumns {
//			xOffset.append(CGFloat(column) * columnWidth)
//		}
//
//		var column:				Int			= 0
//		var yOffset:			[CGFloat]	= [CGFloat](repeating: 0, count: numberOfColumns)
//
//		// Go through each item
//		for item in 0 ..< collectionView!.numberOfItems(inSection: 0) {
//
//			let indexPath:		NSIndexPath	= NSIndexPath(item: item, section: 0)
//
//			// Setup attributes
//			let attributes:		SFCollectionViewLayoutAttributes? = self.getAttributes(forCellWith: indexPath as IndexPath)
//
//			// Check attributes where created. If a delete is in progress then attributes will not be created for the deleted items
//			if let attributes = attributes {
//
//				// Determine cell width
//				var width:		CGFloat		= 0
//
//				if (self.dynamicCellWidthYN) {
//
//					// Dynamic width
//					width = delegate.collectionView(collectionView: collectionView!, widthForCellAtIndexPath : indexPath) + cellPadding * 2
//
//				} else {
//
//					// Column defined width
//					width = columnWidth - cellPadding * 2
//
//				}
//
//				// Determine cell height
//				let cellHeight:	CGFloat		= delegate.collectionView(collectionView: collectionView!, heightForCellAtIndexPath : indexPath, withWidth: width)
//
//				// Determine the insetFrame
//				let height:		CGFloat		= cellPadding + cellHeight + cellPadding
//				let frame:		CGRect		= CGRect(x: xOffset[column], y: yOffset[column], width: width, height: height)
//				let insetFrame:	CGRect		= frame.insetBy(dx: cellPadding, dy: cellPadding)
//
//				// Set custom attributes
//				delegate.setCustomAttributes(attributes: attributes)
//
//				attributes.frame			= insetFrame
//
//				// Increment contentHeight
//				contentHeight				= max(contentHeight, frame.maxY)
//
//				// Determine yOffset for the column
//				yOffset[column]				= yOffset[column] + height
//
//				// Next column
//				column						= column >= (numberOfColumns - 1) ? 0 : column + 1
//			}
//		}
//
//		// Reset attributesDeletedYN flag
//		if (self.attributesDeletedYN &&
//			(collectionView!.numberOfItems(inSection: 0) != self.attributesCache.count)) {
//
//				self.attributesDeletedYN = false
//		}
//
//	}
	
	public override func prepare() {
		
		self.defineContentLayout()
	
		// Go through each item
		for item in 0 ..< collectionView!.numberOfItems(inSection: 0) {
			
			// Get indexPath
			let indexPath:		NSIndexPath	= NSIndexPath(item: item, section: 0)
			
			// Get attributes
			let attributes:		SFCollectionViewLayoutAttributes? = self.getAttributes(forCellWith: indexPath as IndexPath)
			
			// Check attributes where created. If a delete is in progress then attributes will not be created for the deleted items
			if let attributes = attributes {
				
				if (columnsYN) {
					
					self.layoutCell(indexPath: indexPath, byColumns: attributes)
					
				} else {
					
					self.layoutCell(indexPath: indexPath, attributes: attributes)
				}
				
			}
		}
		
		// Reset attributesDeletedYN flag
		if (self.attributesDeletedYN &&
			(collectionView!.numberOfItems(inSection: 0) != self.attributesCache.count)) {
			
			self.attributesDeletedYN = false
		}
		
	}
	
	public override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
		
		var result: UICollectionViewLayoutAttributes?
		
		// Go through each item in attributesCache
		for item in attributesCache {
			
			// Check indexPath
			if (item.indexPath.item == indexPath.item) {
				
				result = item
			}
		}
		
		return result
	}
	
	public override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
		
		var result = [UICollectionViewLayoutAttributes]()
		
		// Go through each item in attributesCache
		for item in attributesCache {
			
			// Check frame
			if item.frame.intersects(rect) {
				
				result.append(item)
			}
		}
		
		return result
	}
	
	
	// MARK: - Override Properties
	
	public override var collectionViewContentSize: CGSize {

		return CGSize(width: self.contentLayout!.width, height: self.contentLayout!.height)
	}
	
	public override class var layoutAttributesClass: AnyClass {
		
		return SFCollectionViewLayoutAttributes.self
	}
	
	
	// MARK: - Private Methods
	
	fileprivate func getAttributes(forCellWith indexPath: IndexPath) -> SFCollectionViewLayoutAttributes? {
		
		var result: SFCollectionViewLayoutAttributes?
		
		// Go through each item in attributesCache
		for item in attributesCache {
			
			// Check indexPath
			if (item.indexPath.item == indexPath.item) {
				
				result = item
			}
		}
		
		// Check item was found
		if (result == nil && !self.attributesDeletedYN) {
			
			result = SFCollectionViewLayoutAttributes(forCellWith: indexPath as IndexPath)
			
			// Add new item to the cache
			attributesCache.append(result!)
		}
		
		return result
	}
	
	fileprivate func setContentInset() {
		
		// Note: We have to offset by an arbitrary value. Not sure where this comes from yet.
		let arbitraryValue: CGFloat = 10
		
		// Get inset for center alignment
		let centerAlignmentInset: 		CGFloat = (collectionView!.bounds.width - self.contentLayout!.width) / 2
		
		// Set contentInset
		collectionView!.contentInset 	= UIEdgeInsets(top: collectionView!.contentInset.top, left: centerAlignmentInset + arbitraryValue, bottom: collectionView!.contentInset.bottom, right: centerAlignmentInset - arbitraryValue)
		
	}

	fileprivate func defineContentLayout() {
		
		self.contentLayout 		= ContentLayoutWrapper()
		let cl: 				ContentLayoutWrapper = self.contentLayout!
		
		cl.maxWidth 			= collectionView!.bounds.width
		cl.width 				= cl.maxWidth
		
		if (self.columnsYN) {
			
			self.defineContentLayoutColumns()
			
		}
		
		// Set contentInset to position content
		self.setContentInset()

	}

	fileprivate func defineContentLayoutColumns() {
		
		let cl: 				ContentLayoutWrapper = self.contentLayout!
		
		// Get numberOfColumns
		var numberOfColumns:	Int = min(Int(floor(cl.maxWidth / self.minColumnWidth)), self.maxNumberofColumns)
		
		var totalPaddingSpace: 	CGFloat = 0
		var columnWidth:		CGFloat = 0
		
		// Get columnWidth
		repeat {
			
			// Increment numberOfColumns at each subsequent iteration
			if (columnWidth > 0) { numberOfColumns -= 1 }
			
			// Get column width
			totalPaddingSpace 	= self.cellPadding * CGFloat(numberOfColumns)
			columnWidth			= min((cl.maxWidth - totalPaddingSpace) / CGFloat(numberOfColumns), self.maxColumnWidth)
			
		} while (columnWidth < minColumnWidth)	// Check minColumnWidth
		
		// Get contentWidth
		cl.width 				= (columnWidth * CGFloat(numberOfColumns)) + totalPaddingSpace
		
		// Set columns
		for _ in 1 ... numberOfColumns {
			
			cl.addColumn()
			
		}

	}
	
	fileprivate func layoutCell(indexPath: NSIndexPath, attributes: SFCollectionViewLayoutAttributes) {

		let cl: 		ContentLayoutWrapper = self.contentLayout!
		
		// Check currentRow
		if (cl.currentRow == nil) {
			
			cl.nextRow()
			
		}
		
		// Get cell width
		var width:		CGFloat = cellPadding * 2		// cellPadding
	
		if (self.dynamicCellWidthYN || self.cellWidth == 0) {
			
			// Width from cell
			width 		+= delegate.collectionView(collectionView: collectionView!, widthForCellAtIndexPath : indexPath)
			
		} else {
			
			// Width predefined
			width 		+= self.cellWidth
			
		}
	
		// Get cell height
		var height:		CGFloat = cellPadding * 2		// cellPadding
		
		if (self.cellHeight == 0) {
			
			// Height from cell
			height 		+= delegate.collectionView(collectionView: collectionView!, heightForCellAtIndexPath : indexPath, withWidth: width)
			
		} else {
			
			// Height predefined
			width 		+= self.cellHeight
			
		}
		
		// Check if cell can fit in row
		if (cl.currentRow!.contentWidth + width > cl.maxWidth) {
			
			// Next row
			cl.nextRow()
			
		}
		
		// Get cellFrame
		var cellFrame:	CGRect = CGRect(x: cl.currentRow!.contentWidth, y: cl.currentRow!.y, width: width, height: height)
		cellFrame		= cellFrame.insetBy(dx: cellPadding, dy: cellPadding)
		
		// Set attributes
		self.setCellAttributes(attributes: attributes, cellFrame: cellFrame)
		
		// Content dimensions
		cl.height 						= max(cl.height, cellFrame.maxY)
		cl.currentRow!.contentHeight 	= max(height, cl.currentRow!.contentHeight)
		cl.currentRow!.contentWidth 	+= width
		
	}

	fileprivate func layoutCell(indexPath: NSIndexPath, byColumns attributes: SFCollectionViewLayoutAttributes) {
		
		let cl: 			ContentLayoutWrapper = self.contentLayout!
		
		// Next column
		cl.nextColumn()

		// Get cell width
		let width:			CGFloat = cl.columnWidth - cellPadding * 2

		// Get cell height
		let height:			CGFloat = cellPadding + delegate.collectionView(collectionView: collectionView!, heightForCellAtIndexPath : indexPath, withWidth: width) + cellPadding
		
		// Get cellFrame
		var cellFrame:		CGRect = CGRect(x: cl.currentColumn!.x, y: cl.currentColumn!.contentHeight, width: width, height: height)
		cellFrame			= cellFrame.insetBy(dx: cellPadding, dy: cellPadding)
		
		// Set attributes
		self.setCellAttributes(attributes: attributes, cellFrame: cellFrame)
		
		// Content dimensions
		cl.height 			= max(cl.height, cellFrame.maxY)
		cl.currentColumn!.contentHeight += height
		
	}
	
	fileprivate func setCellAttributes(attributes: SFCollectionViewLayoutAttributes, cellFrame: CGRect) {
		
		// Set custom attributes
		delegate.setCustomAttributes(attributes: attributes)
		
		attributes.frame = cellFrame
		
	}
	
}

