//
//  ProtocolPlayExperienceModelAccessStrategy.swift
//  SFGame
//
//  Created by David on 01/01/2018.
//  Copyright © 2018 com.smartfoundation. All rights reserved.
//

import SFModel

/// Defines a class which provides a strategy for accessing the PlayExperience model data
public protocol ProtocolPlayExperienceModelAccessStrategy {
	
	// MARK: - Methods

	func select(byPlayMoveID playMoveID: String, forPlayReferenceID playReferenceID: String, loadRelationalTablesYN: Bool, collection: ProtocolModelItemCollection, oncomplete completionHandler:@escaping ([String:Any]?, ProtocolModelItemCollection?, Error?) -> Void)
	
}
