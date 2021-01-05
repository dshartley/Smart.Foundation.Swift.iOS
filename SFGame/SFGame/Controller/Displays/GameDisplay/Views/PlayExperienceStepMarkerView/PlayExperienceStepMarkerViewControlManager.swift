//
//  PlayExperienceStepMarkerViewControlManager.swift
//  SFGame
//
//  Created by David on 24/11/2017.
//  Copyright © 2017 com.smartfoundation. All rights reserved.
//

import UIKit
import SFCore
import SFController

/// Manages the PlayExperienceStepMarkerView control layer
public class PlayExperienceStepMarkerViewControlManager: ControlManagerBase {
	
	// MARK: - Public Stored Properties
	
	public weak var delegate:								ProtocolPlayExperienceStepMarkerViewControlManagerDelegate?
	public var viewManager:									PlayExperienceStepMarkerViewViewManager?
	public fileprivate(set) var playExperienceStepWrapper:	PlayExperienceStepWrapper?
	
	
	// MARK: - Private Stored Properties

	
	// MARK: - Initializers
	
	public override init() {
		super.init()
	}
	
	public init(modelManager: GameModelManager, viewManager: PlayExperienceStepMarkerViewViewManager) {
		super.init(modelManager: modelManager)
		
		self.viewManager				= viewManager
	}
	
	
	// MARK: - Public Methods
	
	public func set(playExperienceStepWrapper: PlayExperienceStepWrapper) {
		
		self.playExperienceStepWrapper = playExperienceStepWrapper
		
		// TODO:
		self.viewManager!.display(playExperienceStepName: playExperienceStepWrapper.id)
		
	}
	
	
	// MARK: - Override Methods
	
	
	// MARK: - Private Methods
	
}
