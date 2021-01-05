//
//  PlayExperienceStepMarkerViewViewAccessStrategy.swift
//  SFGame
//
//  Created by David on 24/11/2017.
//  Copyright © 2017 com.smartfoundation. All rights reserved.
//

import UIKit

/// A strategy for accessing the PlayExperienceStepMarkerView view
public class PlayExperienceStepMarkerViewViewAccessStrategy {
	
	// MARK: - Private Stored Properties

	fileprivate var playExperienceStepNameLabel: UILabel!
	
	
	// MARK: - Initializers
	
	public init() {
		
	}
	
	
	// MARK: - Public Methods
	
	public func setup(playExperienceStepNameLabel: UILabel) {

		self.playExperienceStepNameLabel = playExperienceStepNameLabel
		
	}
	
}

// MARK: - Extension ProtocolPlayExperienceStepMarkerViewViewAccessStrategy

extension PlayExperienceStepMarkerViewViewAccessStrategy: ProtocolPlayExperienceStepMarkerViewViewAccessStrategy {
	
	// MARK: - Methods
	
	public func display(playExperienceStepName: String) {
		
		self.playExperienceStepNameLabel.text = playExperienceStepName
		
	}
	
}
