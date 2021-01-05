//
//  SocialManager.swift
//  SFSocial
//
//  Created by David on 09/03/2018.
//  Copyright © 2018 com.smartfoundation. All rights reserved.
//

import SFModel
import SFCore

/// Manages social modeling
public class SocialManager {
	
	// MARK: - Private Stored Properties
	
	
	// MARK: - Private Static Properties
	
	fileprivate static var singleton:				SocialManager?
	
	
	// MARK: - Public Stored Properties
	
	public fileprivate(set) var modelManager: 		SocialModelManager?
	public weak var delegate:						ProtocolSocialManagerDelegate?
	public fileprivate(set) var isSetupYN:			Bool = false
	public var loadImagesAsynchronouslyYN:			Bool = false
	
	
	// MARK: - Initializers
	
	fileprivate init() {
		
	}
	
	
	// MARK: - Public Class Computed Properties
	
	public class var shared: SocialManager {
		get {
			
			if (SocialManager.singleton == nil) {
				SocialManager.singleton = SocialManager()
			}
			
			return SocialManager.singleton!
		}
	}
	
	
	// MARK: - Public Methods
	
	public func set(modelManager: SocialModelManager) {
		
		self.modelManager 	= modelManager
		
		self.isSetupYN 		= true
	}
	
	
	// MARK: - Public Methods; RelativeMember

	public func loadRelativeMember(userProfileID: String, applicationID: String, oncomplete completionHandler:@escaping ([RelativeMemberWrapper]?, Error?) -> Void) {
		
		guard (self.isSetupYN) else {
			// Call completion handler
			completionHandler(nil, NSError())
			return
		}
		
		// Create completion handler
		let loadCompletionHandler: (([Any]?, Error?) -> Void) =
		{
			[unowned self] (data, error) -> Void in
			
			// Set state
			self.setStateAfterLoad()
			
			if (data != nil && error == nil) {
				
				// Process the loaded relativeMemberWrappers
				self.doAfterLoadRelativeMembers(oncomplete: completionHandler)
				
			} else {
				
				// Call completion handler
				completionHandler(nil, error)
				
			}

		}
		
		// Set state
		self.setStateBeforeLoad()
		
		// Load data
		self.getRelativeMemberModelAdministrator().select(byUserProfileID: userProfileID, applicationID: applicationID, oncomplete: loadCompletionHandler)
		
	}
	
	public func loadRelativeMember(email: String, applicationID: String, oncomplete completionHandler:@escaping ([RelativeMemberWrapper]?, Error?) -> Void) {
		
		guard (self.isSetupYN) else {
			// Call completion handler
			completionHandler(nil, NSError())
			return
		}
		
		// Create completion handler
		let loadCompletionHandler: (([Any]?, Error?) -> Void) =
		{
			[unowned self] (data, error) -> Void in
			
			// Set state
			self.setStateAfterLoad()
			
			if (data != nil && error == nil) {
				
				// Process the loaded relativeMemberWrappers
				self.doAfterLoadRelativeMembers(oncomplete: completionHandler)
				
			} else {
				
				// Call completion handler
				completionHandler(nil, error)
				
			}
			
		}
		
		// Set state
		self.setStateBeforeLoad()
		
		// Load data
		self.getRelativeMemberModelAdministrator().select(byEmail: email, applicationID: applicationID, oncomplete: loadCompletionHandler)
		
	}
	
	public func loadRelativeMember(email: String, applicationID: String, connectionContractType: RelativeConnectionContractTypes, currentRelativeMemberID: String, oncomplete completionHandler:@escaping ([RelativeMemberWrapper]?, Error?) -> Void) {
		
		guard (self.isSetupYN) else {
			// Call completion handler
			completionHandler(nil, NSError())
			return
		}
		
		// Create completion handler
		let loadCompletionHandler: (([Any]?, Error?) -> Void) =
		{
			[unowned self] (data, error) -> Void in
			
			// Set state
			self.setStateAfterLoad()
			
			if (data != nil && error == nil) {
				
				// Process the loaded relativeMemberWrappers
				self.doAfterLoadRelativeMembers(oncomplete: completionHandler)
				
			} else {
				
				// Call completion handler
				completionHandler(nil, error)
				
			}
			
		}
		
		// Set state
		self.setStateBeforeLoad()
		
		// Load data
		self.getRelativeMemberModelAdministrator().select(byEmail: email, applicationID: applicationID, connectionContractType: connectionContractType, currentRelativeMemberID: currentRelativeMemberID, oncomplete: loadCompletionHandler)
		
	}
	
	public func loadRelativeMember(id: String, applicationID: String, connectionContractType: RelativeConnectionContractTypes, currentRelativeMemberID: String, oncomplete completionHandler:@escaping ([RelativeMemberWrapper]?, Error?) -> Void) {
		
		guard (self.isSetupYN) else {
			// Call completion handler
			completionHandler(nil, NSError())
			return
		}
		
		// Create completion handler
		let loadCompletionHandler: (([Any]?, Error?) -> Void) =
		{
			[unowned self] (data, error) -> Void in
			
			// Set state
			self.setStateAfterLoad()
			
			if (data != nil && error == nil) {
				
				// Process the loaded relativeMemberWrappers
				self.doAfterLoadRelativeMembers(oncomplete: completionHandler)
				
			} else {
				
				// Call completion handler
				completionHandler(nil, error)
				
			}
			
		}
		
		// Set state
		self.setStateBeforeLoad()
		
		// Load data
		self.getRelativeMemberModelAdministrator().select(byID: id, applicationID: applicationID, connectionContractType: connectionContractType, currentRelativeMemberID: currentRelativeMemberID, oncomplete: loadCompletionHandler)
		
	}
	
	public func loadRelativeMembers(findText: String, applicationID: String, currentRelativeMemberID: String?, scopeType: RelativeMemberScopeTypes,  previousRelativeMemberID: String,  numberOfItemsToLoad: Int, selectItemsAfterPreviousYN: Bool, oncomplete completionHandler:@escaping ([RelativeMemberWrapper]?, Error?) -> Void) {
		
		guard (self.isSetupYN) else {
			// Call completion handler
			completionHandler(nil, NSError())
			return
		}
		
		// Create completion handler
		let loadCompletionHandler: (([Any]?, Error?) -> Void) =
		{
			[unowned self] (data, error) -> Void in
			
			// DEBUG:
			//let error: Error? = NSError()
			
			// Set state
			self.setStateAfterLoad()
			
			if (data != nil && error == nil) {
				
				// Process the loaded relativeMemberWrappers
				self.doAfterLoadRelativeMembers(oncomplete: completionHandler)
				
			} else {
				
				// Call completion handler
				completionHandler(nil, error)
				
			}
			
		}
		
		// Set state
		self.setStateBeforeLoad()
		
		// Load data
		self.getRelativeMemberModelAdministrator().select(byFindText: findText,
														  applicationID: applicationID,
														  currentRelativeMemberID: currentRelativeMemberID,
														  scopeType: scopeType,
														  previousRelativeMemberID: previousRelativeMemberID,
														  numberOfItemsToLoad: numberOfItemsToLoad,
														  selectItemsAfterPreviousYN: selectItemsAfterPreviousYN,
														  oncomplete: loadCompletionHandler)
		
	}

	public func loadRelativeMembers(aspectTypes: [RelativeMemberQueryAspectTypes], applicationID: String, maxResults: Int, currentRelativeMemberID: String?, scopeType: RelativeMemberScopeTypes,  previousRelativeMemberID: String,  numberOfItemsToLoad: Int, selectItemsAfterPreviousYN: Bool, oncomplete completionHandler:@escaping ([RelativeMemberWrapper]?, Error?) -> Void) {
		
		guard (self.isSetupYN) else {
			// Call completion handler
			completionHandler(nil, NSError())
			return
		}
		
		// Create completion handler
		let loadCompletionHandler: (([Any]?, Error?) -> Void) =
		{
			[unowned self] (data, error) -> Void in
			
			// DEBUG:
			//let error: Error? = NSError()
			
			// Set state
			self.setStateAfterLoad()
			
			if (data != nil && error == nil) {
				
				// Process the loaded relativeMemberWrappers
				self.doAfterLoadRelativeMembers(oncomplete: completionHandler)
				
			} else {
				
				// Call completion handler
				completionHandler(nil, error)
				
			}
			
		}
		
		// Set state
		self.setStateBeforeLoad()
		
		// Load data
		self.getRelativeMemberModelAdministrator().select(byAspects: aspectTypes,
														  applicationID: applicationID,
														  maxResults: maxResults,
														  currentRelativeMemberID: currentRelativeMemberID,
														  scopeType: scopeType,
														  previousRelativeMemberID: previousRelativeMemberID,
														  numberOfItemsToLoad: numberOfItemsToLoad,
														  selectItemsAfterPreviousYN: selectItemsAfterPreviousYN,
														  oncomplete: loadCompletionHandler)
		
	}
	
