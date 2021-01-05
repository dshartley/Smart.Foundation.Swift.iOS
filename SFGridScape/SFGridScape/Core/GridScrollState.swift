//
//  GridScrollState.swift
//  SFGridScape
//
//  Created by David on 23/11/2018.
//  Copyright © 2018 David. All rights reserved.
//

import UIKit
import SFView

/// A wrapper for a GridScrollState item
public class GridScrollState {

	// MARK: - Public Stored Properties
	
	public var mfrx: 				CGFloat = 0
	public var mflx: 				CGFloat = 0
	public var mfby: 				CGFloat = 0
	public var mfty: 				CGFloat = 0
	public var t: 					CGAffineTransform? = nil
	public var isInitialYN:			Bool = true
	public var marginFrame: 		CGRect?
	public var initialOverMinX:		CGFloat = 0
	public var initialOverMaxX:		CGFloat = 0
	public var initialOverMinY:		CGFloat = 0
	public var initialOverMaxY:		CGFloat = 0
	
	
	// MARK: - Public Computed Properties
	
	
	// MARK: - Initializers
	
	public init() {
		
	}
	
	
	// MARK: - Public Methods
	
	public func setMarginFrameProperties(marginFrame: CGRect, attributes: PanGestureAttributes) {
		
		self.marginFrame = marginFrame
		
		// Calculate marginFrame properties for current pan
		self.mfrx = marginFrame.maxX - attributes.horizontalDistance
		self.mflx = marginFrame.minX - attributes.horizontalDistance
		self.mfby = marginFrame.maxY - attributes.verticalDistance
		self.mfty = marginFrame.minY - attributes.verticalDistance
		
	}
	
	public func checkGridLimits(gridProperties: GridProperties, gridState: GridState, attributes: PanGestureAttributes) {
		
		self.checkGridTrueMinX(gridProperties: gridProperties, attributes: attributes)
		self.checkGridTrueMaxX(gridProperties: gridProperties, attributes: attributes)
		self.checkGridTrueMinY(gridProperties: gridProperties, attributes: attributes)
		self.checkGridTrueMaxY(gridProperties: gridProperties, attributes: attributes)
		
		// Check scrollLimitToPopulatedCellsYN
		if (gridProperties.scrollLimitToPopulatedCellsYN) {
			
			let scrollAllowance: CGFloat = gridProperties.blockWidth
				
			self.checkGridFirstPopulatedCellColumnMinX(gridProperties: gridProperties, gridState: gridState, attributes: attributes, scrollAllowance: scrollAllowance)
			self.checkGridFirstPopulatedCellRowMinY(gridProperties: gridProperties, gridState: gridState, attributes: attributes, scrollAllowance: scrollAllowance)
			self.checkGridLastPopulatedCellColumnMaxX(gridProperties: gridProperties, gridState: gridState, attributes: attributes, scrollAllowance: scrollAllowance)
			self.checkGridLastPopulatedCellRowMaxY(gridProperties: gridProperties, gridState: gridState, attributes: attributes, scrollAllowance: scrollAllowance)
			
		}

		// Check scrollLimit to grid size width
		if (gridProperties.gridWidthCells != nil) {
			
			self.checkGridSizeFirstCellColumnMinX(gridProperties: gridProperties, gridState: gridState, attributes: attributes)
			self.checkGridSizeLastCellColumnMaxX(gridProperties: gridProperties, gridState: gridState, attributes: attributes)
			
		}
		
		// Check scrollLimit to grid size width
		if (gridProperties.gridHeightCells != nil) {

			self.checkGridSizeFirstCellRowMinY(gridProperties: gridProperties, gridState: gridState, attributes: attributes)
			self.checkGridSizeLastCellRowMaxY(gridProperties: gridProperties, gridState: gridState, attributes: attributes)
			
		}
		
		self.isInitialYN = false
		
	}
	
	
	// MARK: - Private Methods
	
