//
//  ProtocolRelativeConnectionRequestModelAccessStrategy.swift
//  SFSocial
//
//  Created by David on 01/01/2018.
//  Copyright © 2018 com.smartfoundation. All rights reserved.
//

import SFModel

/// Defines a class which provides a strategy for accessing the RelativeConnectionRequest model data
public protocol ProtocolRelativeConnectionRequestModelAccessStrategy {
	
	// MARK: - Methods
	
	func select(byFromRelativeMemberID fromRelativeMemberID: String, applicationID: String, requestType: RelativeConnectionRequestTypes, collection: ProtocolModelItemCollection, oncomplete completionHandler:@escaping ([String:Any]?, ProtocolModelItemCollection?, Error?) -> Void)
	
	func select(byToRelativeMemberID toRelativeMemberID: String, applicationID: String, requestType: RelativeConnectionRequestTypes, collection: ProtocolModelItemCollection, oncomplete completionHandler:@escaping ([String:Any]?, ProtocolModelItemCollection?, Error?) -> Void)
	
	func select(fromRelativeMemberID: String, byToRelativeMemberID toRelativeMemberID: String, applicationID: String, requestType: RelativeConnectionRequestTypes, collection: ProtocolModelItemCollection, oncomplete completionHandler:@escaping ([String:Any]?, ProtocolModelItemCollection?, Error?) -> Void)
	
}
