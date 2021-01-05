//
//  RelativeConnectionWrapper.swift
//  SFSocial
//
//  Created by David on 01/01/2018.
//  Copyright © 2018 com.smartfoundation. All rights reserved.
//

import UIKit

/// A wrapper for a RelativeConnection model item
public class RelativeConnectionWrapper {
	
	// MARK: - Public Stored Properties
	
	public var id:					        String = ""
	public var applicationID:				String = ""
	public var fromRelativeMemberID:	    String = ""
	public var fromRelativeMember:			RelativeMemberWrapper?
	public var isFromCurrentUserYN:			Bool = false
	public var toRelativeMemberID:		    String = ""
	public var toRelativeMember:			RelativeMemberWrapper?
	public var connectionContractType:		RelativeConnectionContractTypes = .friend
	public var dateActioned:		        Date = Date()
	public var dateLastActive:		        Date = Date()
	public var connectionStatus:	        RelativeConnectionStatus = .active
	
	
	// MARK: - Initializers
	
	public init() {
		
	}
	
}
