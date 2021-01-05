//
//  PlaySpaceBitViewControlManagerBase.swift
//  SFGame
//
//  Created by David on 24/11/2017.
//  Copyright © 2017 com.smartfoundation. All rights reserved.
//

import SFController

/// A base class for classes which manage the PlaySpaceBitView control layer
public class PlaySpaceBitViewControlManagerBase: ControlManagerBase {
	
	// MARK: - Public Stored Properties
	
	public weak var delegate:							ProtocolPlaySpaceBitViewControlManagerDelegate?
	public var viewManager:								PlaySpaceBitViewViewManagerBase?
	public fileprivate(set) var playSpaceBitWrapper:	PlaySpaceBitWrapper?
	
	
	// MARK: - Private Stored Properties

	
	// MARK: - Initializers
	
	public override init() {
		super.init()
	}
	
	public init(modelManager: GameModelManager, viewManager: PlaySpaceBitViewViewManagerBase) {
		super.init(modelManager: modelManager)
		
		self.viewManager = viewManager
	}
	
	
	// MARK: - Public Methods
	
	public func set(playSpaceBitWrapper: PlaySpaceBitWrapper) {
		
		self.playSpaceBitWrapper = playSpaceBitWrapper
		
	}
	
	
	// MARK: - Override Methods
	
	
	// MARK: - Private Methods
	
}
