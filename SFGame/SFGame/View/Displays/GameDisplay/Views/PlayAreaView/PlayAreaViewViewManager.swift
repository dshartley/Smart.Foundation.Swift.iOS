//
//  PlayAreaViewViewManager.swift
//  SFGame
//
//  Created by David on 24/11/2017.
//  Copyright © 2017 com.smartfoundation. All rights reserved.
//

import UIKit
import SFView

/// Manages the PlayAreaView view layer
open class PlayAreaViewViewManager: ViewManagerBase {
	
	// MARK: - Private Stored Properties
	
	fileprivate var viewAccessStrategy: ProtocolPlayAreaViewViewAccessStrategy?
	
	
	// MARK: - Initializers
	
	private override init() {
		super.init()
	}
	
	public init(viewAccessStrategy: ProtocolPlayAreaViewViewAccessStrategy) {
		super.init()
		
		self.viewAccessStrategy = viewAccessStrategy
	}
	
	
	// MARK: - Public Methods
	
	public func displayTotalNumberOfFeathers(value: Int) {
		
		self.viewAccessStrategy!.displayTotalNumberOfFeathers(value: value)
	}
	
	public func displayTotalNumberOfPoints(value: Int) {
		
		self.viewAccessStrategy!.displayTotalNumberOfPoints(value: value)
	}

	public func present(playMoves wrappers: [PlayMoveWrapper]) {
		
		self.viewAccessStrategy!.present(playMoves: wrappers)
	}
	
	public func present(playSpaceMarkerView view: ProtocolPlaySpaceMarkerView) {
		
		self.viewAccessStrategy!.present(playSpaceMarkerView: view)
	}
	
}
