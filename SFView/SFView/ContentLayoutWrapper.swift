//
//  ContentLayoutWrapper.swift
//  SFView
//
//  Created by David on 01/11/2018.
//  Copyright © 2018 com.smartfoundation. All rights reserved.
//

import UIKit

/// A wrapper for a content layout
public class ContentLayoutWrapper {
	
	// MARK: - Private Stored Properties
	
	
	// MARK: - Public Stored Properties
	
	public var height: 							CGFloat = 0
	public var width: 							CGFloat = 0
	public var maxWidth: 						CGFloat = 0
	public var columnWidth:						CGFloat = 0
	public var columns:							[ColumnLayoutWrapper] = [ColumnLayoutWrapper]()
	public var rows:							[RowLayoutWrapper] = [RowLayoutWrapper]()
	public fileprivate(set) var currentColumn: 	ColumnLayoutWrapper? = nil
	public fileprivate(set) var currentRow: 	RowLayoutWrapper? = nil
	
	
	// MARK: - Initializers
	
	public init() {
	}


	// MARK: - Public Methods

	public func addColumn() {
		
		let result: 			ColumnLayoutWrapper = ColumnLayoutWrapper()
		
		// Get index of next column
		let index: 				Int = self.columns.count

		result.index 			= index

		if let previousColumn = self.columns.last {
			
			result.x 			= previousColumn.x + previousColumn.contentWidth
			
		}
		
		self.columns.append(result)
		
	}
	
	public func nextColumn() {
		
		// Get index of next column
		var index: Int = 0
		
		if (self.currentColumn != nil) {
			
			index = self.currentColumn!.index + 1
			
		}
		
		// Check if last column
		if (index > self.columns.count - 1) {
			
			index = 0
			
		}
		
		self.currentColumn = self.columns[index]
		
	}

	public func addRow() {
		
		let result: 			RowLayoutWrapper = RowLayoutWrapper()
		
		// Get index of next row
		let index: 				Int = self.rows.count
		
		result.index 			= index
		
		if let previousRow = self.rows.last {
			
			result.y 			= previousRow.y + previousRow.contentHeight
			
		}
		
		self.rows.append(result)
		
	}
	
	public func nextRow() {
		
		// Get index of next row
		var index: 			Int = 0
		
		if (self.currentRow != nil) {
			
			index 			= self.currentRow!.index + 1

		}
		
		if (index > self.rows.count - 1) {
			
			self.addRow()
			
		}
		
		self.currentRow 	= self.rows[index]
		
	}
	
}