	fileprivate func checkGridTrueMinX(gridProperties: GridProperties, attributes: PanGestureAttributes) {
		
		guard (gridProperties.gridLimitTrueMinX != nil) else { return }
		
		// Calculate distance over gridLimitTrueMinX
		let overMinX: 	CGFloat = (self.mflx + (gridProperties.marginLeftWidth)) - gridProperties.gridLimitTrueMinX!
		
		// Check overMinX
		if (overMinX < 0) {
			
			// Correct marginFrame
			self.mflx 	= self.mflx - overMinX
			
			// Correct PanGestureAttributes
			attributes.horizontalDistance 	= attributes.horizontalDistance + overMinX
			attributes.transform 			= CGAffineTransform(translationX: attributes.transform!.tx + overMinX, y: attributes.transform!.ty)
		}
		
	}

	fileprivate func checkGridTrueMaxX(gridProperties: GridProperties, attributes: PanGestureAttributes) {
		
		guard (gridProperties.gridLimitTrueMaxX != nil) else { return }
		
		// Calculate distance over gridLimitTrueMaxX
		let overMaxX: 	CGFloat = (self.mfrx - (gridProperties.marginRightWidth)) - gridProperties.gridLimitTrueMaxX!
		
		// Check overMaxX
		if (overMaxX > 0) {
			
			// Correct marginFrame
			self.mfrx 	= self.mfrx - overMaxX
			
			// Correct PanGestureAttributes
			attributes.horizontalDistance 	= attributes.horizontalDistance + overMaxX
			attributes.transform 			= CGAffineTransform(translationX: attributes.transform!.tx + overMaxX, y: attributes.transform!.ty)
		}
		
	}
	
	fileprivate func checkGridTrueMinY(gridProperties: GridProperties, attributes: PanGestureAttributes) {
		
		guard (gridProperties.gridLimitTrueMinY != nil) else { return }
		
		// Calculate distance over gridLimitTrueMinY
		let overMinY: 	CGFloat = (self.mfty + (gridProperties.marginTopHeight)) - gridProperties.gridLimitTrueMinY!
		
		// Check overMinY
		if (overMinY < 0) {

			// Correct marginFrame
			self.mfty 	= self.mfty - overMinY
			
			// Correct PanGestureAttributes
			attributes.verticalDistance 	= attributes.verticalDistance + overMinY
			attributes.transform 			= CGAffineTransform(translationX: attributes.transform!.tx, y: attributes.transform!.ty + overMinY)
		}
		
	}
	
	fileprivate func checkGridTrueMaxY(gridProperties: GridProperties, attributes: PanGestureAttributes) {
		
		guard (gridProperties.gridLimitTrueMaxY != nil) else { return }
		
		// Calculate distance over gridLimitTrueMaxY
		let overMaxY: 	CGFloat = (self.mfby - (gridProperties.marginBottomHeight)) - gridProperties.gridLimitTrueMaxY!
		
		// Check overMaxY
		if (overMaxY > 0) {
			
			// Correct marginFrame
			self.mfby 	= self.mfby - overMaxY
			
			// Correct PanGestureAttributes
			attributes.verticalDistance 	= attributes.verticalDistance + overMaxY
			attributes.transform 			= CGAffineTransform(translationX: attributes.transform!.tx, y: attributes.transform!.ty + overMaxY)
		}
		
	}
	
	fileprivate func checkGridFirstPopulatedCellColumnMinX(gridProperties: GridProperties, gridState: GridState, attributes: PanGestureAttributes, scrollAllowance: CGFloat) {
		
		// Calculate distance over firstPopulatedCellColumnMinX
		var overMinX: 		CGFloat = -1
		
		if (gridState.firstPopulatedCellColumnMinX != nil) {
			
			overMinX 		= (self.mflx + gridProperties.marginLeftWidth + scrollAllowance) - gridState.firstPopulatedCellColumnMinX!
		}
		
		if (self.isInitialYN) {
			
			// Calculate initialOverMinX
			self.initialOverMinX 				= (self.marginFrame!.minX + gridProperties.marginLeftWidth + scrollAllowance) - gridState.firstPopulatedCellColumnMinX!
			
		}
		
		// Check initialOverMinX
		if (self.initialOverMinX < 0) {
			
			if (attributes.horizontalDistance > 0) {
				
				// Correct marginFrame
				self.mflx 						= self.marginFrame!.minX
				
				// Correct PanGestureAttributes
				attributes.horizontalDistance 	= 0
				attributes.transform 			= CGAffineTransform(translationX: 0, y: attributes.transform!.ty)
				
				
			}

			return
			
		}
		
		// Check overMinX
		if (overMinX < 0) {
			
			// Correct marginFrame
			self.mflx 	= self.mflx - overMinX
			
			// Correct PanGestureAttributes
			attributes.horizontalDistance 		= attributes.horizontalDistance + overMinX
			attributes.transform 				= CGAffineTransform(translationX: attributes.transform!.tx + overMinX, y: attributes.transform!.ty)
			
		}
		
	}

