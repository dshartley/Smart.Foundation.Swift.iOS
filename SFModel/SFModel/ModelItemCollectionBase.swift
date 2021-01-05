//
//  ModelItemCollectionBase.swift
//  SFModel
//
//  Created by David on 22/06/2017.
//  Copyright © 2017 com.smartfoundation. All rights reserved.
//

/// A base class for classes which encapsulate a collection of model items
open class ModelItemCollectionBase {

	// MARK: - Private Stored Properties
	
	
	// MARK: - ProtocolModelItemCollection Public Stored Properties

	public fileprivate(set) var items:						[ProtocolModelItem]?
	public fileprivate(set) weak var modelAdministrator:	ProtocolModelAdministrator?
	
	
	// MARK: - Public Stored Properties
	
	public weak var delegate: 								ProtocolModelItemCollectionDelegate?
	public var allowDuplicateEmptyIDsYN:					Bool = false
	
	// Culture information formatters used to define how data is stored and how data is output
	public var storageDateFormatter:						DateFormatter?
	
	
	// MARK: - Initializers
	
	public init() {
		
		let dataDocument: [[String : Any]] = [[String : Any]]()
		
		self.storageDateFormatter = DateFormatter()
		
		self.setupCollection(dataDocument: dataDocument,
							 fromDateFormatter: self.storageDateFormatter!)
	}
	
	public init(modelAdministrator: 	ProtocolModelAdministrator,
				storageDateFormatter:	DateFormatter) {
		
		self.modelAdministrator 	= modelAdministrator
		self.storageDateFormatter 	= storageDateFormatter
		
		let dataDocument: 			[[String : Any]] = [[String : Any]]()
		
		self.setupCollection(dataDocument: dataDocument,
							 fromDateFormatter: self.storageDateFormatter!)
	}

	public init(dataDocument:			[[String : Any]],
				modelAdministrator: 	ProtocolModelAdministrator,
				fromDateFormatter: 		DateFormatter,
				storageDateFormatter:	DateFormatter) {

		self.modelAdministrator 	= modelAdministrator
		self.storageDateFormatter 	= storageDateFormatter
		
		self.setupCollection(dataDocument: dataDocument,
							 fromDateFormatter: fromDateFormatter)
	}
	
	
	// MARK: - Public Methods
	
	public func exists(id: String) -> Bool {
		
		// Go through each item
		for item in self.items! {
			
			if (item.id == id) { return true }
		}
		
		// If it wasn't found then return false
		return false
	}
	
	public func addItemLowOverhead(item: ProtocolModelItem) {
		
		(item as? ModelItemBase)?.delegate = self as ProtocolModelItemDelegate
		
		// Add it to the collection
		self.items?.append(item)
		
		// Make sure the item is fully created
		//item.endCreate()
	}
	
	public func compareItems(byInt propertyEnum: Int, ascending: Bool, firstItem: ProtocolModelItem, secondItem: ProtocolModelItem) -> Bool {
		
		// Get the property values
		
		let firstValue: 	Int = Int(firstItem.getProperty(propertyEnum: propertyEnum)!) ?? 0
		let secondValue: 	Int = Int(secondItem.getProperty(propertyEnum: propertyEnum)!) ?? 0
		
		// Return true if first item should be ordered before second item; otherwise, false
		var result: 		Bool = false
		
		if (ascending) {
			
			// Ascending; 1, 2, 3
			if (firstValue <= secondValue) { result = true }
			
		} else {
			
			// Descending; 3, 2, 1
			if (firstValue > secondValue) { result = true }
		}
		
		return result
	}
	
	
	// MARK: - Open [Overridable] Methods
	
	open var dataType: String
	{
		get { return "ModelItemBase" }
	}
	
	open func getNewItem() -> ProtocolModelItem? {
		
		// Override
		
		return nil
	}
	
	open func getNewItem(dataNode:[String: Any], fromDateFormatter: DateFormatter) -> ProtocolModelItem? {
		
		// Override
		
		return nil
	}
	
	open func getNextID() -> String {
		
		// Note: item.id changed to string to allow for different database implementations
		// ie. SQLServer uses auto incrementing numeric ID, whereas Firebase uses string key
		
		//var highest = 0
		
		// Find the highest current ID
//		for item in self.items! {
//			
//			if (item.id >= highest) { highest = item.id }
//		}
		
		//return highest + 1
		
		return UUID().uuidString
	}
	
