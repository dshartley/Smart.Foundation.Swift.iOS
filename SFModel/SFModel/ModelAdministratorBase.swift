//
//  ModelAdministratorBase.swift
//  SFModel
//
//  Created by David on 22/06/2017.
//  Copyright © 2017 com.smartfoundation. All rights reserved.
//

import SFSerialization

/// A base class for model administrators
open class ModelAdministratorBase {

	// MARK: - Private Stored Properties

	
	// MARK: - ProtocolModelAdministrator Public Stored Properties
	
	public weak var delegate:										ProtocolModelAdministratorDelegate?
	public var modelAccessStrategy:									ProtocolModelAccessStrategy?
	public fileprivate(set) var collection:							ProtocolModelItemCollection?
	public fileprivate(set) var dataIsLoadedYN:						Bool = false
	public fileprivate(set) var dataIsSavedYN:						Bool = true
	public fileprivate(set) weak var modelAdministratorProvider:	ProtocolModelAdministratorProvider?
	public var insertRelationalItemsYN:								Bool = false
	
	// Culture information formatters used to define how data is stored and how data is output
	public var storageDateFormatter:								DateFormatter?
	
	
	// MARK: - Public Stored Properties
	
	public fileprivate(set) var settings:							[String : Any]?
	
	
	// MARK: - Initializers
	
	public init() {
	}
	
	public init(	modelAccessStrategy:			ProtocolModelAccessStrategy,
	            	modelAdministratorProvider:		ProtocolModelAdministratorProvider,
					storageDateFormatter:			DateFormatter) {
		
		self.modelAccessStrategy		= modelAccessStrategy
		self.modelAdministratorProvider = modelAdministratorProvider
		self.storageDateFormatter 		= storageDateFormatter

		self.setupModelAccessStrategy()
		self.setupCollection()
		self.setupForeignKeys()
		self.setupOmittedKeys()
	}
	
	
	// MARK: - Public Methods
	
	public func setupCollection() {
		
		self.collection = self.newCollection()
		
		(self.collection as? ModelItemCollectionBase)?.delegate = self as ProtocolModelItemCollectionDelegate
	}
	
	public func doAfterLoad() {
		
		self.dataIsLoadedYN = true
		
		self.onDataLoaded()
	}
	
	public func doAfterSave() {
		
		self.dataIsSavedYN = true
		
		self.onDataSaved()
	}
	
	
	// MARK: - Open [Overridable] Methods
	
	open func newCollection() -> ProtocolModelItemCollection? {

		// Overload
		
		return nil
	}
	
	/// Sets up the foreign keys. To setup a foreign key get the model administrator for the relevant foreign key from the model administrator provider and handle the itemPrimaryKeyModified delegate notifications. In handling this notification update the foreign key of items in the collection
	open func setupForeignKeys() {
		// Overload
	}
	
	open func setupOmittedKeys() {
		// Overload
	}
	
	open func doLoadRelationalTables(data: [String:Any]?) {
		
		// Go through each table name
		for tableName in data!.keys {
			
			// Get the modelAdministrator
			let modelAdministrator: ProtocolModelAdministrator? = self.modelAdministratorProvider!.getModelAdministrator(key: tableName)
			
			if (modelAdministrator != nil && modelAdministrator?.collection?.dataType != self.collection?.dataType) {
				
				modelAdministrator!.initialise()
				
				let tableData: [Any] = data![tableName] as! [Any]
				
				// Load from the tableData
				modelAdministrator!.load(data: tableData)
				
			}
			
		}
		
	}
	
	open func doLoadRelationalTables(data: [String:Any]?, tableNames: [String]) {
		
		// Go through each table name
		for tableName in tableNames {
			
			// Get the table
			if (data!.keys.contains(tableName)) {
				
				// Get the modelAdministrator
				let modelAdministrator: ProtocolModelAdministrator? = self.modelAdministratorProvider!.getModelAdministrator(key: tableName)
				
				if (modelAdministrator != nil) {
					
					let tableData: [Any] = data![tableName] as! [Any]
					
					// Load from the tableData
					modelAdministrator!.load(data: tableData)
					
				}
				
			}
			
		}
		
	}

	
	// MARK: - Private Methods
	
	fileprivate func setupModelAccessStrategy() {
		
		(self.modelAccessStrategy as? ModelAccessStrategyBase)?.delegate = self as ProtocolModelAccessStrategyDelegate
		
	}
	
}

// MARK: - Extension ProtocolModelAdministrator

extension ModelAdministratorBase: ProtocolModelAdministrator {

	// MARK: - Public Methods
	
	public var tableName: String {
		get {
			
			return self.modelAccessStrategy?.tableName ?? ""
			
		}
	}
	
	
	// MARK: - Public Methods
	
	public func initialise() {
		
		// Default flags
		self.dataIsLoadedYN = false
		self.dataIsSavedYN	= true
		
		// Setup the collection
		self.setupCollection()
	}
	