	fileprivate func checkGridFirstPopulatedCellRowMinY(gridProperties: GridProperties, gridState: GridState, attributes: PanGestureAttributes, scrollAllowance: CGFloat) {
		
		// Calculate distance over firstPopulatedCellRowMinY
		var overMinY: 		CGFloat = -1
		
		if (gridState.firstPopulatedCellRowMinY != nil) {
			
			overMinY 		= (self.mfty + gridProperties.marginTopHeight + scrollAllowance) - gridState.firstPopulatedCellRowMinY!
		}
		
		if (self.isInitialYN) {
			
			// Calculate initialOverMinY
			self.initialOverMinY				= (self.marginFrame!.minY + gridProperties.marginTopHeight + scrollAllowance) - gridState.firstPopulatedCellRowMinY!
			
		}
		
		// Check initialOverMinY
		if (self.initialOverMinY < 0) {
			
			if (attributes.verticalDistance > 0) {
				
				// Correct marginFrame
				self.mfty 						= self.marginFrame!.minY
				
				// Correct PanGestureAttributes
				attributes.verticalDistance 	= 0
				attributes.transform 			= CGAffineTransform(translationX: attributes.transform!.tx, y: 0)
				
				
			}
			
			return
			
		}
		
		// Check overMinY
		if (overMinY < 0) {
			
			// Correct marginFrame
			self.mfty 	= self.mfty - overMinY
			
			// Correct PanGestureAttributes
			attributes.verticalDistance 		= attributes.verticalDistance + overMinY
			attributes.transform 				= CGAffineTransform(translationX: attributes.transform!.tx, y: attributes.transform!.ty + overMinY)
			
		}
		
	}
	
	fileprivate func checkGridLastPopulatedCellColumnMaxX(gridProperties: GridProperties, gridState: GridState, attributes: PanGestureAttributes, scrollAllowance: CGFloat) {
		
		// Calculate distance over lastPopulatedCellColumnMaxX
		var overMaxX: 		CGFloat = 1
		
		if (gridState.lastPopulatedCellColumnMaxX != nil) {
			
			overMaxX 		= (self.mfrx - gridProperties.marginRightWidth - scrollAllowance) - gridState.lastPopulatedCellColumnMaxX!
		}
		
		if (self.isInitialYN) {
			
			// Calculate initialOverMaxX
			self.initialOverMaxX 				= (self.marginFrame!.maxX - gridProperties.marginRightWidth - scrollAllowance) - gridState.lastPopulatedCellColumnMaxX!
			
		}
		
		// Check initialOverMaxX
		if (self.initialOverMaxX > 0) {
			
			if (attributes.horizontalDistance < 0) {
				
				// Correct marginFrame
				self.mfrx 						= self.marginFrame!.maxX
				
				// Correct PanGestureAttributes
				attributes.horizontalDistance 	= 0
				attributes.transform 			= CGAffineTransform(translationX: 0, y: attributes.transform!.ty)
				
				
			}
			
			return
			
		}
		
		// Check overMaxX
		if (overMaxX > 0) {
			
			// Correct marginFrame
			self.mfrx 	= self.mfrx - overMaxX
			
			// Correct PanGestureAttributes
			attributes.horizontalDistance 		= attributes.horizontalDistance + overMaxX
			attributes.transform 				= CGAffineTransform(translationX: attributes.transform!.tx + overMaxX, y: attributes.transform!.ty)
			
		}
		
	}
	
