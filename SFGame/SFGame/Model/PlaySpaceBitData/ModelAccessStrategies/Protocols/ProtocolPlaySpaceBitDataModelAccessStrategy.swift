//
//  ProtocolPlaySpaceBitDataModelAccessStrategy.swift
//  SFGame
//
//  Created by David on 01/01/2018.
//  Copyright © 2018 com.smartfoundation. All rights reserved.
//

import SFModel

/// Defines a class which provides a strategy for accessing the PlaySpaceBitData model data
public protocol ProtocolPlaySpaceBitDataModelAccessStrategy {
	
	// MARK: - Methods

	func select(byPlaySpaceBitID playSpaceBitID: String, collection: ProtocolModelItemCollection, oncomplete completionHandler:@escaping ([String:Any]?, ProtocolModelItemCollection?, Error?) -> Void)
	
}
