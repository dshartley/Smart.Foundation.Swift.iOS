//
//  ProtocolPlaySpaceBitTypeModelAccessStrategy.swift
//  SFGame
//
//  Created by David on 01/01/2018.
//  Copyright © 2018 com.smartfoundation. All rights reserved.
//

import SFModel

/// Defines a class which provides a strategy for accessing the PlaySpaceBitType model data
public protocol ProtocolPlaySpaceBitTypeModelAccessStrategy {
	
	// MARK: - Methods

	func select(byRelativeMemberID relativeMemberID: String, playSpaceID: String, collection: ProtocolModelItemCollection, oncomplete completionHandler:@escaping ([String:Any]?, ProtocolModelItemCollection?, Error?) -> Void)
	
}