	fileprivate func checkGridLastPopulatedCellRowMaxY(gridProperties: GridProperties, gridState: GridState, attributes: PanGestureAttributes, scrollAllowance: CGFloat) {
		
		// Calculate distance over lastPopulatedCellRowMaxY
		var overMaxY: 		CGFloat = 1
		
		if (gridState.lastPopulatedCellRowMaxY != nil) {
			
			overMaxY 		= (self.mfby - gridProperties.marginBottomHeight - scrollAllowance) - gridState.lastPopulatedCellRowMaxY!
		}
		
		if (self.isInitialYN) {
			
			// Calculate initialOverMaxY
			self.initialOverMaxY				= (self.marginFrame!.maxY - gridProperties.marginBottomHeight - scrollAllowance) - gridState.lastPopulatedCellRowMaxY!
			
		}
		
		// Check initialOverMaxY
		if (self.initialOverMaxY > 0) {
			
			if (attributes.verticalDistance < 0) {
				
				// Correct marginFrame
				self.mfby 						= self.marginFrame!.maxY
				
				// Correct PanGestureAttributes
				attributes.verticalDistance 	= 0
				attributes.transform 			= CGAffineTransform(translationX: attributes.transform!.tx, y: 0)
				
				
			}
			
			return
			
		}
		
		// Check overMaxY
		if (overMaxY > 0) {
			
			// Correct marginFrame
			self.mfby 	= self.mfby - overMaxY
			
			// Correct PanGestureAttributes
			attributes.verticalDistance 		= attributes.verticalDistance + overMaxY
			attributes.transform 				= CGAffineTransform(translationX: attributes.transform!.tx, y: attributes.transform!.ty + overMaxY)
			
		}
		
	}
	
	fileprivate func checkGridSizeFirstCellColumnMinX(gridProperties: GridProperties, gridState: GridState, attributes: PanGestureAttributes) {
		
		guard (gridState.gridSizeFirstCellColumnMinX != nil) else { return }
		
		// Calculate distance over gridSizeFirstCellColumnMinX
		var overMinX: 		CGFloat = -1
		
		if (gridState.gridSizeFirstCellColumnMinX != nil) {
			
			overMinX 		= (self.mflx + gridProperties.marginLeftWidth) - gridState.gridSizeFirstCellColumnMinX!
		}
		
		if (self.isInitialYN) {
			
			// Calculate initialOverMinX
			self.initialOverMinX 				= (self.marginFrame!.minX + gridProperties.marginLeftWidth) - gridState.gridSizeFirstCellColumnMinX!
			
		}
		
		// Check initialOverMinX
		if (self.initialOverMinX < 0) {
			
			if (attributes.horizontalDistance > 0) {
				
				// Correct marginFrame
				self.mflx 						= self.marginFrame!.minX
				
				// Correct PanGestureAttributes
				attributes.horizontalDistance 	= 0
				attributes.transform 			= CGAffineTransform(translationX: 0, y: attributes.transform!.ty)
				
				
			}
			
			return
			
		}
		
		// Check overMinX
		if (overMinX < 0) {
			
			// Correct marginFrame
			self.mflx 	= self.mflx - overMinX
			
			// Correct PanGestureAttributes
			attributes.horizontalDistance 		= attributes.horizontalDistance + overMinX
			attributes.transform 				= CGAffineTransform(translationX: attributes.transform!.tx + overMinX, y: attributes.transform!.ty)
			
		}
		
	}
	
	fileprivate func checkGridSizeFirstCellRowMinY(gridProperties: GridProperties, gridState: GridState, attributes: PanGestureAttributes) {
		
		guard (gridState.gridSizeFirstCellRowMinY != nil) else { return }
		
		// Calculate distance over gridSizeFirstCellRowMinY
		var overMinY: 		CGFloat = -1
		
		if (gridState.gridSizeFirstCellRowMinY != nil) {
			
			overMinY 		= (self.mfty + gridProperties.marginTopHeight) - gridState.gridSizeFirstCellRowMinY!
		}
		
		if (self.isInitialYN) {
			
			// Calculate initialOverMinY
			self.initialOverMinY				= (self.marginFrame!.minY + gridProperties.marginTopHeight) - gridState.gridSizeFirstCellRowMinY!
			
		}
		
		// Check initialOverMinY
		if (self.initialOverMinY < 0) {
			
			if (attributes.verticalDistance > 0) {
				
				// Correct marginFrame
				self.mfty 						= self.marginFrame!.minY
				
				// Correct PanGestureAttributes
				attributes.verticalDistance 	= 0
				attributes.transform 			= CGAffineTransform(translationX: attributes.transform!.tx, y: 0)
				
				
			}
			
			return
			
		}
		
		// Check overMinY
		if (overMinY < 0) {
			
			// Correct marginFrame
			self.mfty 	= self.mfty - overMinY
			
			// Correct PanGestureAttributes
			attributes.verticalDistance 		= attributes.verticalDistance + overMinY
			attributes.transform 				= CGAffineTransform(translationX: attributes.transform!.tx, y: attributes.transform!.ty + overMinY)
			
		}
		
	}
	