	public func insertRelativeMember(applicationID: String, userProfileID: String, email: String, fullName: String, avatarImageFileName: String, oncomplete completionHandler:@escaping (RelativeMemberWrapper?, Error?) -> Void) {
		
		guard (self.isSetupYN) else {
			// Call completion handler
			completionHandler(nil, NSError())
			return
		}
		
		// Create item
		let item: 			RelativeMember = self.createRelativeMember(applicationID: applicationID, userProfileID: userProfileID, email: email, fullName: fullName, avatarImageFileName: avatarImageFileName)

		// Set status to ensure item is inserted
		item.status 		= .new
		
		// Create completion handler
		let saveCompletionHandler: ((Error?) -> Void) =
		{
			[unowned self] (error) -> Void in
			
			var result: 	[RelativeMemberWrapper]? = nil
			
			if (error == nil) {
				
				// Copy items to wrappers array
				result 		= self.getRelativeMemberModelAdministrator().toWrappers()
		
			}
			
			// Call completion handler
			completionHandler(result!.first, error)
			
		}
		
		// Save data
		self.getRelativeMemberModelAdministrator().save(oncomplete: saveCompletionHandler)
		
	}
	
	public func updateRelativeMember(relativeMemberWrapper: RelativeMemberWrapper, oncomplete completionHandler:@escaping (RelativeMemberWrapper?, Error?) -> Void) {
		
		guard (self.isSetupYN) else {
			// Call completion handler
			completionHandler(nil, NSError())
			return
		}
		
		self.getRelativeMemberModelAdministrator().initialise()
		
		// Create the item to update
		let item: RelativeMember = (self.getRelativeMemberModelAdministrator().collection as? RelativeMemberCollection)?.addItem() as! RelativeMember
		
		item.clone(fromWrapper: relativeMemberWrapper)
		
		// Set status to ensure item is updated
		item.status = .modified
		
		// Create completion handler
		let updateCompletionHandler: ((Error?) -> Void) =
		{
			(error) -> Void in
			
			// Call completion handler
			completionHandler(relativeMemberWrapper, error)
			
		}
		
		// Save data
		self.getRelativeMemberModelAdministrator().save(oncomplete: updateCompletionHandler)
		
	}
	
	public func loadRelativeMemberAvatarImageData(for item: RelativeMemberWrapper, oncomplete completionHandler:@escaping (RelativeMemberWrapper, Data?, Error?) -> Void) {
		
		let fileName: String	= item.avatarImageFileName
		
		guard (fileName.count > 0) else {
			
			// Call completion handler
			completionHandler(item, nil, nil)
			return
			
		}
		
		// Create completion handler
		let loadAvatarImageDataCompletionHandler: ((RelativeMemberWrapper, Data?, Error?) -> Void) =
		{
			(item, data, error) -> Void in
			
			if (data != nil && UIImage(data: data!) != nil) {
				
				item.avatarImageData = data
				
			} else {
				// Error
			}
			
			// Call completion handler
			completionHandler(item, data, error)
			
		}
		
		// Load image data
		self.getRelativeMemberModelAdministrator().loadAvatarImageData(item: item, oncomplete: loadAvatarImageDataCompletionHandler)
		
	}
	
	
	// MARK: - Public Methods; RelativeConnection
	
	public func insertRelativeConnection(applicationID: String, fromRelativeMemberID: String, toRelativeMemberID: String, connectionContractType: RelativeConnectionContractTypes, oncomplete completionHandler:@escaping (RelativeConnectionWrapper?, Error?) -> Void) {
		
		guard (self.isSetupYN) else {
			// Call completion handler
			completionHandler(nil, NSError())
			return
		}
		
		// Create item
		let item: 		RelativeConnection = self.createRelativeConnection(applicationID: applicationID, fromRelativeMemberID: fromRelativeMemberID, toRelativeMemberID: toRelativeMemberID, connectionContractType: connectionContractType)
		
		// Set status to ensure item is inserted
		item.status 	= .new
		
		// Create completion handler
		let saveCompletionHandler: ((Error?) -> Void) =
		{
			[unowned self] (error) -> Void in
			
			var result: [RelativeConnectionWrapper]? = nil
			
			if (error == nil) {
				
				// Copy items to wrappers array
				result = self.getRelativeConnectionModelAdministrator().toWrappers()
				
			}
			
			// Call completion handler
			completionHandler(result?.first, error)
			
		}
		
		// Save data
		self.getRelativeConnectionModelAdministrator().save(oncomplete: saveCompletionHandler)
		
	}
	
	public func insertRelativeConnection(relativeConnectionRequestWrapper: RelativeConnectionRequestWrapper, oncomplete completionHandler:@escaping (RelativeConnectionWrapper?, Error?) -> Void) {
		
		guard (self.isSetupYN) else {
			// Call completion handler
			completionHandler(nil, NSError())
			return
		}
		
		var connectionContractType: 	RelativeConnectionContractTypes = .friend
		
		// Determine connectionContractType
		switch relativeConnectionRequestWrapper.requestType {
		case .friend:
			connectionContractType 		= .friend
		}
		
		// Create item
		let item: 						RelativeConnection = self.createRelativeConnection(relativeConnectionRequestWrapper: relativeConnectionRequestWrapper, connectionContractType: connectionContractType)
		
		// Set status to ensure item is inserted
		item.status 					= .new
		
		// Create completion handler
		let saveCompletionHandler: ((Error?) -> Void) =
		{
			[unowned self] (error) -> Void in
			
			var result: [RelativeConnectionWrapper]? = nil
			
			if (error == nil) {
				
				// Copy items to wrappers array
				result = self.getRelativeConnectionModelAdministrator().toWrappers()
				
			}
			
			// Call completion handler
			completionHandler(result?.first, error)
			
		}
		
		// Save data
		self.getRelativeConnectionModelAdministrator().save(oncomplete: saveCompletionHandler)
		
	}
	
	public func loadRelativeConnection(fromRelativeMemberID: String, toRelativeMemberID: String, applicationID: String, connectionContractType: RelativeConnectionContractTypes, currentRelativeMemberID: String, oncomplete completionHandler:@escaping ([RelativeConnectionWrapper]?, Error?) -> Void) {
		
		guard (self.isSetupYN) else {
			// Call completion handler
			completionHandler(nil, NSError())
			return
		}
		
		// Create completion handler
		let loadCompletionHandler: (([Any]?, Error?) -> Void) =
		{
			[unowned self] (data, error) -> Void in
			
			// Set state
			self.setStateAfterLoad()

			if (data != nil && error == nil) {

				// Process the loaded relativeConnectionWrappers
				self.doAfterLoadRelativeConnections(currentRelativeMemberID: currentRelativeMemberID,
													oncomplete: completionHandler)
				
			} else {
				
				// Call completion handler
				completionHandler(nil, error)
				
			}

		}
		
		// Set state
		self.setStateBeforeLoad()
		
		// Load data
		self.getRelativeConnectionModelAdministrator().select(fromRelativeMemberID: fromRelativeMemberID, byToRelativeMemberID: toRelativeMemberID, applicationID: applicationID, connectionContractType: connectionContractType, oncomplete: loadCompletionHandler)
		
	}
	
	public func loadRelativeConnection(forRelativeMemberID: String, withRelativeMemberID: String, applicationID: String, connectionContractType: RelativeConnectionContractTypes, currentRelativeMemberID: String, oncomplete completionHandler:@escaping ([RelativeConnectionWrapper]?, Error?) -> Void) {
		
		guard (self.isSetupYN) else {
			// Call completion handler
			completionHandler(nil, NSError())
			return
		}
		
		// Create completion handler
		let loadCompletionHandler: (([Any]?, Error?) -> Void) =
		{
			[unowned self] (data, error) -> Void in
			
			// Set state
			self.setStateAfterLoad()

			if (data != nil && error == nil) {

				// Process the loaded relativeConnectionWrappers
				self.doAfterLoadRelativeConnections(currentRelativeMemberID: currentRelativeMemberID,
													oncomplete: completionHandler)
				
			} else {
				
				// Call completion handler
				completionHandler(nil, error)
				
			}

		}
		
		// Set state
		self.setStateBeforeLoad()
		
		// Load data
		self.getRelativeConnectionModelAdministrator().select(forRelativeMemberID: forRelativeMemberID, byWithRelativeMemberID: withRelativeMemberID, applicationID: applicationID, connectionContractType: connectionContractType, oncomplete: loadCompletionHandler)
		
	}
	
	public func loadRelativeConnections(fromRelativeMemberID: String, applicationID: String, connectionContractType: RelativeConnectionContractTypes, currentRelativeMemberID: String, oncomplete completionHandler:@escaping ([RelativeConnectionWrapper]?, Error?) -> Void) {
		
		guard (self.isSetupYN) else {
			// Call completion handler
			completionHandler(nil, NSError())
			return
		}
		
		// Create completion handler
		let loadCompletionHandler: (([Any]?, Error?) -> Void) =
		{
			[unowned self] (data, error) -> Void in
			
			// Set state
			self.setStateAfterLoad()

			if (data != nil && error == nil) {
				
				// Process the loaded relativeConnectionWrappers
				self.doAfterLoadRelativeConnections(currentRelativeMemberID: currentRelativeMemberID,
													oncomplete: completionHandler)
				
			} else {
				
				// Call completion handler
				completionHandler(nil, error)
				
			}

		}
		
		// Set state
		self.setStateBeforeLoad()
		
		// Load data
		self.getRelativeConnectionModelAdministrator().select(byFromRelativeMemberID: fromRelativeMemberID, applicationID: applicationID, connectionContractType: connectionContractType, oncomplete: loadCompletionHandler)
		
	}
	
