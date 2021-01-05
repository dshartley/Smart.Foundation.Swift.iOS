//
//  PlayExperienceViewControlManagerBase.swift
//  SFGame
//
//  Created by David on 24/11/2017.
//  Copyright © 2017 com.smartfoundation. All rights reserved.
//

import SFController

/// A base class for classes which manage the PlayExperienceView control layer
public class PlayExperienceViewControlManagerBase: ControlManagerBase {
	
	// MARK: - Public Stored Properties
	
	public weak var delegate:							ProtocolPlayExperienceViewControlManagerDelegate?
	public var viewManager:								PlayExperienceViewViewManagerBase?
	public fileprivate(set) var playExperienceWrapper:	PlayExperienceWrapper?
	
	
	// MARK: - Private Stored Properties

	
	// MARK: - Initializers
	
	public override init() {
		super.init()
	}
	
	public init(modelManager: GameModelManager, viewManager: PlayExperienceViewViewManagerBase) {
		super.init(modelManager: modelManager)
		
		self.viewManager = viewManager
	}
	
	
	// MARK: - Public Methods
	
	public func set(playExperienceWrapper: PlayExperienceWrapper) {
		
		self.playExperienceWrapper = playExperienceWrapper
		
	}
	
	public func displayPlayExperienceSteps() {

		guard (self.playExperienceWrapper != nil) else { return }
		
		// Go through each item
		for pesw in self.playExperienceWrapper!.playExperiencesSteps!.values {
			
			// Display PlayExperienceStepWrappers
			self.doDisplayPlayExperienceStepMarkerView(wrapper: pesw)
			
		}
		
	}
	
	public func doAfterExperienceStepCompleted(playExperienceStepWrapper: PlayExperienceStepWrapper) {
		

		// Go to the next PlayExperienceStep, or;
		// If complete return PlayExperienceResult to delegate
		
		var isExperienceCompleteYN: Bool = true
		
		for pest in self.playExperienceWrapper!.playExperiencesSteps!.values {
			
			if (pest.playExperienceStepResult == nil) {
				
				isExperienceCompleteYN = false
			}
		}
		
		if (isExperienceCompleteYN) {
			
			self.doAfterExperienceCompleted()
			
			// Notify the delegate
			self.delegate?.playExperienceViewControlManager(playExperienceCompleted: self.playExperienceWrapper!, sender: self)
			
		}
		
	}
	
	
	// MARK: - Override Methods
	
	
	// MARK: - Private Methods

	fileprivate func doAfterExperienceCompleted() {
		
		// Create PlayExperienceResultWrapper
		let result: PlayExperienceResultWrapper = PlayExperienceResultWrapper()
		
		result.playExperienceID 			= self.playExperienceWrapper!.id
		result.numberOfExperiencePoints		= self.doGetNumberOfExperiencePoints()
		result.numberOfPoints 				= self.doGetNumberOfPoints()
		result.numberOfFeathers 			= self.doGetNumberOfFeathers()
		
		// Set result in playExperienceWrapper
		self.playExperienceWrapper!.playExperienceResult = result
		
	}
	
	fileprivate func doGetNumberOfExperiencePoints() -> Int {
		
		var result: Int = 0
		
		// Get numberOfExperiencePoints
		result = self.playExperienceWrapper!.playExperienceOnCompleteData?.numberOfExperiencePoints ?? 0
		
		return result
		
	}
	
	fileprivate func doGetNumberOfPoints() -> Int {
		
		var result: Int = 0
		
		// Go through each item
		for pesw in self.playExperienceWrapper!.playExperiencesSteps!.values {
			
			result += pesw.playExperienceStepResult?.numberOfPoints ?? 0
			
		}
		
		return result
		
	}
	
	fileprivate func doGetNumberOfFeathers() -> Int {
		
		var result: Int = 0
		
		// Go through each item
		for pesw in self.playExperienceWrapper!.playExperiencesSteps!.values {
			
			result += pesw.playExperienceStepResult?.numberOfFeathers ?? 0
			
		}
		
		return result
		
	}
	
	fileprivate func doDisplayPlayExperienceStepMarkerView(wrapper: PlayExperienceStepWrapper) {
		
		// Create PlayExperienceStepMarkerView
		let playExperienceStepMarkerView: ProtocolPlayExperienceStepMarkerView = self.doCreatePlayExperienceStepMarkerView(wrapper: wrapper)
		
		// Present PlayExperienceStepMarkerView
		self.viewManager!.present(playExperienceStepMarkerView: playExperienceStepMarkerView)
		
	}
	
	fileprivate func doCreatePlayExperienceStepMarkerView(wrapper: PlayExperienceStepWrapper) -> ProtocolPlayExperienceStepMarkerView {
		
		return self.delegate!.playExperienceViewControlManager(createPlayExperienceStepMarkerViewFor: wrapper)
		
	}
}