	fileprivate func checkGridSizeLastCellColumnMaxX(gridProperties: GridProperties, gridState: GridState, attributes: PanGestureAttributes) {
		
		guard (gridState.gridSizeLastCellColumnMaxX != nil) else { return }
		
		// Calculate distance over gridSizeLastCellColumnMaxX
		var overMaxX: 		CGFloat = 1
		
		if (gridState.gridSizeLastCellColumnMaxX != nil) {
			
			overMaxX 		= (self.mfrx - gridProperties.marginRightWidth) - gridState.gridSizeLastCellColumnMaxX!
		}
		
		if (self.isInitialYN) {
			
			// Calculate initialOverMaxX
			self.initialOverMaxX 				= (self.marginFrame!.maxX - gridProperties.marginRightWidth) - gridState.gridSizeLastCellColumnMaxX!
			
		}
		
		// Check initialOverMaxX
		if (self.initialOverMaxX > 0) {
			
			if (attributes.horizontalDistance < 0) {
				
				// Correct marginFrame
				self.mfrx 						= self.marginFrame!.maxX
				
				// Correct PanGestureAttributes
				attributes.horizontalDistance 	= 0
				attributes.transform 			= CGAffineTransform(translationX: 0, y: attributes.transform!.ty)
				
				
			}
			
			return
			
		}
		
		// Check overMaxX
		if (overMaxX > 0) {
			
			// Correct marginFrame
			self.mfrx 	= self.mfrx - overMaxX
			
			// Correct PanGestureAttributes
			attributes.horizontalDistance 		= attributes.horizontalDistance + overMaxX
			attributes.transform 				= CGAffineTransform(translationX: attributes.transform!.tx + overMaxX, y: attributes.transform!.ty)
			
		}
		
	}
	
	fileprivate func checkGridSizeLastCellRowMaxY(gridProperties: GridProperties, gridState: GridState, attributes: PanGestureAttributes) {
		
		guard (gridState.gridSizeLastCellRowMaxY != nil) else { return }
		
		// Calculate distance over gridSizeLastCellRowMaxY
		var overMaxY: 		CGFloat = 1
		
		if (gridState.gridSizeLastCellRowMaxY != nil) {
			
			overMaxY 		= (self.mfby - gridProperties.marginBottomHeight) - gridState.gridSizeLastCellRowMaxY!
		}
		
		if (self.isInitialYN) {
			
			// Calculate initialOverMaxY
			self.initialOverMaxY				= (self.marginFrame!.maxY - gridProperties.marginBottomHeight) - gridState.gridSizeLastCellRowMaxY!
			
		}
		
		// Check initialOverMaxY
		if (self.initialOverMaxY > 0) {
			
			if (attributes.verticalDistance < 0) {
				
				// Correct marginFrame
				self.mfby 						= self.marginFrame!.maxY
				
				// Correct PanGestureAttributes
				attributes.verticalDistance 	= 0
				attributes.transform 			= CGAffineTransform(translationX: attributes.transform!.tx, y: 0)
				
				
			}
			
			return
			
		}
		
		// Check overMaxY
		if (overMaxY > 0) {
			
			// Correct marginFrame
			self.mfby 	= self.mfby - overMaxY
			
			// Correct PanGestureAttributes
			attributes.verticalDistance 		= attributes.verticalDistance + overMaxY
			attributes.transform 				= CGAffineTransform(translationX: attributes.transform!.tx, y: attributes.transform!.ty + overMaxY)
			
		}
		
	}
	
}
