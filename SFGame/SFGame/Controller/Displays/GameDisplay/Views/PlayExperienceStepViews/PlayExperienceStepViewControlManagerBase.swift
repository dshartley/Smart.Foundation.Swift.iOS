//
//  PlayExperienceStepViewControlManagerBase.swift
//  SFGame
//
//  Created by David on 24/11/2017.
//  Copyright © 2017 com.smartfoundation. All rights reserved.
//

import SFModel
import SFController

/// A base class for classes which manage the PlayExperienceStepView control layer
open class PlayExperienceStepViewControlManagerBase: ControlManagerBase {
	
	// MARK: - Public Stored Properties
	
	public weak var delegate:								ProtocolPlayExperienceStepViewControlManagerDelegate?
	public var viewManager:									PlayExperienceStepViewViewManagerBase?
	public fileprivate(set) var playExperienceStepWrapper:	PlayExperienceStepWrapper?
	public var repeatedYN: 									Bool = false
	
	
	// MARK: - Private Stored Properties

	
	// MARK: - Initializers
	
	public override init() {
		super.init()
	}
	
	public init(modelManager: GameModelManager, viewManager: PlayExperienceStepViewViewManagerBase) {
		super.init(modelManager: modelManager)
		
		self.viewManager = viewManager
	}
	
	
	// MARK: - Public Methods
	
	public func set(playExperienceStepWrapper: PlayExperienceStepWrapper) {
		
		self.playExperienceStepWrapper = playExperienceStepWrapper
		
	}
	
	public func doAfterExperienceStepCompleted() {
		
		// Create PlayExperienceStepResultWrapper
		let result: PlayExperienceStepResultWrapper = PlayExperienceStepResultWrapper()
		
		result.playExperienceID 	= self.playExperienceStepWrapper!.playExperienceID
		result.playExperienceStepID = self.playExperienceStepWrapper!.id
		result.numberOfPoints 		= self.doGetNumberOfPoints()
		result.numberOfFeathers 	= self.doGetNumberOfFeathers()
		result.dateCompleted		= Date()
		result.repeatedYN 			= self.repeatedYN
		
		// Set result in playExperienceStepWrapper
		self.playExperienceStepWrapper!.playExperienceStepResult = result
		
	}
	
	
	// MARK: - Open [Overridable] Methods
	
	open func display() {
		
		// Override
		
	}
	
	
	// MARK: - Override Methods
	
	
	// MARK: - Private Methods

	fileprivate func doGetNumberOfPoints() -> Int {
		
		var result: Int = 0
		
		// Get numberOfPoints
		result = self.playExperienceStepWrapper!.playExperienceStepOnCompleteData?.numberOfPoints ?? 0
		
		return result
		
	}
	
	fileprivate func doGetNumberOfFeathers() -> Int {
		
		var result: Int = 0
		
		// Get numberOfPoints
		result = self.playExperienceStepWrapper!.playExperienceStepOnCompleteData?.numberOfFeathers ?? 0
		
		return result
		
	}
	
}
