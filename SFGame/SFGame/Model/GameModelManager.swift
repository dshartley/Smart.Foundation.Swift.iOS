//
//  GameModelManager.swift
//  SFSocial
//
//  Created by David on 30/10/2017.
//  Copyright © 2017 com.smartfoundation. All rights reserved.
//

import SFModel

/// Manages the model layer and provides access to the model administrators
open class GameModelManager: ModelManagerBase {

	// MARK: - Initializers

	public override init() {
		super.init()
	}

	public override init(storageDateFormatter: DateFormatter) {
		super.init(storageDateFormatter: storageDateFormatter)
	}
	
	
	// MARK: - Public Methods

	// PlayResult
	
	fileprivate var _playResultModelAdministrator: PlayResultModelAdministrator?
	
	public func setupPlayResultModelAdministrator(modelAccessStrategy: ProtocolModelAccessStrategy) {
		
		if (self.modelAdministrators.keys.contains("PlayResults")) { self.modelAdministrators.removeValue(forKey: "PlayResults") }
		
		self._playResultModelAdministrator = PlayResultModelAdministrator(modelAccessStrategy: modelAccessStrategy, modelAdministratorProvider: self, storageDateFormatter: self.storageDateFormatter!)
		
		self.modelAdministrators["PlayResults"] = self._playResultModelAdministrator
	}
	
	public var getPlayResultModelAdministrator: PlayResultModelAdministrator? {
		get {
			return self._playResultModelAdministrator
		}
	}
	
	// PlayData
	
	fileprivate var _playDataModelAdministrator: PlayDataModelAdministrator?
	
	public func setupPlayDataModelAdministrator(modelAccessStrategy: ProtocolModelAccessStrategy) {
		
		if (self.modelAdministrators.keys.contains("PlayData")) { self.modelAdministrators.removeValue(forKey: "PlayData") }
		
		self._playDataModelAdministrator = PlayDataModelAdministrator(modelAccessStrategy: modelAccessStrategy, modelAdministratorProvider: self, storageDateFormatter: self.storageDateFormatter!)
		
		self.modelAdministrators["PlayData"] = self._playDataModelAdministrator
	}
	
	public var getPlayDataModelAdministrator: PlayDataModelAdministrator? {
		get {
			return self._playDataModelAdministrator
		}
	}
	
	// PlayMove
	
	fileprivate var _playMoveModelAdministrator: PlayMoveModelAdministrator?
	
	public func setupPlayMoveModelAdministrator(modelAccessStrategy: ProtocolModelAccessStrategy) {
		
		if (self.modelAdministrators.keys.contains("PlayMoves")) { self.modelAdministrators.removeValue(forKey: "PlayMoves") }
		
		self._playMoveModelAdministrator = PlayMoveModelAdministrator(modelAccessStrategy: modelAccessStrategy, modelAdministratorProvider: self, storageDateFormatter: self.storageDateFormatter!)
		
		self.modelAdministrators["PlayMoves"] = self._playMoveModelAdministrator
	}
	
	public var getPlayMoveModelAdministrator: PlayMoveModelAdministrator? {
		get {
			return self._playMoveModelAdministrator
		}
	}
	
	// PlaySpaceType
	
	fileprivate var _playSpaceTypeModelAdministrator: PlaySpaceTypeModelAdministrator?
	
	public func setupPlaySpaceTypeModelAdministrator(modelAccessStrategy: ProtocolModelAccessStrategy) {
		
		if (self.modelAdministrators.keys.contains("PlaySpaceTypes")) { self.modelAdministrators.removeValue(forKey: "PlaySpaceTypes") }
		
		self._playSpaceTypeModelAdministrator = PlaySpaceTypeModelAdministrator(modelAccessStrategy: modelAccessStrategy, modelAdministratorProvider: self, storageDateFormatter: self.storageDateFormatter!)
		
		self.modelAdministrators["PlaySpaceTypes"] = self._playSpaceTypeModelAdministrator
	}
	
	public var getPlaySpaceTypeModelAdministrator: PlaySpaceTypeModelAdministrator? {
		get {
			return self._playSpaceTypeModelAdministrator
		}
	}
	
	// PlaySpace
	
	fileprivate var _playSpaceModelAdministrator: PlaySpaceModelAdministrator?
	
	public func setupPlaySpaceModelAdministrator(modelAccessStrategy: ProtocolModelAccessStrategy) {
		
		if (self.modelAdministrators.keys.contains("PlaySpaces")) { self.modelAdministrators.removeValue(forKey: "PlaySpaces") }
		
		self._playSpaceModelAdministrator = PlaySpaceModelAdministrator(modelAccessStrategy: modelAccessStrategy, modelAdministratorProvider: self, storageDateFormatter: self.storageDateFormatter!)
		
		self.modelAdministrators["PlaySpaces"] = self._playSpaceModelAdministrator
	}
	
	public var getPlaySpaceModelAdministrator: PlaySpaceModelAdministrator? {
		get {
			return self._playSpaceModelAdministrator
		}
	}
	
	// PlaySpaceData
	
	fileprivate var _playSpaceDataModelAdministrator: PlaySpaceDataModelAdministrator?
	
