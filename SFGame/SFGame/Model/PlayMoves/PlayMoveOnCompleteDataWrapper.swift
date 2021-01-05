//
//  PlayMoveOnCompleteDataWrapper.swift
//  SFGame
//
//  Created by David on 13/10/2018.
//  Copyright © 2018 com.smartfoundation. All rights reserved.
//

import UIKit
import SFSerialization

/// A wrapper for a PlayMoveOnCompleteDataWrapper model item
public class PlayMoveOnCompleteDataWrapper {
	
	// MARK: - Private Stored Properties
	
	fileprivate var wrapper: DataJSONWrapper?
	
	
	// MARK: - Public Stored Properties
	
	
	// MARK: - Initializers
	
	fileprivate init() {
		
	}
	
	public init(onCompleteData: String) {
		
		self.set(onCompleteData: onCompleteData)
		
	}
	
	
	// MARK: - Public Methods
	
	public func get(key: String) -> String? {
		
		guard (wrapper != nil) else { return nil }
		
		return wrapper!.getParameterValue(key: key)
		
	}
	
	
	// MARK: - Private Methods
	
	fileprivate func set(onCompleteData: String) {
		
		guard (onCompleteData.count > 0) else { return }
		
		// Get DataJSONWrapper from contentData
		self.wrapper = JSONHelper.DeserializeDataJSONWrapper(dataString: onCompleteData)
		
		guard (self.wrapper != nil) else { return }
		
	}
	
}
