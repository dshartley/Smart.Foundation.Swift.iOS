//
//  ModelAccessParameter.swift
//  SFModel
//
//  Created by David on 22/07/2017.
//  Copyright © 2017 com.smartfoundation. All rights reserved.
//

/// Encapsulates a generic model access parameter
public class ModelAccessParameter {

	// MARK: - Public Stored Properties
	
	public var name:		String = ""
	public var value:		Any?
	public var direction:	ParameterDirections = .inward
	
	
	// MARK: - Initializers
	
	public init() {
	}
	
	public init(name: String, value: Any, direction: ParameterDirections) {
		
		self.name		= name
		self.value		= value
		self.direction	= direction
	}
	
}
