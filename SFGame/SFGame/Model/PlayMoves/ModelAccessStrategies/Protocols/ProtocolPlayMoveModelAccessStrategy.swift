//
//  ProtocolPlayMoveModelAccessStrategy.swift
//  SFGame
//
//  Created by David on 01/01/2018.
//  Copyright © 2018 com.smartfoundation. All rights reserved.
//

import SFModel

/// Defines a class which provides a strategy for accessing the PlayMove model data
public protocol ProtocolPlayMoveModelAccessStrategy {
	
	// MARK: - Methods
	
	func select(byPlayReferenceID playReferenceID: String, playReferenceType: PlayReferenceTypes, collection: ProtocolModelItemCollection, oncomplete completionHandler:@escaping ([String:Any]?, ProtocolModelItemCollection?, Error?) -> Void)
	
}
