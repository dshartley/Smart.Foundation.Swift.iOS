//
//  RelativeInteractionWrapper.swift
//  SFSocial
//
//  Created by David on 01/01/2018.
//  Copyright © 2018 com.smartfoundation. All rights reserved.
//

import UIKit

/// A wrapper for a RelativeInteraction model item
public class RelativeInteractionWrapper {
	
	// MARK: - Public Stored Properties
	
	public var id:						String = ""
	public var applicationID:			String = ""
	public var fromRelativeMemberID:	String = ""
	public var fromRelativeMember:		RelativeMemberWrapper?
	public var isFromCurrentUserYN:		Bool = false
	public var toRelativeMemberID:		String = ""
	public var toRelativeMember:		RelativeMemberWrapper?
	public var interactionType:			RelativeInteractionTypes = .standard
	public var dateActioned:			Date = Date()
	public var interactionStatus:		RelativeInteractionStatus = .active
	public var text:					String = ""
	
	
	// MARK: - Initializers
	
	public init() {
		
	}
	
	
	// MARK: - Public Class Methods
	
	public class func find(byID id: String, wrappers: [RelativeInteractionWrapper]) -> RelativeInteractionWrapper? {
		
		for item in wrappers {
			
			if (item.id == id) {
				
				return item
			}
			
		}
		
		return nil
		
	}
	
}
