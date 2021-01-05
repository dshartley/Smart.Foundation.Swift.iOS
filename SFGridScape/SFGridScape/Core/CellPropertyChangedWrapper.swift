//
//  CellPropertyChangedWrapper.swift
//  SFGridScape
//
//  Created by David on 14/12/2018.
//  Copyright © 2018 David. All rights reserved.
//

import UIKit

/// A wrapper for a CellPropertyChanged item
public class CellPropertyChangedWrapper {
	
	// MARK: - Public Stored Properties
	
	public var type:		PropertyChangedTypes = .Property
	public var side:		CellSideTypes? = nil
	public var key: 		String = ""
	public var newValue:	String? = nil
	public var oldValue:	String? = nil
	
	
	// MARK: - Initializers
	
	public init() {
		
	}

	public init(type: PropertyChangedTypes, key: String) {
		
		self.type 	= type
		self.key 	= key
		
	}
	
	public init(type: PropertyChangedTypes, side: CellSideTypes, key: String) {
		
		self.type 	= type
		self.side 	= side
		self.key 	= key
		
	}
	
}