	public func loadRelativeConnections(toRelativeMemberID: String, applicationID: String, connectionContractType: RelativeConnectionContractTypes, currentRelativeMemberID: String, oncomplete completionHandler:@escaping ([RelativeConnectionWrapper]?, Error?) -> Void) {
		
		guard (self.isSetupYN) else {
			// Call completion handler
			completionHandler(nil, NSError())
			return
		}
		
		// Create completion handler
		let loadCompletionHandler: (([Any]?, Error?) -> Void) =
		{
			[unowned self] (data, error) -> Void in
			
			// Set state
			self.setStateAfterLoad()

			if (data != nil && error == nil) {

				// Process the loaded relativeConnectionWrappers
				self.doAfterLoadRelativeConnections(currentRelativeMemberID: currentRelativeMemberID,
													oncomplete: completionHandler)
				
			} else {
				
				// Call completion handler
				completionHandler(nil, error)
				
			}

		}
		
		// Set state
		self.setStateBeforeLoad()
		
		// Load data
		self.getRelativeConnectionModelAdministrator().select(byToRelativeMemberID: toRelativeMemberID, applicationID: applicationID, connectionContractType: connectionContractType, oncomplete: loadCompletionHandler)
		
	}
	
	public func loadRelativeConnections(withRelativeMemberID: String, applicationID: String, connectionContractType: RelativeConnectionContractTypes, currentRelativeMemberID: String, oncomplete completionHandler:@escaping ([RelativeConnectionWrapper]?, Error?) -> Void) {
		
		guard (self.isSetupYN) else {
			// Call completion handler
			completionHandler(nil, NSError())
			return
		}
		
		// Create completion handler
		let loadCompletionHandler: (([Any]?, Error?) -> Void) =
		{
			[unowned self] (data, error) -> Void in
			
			var result: [RelativeConnectionWrapper]? = nil
			
			if (data != nil && error == nil) {
				
				// Copy items to wrappers array
				result = self.getRelativeConnectionModelAdministrator().toWrappers()
				
				// Process the loaded relativeConnectionWrappers
				self.doAfterLoadRelativeConnections(currentRelativeMemberID: currentRelativeMemberID,
													oncomplete: completionHandler)
				
			}
			
			// Set state
			self.setStateAfterLoad()
			
			// Call completion handler
			completionHandler(result, error)
		}
		
		// Set state
		self.setStateBeforeLoad()
		
		// Load data
		self.getRelativeConnectionModelAdministrator().select(byWithRelativeMemberID: withRelativeMemberID, applicationID: applicationID, connectionContractType: connectionContractType, oncomplete: loadCompletionHandler)
		
	}
	
	public func deleteRelativeConnection(relativeConnectionWrapper: RelativeConnectionWrapper, oncomplete completionHandler:@escaping (RelativeConnectionWrapper?, Error?) -> Void) {
		
		guard (self.isSetupYN) else {
			// Call completion handler
			completionHandler(nil, NSError())
			return
		}
		
		self.getRelativeConnectionModelAdministrator().initialise()
		
		// Create the item to delete
		let item: RelativeConnection = (self.getRelativeConnectionModelAdministrator().collection as? RelativeConnectionCollection)?.addItem() as! RelativeConnection
		
		item.clone(fromWrapper: relativeConnectionWrapper)
		
		// Set status to ensure item is deleted
		item.status = .deleted
		
		// Create completion handler
		let deleteCompletionHandler: ((Error?) -> Void) =
		{
			(error) -> Void in
			
			// Call completion handler
			completionHandler(relativeConnectionWrapper, error)
			
		}
		
		// Save data
		self.getRelativeConnectionModelAdministrator().save(oncomplete: deleteCompletionHandler)
		
	}
	
	
	// MARK: - Public Methods; RelativeConnectionRequest
	
	public func loadRelativeConnectionRequest(fromRelativeMemberID: String, toRelativeMemberID: String, applicationID: String, requestType: RelativeConnectionRequestTypes, currentRelativeMemberID: String, oncomplete completionHandler:@escaping ([RelativeConnectionRequestWrapper]?, Error?) -> Void) {
		
		guard (self.isSetupYN) else {
			// Call completion handler
			completionHandler(nil, NSError())
			return
		}
		
		// Create completion handler
		let loadCompletionHandler: (([Any]?, Error?) -> Void) =
		{
			[unowned self] (data, error) -> Void in
			
			// Set state
			self.setStateAfterLoad()
			
			if (data != nil && error == nil) {
				
				// Process the loaded relativeConnectionRequestWrappers
				self.doAfterLoadRelativeConnectionRequests(currentRelativeMemberID: currentRelativeMemberID,
														   oncomplete: completionHandler)
				
			} else {
				
				// Call completion handler
				completionHandler(nil, error)
				
			}

		}
		
		// Set state
		self.setStateBeforeLoad()
		
		// Load data
		self.getRelativeConnectionRequestModelAdministrator().select(fromRelativeMemberID: fromRelativeMemberID, byToRelativeMemberID: toRelativeMemberID, applicationID: applicationID, requestType: requestType, oncomplete: loadCompletionHandler)
		
	}
	
	public func loadRelativeConnectionRequests(fromRelativeMemberID: String, applicationID: String, requestType: RelativeConnectionRequestTypes, currentRelativeMemberID: String, oncomplete completionHandler:@escaping ([RelativeConnectionRequestWrapper]?, Error?) -> Void) {
		
		guard (self.isSetupYN) else {
			// Call completion handler
			completionHandler(nil, NSError())
			return
		}
		
		// Create completion handler
		let loadCompletionHandler: (([Any]?, Error?) -> Void) =
		{
			[unowned self] (data, error) -> Void in
			
			// Set state
			self.setStateAfterLoad()
			
			if (data != nil && error == nil) {
				
				// Process the loaded relativeConnectionRequestWrappers
				self.doAfterLoadRelativeConnectionRequests(currentRelativeMemberID: currentRelativeMemberID,
														   oncomplete: completionHandler)
				
			} else {
				
				// Call completion handler
				completionHandler(nil, error)
				
			}

		}
		
		// Set state
		self.setStateBeforeLoad()
		
		// Load data
		self.getRelativeConnectionRequestModelAdministrator().select(byFromRelativeMemberID: fromRelativeMemberID, applicationID: applicationID, requestType: requestType, oncomplete: loadCompletionHandler)
		
	}
	
	public func loadRelativeConnectionRequests(toRelativeMemberID: String, applicationID: String, requestType: RelativeConnectionRequestTypes, currentRelativeMemberID: String, oncomplete completionHandler:@escaping ([RelativeConnectionRequestWrapper]?, Error?) -> Void) {
		
		guard (self.isSetupYN) else {
			// Call completion handler
			completionHandler(nil, NSError())
			return
		}
		
		// Create completion handler
		let loadCompletionHandler: (([Any]?, Error?) -> Void) =
		{
			[unowned self] (data, error) -> Void in
			
			// Set state
			self.setStateAfterLoad()
			
			if (data != nil && error == nil) {
				
				// Process the loaded relativeConnectionRequestWrappers
				self.doAfterLoadRelativeConnectionRequests(currentRelativeMemberID: currentRelativeMemberID,
														   oncomplete: completionHandler)
				
			} else {
				
				// Call completion handler
				completionHandler(nil, error)
				
			}

		}
		
		// Set state
		self.setStateBeforeLoad()
		
		// Load data
		self.getRelativeConnectionRequestModelAdministrator().select(byToRelativeMemberID: toRelativeMemberID, applicationID: applicationID, requestType: requestType, oncomplete: loadCompletionHandler)
		
	}
	
	public func deleteRelativeConnectionRequest(relativeConnectionRequestWrapper: RelativeConnectionRequestWrapper, oncomplete completionHandler:@escaping (RelativeConnectionRequestWrapper?, Error?) -> Void) {
		
		guard (self.isSetupYN) else {
			// Call completion handler
			completionHandler(nil, NSError())
			return
		}
		
		self.getRelativeConnectionRequestModelAdministrator().initialise()
		
		// Create the item to delete
		let item: RelativeConnectionRequest = (self.getRelativeConnectionRequestModelAdministrator().collection as? RelativeConnectionRequestCollection)?.addItem() as! RelativeConnectionRequest
		
		item.clone(fromWrapper: relativeConnectionRequestWrapper)
		
		// Set status to ensure item is deleted
		item.status = .deleted
		
		// Create completion handler
		let deleteCompletionHandler: ((Error?) -> Void) =
		{
			(error) -> Void in
			
			// Call completion handler
			completionHandler(relativeConnectionRequestWrapper, error)
			
		}
		
		// Save data
		self.getRelativeConnectionRequestModelAdministrator().save(oncomplete: deleteCompletionHandler)
		
	}
	
	
	// MARK: - Public Methods; RelativeInteraction
	
