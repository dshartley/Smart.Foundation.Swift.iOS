//
//  RelativeMemberModelAdministrator.swift
//  SFSocial
//
//  Created by David on 05/02/2018.
//  Copyright © 2018 com.smartfoundation. All rights reserved.
//

import SFModel

/// Manages RelativeMember data
public class RelativeMemberModelAdministrator: ModelAdministratorBase {
	
	// MARK: - Public Stored Properties
	
	public var loadAvatarImageStrategy: 				ProtocolRelativeMemberLoadAvatarImageStrategy?
	
	
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
	
	public func select(byUserProfileID userProfileID: String, applicationID: String, oncomplete completionHandler:@escaping ([Any]?, Error?) -> Void) {
		
		self.setupCollection()
		
		// Create completion handler
		let selectCompletionHandler: (([String:Any]?, ProtocolModelItemCollection?, Error?) -> Void) =
		{
			(data, collection, error) -> Void in
			
			self.doAfterLoad()
			
			// Call completion handler
			completionHandler(self.collection!.dataDocument, error)
		}
		
		// Load the data
		(self.modelAccessStrategy as! ProtocolRelativeMemberModelAccessStrategy).select(byUserProfileID: userProfileID, applicationID: applicationID, collection: self.collection!, oncomplete: selectCompletionHandler)
	}
	
	public func select(byEmail email: String, applicationID: String, oncomplete completionHandler:@escaping ([Any]?, Error?) -> Void) {
		
		self.setupCollection()
		
		// Create completion handler
		let selectCompletionHandler: (([String:Any]?, ProtocolModelItemCollection?, Error?) -> Void) =
		{
			(data, collection, error) -> Void in
			
			self.doAfterLoad()
			
			// Call completion handler
			completionHandler(self.collection!.dataDocument, error)
		}
		
		// Load the data
		(self.modelAccessStrategy as! ProtocolRelativeMemberModelAccessStrategy).select(byEmail: email, applicationID: applicationID, collection: self.collection!, oncomplete: selectCompletionHandler)
	}

	public func select(byEmail email: String, applicationID: String, connectionContractType: RelativeConnectionContractTypes, currentRelativeMemberID: String, oncomplete completionHandler:@escaping ([Any]?, Error?) -> Void) {
		
		self.setupCollection()
		
		// Create completion handler
		let selectCompletionHandler: (([String:Any]?, ProtocolModelItemCollection?, Error?) -> Void) =
		{
			(data, collection, error) -> Void in
			
			self.doAfterLoad()
			
			// Call completion handler
			completionHandler(self.collection!.dataDocument, error)
		}
		
		// Load the data
		(self.modelAccessStrategy as! ProtocolRelativeMemberModelAccessStrategy).select(byEmail: email, applicationID: applicationID, connectionContractType: connectionContractType, currentRelativeMemberID: currentRelativeMemberID, collection: self.collection!, oncomplete: selectCompletionHandler)
	}
	
	public func select(byID id: String, applicationID: String, connectionContractType: RelativeConnectionContractTypes, currentRelativeMemberID: String, oncomplete completionHandler:@escaping ([Any]?, Error?) -> Void) {
		
		self.setupCollection()
		
		// Create completion handler
		let selectCompletionHandler: (([String:Any]?, ProtocolModelItemCollection?, Error?) -> Void) =
		{
			(data, collection, error) -> Void in
			
			self.doAfterLoad()
			
			// Call completion handler
			completionHandler(self.collection!.dataDocument, error)
		}
		
		// Load the data
		(self.modelAccessStrategy as! ProtocolRelativeMemberModelAccessStrategy).select(byID: id, applicationID: applicationID, connectionContractType: connectionContractType, currentRelativeMemberID: currentRelativeMemberID, collection: self.collection!, oncomplete: selectCompletionHandler)
	}
	
