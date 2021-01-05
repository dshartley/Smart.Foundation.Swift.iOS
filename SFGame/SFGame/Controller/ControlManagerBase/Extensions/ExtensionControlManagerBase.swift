//
//  ExtensionControlManagerBase.swift
//  SFGame
//
//  Created by David on 06/11/2017.
//  Copyright © 2017 com.smartfoundation. All rights reserved.
//

import SFController
import SFModel

// MARK: - Extension PlayResults

extension ControlManagerBase {
	
	// MARK: - Public Methods
	
	public func getPlayResultModelAdministrator() -> PlayResultModelAdministrator {
		
		return (self.modelManager! as! GameModelManager).getPlayResultModelAdministrator!
		
	}
	
}

// MARK: - Extension PlayData

extension ControlManagerBase {
	
	// MARK: - Public Methods
	
	public func getPlayDataModelAdministrator() -> PlayDataModelAdministrator {
		
		return (self.modelManager! as! GameModelManager).getPlayDataModelAdministrator!
		
	}
	
}

// MARK: - Extension PlayMoves

extension ControlManagerBase {
	
	// MARK: - Public Methods
	
	public func getPlayMoveModelAdministrator() -> PlayMoveModelAdministrator {
		
		return (self.modelManager! as! GameModelManager).getPlayMoveModelAdministrator!
		
	}
	
}

// MARK: - Extension PlaySpaceTypes

extension ControlManagerBase {
	
	// MARK: - Public Methods
	
	public func getPlaySpaceTypeModelAdministrator() -> PlaySpaceTypeModelAdministrator {
		
		return (self.modelManager! as! GameModelManager).getPlaySpaceTypeModelAdministrator!
		
	}
	
}

// MARK: - Extension PlaySpaces

extension ControlManagerBase {
	
	// MARK: - Public Methods
	
	public func getPlaySpaceModelAdministrator() -> PlaySpaceModelAdministrator {
		
		return (self.modelManager! as! GameModelManager).getPlaySpaceModelAdministrator!
		
	}
	
}

// MARK: - Extension PlaySpaceData

extension ControlManagerBase {
	
	// MARK: - Public Methods
	
	public func getPlaySpaceDataModelAdministrator() -> PlaySpaceDataModelAdministrator {
		
		return (self.modelManager! as! GameModelManager).getPlaySpaceDataModelAdministrator!
		
	}
	
}

// MARK: - Extension PlaySpaceBitTypes

extension ControlManagerBase {
	
	// MARK: - Public Methods
	
	public func getPlaySpaceBitTypeModelAdministrator() -> PlaySpaceBitTypeModelAdministrator {
		
		return (self.modelManager! as! GameModelManager).getPlaySpaceBitTypeModelAdministrator!
		
	}
	
}

// MARK: - Extension PlaySpaceBits

extension ControlManagerBase {
	
	// MARK: - Public Methods
	
	public func getPlaySpaceBitModelAdministrator() -> PlaySpaceBitModelAdministrator {
		
		return (self.modelManager! as! GameModelManager).getPlaySpaceBitModelAdministrator!
		
	}
	
}

// MARK: - Extension PlaySpaceBitData

extension ControlManagerBase {
	
	// MARK: - Public Methods
	
	public func getPlaySpaceBitDataModelAdministrator() -> PlaySpaceBitDataModelAdministrator {
		
		return (self.modelManager! as! GameModelManager).getPlaySpaceBitDataModelAdministrator!
		
	}
	
}

// MARK: - Extension PlayExperiences

extension ControlManagerBase {
	
	// MARK: - Public Methods
	
	public func getPlayExperienceModelAdministrator() -> PlayExperienceModelAdministrator {
		
		return (self.modelManager! as! GameModelManager).getPlayExperienceModelAdministrator!
		
	}
	
	public func doAfterLoadPlayExperience(oncomplete completionHandler:@escaping ([String:Any]?, Error?) -> Void) {
		
		var result: [String:Any] = [String:Any]()
		
		// Get the PlayExperienceWrappers
		let playExperienceWrappers: 		[PlayExperienceWrapper] = self.getPlayExperienceModelAdministrator().toWrappers()
		result[self.getPlayExperienceModelAdministrator().tableName] 		= playExperienceWrappers
		
		// Get the PlayExperienceStepWrappers
		let playExperienceStepWrappers: 	[PlayExperienceStepWrapper] = self.getPlayExperienceStepModelAdministrator().toWrappers()
		result[self.getPlayExperienceStepModelAdministrator().tableName] 	= playExperienceStepWrappers
		
		// Set in PlayWrapper
		PlayWrapper.current?.set(wrappers: result)
		
		// Call completion handler
		completionHandler(result, nil)
		
	}
	
}

// MARK: - Extension PlayExperienceSteps

extension ControlManagerBase {
	
	// MARK: - Public Methods
	
	public func getPlayExperienceStepModelAdministrator() -> PlayExperienceStepModelAdministrator {
		
		return (self.modelManager! as! GameModelManager).getPlayExperienceStepModelAdministrator!
		
	}
	
}
