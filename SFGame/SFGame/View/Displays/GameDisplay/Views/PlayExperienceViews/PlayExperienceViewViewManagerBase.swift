//
//  PlayExperienceViewViewManagerBase.swift
//  SFGame
//
//  Created by David on 24/11/2017.
//  Copyright © 2017 com.smartfoundation. All rights reserved.
//

import UIKit
import SFView

/// A base class for classes which manage the PlayExperienceView view layer
open class PlayExperienceViewViewManagerBase: ViewManagerBase {
	
	// MARK: - Private Stored Properties
	
	fileprivate var viewAccessStrategy: ProtocolPlayExperienceViewViewAccessStrategy?
	
	
	// MARK: - Initializers
	
	public override init() {
		super.init()
	}
	
	public init(viewAccessStrategy: ProtocolPlayExperienceViewViewAccessStrategy) {
		super.init()
		
		self.viewAccessStrategy = viewAccessStrategy
	}
	
	
	// MARK: - Public Methods
	
	public func present(playExperienceStepMarkerView view: ProtocolPlayExperienceStepMarkerView) {
		
		self.viewAccessStrategy!.present(playExperienceStepMarkerView: view)
	}
	
}