	public func loadRelativeInteractions(fromRelativeMemberID: String, applicationID: String, interactionType: RelativeInteractionTypes, currentRelativeMemberID: String, oncomplete completionHandler:@escaping ([RelativeInteractionWrapper]?, Error?) -> Void) {
		
		guard (self.isSetupYN) else {
			// Call completion handler
			completionHandler(nil, NSError())
			return
		}
		
		// Create completion handler
		let loadCompletionHandler: (([Any]?, Error?) -> Void) =
		{
			[unowned self] (data, error) -> Void in
			
			// Set state
			self.setStateAfterLoad()

			if (data != nil && error == nil) {
				
				// Process the loaded relativeInteractionWrappers
				self.doAfterLoadRelativeInteractions(currentRelativeMemberID: currentRelativeMemberID, oncomplete:  completionHandler)
				
			} else {
				
				// Call completion handler
				completionHandler(nil, error)
				
			}

		}
		
		// Set state
		self.setStateBeforeLoad()
		
		// Load data
		self.getRelativeInteractionModelAdministrator().select(byFromRelativeMemberID: fromRelativeMemberID, applicationID: applicationID, interactionType: interactionType, oncomplete: loadCompletionHandler)
		
	}
	
	public func loadRelativeInteractions(toRelativeMemberID: String, applicationID: String, interactionType: RelativeInteractionTypes, currentRelativeMemberID: String, oncomplete completionHandler:@escaping ([RelativeInteractionWrapper]?, Error?) -> Void) {
		
		guard (self.isSetupYN) else {
			// Call completion handler
			completionHandler(nil, NSError())
			return
		}
		
		// Create completion handler
		let loadCompletionHandler: (([Any]?, Error?) -> Void) =
		{
			[unowned self] (data, error) -> Void in
			
			// Set state
			self.setStateAfterLoad()

			if (data != nil && error == nil) {
				
				// Process the loaded relativeInteractionWrappers
				self.doAfterLoadRelativeInteractions(currentRelativeMemberID: currentRelativeMemberID, oncomplete:  completionHandler)
				
			} else {
				
				// Call completion handler
				completionHandler(nil, error)
				
			}

		}
		
		// Set state
		self.setStateBeforeLoad()
		
		// Load data
		self.getRelativeInteractionModelAdministrator().select(byToRelativeMemberID: toRelativeMemberID, applicationID: applicationID, interactionType: interactionType, oncomplete: loadCompletionHandler)
		
	}
	
	
	// MARK: - Public Methods; RelativeTimelineEvent

	public func saveRelativeTimelineEvent(for relativeInteractionWrapper: RelativeInteractionWrapper, currentRelativeMemberID: String, oncomplete completionHandler: ((RelativeTimelineEventWrapper?, Error?) -> Void)?) {
		
		guard (self.isSetupYN) else {
			// Call completion handler
			completionHandler?(nil, NSError())
			return
		}
		
		// ***************************************************************
		// This logic needs to be done on the server!!!!!!
		// ***************************************************************
		
		// Create completion handler
		let saveCompletionHandler: ((Error?) -> Void) =
		{
			[unowned self] (error) -> Void in
			
			var result: [RelativeTimelineEventWrapper]? = nil
			
			if (error == nil) {
				
				// Copy items to wrappers array
				result = self.getRelativeTimelineEventModelAdministrator().toWrappers()
				
			}
			
			// Call completion handler
			completionHandler?(result?.first, error)
			
		}
		
		if (relativeInteractionWrapper.interactionType == .postfollowcontractmyfeed) {
			
			// Create completion handler
			let loadFollowersCompletionHandler: (([RelativeConnectionWrapper]?, Error?) -> Void) =
			{
				[unowned self] (items, error) -> Void in
				
				if (items != nil && error == nil) {
					
					// Create timeline event item
					let item:		RelativeTimelineEvent = self.createRelativeTimelineEvent(forRelativeMemberID: nil, relativeInteractionWrapper: relativeInteractionWrapper)
					
					// Set status to ensure item is inserted
					item.status 	= .new
					
					// Save data
					self.saveRelativeTimelineEvent(item: item, forFollowers: items!, currentRelativeMemberID: currentRelativeMemberID, oncomplete: saveCompletionHandler)
					
				} else {
					
					// Call completion handler
					completionHandler?(nil, error)
					
				}
				
			}
			
			// Load followers from data source
			self.loadRelativeConnections(toRelativeMemberID: currentRelativeMemberID, applicationID: relativeInteractionWrapper.applicationID, connectionContractType: .follow, currentRelativeMemberID: currentRelativeMemberID, oncomplete: loadFollowersCompletionHandler)
			
		} else if (relativeInteractionWrapper.interactionType == .postfriendcontractmyfeed) {
			
			// Create timeline event item
			let item:		RelativeTimelineEvent = self.createRelativeTimelineEvent(forRelativeMemberID: currentRelativeMemberID, relativeInteractionWrapper: relativeInteractionWrapper)
			
			// Set status to ensure item is inserted
			item.status 	= .new
			
			// Save data
			self.saveRelativeTimelineEvent(item: item, forFriends: [RelativeConnectionWrapper](), currentRelativeMemberID: currentRelativeMemberID, oncomplete: saveCompletionHandler)
			
		} else if (relativeInteractionWrapper.interactionType == .postfriendcontractfriendfeed) {
			
			// Call completion handler
			completionHandler?(nil, nil)
			
		}
		
	}
	
	public func saveRelativeTimelineEvent(item: RelativeTimelineEvent, forFollowers relativeConnectionWrappers: [RelativeConnectionWrapper], currentRelativeMemberID: String, oncomplete completionHandler:@escaping (Error?) -> Void) {
		
		guard (self.isSetupYN) else {
			// Call completion handler
			completionHandler(NSError())
			return
		}
		
		// Create completion handler
		let insertCompletionHandler: ((String, Error?) -> Void) =
		{
			(id, error) -> Void in
			
			// Call completion handler
			completionHandler(error)
			
		}
		
		// ***************************************************************
		// This logic needs to be done on the server!!!!!!
		
		var forRelativeMemberIDs: [String] = [String]()
		
		// Add current user
		forRelativeMemberIDs.append(currentRelativeMemberID)
		
		// Add followers
		for item in relativeConnectionWrappers {
			
			forRelativeMemberIDs.append(item.fromRelativeMemberID)
			
		}
		// ***************************************************************
		
		self.getRelativeTimelineEventModelAdministrator().insert(item: item, forRelativeMemberIDs: forRelativeMemberIDs, oncomplete: insertCompletionHandler)
		
	}
	
	public func saveRelativeTimelineEvent(item: RelativeTimelineEvent, forFriends relativeConnectionWrappers: [RelativeConnectionWrapper], currentRelativeMemberID: String, oncomplete completionHandler:@escaping (Error?) -> Void) {
		
		// Create completion handler
		let insertCompletionHandler: ((String, Error?) -> Void) =
		{
			(id, error) -> Void in
			
			// Call completion handler
			completionHandler(error)
			
		}
		
		
		// ***************************************************************
		// This logic needs to be done on the server!!!!!!
		
		var forRelativeMemberIDs: [String] = [String]()
		
		// Add current user
		forRelativeMemberIDs.append(currentRelativeMemberID)
		
		// Add followers
		for item in relativeConnectionWrappers {
			
			var id: String = item.fromRelativeMemberID
			
			if (item.fromRelativeMemberID == currentRelativeMemberID) {
				
				id = item.toRelativeMemberID
				
			}
			
			forRelativeMemberIDs.append(id)
			
		}
		// ***************************************************************
		
		
		self.getRelativeTimelineEventModelAdministrator().insert(item: item, forRelativeMemberIDs: forRelativeMemberIDs, oncomplete: insertCompletionHandler)
		
	}
	
	public func loadRelativeTimelineEvents(forRelativeMemberID: String,
										   applicationID: String,
										   currentRelativeMemberID: String,
										   scopeType: RelativeTimelineEventScopeTypes,
										   relativeTimelineEventTypes: [RelativeTimelineEventTypes],
										   previousRelativeTimelineEventID: String,
										   numberOfItemsToLoad: Int,
										   selectItemsAfterPreviousYN: Bool,
										   oncomplete completionHandler:@escaping ([RelativeTimelineEventWrapper]?, Error?) -> Void) {
		
		guard (self.isSetupYN) else {
			// Call completion handler
			completionHandler(nil, NSError())
			return
		}
		
		// Create completion handler
		let loadCompletionHandler: (([Any]?, Error?) -> Void) =
		{
			[unowned self] (data, error) -> Void in

			// Set state
			self.setStateAfterLoad()
			
			if (data != nil && error == nil) {
				
				// Process the loaded relativeTimelineEventWrappers
				self.doAfterLoadRelativeTimelineEvents(currentRelativeMemberID: currentRelativeMemberID, oncomplete: completionHandler)

			} else {
				
				// Call completion handler
				completionHandler(nil, error)
				
			}
			
		}
		
		// Set state
		self.setStateBeforeLoad()
		
		// Load data
		self.getRelativeTimelineEventModelAdministrator().select(byForRelativeMemberID: forRelativeMemberID,
																 applicationID: applicationID,
																 currentRelativeMemberID: currentRelativeMemberID,
																 scopeType: scopeType,
																 relativeTimelineEventTypes: relativeTimelineEventTypes,
																 previousRelativeTimelineEventID:
			previousRelativeTimelineEventID,
																 numberOfItemsToLoad: numberOfItemsToLoad,
																 selectItemsAfterPreviousYN: selectItemsAfterPreviousYN,
																 oncomplete: loadCompletionHandler)
		
	}
	
