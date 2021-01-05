//
//  CacheManagerBase.swift
//  SFController
//
//  Created by David on 09/12/2017.
//  Copyright © 2017 com.smartfoundation. All rights reserved.
//

import CoreData
import SFModel
import SFSerialization

/// A base class for classes which manage cacheing
open class CacheManagerBase {
	
	// MARK: - Private Stored Properties
	
	
	// MARK: - Private Static Properties

	
	// MARK: - Public Stored Properties
	
	public var managedObjectContext:		NSManagedObjectContext? = nil
	public var entityName: 					String = ""
	public var collection:					ProtocolModelItemCollection? = nil
	public var predicate:					NSPredicate?
	
	
	// MARK: - Initializers
	
	public init() {
	}
	
	
	// MARK: - Public Methods
	
	public func set(managedObjectContext: NSManagedObjectContext) {
		
		self.managedObjectContext = managedObjectContext
	}
	
	public func saveImageToCache(imageData: Data, fileName: String) {
		
		let fileManager: FileManager = FileManager.default
		
		do {
			let documentDirectoryUrl:	URL	= try fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor:nil, create:false)
			let fileUrl:				URL = documentDirectoryUrl.appendingPathComponent(fileName)
			
			try imageData.write(to: fileUrl)
			
		} catch {
			// Not required
		}
		
	}
	
	public func saveStringToCache(dataString: String) {
		
		guard (	self.managedObjectContext != nil) else { return }
		
		// Fetch data
		var cacheData:				NSManagedObject?			= self.doFetchDataFromCache()
		
		// Check cacheData is nil
		if (cacheData == nil) {
			
			// Get cacheDataEntity
			let cacheDataEntity:	NSEntityDescription			= NSEntityDescription.entity(forEntityName: self.entityName, in: managedObjectContext!)!
			
			// Create new data item
			cacheData = NSManagedObject(entity: cacheDataEntity, insertInto: managedObjectContext!)
			
			// Set attributes
			self.setAttributes(cacheData: cacheData!)
			
		}
		
		// Set dataString
		cacheData!.setValue(dataString, forKeyPath: "dataString")
		
		// Save data
		do {
			try managedObjectContext!.save()
			
		} catch _ as NSError {
			// Not required
		}
		
	}
	
	public func loadStringFromCache() -> String? {
		
		var result:	String? = nil
		
		guard (self.managedObjectContext != nil && self.predicate != nil) else { return nil }
		
		// Fetch data
		let cachedData: NSManagedObject? = self.doFetchDataFromCache()
		
		if let cachedData = cachedData {
			
			// Get dataString
			if let dataString = cachedData.value(forKeyPath: "dataString") as? String {
				
				result = dataString
				
			}
		}

		return result
		
	}
		
	public func loadImageFromCache(with fileName: String) -> Data? {
		
		var result:						Data? = nil
		
		let fileManager:				FileManager = FileManager.default
		
		do {
			let documentDirectoryUrl:	URL = try fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor:nil, create:false)
			let fileUrl:				URL	= documentDirectoryUrl.appendingPathComponent(fileName)
			
			result = fileManager.contents(atPath: fileUrl.path)
			
		} catch {
			// Not required
		}
		
		return result
		
	}

	public func removeImageFromCache(with fileName: String) {

		let fileManager:				FileManager = FileManager.default

		do {
			let documentDirectoryUrl:	URL = try fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor:nil, create:false)
			let fileUrl:				URL	= documentDirectoryUrl.appendingPathComponent(fileName)

			if (fileManager.isDeletableFile(atPath: fileUrl.path)) {

				try fileManager.removeItem(atPath: fileUrl.path)

			}

		} catch {
			// Not required
		}

	}
	
	public func deleteAllFromCache() {
		
		guard (	self.managedObjectContext != nil) else { return }
		
		// Setup fetchRequest
		let fetchRequest:			NSFetchRequest			= NSFetchRequest<NSManagedObject>(entityName: self.entityName)
		
		// Fetch data
		var fetchResult:			[NSManagedObject]?		= nil
		
		do {
			fetchResult	= try self.managedObjectContext!.fetch(fetchRequest)
			
		} catch _ as NSError {
			// Error
		}
		
		// Go through each item
		for (_, item) in fetchResult!.enumerated() {
			
			// Delete item
			self.managedObjectContext!.delete(item)
		}
		
		do {
			try self.managedObjectContext!.save()
			
		} catch _ as NSError {
			// Error
		}
	}

	public func doFetchDataFromCache() -> NSManagedObject? {
		
		guard (self.predicate != nil) else { return nil }
		
		var result:			NSManagedObject?	= nil
		
		// Setup fetchRequest
		let fetchRequest:	NSFetchRequest		= NSFetchRequest<NSManagedObject>(entityName: self.entityName)
		
		fetchRequest.predicate = self.predicate
		
		// Fetch data
		var fetchResult:	[NSManagedObject]?	= nil
		
		do {
			fetchResult	= try self.managedObjectContext!.fetch(fetchRequest)
			
		} catch _ as NSError {
			// Not required
		}
		
		if (fetchResult != nil && fetchResult!.count > 0) {
			
			// Get first item from result
			result = fetchResult!.first
			
		}
		
		return result
	}
	
	public func saveToCache() {
		
		guard (self.managedObjectContext != nil) else { return }
		guard (self.collection != nil) else { return }
		
		// Fetch data
		var cacheData:				NSManagedObject?			= self.doFetchDataFromCache()
		
		// Check cacheData is nil
		if (cacheData == nil) {
			
			// Get cacheDataEntity
			let cacheDataEntity:	NSEntityDescription			= NSEntityDescription.entity(forEntityName: self.entityName, in: managedObjectContext!)!
			
			// Create new data item
			cacheData = NSManagedObject(entity: cacheDataEntity, insertInto: managedObjectContext!)
			
			// Set attributes
			self.setAttributes(cacheData: cacheData!)
			
		}
		
		// Serialize the data
		let dataDictionary:		[String:Any]	= [self.entityName.lowercased() : self.collection!.dataDocument]
		let dataString:			String			= JSONHelper.JSONToString(json: dataDictionary)!
		
		// Set dataString
		cacheData!.setValue(dataString, forKeyPath: "dataString")
		
		// Save data
		do {
			try managedObjectContext!.save()
			
		} catch _ as NSError {
			// Not required
		}
		
	}

	public func loadFromCache() {
		
		var result = [Any]()
		
		guard (self.managedObjectContext != nil && self.predicate != nil) else { return }
		
		// Fetch data
		let cachedData: NSManagedObject? = self.doFetchDataFromCache()
		
		if let cachedData = cachedData {
			
			// Get dataString
			if let dataString = cachedData.value(forKeyPath: "dataString") as? String {
				
				// Deserialize the data
				let dataDictionary: [String:Any]? = JSONHelper.stringToJSON(jsonString: dataString) as? [String:Any]
				
				if (dataDictionary != nil && dataDictionary!.count > 0) {
					
					// Add data element to result
					result = dataDictionary![self.entityName.lowercased()] as! [Any]
				}
				
			}
		}
		
		// Process loaded data
		self.processLoadedData(data: result)

	}
	
	public func select() -> [Any] {
		
		var result: 	[Any] = [Any]()
		
		guard (self.collection != nil) else { return result }

		// Go through each item
		for item in self.collection!.items! {
			
			if (item.status != .deleted && item.status != .obsolete) {
				
				// Get itemData
				let itemData: Any = item.dataNode! as Any
				
				// Append to data
				result.append(itemData)
				
			}
			
		}
		
		return result
	}
	
	
	// MARK: - Open [Overridable] Methods
	
	open func clear() {
		
		self.collection	= nil
		
	}
	
	open func initialiseCacheData() {
		
		// Not implemented
		
	}

	open func shouldSortYN(cacheItem: ProtocolModelItem, sourceItem: ProtocolModelItem) -> Bool {
		
		return false
		
	}
	
	open func sortCollection() {
		
		// Not implemented
		
	}
	
	open func setAttributes(cacheData: NSManagedObject) {
		
		// Not implemented
		
	}

	open func mergeToCache(from sourceItem: ProtocolModelItem) {
		
		guard (self.collection != nil) else { return }
		
		var cacheItem: 	ProtocolModelItem? = nil
		var sortYN: 	Bool = false
		
		if (sourceItem.status != .deleted && sourceItem.status != .obsolete) {
			
			// Find cache item
			cacheItem = self.collection!.getItem(id: sourceItem.id)
			
			if (cacheItem == nil) {
				
				// Create new item
				cacheItem 		= self.collection!.addItem()
			}
			
			// Check should sort
			if (self.shouldSortYN(cacheItem: cacheItem!, sourceItem: sourceItem)) {
				
				sortYN = true
				
			}
			
			// Update item
			cacheItem!.clone(item: sourceItem)
			
		} else {
			
			// Remove item
			self.collection!.removeItem(item: sourceItem)
			
		}
		
		// Check if sortYN
		if (sortYN) {
			
			// Sort the collection
			self.sortCollection()
			
		}
		
	}
	
	open func mergeToCache(from sourceCollection: ProtocolModelItemCollection) {
		
		// Check cache is loaded
		if (self.collection == nil) {
			
			self.loadFromCache()
			
		}
		
		var cacheItem: 	ProtocolModelItem? = nil
		var sortYN: 	Bool = false
		
		// Go through each source item
		for sourceItem in sourceCollection.items! {
			
			if (sourceItem.status != .deleted && sourceItem.status != .obsolete) {
				
				// Find cache item
				cacheItem = self.collection!.getItem(id: sourceItem.id)
				
				if (cacheItem == nil) {
					
					// Create new item
					cacheItem 		= self.collection!.addItem()
				}
				
				// Check should sort
				if (self.shouldSortYN(cacheItem: cacheItem!, sourceItem: sourceItem)) {
					
					sortYN = true
					
				}
				
				// Update item
				cacheItem!.clone(item: sourceItem)
				
			} else {
				
				// Remove item
				self.collection!.removeItem(item: sourceItem)
				
			}
			
		}
		
		// Check if sortYN
		if (sortYN) {
			
			// Sort the collection
			self.sortCollection()
			
		}
		
	}
	
	open func processLoadedData(data: [Any]?) {
		
		// Initialise cache data
		self.initialiseCacheData()
		
		guard (data != nil) else { return }
		
		// Go through each node in the data
		for dataNode in data! {
			
			let dataNode:	[String : Any] = dataNode as! [String : Any]
			
			// Create the item
			let item: 		ProtocolModelItem = self.collection!.getNewItem(dataNode: dataNode,
																			  fromDateFormatter: DateFormatter())!
			
			// Include items that are not deleted or obsolete
			if (item.status != .deleted && item.status != .obsolete) {
				
				// Add the item to the collection
				self.collection!.addItem(item: item)
			}
		}
		
	}
	
	
	// MARK: - Private Methods

	
}

