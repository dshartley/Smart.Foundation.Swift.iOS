//
//  DM.swift
//  Smart.Foundation
//
//  Created by David on 20/07/2017.
//  Copyright © 2017 com.smartfoundation. All rights reserved.
//

import SFModel

/// Encapsulates a DM model item
public class DM : ModelItemBase {
	
	// MARK: - Initializers
	
	private override init() {
		super.init()
	}
	
	public override init(collection: ProtocolModelItemCollection) {
		super.init(collection: collection)
	}
	
	
	// MARK: - Public Methods
	
	let stringvalueKey: String = "stringvalue"
	
	/// Gets or sets the [stringvalue]
	public var stringvalue: String {
		get {
			
			return self.getProperty(key: stringvalueKey)!
		}
		set(value) {
			
			self.setProperty(key: stringvalueKey, value: value, setWhenInvalidYN: false)
		}
	}
	
	let numericvalueKey: String = "numericvalue"
	
	/// Gets or sets the [numericvalue]
	public var numericvalue: Int {
		get {
			
			return Int(self.getProperty(key: numericvalueKey)!)!
		}
		set(value) {
			
			self.setProperty(key: numericvalueKey, value: String(value), setWhenInvalidYN: false)
		}
	}
	
	
	// MARK: - Override Methods
	
	public override func initialiseDataNode() {
		
		// Setup the node data
		
		self.doSetProperty(key: idKey,				value: "0")
		self.doSetProperty(key: stringvalueKey,		value: "")
		self.doSetProperty(key: numericvalueKey,	value: "0")
	}
	
	public override func initialiseDataItem() {
		
		// Setup foreign key dependency helpers
	}
	
	public override func initialisePropertyIndexes() {
		
		// Define the range of the properties using the enum values
		
		startEnumIndex	= ModelProperties.dm_id.rawValue
		endEnumIndex	= ModelProperties.dm_numericvalue.rawValue
		
	}
	
	public override func initialisePropertyKeys() {
		
		// Populate the dictionary of property keys
		
		keys[idKey]				= ModelProperties.dm_id.rawValue
		keys[stringvalueKey]	= ModelProperties.dm_stringvalue.rawValue
		keys[numericvalueKey]	= ModelProperties.dm_numericvalue.rawValue
	}
	
	public override var dataType: String {
		get {
			return "DM"
		}
	}
	
	public override func clone(item: ProtocolModelItem) {
		
		// Validations should not be performed when cloning the item
		let doValidationsYN: Bool = self.doValidationsYN
		self.doValidationsYN = false
		
		// Copy all properties from the specified item
		if let item = item as? DM {
			
			self.id				= item.id
			self.stringvalue	= item.stringvalue
			self.numericvalue	= item.numericvalue
		}
		
		self.doValidationsYN = doValidationsYN
	}
	
	public override func isValid(propertyEnum: Int, value: String) -> ValidationResultTypes {
		
		var result: ValidationResultTypes = ValidationResultTypes.passed
		
		// Perform validations for the specified property
		switch toProperty(propertyEnum: propertyEnum) {
		case .dm_stringvalue:
			result = self.isValidStringValue(value: value)
			break
			
		case .dm_numericvalue:
			result = self.isValidNumericValue(value: value)
			break
			
		default:
			break
		}
		
		return result
	}
	
	
	// MARK: - Private Methods
	
	fileprivate func toProperty(propertyEnum: Int) -> ModelProperties {
		
		return ModelProperties(rawValue: propertyEnum)!
	}
	
	
	// MARK: - Validations
	
	fileprivate func isValidStringValue(value: String) -> ValidationResultTypes {
		
		var result: ValidationResultTypes = .passed
		
		result = self.checkMaxLength(value: value, maxLength: 250, propertyName: "stringvalue")
		
		return result
	}
	
	fileprivate func isValidNumericValue(value: String) -> ValidationResultTypes {
		
		var result: ValidationResultTypes = .passed
		
		result = self.checkNumeric(value: value, propertyName: "numericvalue")
		
		return result
	}
	
}