	public func loadRelativeTimelineEvent(relativeInteractionID: String,
										  applicationID: String,
										  currentRelativeMemberID: String,
										  oncomplete completionHandler:@escaping ([RelativeTimelineEventWrapper]?, Error?) -> Void) {
		
		guard (self.isSetupYN) else {
			// Call completion handler
			completionHandler(nil, NSError())
			return
		}
		
		// Create completion handler
		let loadCompletionHandler: (([Any]?, Error?) -> Void) =
		{
			[unowned self] (data, error) -> Void in
			
			// Set state
			self.setStateAfterLoad()
			
			if (data != nil && error == nil) {
				
				// Process the loaded relativeTimelineEventWrappers
				self.doAfterLoadRelativeTimelineEvents(currentRelativeMemberID: currentRelativeMemberID, oncomplete: completionHandler)
				
			} else {
				
				// Call completion handler
				completionHandler(nil, error)
				
			}
			
		}
		
		// Set state
		self.setStateBeforeLoad()
		
		// Load data
		self.getRelativeTimelineEventModelAdministrator().select(byRelativeInteractionID: relativeInteractionID,
																 applicationID: applicationID,
																 oncomplete: loadCompletionHandler)
		
	}
	
	
	// MARK: - Public Methods; Friend Contract
	
	public func friendContractSendFriendRequest(fromRelativeMemberID: String, toRelativeMemberWrapper: RelativeMemberWrapper, applicationID: String, oncomplete completionHandler:@escaping (RelativeConnectionRequestWrapper?, Error?) -> Void) {
		
		guard (self.isSetupYN) else {
			// Call completion handler
			completionHandler(nil, NSError())
			return
		}
		
		// Create item
		let item: 		RelativeConnectionRequest = self.createRelativeConnectionRequest(applicationID: applicationID, fromRelativeMemberID: fromRelativeMemberID, toRelativeMemberID: toRelativeMemberWrapper.id, requestType: RelativeConnectionRequestTypes.friend)
		
		// Set status to ensure item is inserted
		item.status 	= .new
		
		// Create completion handler
		let saveCompletionHandler: ((Error?) -> Void) =
		{
			[unowned self] (error) -> Void in
			
			var result: [RelativeConnectionRequestWrapper]? = nil
			
			if (error == nil) {
				
				// Copy items to wrappers array
				result = self.getRelativeConnectionRequestModelAdministrator().toWrappers()
				
				// Set toRelativeMember
				result!.first!.toRelativeMember = toRelativeMemberWrapper
				
			}
			
			// Call completion handler
			completionHandler(result?.first, error)
			
		}
		
		// Save data
		self.getRelativeConnectionRequestModelAdministrator().save(oncomplete: saveCompletionHandler)
		
	}
	
	public func friendContractAcceptFriendRequest(relativeConnectionRequestWrapper: RelativeConnectionRequestWrapper, oncomplete completionHandler:@escaping (RelativeConnectionRequestWrapper?, Error?) -> Void) {
		
		guard (self.isSetupYN) else {
			// Call completion handler
			completionHandler(nil, NSError())
			return
		}
		
		// Create completion handler
		let deleteCompletionHandler: ((Error?) -> Void) =
		{
			(error) -> Void in
			
			// Not required
			
		}
		
		// Create completion handler
		let insertRelativeConnectionCompletionHandler: ((RelativeConnectionWrapper?, Error?) -> Void) =
		{
			[unowned self] (item, error) -> Void in
			
			if (item != nil && error == nil) {
				
				self.getRelativeConnectionRequestModelAdministrator().initialise()
				
				// Create the item to delete
				let item: RelativeConnectionRequest = (self.getRelativeConnectionRequestModelAdministrator().collection as? RelativeConnectionRequestCollection)?.addItem() as! RelativeConnectionRequest
				
				item.clone(fromWrapper: relativeConnectionRequestWrapper)
				
				// Set status to ensure item is deleted
				item.status = .deleted
				
				// Delete data
				self.getRelativeConnectionRequestModelAdministrator().save(oncomplete: deleteCompletionHandler)
				
			}
			
			// Call completion handler
			completionHandler(relativeConnectionRequestWrapper, error)
			
		}
		
		// Save data
		self.insertRelativeConnection(relativeConnectionRequestWrapper: relativeConnectionRequestWrapper, oncomplete: insertRelativeConnectionCompletionHandler)
		
	}
	
	public func friendContractPostToMyFeed(forRelativeMemberID: String, text: String, applicationID: String, oncomplete completionHandler:@escaping (RelativeInteractionWrapper?, Error?) -> Void) {
		
		guard (self.isSetupYN) else {
			// Call completion handler
			completionHandler(nil, NSError())
			return
		}
		
		// Create item
		let item:		RelativeInteraction = self.createRelativeInteraction(applicationID: applicationID, fromRelativeMemberID: forRelativeMemberID, toRelativeMemberID: nil, interactionType: .postfriendcontractmyfeed, text: text)
		
		// Set status to ensure item is inserted
		item.status 	= .new
		
		// Create completion handler
		let saveCompletionHandler: ((Error?) -> Void) =
		{
			[unowned self] (error) -> Void in
			
			var result: [RelativeInteractionWrapper]? = nil
			
			if (error == nil) {
				
				// Copy items to wrappers array
				result = self.getRelativeInteractionModelAdministrator().toWrappers()
				
			}
			
			// Call completion handler
			completionHandler(result?.first, error)
			
		}
		
		// Save data
		self.getRelativeInteractionModelAdministrator().save(oncomplete: saveCompletionHandler)
		
	}
	
	public func friendContractPostToFriendFeed(forRelativeMemberID: String, currentRelativeMemberID: String, text: String, applicationID: String, oncomplete completionHandler:@escaping (RelativeInteractionWrapper?, Error?) -> Void) {
		
		guard (self.isSetupYN) else {
			// Call completion handler
			completionHandler(nil, NSError())
			return
		}
		
		// Create item
		let item:		RelativeInteraction = self.createRelativeInteraction(applicationID: applicationID, fromRelativeMemberID: forRelativeMemberID, toRelativeMemberID: currentRelativeMemberID, interactionType: .postfriendcontractfriendfeed, text: text)
		
		// Set status to ensure item is inserted
		item.status 	= .new
		
		// Create completion handler
		let saveCompletionHandler: ((Error?) -> Void) =
		{
			[unowned self] (error) -> Void in
			
			var result: [RelativeInteractionWrapper]? = nil
			
			if (error == nil) {
				
				// Copy items to wrappers array
				result = self.getRelativeInteractionModelAdministrator().toWrappers()
				
			}
			
			// Call completion handler
			completionHandler(result?.first, error)
			
		}
		
		// Save data
		self.getRelativeInteractionModelAdministrator().save(oncomplete: saveCompletionHandler)
		
	}
	
	
	// MARK: - Public Methods; Follow Contract
	
	public func followContractPostToMyFeed(fromRelativeMemberID: String, text: String, applicationID: String, oncomplete completionHandler:@escaping (RelativeInteractionWrapper?, Error?) -> Void) {
		
		guard (self.isSetupYN) else {
			// Call completion handler
			completionHandler(nil, NSError())
			return
		}
		
		// Create item
		let item:		RelativeInteraction = self.createRelativeInteraction(applicationID: applicationID, fromRelativeMemberID: fromRelativeMemberID, toRelativeMemberID: nil, interactionType: .postfollowcontractmyfeed, text: text)
		
		// Set status to ensure item is inserted
		item.status 	= .new
		
		// Create completion handler
		let saveCompletionHandler: ((Error?) -> Void) =
		{
			[unowned self] (error) -> Void in
			
			var result: [RelativeInteractionWrapper]? = nil
			
			if (error == nil) {
				
				// Copy items to wrappers array
				result = self.getRelativeInteractionModelAdministrator().toWrappers()
				
			}
			
			// Call completion handler
			completionHandler(result?.first, error)
			
		}
		
		// Save data
		self.getRelativeInteractionModelAdministrator().save(oncomplete: saveCompletionHandler)
		
	}
	
	
	// MARK: - Public Methods; Handshake Contract
	
