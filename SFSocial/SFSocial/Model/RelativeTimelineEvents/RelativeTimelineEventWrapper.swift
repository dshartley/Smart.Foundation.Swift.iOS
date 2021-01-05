//
//  RelativeTimelineEventWrapper.swift
//  SFSocial
//
//  Created by David on 01/01/2018.
//  Copyright © 2018 com.smartfoundation. All rights reserved.
//

import UIKit

/// A wrapper for a RelativeTimelineEvent model item
public class RelativeTimelineEventWrapper {
	
	// MARK: - Public Stored Properties
	
	public var id:						String = ""
	public var applicationID:			String = ""
	public var forRelativeMemberID:		String = ""
	public var forRelativeMember:		RelativeMemberWrapper?
	public var relativeInteractionID:	String = ""
	public var relativeInteraction:		RelativeInteractionWrapper?
	public var eventType:				RelativeTimelineEventTypes = .standard
	public var dateActioned:			Date = Date()
	public var eventStatus:				RelativeTimelineEventStatus = .active
	
	
	// MARK: - Initializers
	
	public init() {
		
	}

}
