//
//  DMControlManager.swift
//  Smart.Foundation
//
//  Created by David on 20/07/2017.
//  Copyright © 2017 com.smartfoundation. All rights reserved.
//

import SFController

/// Manages the DM control layer
public class DMControlManager : ControlManagerBase {

	// MARK: - Public Stored Properties
	
	public var viewManager:	DMViewManager?
	
	
	// MARK: - Initializers
	
	public override init() {
		super.init()
	}
	
	public init(modelManager: ModelManager, viewManager: DMViewManager) {
		super.init(modelManager: modelManager)

		self.viewManager	= viewManager
	}
	
	
	// MARK: - Public Methods
	
	public func displayView() {
	
		// TODO: implement
	}
	
	public func loadModel(oncomplete completionHandler:@escaping (Error?) -> Void) {
		
		// Create completion handler
		let loadCompletionHandler: ((Error?) -> Void) =
		{
			(error) -> Void in
			
			// Call completion handler
			completionHandler(error)
		}
		
		self.getDMModelAdministrator().load(oncomplete: loadCompletionHandler)
	}
	
	public func getNumberofItemsLoaded() -> Int {
		
		var result: Int = 0
		
		if let collection = self.getDMModelAdministrator().collection {
			
			// Go through each item
			for item in collection.items! {
				
				// Count items that are not deleted or obsolete
				if (item.status != .deleted && item.status != .obsolete) { result += 1 }
			}
		}
		
		return result
	}
	
	public func getNumberofItems(oncomplete completionHandler:@escaping (Int, Error?) -> Void) {
	
		self.getDMModelAdministrator().countAll(oncomplete: completionHandler)
	
	}
	
	public func getItems() -> [DM] {
		
		var result = [DM]()
		
		if let collection = self.getDMModelAdministrator().collection {
			
			let collection = collection as! DMCollection
			
			// Go through each item
			for item in collection.items! {
				
				// Include items that are not deleted or obsolete
				if (item.status != .deleted && item.status != .obsolete) { result.append(item as! DM) }
			}
		}
		
		return result
	}
	
	public func addItem(oncomplete completionHandler:@escaping (Error?) -> Void) {
		
		// Create completion handler
		let saveCompletionHandler: ((Error?) -> Void) =
		{
			(error) -> Void in
			
			// Call completion handler
			completionHandler(error)
		}
		
		// Create new item
		let item = self.getDMModelAdministrator().collection!.addItem() as! DM
		
		item.stringvalue	= self.viewManager!.getStringValue()
		item.numericvalue	= Int((self.viewManager?.getNumericValue())!)!
		
		// Save the data
		self.getDMModelAdministrator().save(oncomplete: saveCompletionHandler)
	}
	
	public func updateItem() {
		
		// Create completion handler
		let saveCompletionHandler: ((Error?) -> Void) =
		{
			(error) -> Void in
			
		}
		
		let id: String			= self.viewManager!.getID()
		
		// Get the item
		if let item = self.getDMModelAdministrator().collection!.getItem(id: id) as? DM {
	
			item.stringvalue	= self.viewManager!.getStringValue()
			item.numericvalue	= Int((self.viewManager?.getNumericValue())!)!
			
			// Save the data
			self.getDMModelAdministrator().save(oncomplete: saveCompletionHandler)
		}
	}
	
	public func deleteItem() {
		
		// Create completion handler
		let saveCompletionHandler: ((Error?) -> Void) =
		{
			(error) -> Void in
			
		}
		
		let id: String			= self.viewManager!.getID()
		
		// Get the item
		if let item = self.getDMModelAdministrator().collection!.getItem(id: id) as? DM {
			
			item.remove()
			
			// Save the data
			self.getDMModelAdministrator().save(oncomplete: saveCompletionHandler)
		}
		
	}
	
	
	// MARK: - Private Methods
	
	fileprivate func getDMModelAdministrator() -> DMModelAdministrator {
		
		return (self.modelManager! as! ModelManager).getDMModelAdministrator!
	}
}
