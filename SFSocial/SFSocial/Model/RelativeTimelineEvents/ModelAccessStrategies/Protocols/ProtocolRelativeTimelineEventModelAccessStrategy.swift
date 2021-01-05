//
//  ProtocolRelativeTimelineEventModelAccessStrategy.swift
//  SFSocial
//
//  Created by David on 01/01/2018.
//  Copyright © 2018 com.smartfoundation. All rights reserved.
//

import SFModel

/// Defines a class which provides a strategy for accessing the RelativeTimelineEvent model data
public protocol ProtocolRelativeTimelineEventModelAccessStrategy {
	
	// MARK: - Methods
	
	func insert(item: ProtocolModelItem, forRelativeMemberIDs: [String], oncomplete completionHandler:@escaping (String, Error?) -> Void)
	
	func select(byForRelativeMemberID forRelativeMemberID: String,
				applicationID: String,
				currentRelativeMemberID: String,
				scopeType: RelativeTimelineEventScopeTypes,
				relativeTimelineEventTypes: [RelativeTimelineEventTypes],
				previousRelativeTimelineEventID: String,
				numberOfItemsToLoad: Int,
				selectItemsAfterPreviousYN: Bool,
				collection: ProtocolModelItemCollection,
				oncomplete completionHandler:@escaping ([String:Any]?, ProtocolModelItemCollection?, Error?) -> Void)

	func select(byRelativeInteractionID relativeInteractionID: String,
				applicationID: String,
				collection: ProtocolModelItemCollection,
				oncomplete completionHandler:@escaping ([String:Any]?, ProtocolModelItemCollection?, Error?) -> Void)
	
}
