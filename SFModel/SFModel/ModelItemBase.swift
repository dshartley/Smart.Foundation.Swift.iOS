//
//  ModelItemBase.swift
//  SFModel
//
//  Created by David on 22/06/2017.
//  Copyright © 2017 com.smartfoundation. All rights reserved.
//

import SFSerialization

/// A base class for classes which encapsulate a model item
open class ModelItemBase : HasValidationsBase {

	// MARK: - Private Stored Properties

	// These indexes are included in the search operation
	fileprivate var searchPropertyIndexes:		[Int]?
	
	
	// MARK: - ProtocolModelItem Public Stored Properties
	
	public weak var delegate:					ProtocolModelItemDelegate?
	public var dataNode:						[String: Any]?
	public var doSavesYN:						Bool = true
	public var doValidationsYN:					Bool = true
	public private(set) weak var collection:	ProtocolModelItemCollection?
	
	
	// MARK: - Public Stored Properties

	public var keys =							[String:Int]()
	
	// These indexes define the range of properties in the enum
	public var startEnumIndex:					Int	= 0
	public var endEnumIndex:					Int	= 0
	
	public let idKey:							String = "ID"
	public let previousIDKey:					String = "PreviousID"
	public let rowNumberKey:					String = "RowNumber"
	public let statusKey:						String = "status"
	
	// Culture formatters used to define how data is stored and how data is output
	public var storageDateFormatter:			DateFormatter?
	public var outputDateFormatter:				DateFormatter?
	
	
	// MARK: - Initializers
	
	public override init() {
		super.init()
	}
	
	public init(collection: 			ProtocolModelItemCollection,
				storageDateFormatter:	DateFormatter) {
		super.init()
		
		self.collection				= collection
		self.dataNode				= [String:Any]()
		self.storageDateFormatter	= storageDateFormatter
		
		self.status					= ModelItemStatusTypes.new
		self.setup()
	}
	
	
	// MARK: - Public Methods
	
	public func setup() {
		
		// Setup the data node
		initialiseDataNode()
		
		// Setup the data item
		initialiseDataItem()
		
		// Setup the property indexes and keys
		initialisePropertyIndexes()
		initialisePropertyKeys()
		initialiseSearchPropertyIndexes()
		
		// Setup culture formatting
		self.outputDateFormatter = self.storageDateFormatter
		
	}
	
	public func doSetProperty(key: String, value: String) {
		
		if (self.dataNode != nil) {
			self.dataNode![key] = value
		}
		
	}
	
	public func initialiseSearchPropertyIndexes() {
		searchPropertyIndexes = [Int]()
	}
	
	public func getNullValue(key: String) -> String {
		return ""
	}
	
	public func toKey(propertyEnum: Int) -> String {
		
		// Get the key for the specified enum value
		for (key, value) in self.keys {
			if (value == propertyEnum) { return key }
		}
		
		return ""
	}

	public func toEnum(key: String) -> Int {
		
		// Get the enum value for the specified key
		if let value = self.keys[key] {
			return value
		} else {
			return 0
		}
		
	}
	
	public var properties: [String: Any]? {
		get {
			return self.dataNode
		}
	}
	
	public func getStorageDateString(fromDate date: Date) -> String {
		
		var result: 				String? = nil
		
		// Get dateFormatter
		let dateFormatter:			DateFormatter = DateFormatter()
		dateFormatter.timeZone 		= TimeZone(secondsFromGMT: 0)
		
		// "dd-MM-yyyy HH:mm:ss a"
		dateFormatter.dateFormat	= "dd-MM-yyyy HH:mm:ss a"
		result 						= dateFormatter.string(from: date)
		
		if (result != nil) { return result! }
		
		return ""
		
	}
	
	public func doParseToStorageDateString(value: String, fromDateFormatter: DateFormatter) -> String {
		
		var result: String = ""
		
		// Parse the value to a Date using fromDateFormatter
		var d: Date? = nil
		d = fromDateFormatter.date(from: value)
		
		if (d != nil) {
			
			// Get string from Date using the storageDateFormatter
			result = self.storageDateFormatter?.string(from: d!) ?? ""
		
		}
		
		return result
		
	}
	
	
	// MARK: - Open [Overridable] Methods
	
	open func initialiseDataNode() {
		// Override
		
		self.doSetProperty(key: idKey, value: "0")
		self.doSetProperty(key: rowNumberKey, value: "0")
		
	}
	
