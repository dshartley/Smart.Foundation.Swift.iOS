//
//  RelativeMemberWrapper.swift
//  SFSocial
//
//  Created by David on 05/02/2018.
//  Copyright © 2018 com.smartfoundation. All rights reserved.
//

import UIKit

/// A wrapper for a RelativeMember model item
public class RelativeMemberWrapper: Codable {
	
	// MARK: - Private Static Stored Properties
	
	fileprivate static var _current:	RelativeMemberWrapper? = nil
	
	
	// MARK: - Public Stored Properties
	
	public var id:					    String = ""
	public var applicationID:			String = ""
	public var userProfileID:	        String = ""
	public var email:					String = ""
	public var fullName:				String = ""
	public var avatarImageFileName: 	String = ""
	public var avatarImageData: 		Data?
	public var connectionContractTypes:	String = ""
	
	
	// MARK: - Public Class Computed Properties
	
	public class var current: RelativeMemberWrapper? {
		get {
			return RelativeMemberWrapper._current
		}
		set(value) {
			RelativeMemberWrapper._current = value
		}
	}
	
	
	// MARK: - Initializers
	
	public init() {
		
	}
	
	
	// MARK: - Public Class Methods
	
	public class func find(byID id: String, wrappers: [RelativeMemberWrapper]) -> RelativeMemberWrapper? {
		
		for item in wrappers {
			
			if (item.id == id) {
				
				return item
			}
			
		}
		
		return nil
		
	}
	
}