	open func compareItems(by propertyEnum: Int, ascending: Bool, firstItem: ProtocolModelItem, secondItem: ProtocolModelItem) -> Bool {
		
		// Get the property values
		let firstValue: 	String = firstItem.getProperty(propertyEnum: propertyEnum) ?? ""
		let secondValue: 	String = secondItem.getProperty(propertyEnum: propertyEnum) ?? ""
		
		// Return true if first item should be ordered before second item; otherwise, false
		var result: 		Bool = false
		
		if (ascending) {
			
			// Ascending; a, b, c
			if (firstValue <= secondValue) { result = true }
			
		} else {
			
			// Descending; c, b, a
			if (firstValue > secondValue) { result = true }
		}
		
		return result
	}

	
	// MARK: - Private Methods
	
	fileprivate func setupCollection(dataDocument: [[String : Any]],
									 fromDateFormatter: DateFormatter) {
	
		// Create a new collection
		self.items = [ProtocolModelItem]()
		
		// For each node in the data create an item in the collection
		for dataNode: [String: Any] in dataDocument {
		
			let item: ProtocolModelItem = self.getNewItem(dataNode: dataNode,
														  fromDateFormatter: fromDateFormatter)!
			
			self.addItemLowOverhead(item: item)
		}
	}
	
}

// MARK: - Extension ProtocolModelItemCollection

extension ModelItemCollectionBase: ProtocolModelItemCollection {
	
	// MARK: - Public Computed Properties
	
	public var dataDocument: [[String : Any]] {
		get {
			var result: [[String : Any]] = [[String : Any]]()
			
			guard (self.items != nil) else { return result }
			
			// Go through each item
			for (_, item) in self.items!.enumerated() {
				
				result.append(item.dataNode!)
			}
			
			return result
		}
	}
	
	
	// MARK: - Public Methods
	
	public func clear() {
		
		if (self.items == nil) { return }
		
		self.items = [ProtocolModelItem]()
	}
	
	public func addItem() -> ProtocolModelItem {
		
		// Create a new item
		let item: ProtocolModelItem = self.getNewItem()!
		
		self.addItem(item: item)
		
		return item
	}
	
	public func addItem(item: ProtocolModelItem) {
		
		self.addItemLowOverhead(item: item)

		self.onItemStatusChanged(item: item, status: item.status, message: "")
	}
	
	public func removeItem(item: ProtocolModelItem) {
		
		self.removeItem(id: item.id)
	}
	
	public func removeItem(id: String) {
		
		// Get the item from the collection
		if let actualItem: ProtocolModelItem = self.getItem(id: id) {
			
			// Remove the node
			actualItem.remove()
			
			self.onItemStatusChanged(item: actualItem, status: actualItem.status, message: "")
		}
	}
	
	public func getItem(id: String) -> ProtocolModelItem? {
	
		// Go through each item
		for item in self.items! {
			
			if (item.id == id) { return item }
		}
		
		return nil
	}
	
	public func getItem(propertyEnum: Int, value: String) -> ProtocolModelItem? {
		
		// Go through each item
		for item in self.items! {
			
			if let actualValue = item.getProperty(propertyEnum: propertyEnum)?.lowercased() {
				
				if (actualValue == value.lowercased()) { return item }
			}
		}
		
		return nil
	}

	public func getItem(propertyKey: String, value: String) -> ProtocolModelItem? {
		
		// Go through each item
		for item in self.items! {
			
			if let actualValue = item.getProperty(key: propertyKey)?.lowercased() {
				
				if (actualValue == value.lowercased()) { return item }
			}
		}
		
		return nil
	}
	
	public func getItems(propertyEnum: Int, value: String) -> [ProtocolModelItem] {
		
		var items = [ProtocolModelItem]()
		
		// Go through each item
		for item in self.items! {
			
			if let actualValue = item.getProperty(propertyEnum: propertyEnum)?.lowercased() {
				
				if (actualValue == value.lowercased()) { items.append(item) }
			}
		}
		
		return items
	}
	