	public func load(oncomplete completionHandler:@escaping (Error?) -> Void) {
		
		self.setupCollection()
		
		// Create completion handler
		let selectCompletionHandler: (([String:Any]?, ProtocolModelItemCollection?, Error?) -> Void) =
		{
			(data, collection, error) -> Void in
			
			self.collection = collection
			
			self.doAfterLoad()
			
			// Call completion handler
			completionHandler(error)
		}
		
		// Load the data
		self.modelAccessStrategy!.select(collection: self.collection!, oncomplete: selectCompletionHandler)
		
	}
	
	public func load(data: [Any]) {
		
		self.setupCollection()
		
		// Load the data
		_ = self.modelAccessStrategy!.fillCollection(collection: self.collection!, data: data)
		
		self.doAfterLoad()

	}
	
	public func load(id: Int, oncomplete completionHandler:@escaping (Error?) -> Void) {
		
		self.setupCollection()
		
		// Create completion handler
		let selectCompletionHandler: (([String:Any]?, ProtocolModelItemCollection?, Error?) -> Void) =
		{
			(data, collection, error) -> Void in
			
			self.collection = collection
			
			self.doAfterLoad()
			
			// Call completion handler
			completionHandler(error)
		}
		
		// Load the data
		self.modelAccessStrategy!.select(collection: self.collection!, id: id, oncomplete: selectCompletionHandler)

	}
	
	public func loadItemsBefore(beforeID: Int, includeBeforeIDItemYN: Bool, numberofItems: Int, oncomplete completionHandler:@escaping (Error?) -> Void) {
		
		self.setupCollection()
		
		// Create completion handler
		let selectBeforeCompletionHandler: (([String:Any]?, ProtocolModelItemCollection?, Error?) -> Void) =
		{
			(data, collection, error) -> Void in
			
			self.collection = collection
			
			self.doAfterLoad()
			
			// Call completion handler
			completionHandler(error)
		}
		
		// Load the data
		self.modelAccessStrategy!.selectBefore(collection: self.collection!, beforeID: beforeID, includeBeforeIDItemYN: includeBeforeIDItemYN, numberofItems: numberofItems, oncomplete: selectBeforeCompletionHandler)

	}
	
	public func loadItemsAfter(afterID: Int, includeAfterIDItemYN: Bool, numberofItems: Int, oncomplete completionHandler:@escaping (Error?) -> Void) {
		
		self.setupCollection()
		
		// Create completion handler
		let selectAfterCompletionHandler: (([String:Any]?, ProtocolModelItemCollection?, Error?) -> Void) =
		{
			(data, collection, error) -> Void in
			
			self.collection = collection
			
			self.doAfterLoad()
			
			// Call completion handler
			completionHandler(error)
		}
		
		// Load the data
		self.modelAccessStrategy!.selectAfter(collection: self.collection!, afterID: afterID, includeAfterIDItemYN: includeAfterIDItemYN, numberofItems: numberofItems, oncomplete: selectAfterCompletionHandler)

	}
	
	public func loadItemsBetween(fromRowNumber: Int, toRowNumber: Int, sortBy: Int, oncomplete completionHandler:@escaping (Error?) -> Void) {
		
		self.setupCollection()
		
		// Create completion handler
		let selectBetweenCompletionHandler: (([String:Any]?, ProtocolModelItemCollection?, Error?) -> Void) =
		{
			(data, collection, error) -> Void in
			
			self.collection = collection
			
			self.doAfterLoad()
			
			// Call completion handler
			completionHandler(error)
		}
		
		// Load the data
		self.modelAccessStrategy!.selectBetween(collection: self.collection!, fromRowNumber: fromRowNumber, toRowNumber: toRowNumber, sortBy: sortBy, oncomplete: selectBetweenCompletionHandler)

	}
	
	public func countAll(oncomplete completionHandler:@escaping (Int, Error?) -> Void) {

		// Create completion handler
		let selectCountCompletionHandler: ((Int, Error?) -> Void) =
		{
			(count, error) -> Void in
			
			// Call completion handler
			completionHandler(count, error)
		}
		
		self.modelAccessStrategy!.selectCount(collection: self.collection!, oncomplete: selectCountCompletionHandler)
		
	}
	
	public func save(oncomplete completionHandler:@escaping (Error?) -> Void) {
		
		// Create completion handler
		let commitCompletionHandler: ((Error?) -> Void) =
		{
			(error) -> Void in
			
			self.doAfterSave()
			
			// Call completion handler
			completionHandler(error)
			
		}
		
		// Save the data
		self.modelAccessStrategy!.commit(collection: self.collection!, insertRelationalItemsYN: self.insertRelationalItemsYN, oncomplete: commitCompletionHandler)
		
	}
	
	public func getNewItem() -> ProtocolModelItem {
		
		return self.collection!.getNewItem()!
	}
	
	public func addItem(item: ProtocolModelItem) {
		
		self.collection!.addItem(item: item)
	}
	
	public func removeItem(item: ProtocolModelItem) {
		
		self.collection!.removeItem(item: item)
	}
	