	public func handshakeContractSendHandshake(fromRelativeMemberID: String, toRelativeMemberWrapper: RelativeMemberWrapper, applicationID: String, oncomplete completionHandler:@escaping (RelativeInteractionWrapper?, Error?) -> Void) {
		
		guard (self.isSetupYN) else {
			// Call completion handler
			completionHandler(nil, NSError())
			return
		}
		
		// Create item
		let item: 		RelativeInteraction = self.createRelativeInteraction(applicationID: applicationID, fromRelativeMemberID: fromRelativeMemberID, toRelativeMemberID: toRelativeMemberWrapper.id, interactionType: .handshake, text: "")
		
		// Set status to ensure item is inserted
		item.status 	= .new
		
		// Create completion handler
		let saveCompletionHandler: ((Error?) -> Void) =
		{
			[unowned self] (error) -> Void in
			
			var result: [RelativeInteractionWrapper]? = nil
			
			if (error == nil) {
				
				// Copy items to wrappers array
				result = self.getRelativeInteractionModelAdministrator().toWrappers()
				
				// Set toRelativeMember
				result!.first!.toRelativeMember = toRelativeMemberWrapper
				
			}
			
			// Call completion handler
			completionHandler(result?.first, error)
			
		}
		
		// Save data
		self.getRelativeInteractionModelAdministrator().save(oncomplete: saveCompletionHandler)
		
	}
	
	
	// MARK: - Public Methods; Contractless
	
	public func contractlessPostToMyFeed(currentRelativeMemberID: String, text: String, applicationID: String, oncomplete completionHandler:@escaping (RelativeInteractionWrapper?, Error?) -> Void) {
		
		guard (self.isSetupYN) else {
			// Call completion handler
			completionHandler(nil, NSError())
			return
		}
		
		#if DEBUG
			
			if (ApplicationFlags.flag(key: "PostDummyDataYN")) {
				
				self.doDummyPost(text: text, oncomplete: completionHandler)
				return
				
			}
			
		#endif
		
		// Create item
		let item:		RelativeInteraction = self.createRelativeInteraction(applicationID: applicationID, fromRelativeMemberID: currentRelativeMemberID, toRelativeMemberID: nil, interactionType: .postcontractlessmyfeed, text: text)
		
		// Set status to ensure item is inserted
		item.status 	= .new
		
		// Create completion handler
		let saveCompletionHandler: ((Error?) -> Void) =
		{
			[unowned self] (error) -> Void in
			
			var result: [RelativeInteractionWrapper]? = nil
			
			if (error == nil) {
				
				// Copy items to wrappers array
				result = self.getRelativeInteractionModelAdministrator().toWrappers()
				
			}
			
			// Call completion handler
			completionHandler(result?.first, error)
			
		}
		
		// Save data
		self.getRelativeInteractionModelAdministrator().save(oncomplete: saveCompletionHandler)
		
	}
	
	public func contractlessPostToMemberFeed(toRelativeMemberID: String, currentRelativeMemberID: String, text: String, applicationID: String, oncomplete completionHandler:@escaping (RelativeInteractionWrapper?, Error?) -> Void) {
		
		guard (self.isSetupYN) else {
			// Call completion handler
			completionHandler(nil, NSError())
			return
		}
		
		#if DEBUG
			
			if (ApplicationFlags.flag(key: "PostDummyDataYN")) {
				
				self.doDummyPost(text: text, oncomplete: completionHandler)
				return
				
			}
			
		#endif
		
		// Create item
		let item:		RelativeInteraction = self.createRelativeInteraction(applicationID: applicationID, fromRelativeMemberID: currentRelativeMemberID, toRelativeMemberID: toRelativeMemberID, interactionType: .postcontractlessmemberfeed, text: text)
		
		// Set status to ensure item is inserted
		item.status 	= .new
		
		// Create completion handler
		let saveCompletionHandler: ((Error?) -> Void) =
		{
			[unowned self] (error) -> Void in
			
			var result: [RelativeInteractionWrapper]? = nil
			
			if (error == nil) {
				
				// Copy items to wrappers array
				result = self.getRelativeInteractionModelAdministrator().toWrappers()
				
			}
			
			// Call completion handler
			completionHandler(result?.first, error)
			
		}
		
		// Save data
		self.getRelativeInteractionModelAdministrator().save(oncomplete: saveCompletionHandler)
		
	}
	
	
	// MARK: - Private Methods
	
	fileprivate func setStateBeforeLoad() {
		
		// Notify the delegate
		self.delegate?.socialManagerSetStateBeforeLoad()
	}
	
	fileprivate func setStateAfterLoad() {
		
		// Notify the delegate
		self.delegate?.socialManagerSetStateAfterLoad()
	}
	
	fileprivate func doDummyPost(text: String, oncomplete completionHandler:@escaping (RelativeInteractionWrapper?, Error?) -> Void) {

		// Setup dummy item
		let ri: 	RelativeInteractionWrapper = RelativeInteractionWrapper()
		ri.text 	= text
		
		// DEBUG:
		//let error: Error? = NSError()
		let error: Error? = nil
		
		// Call completion handler
		completionHandler(ri, error)
		
	}
	
	
	// MARK: - Private Methods; getModelAdministrator
	
	fileprivate func getRelativeMemberModelAdministrator() -> RelativeMemberModelAdministrator {
		
		return self.modelManager!.getRelativeMemberModelAdministrator!
	}
	
	fileprivate func getRelativeConnectionModelAdministrator() -> RelativeConnectionModelAdministrator {
		
		return self.modelManager!.getRelativeConnectionModelAdministrator!
	}
	
	fileprivate func getRelativeConnectionRequestModelAdministrator() -> RelativeConnectionRequestModelAdministrator {
		
		return self.modelManager!.getRelativeConnectionRequestModelAdministrator!
	}
	
	fileprivate func getRelativeInteractionModelAdministrator() -> RelativeInteractionModelAdministrator {
		
		return self.modelManager!.getRelativeInteractionModelAdministrator!
	}
	
	fileprivate func getRelativeTimelineEventModelAdministrator() -> RelativeTimelineEventModelAdministrator {
		
		return self.modelManager!.getRelativeTimelineEventModelAdministrator!
	}
	

	// MARK: - Private Methods; doAfterLoad

	fileprivate func doAfterLoadRelativeMembers(oncomplete completionHandler:@escaping ([RelativeMemberWrapper]?, Error?) -> Void) {
		
		// Get the relativeMemberWrappers
		let relativeMemberWrappers: 		[RelativeMemberWrapper] = self.getRelativeMemberModelAdministrator().toWrappers()

		// Create completion handler
		let loadAvatarImagesCompletionHandler: (([RelativeMemberWrapper]?, Error?) -> Void) =
		{
			(items, error) -> Void in
			
			// Call completion handler
			completionHandler(relativeMemberWrappers, error)
			
		}
		
		// Check loadImagesAsynchronouslyYN
		if (self.loadImagesAsynchronouslyYN) {
			
			// Call completion handler
			completionHandler(relativeMemberWrappers, nil)
			
			// Load avatar images
			self.doLoadAvatarImagesAsync(items: relativeMemberWrappers)
			
		} else {
			
			// Load avatar images
			self.doLoadAvatarImages(items: relativeMemberWrappers, oncomplete: loadAvatarImagesCompletionHandler)
			
		}
		
	}
	
	fileprivate func doAfterLoadRelativeConnections(currentRelativeMemberID: String,
													oncomplete completionHandler:@escaping ([RelativeConnectionWrapper]?, Error?) -> Void) {
		
		// Get the relativeConnectionWrappers
		let relativeConnectionWrappers: 	[RelativeConnectionWrapper] = self.getRelativeConnectionModelAdministrator().toWrappers()
		
		// Get the relativeMemberWrappers
		let relativeMemberWrappers: 		[RelativeMemberWrapper] = self.getRelativeMemberModelAdministrator().toWrappers()
		
		// Get currentRelativeMemberWrapper
		let currentRelativeMemberWrapper: 	RelativeMemberWrapper? = RelativeMemberWrapper.current!
		
		// Set relational items
		self.setRelationalItemsForRelativeConnections(relativeConnectionWrappers: relativeConnectionWrappers,
													  relativeMemberWrappers: relativeMemberWrappers,
													  currentRelativeMemberWrapper: currentRelativeMemberWrapper!)
		
		// Create completion handler
		let loadAvatarImagesCompletionHandler: (([RelativeMemberWrapper]?, Error?) -> Void) =
		{
			(items, error) -> Void in
			
			// Call completion handler
			completionHandler(relativeConnectionWrappers, error)
			
		}
		
		// Check loadImagesAsynchronouslyYN
		if (self.loadImagesAsynchronouslyYN) {
			
			// Call completion handler
			completionHandler(relativeConnectionWrappers, nil)
			
			// Load avatar images
			self.doLoadAvatarImagesAsync(items: relativeMemberWrappers)
			
		} else {
			
			// Load avatar images
			self.doLoadAvatarImages(items: relativeMemberWrappers, oncomplete: loadAvatarImagesCompletionHandler)
			
		}
		
	}
	
