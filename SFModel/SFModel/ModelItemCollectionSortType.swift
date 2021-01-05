//
//  ModelItemCollectionSortType.swift
//  SFModel
//
//  Created by David on 19/07/2017.
//  Copyright © 2017 com.smartfoundation. All rights reserved.
//

/// Encapsulates a type of sort for a model item collection
public struct ModelItemCollectionSortType {

	// MARK: - Public Stored Properties
	
	public var index:				Int = 0
	public var name:				String = ""
	public var sortPropertyEnum:	Int = 0
	public var ascendingYN:			Bool = true
	
	
	// MARK: - Initializers
	
	private init() {
	}
	
	public init(index: Int, name: String, sortPropertyEnum: Int, ascendingYN: Bool) {
		
		self.index				= index
		self.name				= name
		self.sortPropertyEnum	= sortPropertyEnum
		self.ascendingYN		= ascendingYN
	}
}
