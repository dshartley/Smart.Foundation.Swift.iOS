//
//  ProtocolRelativeMemberModelAccessStrategy.swift
//  SFSocial
//
//  Created by David on 01/01/2018.
//  Copyright © 2018 com.smartfoundation. All rights reserved.
//

import SFModel

/// Defines a class which provides a strategy for accessing the RelativeMember model data
public protocol ProtocolRelativeMemberModelAccessStrategy {
	
	// MARK: - Methods

	func select(byUserProfileID userProfileID: String, applicationID: String, collection: ProtocolModelItemCollection, oncomplete completionHandler:@escaping ([String:Any]?, ProtocolModelItemCollection?, Error?) -> Void)
	
	func select(byEmail email: String, applicationID: String, collection: ProtocolModelItemCollection, oncomplete completionHandler:@escaping ([String:Any]?, ProtocolModelItemCollection?, Error?) -> Void)

	func select(byEmail email: String, applicationID: String, connectionContractType: RelativeConnectionContractTypes, currentRelativeMemberID: String, collection: ProtocolModelItemCollection, oncomplete completionHandler:@escaping ([String:Any]?, ProtocolModelItemCollection?, Error?) -> Void)

	func select(byID id: String, applicationID: String, connectionContractType: RelativeConnectionContractTypes, currentRelativeMemberID: String, collection: ProtocolModelItemCollection, oncomplete completionHandler:@escaping ([String:Any]?, ProtocolModelItemCollection?, Error?) -> Void)

	func select(byFindText findText: String, applicationID: String, currentRelativeMemberID: String?, scopeType: RelativeMemberScopeTypes, previousRelativeMemberID: String, numberOfItemsToLoad: Int, selectItemsAfterPreviousYN: Bool, collection: ProtocolModelItemCollection, oncomplete completionHandler:@escaping ([String:Any]?, ProtocolModelItemCollection?, Error?) -> Void)
	
	func select(byAspects aspectTypes: [RelativeMemberQueryAspectTypes], applicationID: String, maxResults: Int, currentRelativeMemberID: String?, scopeType: RelativeMemberScopeTypes, previousRelativeMemberID: String, numberOfItemsToLoad: Int, selectItemsAfterPreviousYN: Bool, collection: ProtocolModelItemCollection, oncomplete completionHandler:@escaping ([String:Any]?, ProtocolModelItemCollection?, Error?) -> Void)
	
}
