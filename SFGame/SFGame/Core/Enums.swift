//
//  Enums.swift
//  SFGame
//
//  Created by David on 12/01/2019.
//  Copyright © 2019 com.smartfoundation. All rights reserved.
//

/// Specifies PlayReferenceTypes
public enum PlayReferenceTypes: Int {
	
	case PlaySpaceType = 1
	case PlaySpace = 2
	case PlaySpaceBitType = 3
	case PlaySpaceBit = 4
	
}

/// Specifies PlayReferenceActionTypes
public enum PlayReferenceActionTypes: Int {
	
	case Unspecified = 0
	case AddPlaySpace = 1
	case AddPlaySpaceBit = 2
	case SetPlaySpaceBitAttribute = 3
	
}

