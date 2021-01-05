//
//  ModelProperties.swift
//  SFSocial
//
//  Created by David on 09/03/2018.
//  Copyright © 2018 com.smartfoundation. All rights reserved.
//

/// Specifies model properties
public enum ModelProperties: Int {
	
	// General
	case id
	
	// relativeMember
	case relativeMember_id
	case relativeMember_applicationID
	case relativeMember_userProfileID
	case relativeMember_email
	case relativeMember_fullName
	case relativeMember_avatarImageFileName
	case relativeMember_connectionContractTypes
	
	// relativeConnection
	case relativeConnection_id
	case relativeConnection_applicationID
	case relativeConnection_fromRelativeMemberID
	case relativeConnection_toRelativeMemberID
	case relativeConnection_connectionContractType
	case relativeConnection_dateActioned
	case relativeConnection_dateLastActive
	case relativeConnection_connectionStatus
	
	// relativeConnectionRequest
	case relativeConnectionRequest_id
	case relativeConnectionRequest_applicationID
	case relativeConnectionRequest_fromRelativeMemberID
	case relativeConnectionRequest_toRelativeMemberID
	case relativeConnectionRequest_requestType
	case relativeConnectionRequest_dateActioned
	case relativeConnectionRequest_requestStatus
	
	// relativeInteraction
	case relativeInteraction_id
	case relativeInteraction_applicationID
	case relativeInteraction_fromRelativeMemberID
	case relativeInteraction_toRelativeMemberID
	case relativeInteraction_interactionType
	case relativeInteraction_dateActioned
	case relativeInteraction_interactionStatus
	case relativeInteraction_text
	
	// relativeTimelineEvent
	case relativeTimelineEvent_id
	case relativeTimelineEvent_applicationID
	case relativeTimelineEvent_forRelativeMemberID
	case relativeTimelineEvent_relativeInteractionID
	case relativeTimelineEvent_eventType
	case relativeTimelineEvent_dateActioned
	case relativeTimelineEvent_eventStatus
	
}
