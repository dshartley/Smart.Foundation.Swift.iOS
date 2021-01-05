//
//  PathLogWrapper.swift
//  SFGridScape
//
//  Created by David on 27/09/2018.
//  Copyright © 2018 com.smartfoundation. All rights reserved.
//

import UIKit
import SFSerialization

public enum PathLogKeys {
	case DoneDoBeforeStartMovingAlongPath
	case DoneSetNext
	case DoneDoBeforeMovePoint
	case DoneDoMovePoint
	case DoneDoAfterMovePoint
	case DoneDoAfterFinishedMovingAlongPath
}

/// A wrapper for a PathLogWrapper model item
public class PathLogWrapper {
	
	// MARK: - Private Stored Properties
	
	
	// MARK: - Public Stored Properties
	
	public fileprivate(set) var wrapper: DataJSONWrapper = DataJSONWrapper()
	
	
	// MARK: - Initializers
	
	public init() {
		
	}
	
	public init(pathLogString: String) {
		
		self.set(pathLogString: pathLogString)
		
	}
	
	
	// MARK: - Public Methods
	
	public func toString() -> String {
		
		var result: String = ""

		// Get DataJSONWrapper from contentData
		result = JSONHelper.SerializeDataJSONWrapper(dataWrapper: self.wrapper) ?? ""
		
		return result
		
	}
	
	public func set(attribute key: String, value: String?) {
		
		if (value != nil) {
			
			self.wrapper.setParameterValue(key: key, value: value!)
			
		} else {
			
			self.wrapper.deleteParameterValue(key: key)
			
		}
		
	}
	
	public func get(attribute key: String) -> String? {
		
		var result: String? = nil
		
		result 		= self.wrapper.getParameterValue(key: key)
		
		return result
		
	}
	
	public func get() -> [String: String] {
		
		var result: [String: String] = [String: String]()
		
		for pw in self.wrapper.Params {
			
			result[pw.Key] = pw.Value
			
		}
		
		return result
		
	}
	
	public func log(key: PathLogKeys) {
		
		let data: 	DataJSONWrapper = DataJSONWrapper()
		data.ID 	= "\(key)"
		
		self.wrapper.Items.append(data)
		
	}

	public func log(key: PathLogKeys, pathPointWrapperID: String) {
		
		let data: 	DataJSONWrapper = DataJSONWrapper()
		data.ID 	= "\(pathPointWrapperID)_\(key)"
		
		data.setParameterValue(key: "PathPointWrapperID", value: pathPointWrapperID)
		
		self.wrapper.Items.append(data)
		
		print("LOG:\(data.ID)")
	}
	
	public func hasLogged(key: PathLogKeys) -> Bool {
		
		let id: 		String = "\(key)"
		
		let result: 	Bool = (self.wrapper.getItem(id: id) != nil) ? true : false

		return result
		
	}

	public func hasLogged(key: PathLogKeys, pathPointWrapperID: String) -> Bool {
		
		let id: 		String = "\(pathPointWrapperID)_\(key)"
		
		let result: 	Bool = (self.wrapper.getItem(id: id) != nil) ? true : false
		
		return result
		
	}
	
	// MARK: - Private Methods
	
	fileprivate func set(pathLogString: String) {
		
		var result: DataJSONWrapper = DataJSONWrapper()
		
		if (pathLogString.count > 0) {
			
			// Get DataJSONWrapper from PathLogString
			result = JSONHelper.DeserializeDataJSONWrapper(dataString: pathLogString) ?? DataJSONWrapper()
			
		}
		
		self.wrapper = result
		
	}
	
}