	public func copyItem(item: ProtocolModelItem) -> ProtocolModelItem {
		
		// Get a copy of the data node
		let dataNodeCopy: 	[String : Any] = item.dataNode!
		
		// Get the copy of the item by asking the collection for a new item using the specified node
		let itemCopy: 		ProtocolModelItem = self.collection!.getNewItem(dataNode: dataNodeCopy,
																	  fromDateFormatter: self.storageDateFormatter!)!
		
		return itemCopy
	}
	
	public func toWrapper() -> DataJSONWrapper {
		
		let dataWrapper: DataJSONWrapper = DataJSONWrapper()
		
		// Check the data
		if (self.collection?.items != nil && self.collection!.items!.count > 0) {
			
			// Go through each item
			for item in self.collection!.items! {
				
				// Put the item in a wrapper
				let wrapper: DataJSONWrapper = item.copyToWrapper()

				dataWrapper.Items.append(wrapper)
	
			}
			
		}
		
		return dataWrapper
		
	}
	
	public func setSetting(key: String, value: Any) {
		
		if (self.settings == nil) { self.settings = [String : Any]() }
			
		self.settings![key] = value
	}
	
	public func getSetting(key: String) -> Any? {
		
		if let value = self.settings![key] {
			
			return value
		} else {
			
			return nil
		}
	}

	
	// MARK: - Delegate Notifications
	
	public func onItemModified(item: ProtocolModelItem, propertyEnum:Int, message: String) {
		
		// Notify the delegate
		delegate?.modelAdministrator(item: item, itemModifiedFor: propertyEnum, message: message)

	}
	
	public func onItemStatusChanged(item: ProtocolModelItem, status: ModelItemStatusTypes, message: String) {
		
		// Notify the delegate
		delegate?.modelAdministrator(item: item, itemStatusChangedTo: status, message: message)

	}
	
	public func onItemPrimaryKeyModified(item: ProtocolModelItem, id: String, previousID: String) {
		
		// Notify the delegate
		delegate?.modelAdministrator(item: item, itemPrimaryKeyModifiedTo: id, previousID: previousID)

	}
	
	public func onItemValidationPassed(item: ProtocolHasValidations, propertyEnum: Int, message: String, resultType: ValidationResultTypes) {
		
		// Notify the delegate
		delegate?.modelAdministrator(item: item, itemValidationPassedFor: propertyEnum, message: message, resultType: resultType)

	}
	
	public func onItemValidationFailed(item: ProtocolHasValidations, propertyEnum: Int, message: String, resultType: ValidationResultTypes) {
		
		// Notify the delegate
		delegate?.modelAdministrator(item: item, itemValidationFailedFor: propertyEnum, message: message, resultType: resultType)

	}
	
	public func onDataLoaded() {
		
		// Notify the delegate
		delegate?.modelAdministratorDataLoaded()

	}
	
	public func onDataSaved() {
		
		// Notify the delegate
		delegate?.modelAdministratorDataSaved()

	}
	
}

// MARK: - Extension ProtocolModelItemCollectionDelegate

extension ModelAdministratorBase: ProtocolModelItemCollectionDelegate {

    // MARK: - Public Methods
	
	public func modelItemCollection(item: ProtocolModelItem, itemModifiedFor propertyEnum: Int, message: String) {
		
		// Propagate the notification
		self.onItemModified(item: item, propertyEnum: propertyEnum, message: message)
	}
	
	public func modelItemCollection(item: ProtocolModelItem, itemStatusChangedTo status: ModelItemStatusTypes, message: String) {
		
		// Propagate the notification
		self.onItemStatusChanged(item: item, status: status, message: message)
	}
	
	public func modelItemCollection(item: ProtocolModelItem, itemPrimaryKeyModifiedTo id: String, previousID: String) {
		
		// Propagate the notification
		self.onItemPrimaryKeyModified(item: item, id: id, previousID: previousID)
	}
	
	public func modelItemCollection(item: ProtocolHasValidations, itemValidationPassedFor propertyEnum: Int, message: String, resultType: ValidationResultTypes) {
		
		// Propagate the notification
		self.onItemValidationPassed(item: item, propertyEnum: propertyEnum, message: message, resultType: resultType)
	}
	
	public func modelItemCollection(item: ProtocolHasValidations, itemValidationFailedFor propertyEnum: Int, message: String, resultType: ValidationResultTypes) {
		
		// Propagate the notification
		self.onItemValidationFailed(item: item, propertyEnum: propertyEnum, message: message, resultType: resultType)
	}
	
}

// MARK: - Extension ProtocolModelAccessStrategyDelegate

extension ModelAdministratorBase: ProtocolModelAccessStrategyDelegate {

	// MARK: - Public Methods
	
	public func modelAccessStrategy(getModelAdministratorProvider sender: ProtocolModelAccessStrategy) -> ProtocolModelAdministratorProvider? {
		
		return self.modelAdministratorProvider
		
	}
	
}

