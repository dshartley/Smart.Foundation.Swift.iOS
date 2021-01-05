//
//  ModelProperties.swift
//  SFGame
//
//  Created by David on 09/03/2018.
//  Copyright © 2018 com.smartfoundation. All rights reserved.
//

/// Specifies model properties
public enum ModelProperties: Int {
	
	// General
	case id
	
	// playResult
	case playResult_id
	case playResult_applicationID
	case playResult_relativeMemberID
	case playResult_playDataJSON
	case playResult_playSpacesJSON
	case playResult_playSpaceDataJSON
	case playResult_playSpaceBitsJSON
	case playResult_playSpaceBitDataJSON
	case playResult_playExperienceStepResultsJSON
	
	// playData
	case playData_id
	case playData_applicationID
	case playData_relativeMemberID
	case playData_playLanguageID
	case playData_numberOfFeathers
	case playData_numberOfExperiencePoints
	case playData_numberOfPoints
	
	// playMove
	case playMove_id
	case playMove_playReferenceType
	case playMove_playReferenceID
	case playMove_playReferenceActionType
	case playMove_onCompleteData
	
	// playSpaceType
	case playSpaceType_id
	case playSpaceType_playSpaceType
	case playSpaceType_name
	
	// playSpace
	case playSpace_id
	case playSpace_relativeMemberID
	case playSpace_playAreaID
	case playSpace_playSpaceType
	case playSpace_playLanguageID
	case playSpace_coordX
	case playSpace_coordY
	
	// playSpaceData
	case playSpaceData_id
	case playSpaceData_relativeMemberID
	case playSpaceData_playSpaceID
	case playSpaceData_numberOfFeathers
	case playSpaceData_numberOfExperiencePoints
	case playSpaceData_numberOfPoints
	case playSpaceData_attributeData
	
	// playSpaceBitType
	case playSpaceBitType_id
	case playSpaceBitType_playSpaceBitType
	case playSpaceBitType_name
	
	// playSpaceBit
	case playSpaceBit_id
	case playSpaceBit_relativeMemberID
	case playSpaceBit_playSpaceID
	case playSpaceBit_playSpaceBitType
	case playSpaceBit_coordX
	case playSpaceBit_coordY
	
	// playSpaceBitData
	case playSpaceBitData_id
	case playSpaceBitData_relativeMemberID
	case playSpaceBitData_playSpaceBitID
	case playSpaceBitData_numberOfFeathers
	case playSpaceBitData_numberOfExperiencePoints
	case playSpaceBitData_numberOfPoints
	case playSpaceBitData_attributeData
	
	// playExperience
	case playExperience_id
	case playExperience_playExperienceType
	case playExperience_playLanguageID
	case playExperience_name
	case playExperience_onCompleteData
	
	// playExperienceStep
	case playExperienceStep_id
	case playExperienceStep_playExperienceID
	case playExperienceStep_playExperienceStepType
	case playExperienceStep_playLanguageID
	case playExperienceStep_contentData
	case playExperienceStep_onCompleteData
	
}