	open func initialiseDataItem() {
		// Override
	}
	
	open func initialisePropertyIndexes() {
		// Override
	}
	
	open func initialisePropertyKeys() {
		// Override
	}

	open var dataType: String {
		get {
			// Override
			
			return "ModelItemBase"
		}
	}
	
	open func clone(item: ProtocolModelItem) {
		// Override
	}
	
	open func copyToWrapper() -> DataJSONWrapper {
		
		// Override
		
		return DataJSONWrapper()
	}
	
	open func copyFromWrapper(dataWrapper: DataJSONWrapper, fromDateFormatter: DateFormatter) {
		
		// Override
	}
	
	// This method may be overridden to implement culture specific formatting
	open func getProperty(propertyEnum: Int) -> String? {
		
		// Get the key
		let key: String = self.toKey(propertyEnum: propertyEnum)
		
		guard	let properties	= self.dataNode,
				let value		= properties[key] else {
				return nil
		}
		
		return (value as! String)
	}

	// This method may be overridden to implement culture specific formatting
	open func getProperty(propertyEnum: Int, toDateFormatter: DateFormatter) -> String? {
		
		return self.getProperty(propertyEnum: propertyEnum)
		
	}
	
	// This method may be overridden to implement culture specific formatting
	open func getProperty(key: String) -> String? {
		
		guard	let properties	= self.dataNode,
				let value		= properties[key] else {
				return nil
		}
		
		return (value as! String)
	}

	// This method may be overridden to implement culture specific formatting
	open func getProperty(key: String, toDateFormatter: DateFormatter) -> String? {
		
		// Get the enum value for the property
		let propertyEnum: Int = self.toEnum(key: key)

		return self.getProperty(propertyEnum: propertyEnum, toDateFormatter: toDateFormatter)
		
	}
	
	// This method may be overridden to implement culture specific formatting
	open func setProperty(propertyEnum: Int, value: String, setWhenInvalidYN: Bool) {
		
		// Get the key
		let key:String = self.toKey(propertyEnum: propertyEnum)
		
		self.setProperty(key: key, value: value, setWhenInvalidYN: setWhenInvalidYN)
	}
	
	// This method may be overridden to implement culture specific formatting
	open func setProperty(propertyEnum: Int,
						  value: String,
						  setWhenInvalidYN: Bool,
						  fromDateFormatter: DateFormatter) {
		
		self.setProperty(key: self.toKey(propertyEnum: propertyEnum),
						 value: value,
						 setWhenInvalidYN: setWhenInvalidYN,
						 fromDateFormatter: fromDateFormatter)
		
	}
	
	// This method may be overridden to implement culture specific formatting
	open func setProperty(key: String, value: String, setWhenInvalidYN: Bool) {
		var value = value
		
		var isModifiedYN:	Bool		= true
		
		// Get the property's null value
		if (value == "") {
			value = self.getNullValue(key: key)
		}
		
		// Get the enum value for the property
		let propertyEnum:	Int			= self.toEnum(key: key)
		
		if (self.doValidationsYN) {
			
			// Perform the validation
			let validationResult = self.isValid(propertyEnum: propertyEnum, value: value)
			
			switch validationResult {
			case ValidationResultTypes.passed :
				
				// Set the value
				self.doSetProperty(key: key, value: value)
				
				// Actions following a successful validation
				let message: String = ""
				self.afterValidationPassed(propertyEnum: propertyEnum, message: message, resultType: validationResult)
				
				break
				
			case ValidationResultTypes.warning :
				
				// Set the value
				self.doSetProperty(key: key, value: value)
				
				// Actions following a warning
				self.afterValidationPassed(propertyEnum: propertyEnum, message: self.validationMessage!, resultType: validationResult)
				
				break
				
			case ValidationResultTypes.failed :
				
				// Set the value if required
				if (setWhenInvalidYN) {
					self.doSetProperty(key: key, value: value)
				} else {
					isModifiedYN = false
				}
				
				// Actions following a failed validation
				self.afterValidationFailed(propertyEnum: propertyEnum, message: self.validationMessage!, resultType: validationResult)
				
				break
			}
			
		} else {
			
			// Set the value
			self.doSetProperty(key: key, value: value)
		}
		
		// Raise the notification
		if (isModifiedYN) {
			self.onModified(propertyEnum: propertyEnum, message: "")
		}
	}
	
