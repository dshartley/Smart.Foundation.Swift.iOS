//
//  PlayExperienceStepViewViewManagerBase.swift
//  SFGame
//
//  Created by David on 24/11/2017.
//  Copyright © 2017 com.smartfoundation. All rights reserved.
//

import UIKit
import SFView

/// A base class for classes which manage the PlayExperienceStepView view layer
open class PlayExperienceStepViewViewManagerBase: ViewManagerBase {
	
	// MARK: - Private Stored Properties
	
	
	// MARK: - Public Stored Properties
	
	public var viewAccessStrategy: ProtocolPlayExperienceStepViewViewAccessStrategy?
	
	
	// MARK: - Initializers
	
	public override init() {
		super.init()
	}
	
	public init(viewAccessStrategy: ProtocolPlayExperienceStepViewViewAccessStrategy) {
		super.init()
		
		self.viewAccessStrategy = viewAccessStrategy
	}
	
	
	// MARK: - Public Methods
	
	
}
