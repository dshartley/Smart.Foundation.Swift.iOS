//
//  GridProperties.swift
//  PlayGridViewDemo
//
//  Created by David on 12/11/2018.
//  Copyright © 2018 David. All rights reserved.
//

import UIKit

/// A wrapper for a GridProperties item
public class GridProperties {

	// MARK: - Public Stored Properties
	
	public var displayWidth: 										CGFloat = 0
	public var displayHeight: 										CGFloat = 0
	public var gridPositionReferenceToType:							GridPositionReferenceToTypes = .center
	public var gridLimitTrueMinX:									CGFloat? = nil
	public var gridLimitTrueMaxX:									CGFloat? = nil
	public var gridLimitTrueMinY:									CGFloat? = nil
	public var gridLimitTrueMaxY:									CGFloat? = nil
	public var cellWidth: 											CGFloat = 0
	public var cellHeight: 											CGFloat = 0
	public var marginRightBlocks: 									Int = 1
	public var marginLeftBlocks: 									Int = 1
	public var marginTopBlocks: 									Int = 1
	public var marginBottomBlocks: 									Int = 1
	public var blockWidthCells:										Int = 0
	public var blockHeightCells:									Int = 0
	public var gridWidthCells:										Int? = nil
	public var gridHeightCells:										Int? = nil
	public var blockCoordsVisibleYN:								Bool = true
	public var gridLinesVisibleYN:									Bool = true
	public var gridLinesColor:										UIColor? = nil
	public var gridLinesAlpha:										CGFloat = 1
	public var horizontalScrollYN:									Bool = true
	public var verticalScrollYN:									Bool = true
	public var scrollLimitToPopulatedCellsYN:						Bool = false
	public var blockBackgroundColorOnYN:							Bool = true
	public var blockBackgroundColor:								UIColor? = nil
	public var cellBackgroundColor:									UIColor? = nil
	public var cellBorderColor:										UIColor? = nil
	public var cellBorderWidth:										CGFloat? = nil
	public var cellHighlightBackgroundColor:						UIColor? = nil
	public var cellHighlightFilterColor:							UIColor? = nil
	public var cellHighlightBorderColor:							UIColor? = nil
	public var cellHighlightBorderWidth:							CGFloat? = nil
	public var alternatingCellBackgroundColorOnYN:					Bool = false
	public var alternateCellBackgroundColor:						UIColor? = nil
	public var dragAndDropCellsYN:									Bool = true
	public var dragAndDropTilesYN:									Bool = true
	public var dragAndDropTokensYN:									Bool = true
	public var canDropCellViewCheckIsCompatibleWithNeighboursYN:	Bool = true
	public var canDropTileViewCheckIsCompatibleWithNeighboursYN:	Bool = true
	public var canDropTokenViewCheckIsCompatibleWithNeighboursYN:	Bool = true
	public var setGridPositionBeforeMoveTokenAlongPathYN:			Bool = true
	
	
	// MARK: - Public Computed Properties
	
	public var blockWidth: CGFloat {
		get {
			
			return CGFloat(self.blockWidthCells) * self.cellWidth
			
		}
	}

	public var blockHeight: CGFloat {
		get {
			
			return CGFloat(self.blockHeightCells) * self.cellHeight
			
		}
	}

	public var displayWidthBlocks: Int {
		get {
			
			let xDiv: 	div_t = div(Int32(self.displayWidth), Int32(self.blockWidth))
			var c: 		Int = Int(xDiv.quot)
			if (xDiv.rem > 0) { c += 1 }
			
			return c
			
		}
	}

	public var displayHeightBlocks: Int {
		get {
			
			let yDiv: 	div_t = div(Int32(self.displayHeight), Int32(self.blockHeight))
			var r: 		Int = Int(yDiv.quot)
			if (yDiv.rem > 0) { r += 1 }
			
			return r
			
		}
	}
	
	public var marginLeftWidth: CGFloat {
		get {
		
			return CGFloat(self.marginLeftBlocks) * self.blockWidth
			
		}
	}
	
	public var marginRightWidth: CGFloat {
		get {
			
			return CGFloat(self.marginRightBlocks) * self.blockWidth
			
		}
	}
	
	public var marginTopHeight: CGFloat {
		get {
			
			return CGFloat(self.marginTopBlocks) * self.blockHeight
			
		}
	}
	
	public var marginBottomHeight: CGFloat {
		get {
			
			return CGFloat(self.marginBottomBlocks) * self.blockHeight
			
		}
	}

	public var marginLeftCells: Int {
		get {
			
			return self.blockWidthCells * self.marginLeftBlocks
			
		}
	}
	
	public var marginRightCells: Int {
		get {
			
			return self.blockWidthCells * self.marginRightBlocks
			
		}
	}
	
	public var marginTopCells: Int {
		get {
			
			return self.blockHeightCells * self.marginTopBlocks
			
		}
	}
	
	public var marginBottomCells: Int {
		get {
			
			return self.blockHeightCells * self.marginBottomBlocks
			
		}
	}
	
	
	// MARK: - Initializers
	
	public init() {
		
	}
	
}