	// This method may be overridden to implement culture specific formatting
	open func setProperty(key: String,
						  value: String,
						  setWhenInvalidYN: Bool,
						  fromDateFormatter: DateFormatter) {
		
		guard (self.dataNode?[key] != nil) else {
			return
		}
		
		self.setProperty(key: key, value: value, setWhenInvalidYN: setWhenInvalidYN)
		
	}
	
}

// MARK: - Extension ProtocolModelItem

extension ModelItemBase: ProtocolModelItem {
	
	// MARK: - Public Computed Properties
	
	public var id: String {
		get {
			
			return self.getProperty(key: idKey)!
		}
		set(value) {
			var previousID = ""

			if	let idValue	= self.dataNode?[idKey]! as? String {
				
				previousID 			= idValue
				
				self.previousID 	= previousID
				
			}
			
			self.setProperty(key: idKey, value: value, setWhenInvalidYN: true)
			
			// Raise the notification
			self.onPrimaryKeyModified(previousID: previousID)
		}
	}

	public var previousID: String {
		get {
			
			return self.getProperty(key: previousIDKey)!
		}
		set(value) {

			self.setProperty(key: previousIDKey, value: value, setWhenInvalidYN: true)

		}
	}
	
	public var rowNumber: Int {
		get {
			
			return Int(self.getProperty(key: rowNumberKey)!)!
		}
		set(value) {
			
			self.setProperty(key: rowNumberKey, value: String(value), setWhenInvalidYN: false)
		}
	}
	
	public var status: ModelItemStatusTypes {
		get {
			guard	let properties	= self.dataNode,
					let status		= ModelItemStatusTypes(rawValue: Int(properties[statusKey]! as! String)!) else {
					return ModelItemStatusTypes.obsolete
			}
			
			return status
		}
		set(value) {

			let s : String = String(value.rawValue)
			
			self.doSetProperty(key: statusKey, value: s)
			
			// Raise the notification
			self.onStatusChanged(message: s)
		}
	}
	
	
	// MARK: - Public Methods
	
	public func validate() {
		
		// Go through each enum item
		for i in self.startEnumIndex...self.endEnumIndex {
			
			// Get the value of the property
			let value: String? = self.getProperty(propertyEnum: i)
			
			// Perform the validation by setting the property
			if (value != nil) { self.setProperty(propertyEnum: i, value: value!, setWhenInvalidYN: false) }
		}
		
	}
	
	public func remove() {

		self.status = ModelItemStatusTypes.deleted
	}
	
	public func getPropertyEnums() -> [Int] {
		
		var values = [Int]()
		
		// Go through each enum item
		for i in self.startEnumIndex...self.endEnumIndex {
			values.append(i)
		}
		
		return values
	}
	
	public func getPropertyKeys() -> [String] {
		
		var values = [String]()
		
		// Go through each enum item
		for i in self.startEnumIndex...self.endEnumIndex {
			values.append(self.toKey(propertyEnum: i))
		}
		
		return values
	}
	
	public func containsPropertyValue(value: String) -> Bool {
		
		// Go through each enum item
		for i in self.startEnumIndex...self.endEnumIndex {
			
			// Only query the property if it has been specified in the search property indexes list
			if let indexes = self.searchPropertyIndexes {
				
				if (indexes.contains(where: { $0 == 1 })) {
					
					// Get the property value
					if let v = self.getProperty(propertyEnum: i) {

						// If the property contains the specified search value then return true
						if v.lowercased().range(of:value.lowercased()) != nil {
							return true
						}
					}
				}
			}
		}
		
		return false
	}
	
	
	// MARK: - Delegate Notifications
	
	public func onModified(propertyEnum: Int, message: String) {
		
		// Notify the delegate
		delegate?.modelItem(item: self, modifiedFor: propertyEnum, message: message)
		
		if (self.status == ModelItemStatusTypes.unmodified) { self.status = ModelItemStatusTypes.modified }
	}
	
	public func onStatusChanged(message: String) {
		
		// Notify the delegate
		delegate?.modelItem(item: self, statusChangedTo: self.status, message: message)

	}
	
	public func onPrimaryKeyModified(previousID: String) {
		
		// Notify the delegate
		delegate?.modelItem(item: self, primaryKeyModifiedTo: self.id, previousID: previousID)

	}

}