	public func setupPlaySpaceDataModelAdministrator(modelAccessStrategy: ProtocolModelAccessStrategy) {
		
		if (self.modelAdministrators.keys.contains("PlaySpaceData")) { self.modelAdministrators.removeValue(forKey: "PlaySpaceData") }
		
		self._playSpaceDataModelAdministrator = PlaySpaceDataModelAdministrator(modelAccessStrategy: modelAccessStrategy, modelAdministratorProvider: self, storageDateFormatter: self.storageDateFormatter!)
		
		self.modelAdministrators["PlaySpaceData"] = self._playSpaceDataModelAdministrator
	}
	
	public var getPlaySpaceDataModelAdministrator: PlaySpaceDataModelAdministrator? {
		get {
			return self._playSpaceDataModelAdministrator
		}
	}
	
	// PlaySpaceBitType
	
	fileprivate var _playSpaceBitTypeModelAdministrator: PlaySpaceBitTypeModelAdministrator?
	
	public func setupPlaySpaceBitTypeModelAdministrator(modelAccessStrategy: ProtocolModelAccessStrategy) {
		
		if (self.modelAdministrators.keys.contains("PlaySpaceBitTypes")) { self.modelAdministrators.removeValue(forKey: "PlaySpaceBitTypes") }
		
		self._playSpaceBitTypeModelAdministrator = PlaySpaceBitTypeModelAdministrator(modelAccessStrategy: modelAccessStrategy, modelAdministratorProvider: self, storageDateFormatter: self.storageDateFormatter!)
		
		self.modelAdministrators["PlaySpaceBitTypes"] = self._playSpaceBitTypeModelAdministrator
	}
	
	public var getPlaySpaceBitTypeModelAdministrator: PlaySpaceBitTypeModelAdministrator? {
		get {
			return self._playSpaceBitTypeModelAdministrator
		}
	}
	
	// PlaySpaceBit
	
	fileprivate var _playSpaceBitModelAdministrator: PlaySpaceBitModelAdministrator?
	
	public func setupPlaySpaceBitModelAdministrator(modelAccessStrategy: ProtocolModelAccessStrategy) {
		
		if (self.modelAdministrators.keys.contains("PlaySpaceBits")) { self.modelAdministrators.removeValue(forKey: "PlaySpaceBits") }
		
		self._playSpaceBitModelAdministrator = PlaySpaceBitModelAdministrator(modelAccessStrategy: modelAccessStrategy, modelAdministratorProvider: self, storageDateFormatter: self.storageDateFormatter!)
		
		self.modelAdministrators["PlaySpaceBits"] = self._playSpaceBitModelAdministrator
	}
	
	public var getPlaySpaceBitModelAdministrator: PlaySpaceBitModelAdministrator? {
		get {
			return self._playSpaceBitModelAdministrator
		}
	}
	
	// PlaySpaceBitData
	
	fileprivate var _playSpaceBitDataModelAdministrator: PlaySpaceBitDataModelAdministrator?
	
	public func setupPlaySpaceBitDataModelAdministrator(modelAccessStrategy: ProtocolModelAccessStrategy) {
		
		if (self.modelAdministrators.keys.contains("PlaySpaceBitData")) { self.modelAdministrators.removeValue(forKey: "PlaySpaceBitData") }
		
		self._playSpaceBitDataModelAdministrator = PlaySpaceBitDataModelAdministrator(modelAccessStrategy: modelAccessStrategy, modelAdministratorProvider: self, storageDateFormatter: self.storageDateFormatter!)
		
		self.modelAdministrators["PlaySpaceBitData"] = self._playSpaceBitDataModelAdministrator
	}
	
	public var getPlaySpaceBitDataModelAdministrator: PlaySpaceBitDataModelAdministrator? {
		get {
			return self._playSpaceBitDataModelAdministrator
		}
	}
	
	// PlayExperience
	
	fileprivate var _playExperienceModelAdministrator: PlayExperienceModelAdministrator?
	
	public func setupPlayExperienceModelAdministrator(modelAccessStrategy: ProtocolModelAccessStrategy) {
		
		if (self.modelAdministrators.keys.contains("PlayExperiences")) { self.modelAdministrators.removeValue(forKey: "PlayExperiences") }
		
		self._playExperienceModelAdministrator = PlayExperienceModelAdministrator(modelAccessStrategy: modelAccessStrategy, modelAdministratorProvider: self, storageDateFormatter: self.storageDateFormatter!)
		
		self.modelAdministrators["PlayExperiences"] = self._playExperienceModelAdministrator
	}
	
	public var getPlayExperienceModelAdministrator: PlayExperienceModelAdministrator? {
		get {
			return self._playExperienceModelAdministrator
		}
	}
	
	// PlayExperienceStep
	
	fileprivate var _playExperienceStepModelAdministrator: PlayExperienceStepModelAdministrator?
	
	public func setupPlayExperienceStepModelAdministrator(modelAccessStrategy: ProtocolModelAccessStrategy) {
		
		if (self.modelAdministrators.keys.contains("PlayExperienceSteps")) { self.modelAdministrators.removeValue(forKey: "PlayExperienceSteps") }
		
		self._playExperienceStepModelAdministrator = PlayExperienceStepModelAdministrator(modelAccessStrategy: modelAccessStrategy, modelAdministratorProvider: self, storageDateFormatter: self.storageDateFormatter!)
		
		self.modelAdministrators["PlayExperienceSteps"] = self._playExperienceStepModelAdministrator
	}
	
	public var getPlayExperienceStepModelAdministrator: PlayExperienceStepModelAdministrator? {
		get {
			return self._playExperienceStepModelAdministrator
		}
	}
	
	
}