	fileprivate func doAfterLoadRelativeConnectionRequests(currentRelativeMemberID: String,
														   oncomplete completionHandler:@escaping ([RelativeConnectionRequestWrapper]?, Error?) -> Void) {
		
		// Get the relativeConnectionRequestWrappers
		let relativeConnectionRequestWrappers: 	[RelativeConnectionRequestWrapper] = self.getRelativeConnectionRequestModelAdministrator().toWrappers()
		
		// Get the relativeMemberWrappers
		let relativeMemberWrappers: 			[RelativeMemberWrapper] = self.getRelativeMemberModelAdministrator().toWrappers()
		
		// Get currentRelativeMemberWrapper
		let currentRelativeMemberWrapper: 		RelativeMemberWrapper? = RelativeMemberWrapper.current!
		
		// Set relational items
		self.setRelationalItemsForRelativeConnectionRequests(relativeConnectionRequestWrappers: relativeConnectionRequestWrappers,
															 relativeMemberWrappers: relativeMemberWrappers,
															 currentRelativeMemberWrapper: currentRelativeMemberWrapper!)
		
		// Create completion handler
		let loadAvatarImagesCompletionHandler: (([RelativeMemberWrapper]?, Error?) -> Void) =
		{
			(items, error) -> Void in
			
			// Call completion handler
			completionHandler(relativeConnectionRequestWrappers, error)
			
		}
		
		// Check loadImagesAsynchronouslyYN
		if (self.loadImagesAsynchronouslyYN) {
			
			// Call completion handler
			completionHandler(relativeConnectionRequestWrappers, nil)
			
			// Load avatar images
			self.doLoadAvatarImagesAsync(items: relativeMemberWrappers)
			
		} else {
			
			// Load avatar images
			self.doLoadAvatarImages(items: relativeMemberWrappers, oncomplete: loadAvatarImagesCompletionHandler)
			
		}
		
	}
	
	fileprivate func doAfterLoadRelativeInteractions(currentRelativeMemberID: String,
													 oncomplete completionHandler:@escaping ([RelativeInteractionWrapper]?, Error?) -> Void) {
		
		// Get the relativeInteractionWrappers
		let relativeInteractionWrappers: 	[RelativeInteractionWrapper] = self.getRelativeInteractionModelAdministrator().toWrappers()
		
		// Get the relativeMemberWrappers
		let relativeMemberWrappers: 		[RelativeMemberWrapper] = self.getRelativeMemberModelAdministrator().toWrappers()
		
		// Get currentRelativeMemberWrapper
		let currentRelativeMemberWrapper: 	RelativeMemberWrapper? = RelativeMemberWrapper.current!

		// Set relational items
		self.setRelationalItemsForRelativeInteractions(relativeInteractionWrappers: relativeInteractionWrappers,
													   relativeMemberWrappers: relativeMemberWrappers,
													   currentRelativeMemberWrapper: currentRelativeMemberWrapper!)
		
		// Call completion handler
		completionHandler(relativeInteractionWrappers, nil)
		
	}
	
	fileprivate func doAfterLoadRelativeTimelineEvents(currentRelativeMemberID: String,
													   oncomplete completionHandler:@escaping ([RelativeTimelineEventWrapper]?, Error?) -> Void) {
		
		// Get relativeTimelineEventWrappers
		let relativeTimelineEventWrappers: 	[RelativeTimelineEventWrapper] = self.getRelativeTimelineEventModelAdministrator().toWrappers()
		
		// Get the relativeMemberWrappers
		let relativeMemberWrappers: 		[RelativeMemberWrapper] = self.getRelativeMemberModelAdministrator().toWrappers()
		
		// Get the relativeInteractionWrappers
		let relativeInteractionWrappers: 	[RelativeInteractionWrapper] = self.getRelativeInteractionModelAdministrator().toWrappers()

		// Get currentRelativeMemberWrapper
		let currentRelativeMemberWrapper: 	RelativeMemberWrapper? = RelativeMemberWrapper.current!

		// Set relational items in relativeInteractionWrappers
		self.setRelationalItemsForRelativeInteractions(relativeInteractionWrappers: relativeInteractionWrappers,
													   relativeMemberWrappers: relativeMemberWrappers,
													   currentRelativeMemberWrapper: RelativeMemberWrapper.current!)
		
		// Set relational items in relativeTimelineEventWrappers
		self.setRelationalItemsForRelativeTimelineEvents(relativeTimelineEventWrappers: relativeTimelineEventWrappers,
														 relativeInteractionWrappers: relativeInteractionWrappers,
														 relativeMemberWrappers: relativeMemberWrappers,
														 currentRelativeMemberWrapper: currentRelativeMemberWrapper!)
		
		// Create completion handler
		let loadAvatarImagesCompletionHandler: (([RelativeMemberWrapper]?, Error?) -> Void) =
		{
			(items, error) -> Void in
			
			// Call completion handler
			completionHandler(relativeTimelineEventWrappers, error)
			
		}
		
		// Check loadImagesAsynchronouslyYN
		if (self.loadImagesAsynchronouslyYN) {
			
			// Call completion handler
			completionHandler(relativeTimelineEventWrappers, nil)
			
			// Load avatar images
			self.doLoadAvatarImagesAsync(items: relativeMemberWrappers)
			
		} else {
			
			// Load avatar images
			self.doLoadAvatarImages(items: relativeMemberWrappers, oncomplete: loadAvatarImagesCompletionHandler)
			
		}
		
	}

	
	// MARK: - Private Methods; setRelationalItemsFor
	
	fileprivate func setRelationalItemsForRelativeConnections(relativeConnectionWrappers:  [RelativeConnectionWrapper],
															   relativeMemberWrappers: [RelativeMemberWrapper],
															   currentRelativeMemberWrapper: RelativeMemberWrapper) {
		
		// Go through each relativeConnectionWrapper
		for item in relativeConnectionWrappers {
			
			// Set fromRelativeMember
			if (item.fromRelativeMemberID == currentRelativeMemberWrapper.id) {
				
				item.fromRelativeMember 	= currentRelativeMemberWrapper
				item.isFromCurrentUserYN 	= true
				
			} else {
				
				item.fromRelativeMember 	= RelativeMemberWrapper.find(byID: item.fromRelativeMemberID, wrappers: relativeMemberWrappers)
				item.isFromCurrentUserYN 	= false
				
			}
			
			// Set toRelativeMember
			if (item.toRelativeMemberID == currentRelativeMemberWrapper.id) {
				
				item.toRelativeMember 		= currentRelativeMemberWrapper
				
			} else {
				
				item.toRelativeMember 		= RelativeMemberWrapper.find(byID: item.toRelativeMemberID, wrappers: relativeMemberWrappers)
				
			}
			
		}
		
	}
	
	fileprivate func setRelationalItemsForRelativeConnectionRequests(relativeConnectionRequestWrappers:  [RelativeConnectionRequestWrapper],
															  relativeMemberWrappers: [RelativeMemberWrapper],
															  currentRelativeMemberWrapper: RelativeMemberWrapper) {
		
		// Go through each relativeConnectionRequestWrapper
		for item in relativeConnectionRequestWrappers {
			
			// Set fromRelativeMember
			if (item.fromRelativeMemberID == currentRelativeMemberWrapper.id) {
				
				item.fromRelativeMember 	= currentRelativeMemberWrapper
				item.isFromCurrentUserYN 	= true
				
			} else {
				
				item.fromRelativeMember 	= RelativeMemberWrapper.find(byID: item.fromRelativeMemberID, wrappers: relativeMemberWrappers)
				item.isFromCurrentUserYN 	= false
				
			}
			
			// Set toRelativeMember
			if (item.toRelativeMemberID == currentRelativeMemberWrapper.id) {
				
				item.toRelativeMember 		= currentRelativeMemberWrapper
				
			} else {
				
				item.toRelativeMember 		= RelativeMemberWrapper.find(byID: item.toRelativeMemberID, wrappers: relativeMemberWrappers)
				
			}
			
		}
		
	}
	
	fileprivate func setRelationalItemsForRelativeTimelineEvents(relativeTimelineEventWrappers: [RelativeTimelineEventWrapper],
																 relativeInteractionWrappers: [RelativeInteractionWrapper],
																 relativeMemberWrappers: [RelativeMemberWrapper],
																 currentRelativeMemberWrapper: RelativeMemberWrapper) {
		
		
		// Go through each relativeTimelineEventWrapper
		for item in relativeTimelineEventWrappers {
			
			if (item.forRelativeMemberID == currentRelativeMemberWrapper.id) {
				
				item.forRelativeMember 		= currentRelativeMemberWrapper
				
			} else {
				
				item.forRelativeMember 		= RelativeMemberWrapper.find(byID: item.forRelativeMemberID, wrappers: relativeMemberWrappers)
				
			}
			
			item.relativeInteraction 		= RelativeInteractionWrapper.find(byID: item.relativeInteractionID, wrappers: relativeInteractionWrappers)
			
		}
		
	}
	
