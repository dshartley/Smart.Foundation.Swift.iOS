//
//  RelativeTimelineEventModelAdministrator.swift
//  SFSocial
//
//  Created by David on 04/01/2018.
//  Copyright © 2018 com.smartfoundation. All rights reserved.
//

import SFModel

/// Manages RelativeTimelineEvent data
public class RelativeTimelineEventModelAdministrator: ModelAdministratorBase {
	
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
	
	public func insert(item: ProtocolModelItem, forRelativeMemberIDs: [String], oncomplete completionHandler:@escaping (String, Error?) -> Void) {
		
		// Create completion handler
		let insertCompletionHandler: ((String, Error?) -> Void) =
		{
			(id, error) -> Void in
		
			// Call completion handler
			completionHandler(id, error)
			
		}
		
		// Insert the data
		(self.modelAccessStrategy as! ProtocolRelativeTimelineEventModelAccessStrategy).insert(item: item, forRelativeMemberIDs: forRelativeMemberIDs, oncomplete: insertCompletionHandler)
		
	}
	
	public func select(byForRelativeMemberID forRelativeMemberID: String,
					   applicationID: String,
					   currentRelativeMemberID: String,
					   scopeType: RelativeTimelineEventScopeTypes,
					   relativeTimelineEventTypes: [RelativeTimelineEventTypes],
					   previousRelativeTimelineEventID: String,
					   numberOfItemsToLoad: Int,
					   selectItemsAfterPreviousYN: Bool,
					   oncomplete completionHandler:@escaping ([Any]?, Error?) -> Void) {
		
		self.setupCollection()
		
		// Create completion handler
		let selectCompletionHandler: (([String:Any]?, ProtocolModelItemCollection?, Error?) -> Void) =
		{
			(data, collection, error) -> Void in
			
			if (data != nil && error == nil) {
				
				// Load relational tables
				self.doLoadRelationalTables(data: data!, tableNames: ["RelativeMembers", "RelativeInteractions"])
				
			}
			
			self.doAfterLoad()
			
			// Call completion handler
			completionHandler(self.collection!.dataDocument, error)
		}
		
		// Load the data
		(self.modelAccessStrategy as! ProtocolRelativeTimelineEventModelAccessStrategy).select(byForRelativeMemberID: forRelativeMemberID,
																	applicationID: applicationID,
																	currentRelativeMemberID: currentRelativeMemberID,
																	scopeType: scopeType,
																	relativeTimelineEventTypes: relativeTimelineEventTypes,
																	previousRelativeTimelineEventID: previousRelativeTimelineEventID,
																	numberOfItemsToLoad: numberOfItemsToLoad,
																	selectItemsAfterPreviousYN: selectItemsAfterPreviousYN,
																	collection: self.collection!,
																	oncomplete: selectCompletionHandler)
		
	}
	
	public func select(byRelativeInteractionID relativeInteractionID: String,
					   applicationID: String,
					   oncomplete completionHandler:@escaping ([Any]?, Error?) -> Void) {
		
		self.setupCollection()
		
		// Create completion handler
		let selectCompletionHandler: (([String:Any]?, ProtocolModelItemCollection?, Error?) -> Void) =
		{
			(data, collection, error) -> Void in
			
			if (data != nil && error == nil) {
				
				// Load relational tables
				self.doLoadRelationalTables(data: data!, tableNames: ["RelativeMembers", "RelativeInteractions"])
				
			}
			
			self.doAfterLoad()
			
			// Call completion handler
			completionHandler(self.collection!.dataDocument, error)
		}
		
		// Load the data
		(self.modelAccessStrategy as! ProtocolRelativeTimelineEventModelAccessStrategy).select(byRelativeInteractionID: relativeInteractionID,
																	applicationID: applicationID,
																	collection: self.collection!,
																	oncomplete: selectCompletionHandler)
		
	}
	
	public func toWrappers() -> [RelativeTimelineEventWrapper] {
		
		var result:             [RelativeTimelineEventWrapper] = [RelativeTimelineEventWrapper]()
		
		if let collection = self.collection {
			
			let collection:     RelativeTimelineEventCollection = collection as! RelativeTimelineEventCollection
			
			// Go through each item
			for item in collection.items! {
				
				// Include items that are not deleted or obsolete
				if (item.status != .deleted && item.status != .obsolete) {
					
					// Get item wrapper
					let wrapper: RelativeTimelineEventWrapper = (item as! RelativeTimelineEvent).toWrapper()
					
					result.append(wrapper)
					
				}
				
			}
			
		}
		
		return result
	}
	
	
	// MARK: - Override Methods
	
	public override func newCollection() -> ProtocolModelItemCollection? {
		
		return RelativeTimelineEventCollection(modelAdministrator: self,
											   storageDateFormatter: self.storageDateFormatter!)
	}
	
	public override func setupForeignKeys() {
		
		// No foreign keys
	}
	
	
	// MARK: - Private Methods
	
}
