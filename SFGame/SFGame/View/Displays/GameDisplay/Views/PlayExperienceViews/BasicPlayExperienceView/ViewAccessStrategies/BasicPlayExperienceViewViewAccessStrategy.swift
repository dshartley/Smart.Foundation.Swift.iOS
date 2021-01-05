//
//  BasicPlayExperienceViewViewAccessStrategy.swift
//  SFGame
//
//  Created by David on 24/11/2017.
//  Copyright © 2017 com.smartfoundation. All rights reserved.
//

import UIKit

/// A strategy for accessing the BasicPlayExperienceView view
public class BasicPlayExperienceViewViewAccessStrategy {
	
	// MARK: - Private Stored Properties

	fileprivate var playExperienceView: ProtocolPlayExperienceView?
	
	
	// MARK: - Initializers
	
	public init() {
		
	}
	
	
	// MARK: - Public Methods
	
	public func setup(playExperienceView: ProtocolPlayExperienceView) {

		self.playExperienceView = playExperienceView
		
	}
	
}

// MARK: - Extension ProtocolBasicPlayExperienceViewViewAccessStrategy

extension BasicPlayExperienceViewViewAccessStrategy: ProtocolBasicPlayExperienceViewViewAccessStrategy {
	
	// MARK: - Methods
	
}

// MARK: - Extension ProtocolPlayExperienceViewViewAccessStrategy

extension BasicPlayExperienceViewViewAccessStrategy: ProtocolPlayExperienceViewViewAccessStrategy {
	
	// MARK: - Methods
	
	public func present(playExperienceStepMarkerView view: ProtocolPlayExperienceStepMarkerView) {
		
		self.playExperienceView!.present(playExperienceStepMarkerView: view)
		
	}
	
}
