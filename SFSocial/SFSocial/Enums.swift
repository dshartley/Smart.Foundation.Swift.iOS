//
//  Enums.swift
//  SFSocial
//
//  Created by David on 09/03/2018.
//  Copyright © 2018 com.smartfoundation. All rights reserved.
//

/// Specifies relative connection contract types
public enum RelativeConnectionContractTypes: Int {
	case friend 		= 1
	case follow 		= 2
	case handshake		= 3
	case contractless 	= 4
	case transient 		= 5
	
}

/// Specifies relative connection status
public enum RelativeConnectionStatus: Int {
	case active 	= 1
}

/// Specifies relative connection request types
public enum RelativeConnectionRequestTypes: Int {
	case friend 	= 1
}

/// Specifies relative connection request status
public enum RelativeConnectionRequestStatus: Int {
	case active 	= 1
	case accepted	= 2
	case rejected	= 3
}

/// Specifies relative interaction types
public enum RelativeInteractionTypes: Int {
	case standard 						= 1
	case postfollowcontractmyfeed 		= 2
	case postfriendcontractmyfeed 		= 3
	case postfriendcontractfriendfeed 	= 4
	case handshake						= 5
	case postcontractlessmyfeed			= 6
	case postcontractlessmemberfeed		= 7
}

/// Specifies relative interaction status
public enum RelativeInteractionStatus: Int {
	case active 	= 1
}

/// Specifies relative timeline event types
public enum RelativeTimelineEventTypes: Int {
	case standard 						= 1
	case postfollowcontractmyfeed 		= 2
	case postfriendcontractmyfeed 		= 3
	case postfriendcontractfriendfeed 	= 4
	case handshake						= 5
	case postcontractlessmyfeed			= 6
	case postcontractlessmemberfeed		= 7
}

/// Specifies relative timeline status
public enum RelativeTimelineEventStatus: Int {
	case active 	= 1
}

/// Specifies relative member scope types
public enum RelativeMemberScopeTypes: Int {
	case unspecified		= 0
	case all 				= 1
	case friends 			= 2
	case followers			= 3
	case followed 			= 4
	case contractless 		= 5
	case handshakegiver 	= 6
	case handshakereceiver 	= 7
	case transient			= 8
}

/// Specifies relative member query aspect types
public enum RelativeMemberQueryAspectTypes: Int {
	case recentlypostedto 		= 1
	case recentlypostedfrom		= 2
}

/// Specifies relative timeline event scope types
public enum RelativeTimelineEventScopeTypes: Int {
	case unspecified	= 0
	case all 			= 1
}
