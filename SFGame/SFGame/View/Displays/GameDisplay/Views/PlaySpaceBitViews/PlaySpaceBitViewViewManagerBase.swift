//
//  PlaySpaceBitViewViewManagerBase.swift
//  SFGame
//
//  Created by David on 24/11/2017.
//  Copyright © 2017 com.smartfoundation. All rights reserved.
//

import UIKit
import SFView

/// A base class for classes which manage the PlaySpaceBitView view layer
open class PlaySpaceBitViewViewManagerBase: ViewManagerBase {
	
	// MARK: - Private Stored Properties
	
	
	// MARK: - Public Stored Properties
	
	public var viewAccessStrategy: ProtocolPlaySpaceBitViewViewAccessStrategy?
	
	
	// MARK: - Initializers
	
	public override init() {
		super.init()
	}
	
	public init(viewAccessStrategy: ProtocolPlaySpaceBitViewViewAccessStrategy) {
		super.init()
		
		self.viewAccessStrategy = viewAccessStrategy
	}
	
	
	// MARK: - Public Methods
	
	public func display(numberOfFeathers: Int) {
		
		self.viewAccessStrategy!.display(numberOfFeathers: numberOfFeathers)
		
	}
	
	public func display(numberOfExperiencePoints: Int) {
		
		self.viewAccessStrategy!.display(numberOfExperiencePoints: numberOfExperiencePoints)
		
	}
	
	public func display(numberOfPoints: Int) {
		
		self.viewAccessStrategy!.display(numberOfPoints: numberOfPoints)
		
	}
	
}