	public func select(byFindText findText: String, applicationID: String, currentRelativeMemberID: String?, scopeType: RelativeMemberScopeTypes, previousRelativeMemberID: String, numberOfItemsToLoad: Int, selectItemsAfterPreviousYN: Bool, oncomplete completionHandler:@escaping ([Any]?, Error?) -> Void) {
		
		self.setupCollection()
		
		// Create completion handler
		let selectCompletionHandler: (([String:Any]?, ProtocolModelItemCollection?, Error?) -> Void) =
		{
			(data, collection, error) -> Void in
			
			self.doAfterLoad()
			
			// Call completion handler
			completionHandler(self.collection!.dataDocument, error)
		}
		
		// Load the data
		(self.modelAccessStrategy as! ProtocolRelativeMemberModelAccessStrategy).select(byFindText: findText, applicationID: applicationID, currentRelativeMemberID: currentRelativeMemberID, scopeType: scopeType, previousRelativeMemberID: previousRelativeMemberID, numberOfItemsToLoad: numberOfItemsToLoad, selectItemsAfterPreviousYN: selectItemsAfterPreviousYN, collection: self.collection!, oncomplete: selectCompletionHandler)
	}
	
	public func select(byAspects aspectTypes: [RelativeMemberQueryAspectTypes], applicationID: String, maxResults: Int, currentRelativeMemberID: String?, scopeType: RelativeMemberScopeTypes, previousRelativeMemberID: String, numberOfItemsToLoad: Int, selectItemsAfterPreviousYN: Bool, oncomplete completionHandler:@escaping ([Any]?, Error?) -> Void) {
		
		self.setupCollection()
		
		// Create completion handler
		let selectCompletionHandler: (([String:Any]?, ProtocolModelItemCollection?, Error?) -> Void) =
		{
			(data, collection, error) -> Void in
			
			self.doAfterLoad()
			
			// Call completion handler
			completionHandler(self.collection!.dataDocument, error)
		}
		
		// Load the data
		(self.modelAccessStrategy as! ProtocolRelativeMemberModelAccessStrategy).select(byAspects: aspectTypes, applicationID: applicationID, maxResults: maxResults, currentRelativeMemberID: currentRelativeMemberID, scopeType: scopeType, previousRelativeMemberID: previousRelativeMemberID, numberOfItemsToLoad: numberOfItemsToLoad, selectItemsAfterPreviousYN: selectItemsAfterPreviousYN, collection: self.collection!, oncomplete: selectCompletionHandler)
	}
	
	public func toWrappers() -> [RelativeMemberWrapper] {
		
		var result:             [RelativeMemberWrapper] = [RelativeMemberWrapper]()
		
		if let collection = self.collection {
			
			let collection:     RelativeMemberCollection = collection as! RelativeMemberCollection
			
			// Go through each item
			for item in collection.items! {
				
				// Include items that are not deleted or obsolete
				if (item.status != .deleted && item.status != .obsolete) {
					
					// Get item wrapper
					let wrapper: RelativeMemberWrapper = (item as! RelativeMember).toWrapper()
					
					result.append(wrapper)
					
				}
				
			}
			
		}
		
		return result
	}
	
	public func loadAvatarImageData(item: RelativeMemberWrapper, oncomplete completionHandler:@escaping (RelativeMemberWrapper, Data?, Error?) -> Void) {
		
		// Check loadAvatarImageStrategy
		guard (self.loadAvatarImageStrategy != nil) else {
			
			// Call completion handler
			completionHandler(item, nil, NSError())
			
			return
		}
		
		// Create completion handler
		let loadAvatarImageDataCompletionHandler: ((RelativeMemberWrapper, Data?, Error?) -> Void) =
		{
			(item, data, error) -> Void in

			if (data != nil && error == nil) {
				
				// Get the item from the collection
				let rm: RelativeMember? = self.collection!.getItem(id: item.id) as? RelativeMember
				
				if (rm != nil) {
					
					rm!.avatarImageData = data
					
				}
				
			}
			
			// Call completion handler
			completionHandler(item, data, error)
			
		}
		
		self.loadAvatarImageStrategy!.loadAvatarImageData(item: item, oncomplete: loadAvatarImageDataCompletionHandler)
		
	}
	
	
	// MARK: - Override Methods
	
	public override func newCollection() -> ProtocolModelItemCollection? {
		
		return RelativeMemberCollection(modelAdministrator: self,
										storageDateFormatter: self.storageDateFormatter!)
	}
	
	public override func setupForeignKeys() {
		
		// No foreign keys
	}
	
	public override func setupOmittedKeys() {
		
		// ConnectionContractType
		self.modelAccessStrategy!.setOmittedParameter(key: "\(RelativeMemberDataParameterKeys.ConnectionContractTypes)")

	}
	
	
	// MARK: - Private Methods
	
}