	fileprivate func setRelationalItemsForRelativeInteractions(relativeInteractionWrappers:  [RelativeInteractionWrapper],
															   relativeMemberWrappers: [RelativeMemberWrapper],
															   currentRelativeMemberWrapper: RelativeMemberWrapper) {
		
		// Go through each relativeInteractionWrapper
		for item in relativeInteractionWrappers {
			
			// Set fromRelativeMember
			if (item.fromRelativeMemberID == currentRelativeMemberWrapper.id) {
				
				item.fromRelativeMember 	= currentRelativeMemberWrapper
				item.isFromCurrentUserYN 	= true
				
			} else {
				
				item.fromRelativeMember 	= RelativeMemberWrapper.find(byID: item.fromRelativeMemberID, wrappers: relativeMemberWrappers)
				item.isFromCurrentUserYN 	= false
				
			}
			
			// Set toRelativeMember
			if (item.toRelativeMemberID == currentRelativeMemberWrapper.id) {
				
				item.toRelativeMember 		= currentRelativeMemberWrapper
				
			} else {
				
				item.toRelativeMember 		= RelativeMemberWrapper.find(byID: item.toRelativeMemberID, wrappers: relativeMemberWrappers)
				
			}
			
		}
		
	}
	
	
	// MARK: - Private Methods; create
	
	fileprivate func createRelativeMember(applicationID: String, userProfileID: String, email: String, fullName: String, avatarImageFileName: String) -> RelativeMember {
		
		var result: RelativeMember? = nil
		
		self.getRelativeMemberModelAdministrator().initialise()
		
		// Get the collection
		if let collection = self.getRelativeMemberModelAdministrator().collection as? RelativeMemberCollection {
			
			// Create item
			result = (collection.addItem() as! RelativeMember)
			
			// Set properties
			result!.applicationID 		= applicationID
			result!.userProfileID		= userProfileID
			result!.email 				= email
			result!.fullName 			= fullName
			result!.avatarImageFileName = avatarImageFileName
			
		}
		
		return result!
		
	}
	
	fileprivate func createRelativeConnection(applicationID: String, fromRelativeMemberID: String, toRelativeMemberID: String, connectionContractType: RelativeConnectionContractTypes) -> RelativeConnection {
		
		var result: RelativeConnection? = nil
		
		self.getRelativeConnectionModelAdministrator().initialise()
		
		// Get the collection
		if let collection = self.getRelativeConnectionModelAdministrator().collection as? RelativeConnectionCollection {
			
			// Create item
			result = (collection.addItem() as! RelativeConnection)
			
			// Set properties
			result!.applicationID 				= applicationID
			result!.fromRelativeMemberID 		= fromRelativeMemberID
			result!.toRelativeMemberID 			= toRelativeMemberID
			result!.connectionContractType 		= connectionContractType
			result!.dateActioned 				= Date()
			result!.connectionStatus 			= RelativeConnectionStatus.active
			
		}
		
		return result!
	}
	
	fileprivate func createRelativeConnection(relativeConnectionRequestWrapper: RelativeConnectionRequestWrapper, connectionContractType: RelativeConnectionContractTypes) -> RelativeConnection {
		
		var result: RelativeConnection? = nil
		
		self.getRelativeConnectionModelAdministrator().initialise()
		
		// Get the collection
		if let collection = self.getRelativeConnectionModelAdministrator().collection as? RelativeConnectionCollection {
			
			// Create item
			result = (collection.addItem() as! RelativeConnection)
			
			// Set properties
			result!.applicationID 				= relativeConnectionRequestWrapper.applicationID
			result!.fromRelativeMemberID 		= relativeConnectionRequestWrapper.fromRelativeMemberID
			result!.toRelativeMemberID 			= relativeConnectionRequestWrapper.toRelativeMemberID
			result!.connectionContractType 		= connectionContractType
			result!.dateActioned 				= Date()
			result!.connectionStatus 			= RelativeConnectionStatus.active
			
		}
		
		return result!
	}
	
	fileprivate func createRelativeConnectionRequest(applicationID: String, fromRelativeMemberID: String, toRelativeMemberID: String, requestType: RelativeConnectionRequestTypes) -> RelativeConnectionRequest {
		
		var result: RelativeConnectionRequest? = nil
		
		self.getRelativeConnectionRequestModelAdministrator().initialise()
		
		// Get the collection
		if let collection = self.getRelativeConnectionRequestModelAdministrator().collection as? RelativeConnectionRequestCollection {
			
			// Create item
			result = (collection.addItem() as! RelativeConnectionRequest)
			
			// Set properties
			result!.applicationID 			= applicationID
			result!.fromRelativeMemberID 	= fromRelativeMemberID
			result!.toRelativeMemberID 		= toRelativeMemberID
			result!.requestType 			= requestType
			result!.dateActioned 			= Date()
			result!.requestStatus 			= RelativeConnectionRequestStatus.active
			
		}
		
		return result!
	}
	
	fileprivate func createRelativeInteraction(applicationID: String, fromRelativeMemberID: String, toRelativeMemberID: String?, interactionType: RelativeInteractionTypes, text: String) -> RelativeInteraction {
		
		var result: RelativeInteraction? = nil
		
		self.getRelativeInteractionModelAdministrator().initialise()
		
		// Get the collection
		if let collection = self.getRelativeInteractionModelAdministrator().collection as? RelativeInteractionCollection {
			
			// Create item
			result = (collection.addItem() as! RelativeInteraction)
			
			// Set properties
			result!.applicationID 			= applicationID
			result!.fromRelativeMemberID 	= fromRelativeMemberID
			result!.toRelativeMemberID 		= toRelativeMemberID ?? ""
			result!.interactionType 		= interactionType
			result!.dateActioned 			= Date()
			result!.interactionStatus 		= RelativeInteractionStatus.active
			result!.text 					= text
			
		}
		
		return result!
	}
	
	fileprivate func createRelativeTimelineEvent(forRelativeMemberID: String?, relativeInteractionWrapper: RelativeInteractionWrapper) -> RelativeTimelineEvent {
		
		var result: 			RelativeTimelineEvent? = nil
		
		self.getRelativeTimelineEventModelAdministrator().initialise()
		
		// Get the collection
		if let collection = self.getRelativeTimelineEventModelAdministrator().collection as? RelativeTimelineEventCollection {
			
			// Create item
			result 				= (collection.addItem() as! RelativeTimelineEvent)
			
			// Get the eventType
			var eventType: 		RelativeTimelineEventTypes = .standard
			
			switch relativeInteractionWrapper.interactionType {
			case .postfollowcontractmyfeed:
				eventType 		= .postfollowcontractmyfeed
			case .postfriendcontractmyfeed:
				eventType 		= .postfriendcontractmyfeed
			case .postfriendcontractfriendfeed:
				eventType 		= .postfriendcontractfriendfeed
			default:
				eventType 		= .standard
			}
			
			// Set properties
			result!.applicationID 			= relativeInteractionWrapper.applicationID
			result!.forRelativeMemberID		= forRelativeMemberID ?? ""
			result!.relativeInteractionID 	= relativeInteractionWrapper.id
			result!.eventType 				= eventType
			result!.dateActioned 			= Date()
			result!.eventStatus 			= RelativeTimelineEventStatus.active
			
		}
		
		return result!
	}

	
	// MARK: - Private Methods; doLoadAvatarImages
	
	fileprivate func doLoadAvatarImagesAsync(items: [RelativeMemberWrapper]) {
		
		guard (self.getRelativeMemberModelAdministrator().collection?.items != nil) else {
			
			return
		}
		
		// Create completion handler
		let loadRelativeMemberAvatarImageDataCompletionHandler: ((RelativeMemberWrapper, Data?, Error?) -> Void) =
		{
			[unowned self] (item, data, error) -> Void in

			if (data != nil && error == nil) {
				
				// Notify the delegate
				self.delegate?.socialManager(item: item, loadedAvatarImage: self)
				
			}
			
		}
		
		// Go through each item
		for item in items {
			
			// Load image data
			self.loadRelativeMemberAvatarImageData(for: item, oncomplete: loadRelativeMemberAvatarImageDataCompletionHandler)
			
		}
		
	}
	
	fileprivate func doLoadAvatarImages(items: [RelativeMemberWrapper], oncomplete completionHandler:@escaping ([RelativeMemberWrapper]?, Error?) -> Void) {
		
		guard (items.count > 0) else {
			
			// Call completion handler
			completionHandler(items, nil)
			
			return
		}

		var loadResultCount: Int = 0
		
		// Create completion handler
		let loadRelativeMemberAvatarImageDataCompletionHandler: ((RelativeMemberWrapper, Data?, Error?) -> Void) =
		{
			(item, data, error) -> Void in
			
			loadResultCount += 1

			// Check loadResultCount
			if (loadResultCount >= items.count) {
				
				// Call completion handler
				completionHandler(items, nil)
				
			}
			
		}
		
		// Go through each item
		for item in items {
			
			// Load image data
			self.loadRelativeMemberAvatarImageData(for: item, oncomplete: loadRelativeMemberAvatarImageDataCompletionHandler)
			
		}
	
	}
	
}

