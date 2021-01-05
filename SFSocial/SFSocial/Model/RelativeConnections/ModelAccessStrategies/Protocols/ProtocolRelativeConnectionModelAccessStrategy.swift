//
//  ProtocolRelativeConnectionModelAccessStrategy.swift
//  SFSocial
//
//  Created by David on 01/01/2018.
//  Copyright © 2018 com.smartfoundation. All rights reserved.
//

import SFModel

/// Defines a class which provides a strategy for accessing the RelativeConnection model data
public protocol ProtocolRelativeConnectionModelAccessStrategy {
	
	// MARK: - Methods

    func select(byFromRelativeMemberID fromRelativeMemberID: String, applicationID: String, connectionContractType: RelativeConnectionContractTypes, collection: ProtocolModelItemCollection, oncomplete completionHandler:@escaping ([String:Any]?, ProtocolModelItemCollection?, Error?) -> Void)

	func select(byToRelativeMemberID toRelativeMemberID: String, applicationID: String, connectionContractType: RelativeConnectionContractTypes, collection: ProtocolModelItemCollection, oncomplete completionHandler:@escaping ([String:Any]?, ProtocolModelItemCollection?, Error?) -> Void)

	func select(fromRelativeMemberID: String, byToRelativeMemberID toRelativeMemberID: String, applicationID: String, connectionContractType: RelativeConnectionContractTypes, collection: ProtocolModelItemCollection, oncomplete completionHandler:@escaping ([String:Any]?, ProtocolModelItemCollection?, Error?) -> Void)
	
	func select(byWithRelativeMemberID withRelativeMemberID: String, applicationID: String, connectionContractType: RelativeConnectionContractTypes, collection: ProtocolModelItemCollection, oncomplete completionHandler:@escaping ([String:Any]?, ProtocolModelItemCollection?, Error?) -> Void)

	func select(forRelativeMemberID: String, byWithRelativeMemberID withRelativeMemberID: String, applicationID: String, connectionContractType: RelativeConnectionContractTypes, collection: ProtocolModelItemCollection, oncomplete completionHandler:@escaping ([String:Any]?, ProtocolModelItemCollection?, Error?) -> Void)
	
}
