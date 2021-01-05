//
//  RelativeInteractionModelAdministrator.swift
//  SFSocial
//
//  Created by David on 04/01/2018.
//  Copyright © 2018 com.smartfoundation. All rights reserved.
//

import SFModel

/// Manages RelativeInteraction data
public class RelativeInteractionModelAdministrator: ModelAdministratorBase {
	
	// MARK: - Initializers
	
	private override init() {
		super.init()
	}
	
	public override init(modelAccessStrategy:			ProtocolModelAccessStrategy,
						 modelAdministratorProvider:	ProtocolModelAdministratorProvider,
						 storageDateFormatter:			DateFormatter) {
		super.init(modelAccessStrategy: modelAccessStrategy,
				   modelAdministratorProvider: modelAdministratorProvider,
				   storageDateFormatter: storageDateFormatter)
	}
	
	
	// MARK: - Public Methods
	
	public func select(byFromRelativeMemberID fromRelativeMemberID: String, applicationID: String, interactionType: RelativeInteractionTypes, oncomplete completionHandler:@escaping ([Any]?, Error?) -> Void) {
		
		self.setupCollection()
		
		// Create completion handler
		let selectCompletionHandler: (([String:Any]?, ProtocolModelItemCollection?, Error?) -> Void) =
		{
			(data, collection, error) -> Void in
			
			if (data != nil && error == nil) {
				
				// Load relational tables
				self.doLoadRelationalTables(data: data!, tableNames: ["RelativeMembers"])
				
			}
			
			self.doAfterLoad()
			
			// Call completion handler
			completionHandler(self.collection!.dataDocument, error)
		}
		
		// Load the data
		(self.modelAccessStrategy as! ProtocolRelativeInteractionModelAccessStrategy).select(byFromRelativeMemberID: fromRelativeMemberID, applicationID: applicationID, interactionType: interactionType, collection: self.collection!, oncomplete: selectCompletionHandler)
	}
	
	public func select(byToRelativeMemberID toRelativeMemberID: String, applicationID: String, interactionType: RelativeInteractionTypes, oncomplete completionHandler:@escaping ([Any]?, Error?) -> Void) {
		
		self.setupCollection()
		
		// Create completion handler
		let selectCompletionHandler: (([String:Any]?, ProtocolModelItemCollection?, Error?) -> Void) =
		{
			(data, collection, error) -> Void in
			
			if (data != nil && error == nil) {
				
				// Load relational tables
				self.doLoadRelationalTables(data: data!, tableNames: ["RelativeMembers"])
				
			}
			
			self.doAfterLoad()
			
			// Call completion handler
			completionHandler(self.collection!.dataDocument, error)
		}
		
		// Load the data
		(self.modelAccessStrategy as! ProtocolRelativeInteractionModelAccessStrategy).select(byToRelativeMemberID: toRelativeMemberID, applicationID: applicationID, interactionType: interactionType, collection: self.collection!, oncomplete: selectCompletionHandler)
	}
	
	public func toWrappers() -> [RelativeInteractionWrapper] {
		
		var result:             [RelativeInteractionWrapper] = [RelativeInteractionWrapper]()
		
		if let collection = self.collection {
			
			let collection:     RelativeInteractionCollection = collection as! RelativeInteractionCollection
			
			// Go through each item
			for item in collection.items! {
				
				// Include items that are not deleted or obsolete
				if (item.status != .deleted && item.status != .obsolete) {
					
					// Get item wrapper
					let wrapper: RelativeInteractionWrapper = (item as! RelativeInteraction).toWrapper()
					
					result.append(wrapper)
					
				}
				
			}
			
		}
		
		return result
	}
	
	
	// MARK: - Override Methods
	
	public override func newCollection() -> ProtocolModelItemCollection? {
		
		return RelativeInteractionCollection(modelAdministrator: self,
											 storageDateFormatter: self.storageDateFormatter!)
	}
	
	public override func setupForeignKeys() {
		
		// No foreign keys
	}
	
	
	// MARK: - Private Methods
	
}
