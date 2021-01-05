//
//  ProtocolPlaySpaceDataModelAccessStrategy.swift
//  SFGame
//
//  Created by David on 01/01/2018.
//  Copyright © 2018 com.smartfoundation. All rights reserved.
//

import SFModel

/// Defines a class which provides a strategy for accessing the PlaySpaceData model data
public protocol ProtocolPlaySpaceDataModelAccessStrategy {
	
	// MARK: - Methods

	func select(byPlaySpaceID playSpaceID: String, collection: ProtocolModelItemCollection, oncomplete completionHandler:@escaping ([String:Any]?, ProtocolModelItemCollection?, Error?) -> Void)
	
}