	public func getItems(propertyKey: String, value: String) -> [ProtocolModelItem] {
		
		var items = [ProtocolModelItem]()
		
		// Go through each item
		for item in self.items! {
			
			if let actualValue = item.getProperty(key: propertyKey)?.lowercased() {
				
				if (actualValue == value.lowercased()) { items.append(item) }
			}
		}
		
		return items
	}

	public func setSetting(key: String, value: Any) {
		
		guard self.modelAdministrator == nil else { return }
		
		self.modelAdministrator!.setSetting(key: key, value: value)
	}

	public func getSetting(key: String) -> Any? {
		
		guard self.modelAdministrator == nil else { return nil }
		
		return self.modelAdministrator!.getSetting(key: key)
	}
	
	public func sortBy(propertyEnum: Int, ascending: Bool) -> [ProtocolModelItem] {
		
		// Sort the items
		self.items!.sort { (firstItem, secondItem) -> Bool in
			
			// Return true if first item should be ordered before second item; otherwise, false
			return self.compareItems(by: propertyEnum, ascending: ascending, firstItem: firstItem, secondItem: secondItem)
		}
		
		return self.items!
	}
	
	
	// MARK: - Delegate Notifications
	
	public func onItemModified(item: ProtocolModelItem, propertyEnum:Int, message: String) {
		
		// Notify the delegate
		delegate?.modelItemCollection(item: item, itemModifiedFor: propertyEnum, message: message)

	}
	
	public func onItemStatusChanged(item: ProtocolModelItem, status: ModelItemStatusTypes, message: String) {
		
		// Notify the delegate
		delegate?.modelItemCollection(item: item, itemStatusChangedTo: status, message: message)

	}
	
	public func onItemPrimaryKeyModified(item: ProtocolModelItem, id: String, previousID: String) {
		
		// Notify the delegate
		delegate?.modelItemCollection(item: item, itemPrimaryKeyModifiedTo: id, previousID: previousID)

	}
	
	public func onItemValidationPassed(item: ProtocolHasValidations, propertyEnum: Int, message: String, resultType: ValidationResultTypes) {
		
		// Notify the delegate
		delegate?.modelItemCollection(item: item, itemValidationPassedFor: propertyEnum, message: message, resultType: resultType)

	}
	
	public func onItemValidationFailed(item: ProtocolHasValidations, propertyEnum: Int, message: String, resultType: ValidationResultTypes) {
		
		// Notify the delegate
		delegate?.modelItemCollection(item: item, itemValidationFailedFor: propertyEnum, message: message, resultType: resultType)

	}
	
}

// MARK: - Extension ProtocolModelItemDelegate

extension ModelItemCollectionBase: ProtocolModelItemDelegate {

	// Public Methods
	
	public func modelItem(item: ProtocolModelItem, modifiedFor propertyEnum: Int, message: String) {
		
		// Propagate the notification
		self.onItemModified(item: item, propertyEnum: propertyEnum, message: message)
	}
	
	public func modelItem(item: ProtocolModelItem, statusChangedTo status: ModelItemStatusTypes, message: String) {
		
		// Propagate the notification
		self.onItemStatusChanged(item: item, status: status, message: message)
	}
	
	public func modelItem(item: ProtocolModelItem, primaryKeyModifiedTo id: String, previousID: String) {
		
		// Propagate the notification
		self.onItemPrimaryKeyModified(item: item, id: id, previousID: previousID)
	}
	
}

// MARK: - Extension ProtocolHasValidationsDelegate

extension ModelItemCollectionBase: ProtocolHasValidationsDelegate {

	// Public Methods
	
	public func hasValidations(item: ProtocolHasValidations, validationPassedFor propertyEnum: Int, message: String, resultType: ValidationResultTypes) {
		
		// Propagate the notification
		self.onItemValidationPassed(item: item, propertyEnum: propertyEnum, message: message, resultType: resultType)
	}
	
	public func hasValidations(item: ProtocolHasValidations, validationFailedFor propertyEnum: Int, message: String, resultType: ValidationResultTypes) {
		
		// Propagate the notification
		self.onItemValidationFailed(item: item, propertyEnum: propertyEnum, message: message, resultType: resultType)
	}
	
}


