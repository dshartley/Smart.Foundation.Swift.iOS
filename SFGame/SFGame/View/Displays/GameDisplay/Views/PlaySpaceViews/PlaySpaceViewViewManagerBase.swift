//
//  PlaySpaceViewViewManagerBase.swift
//  SFGame
//
//  Created by David on 24/11/2017.
//  Copyright © 2017 com.smartfoundation. All rights reserved.
//

import UIKit
import SFView

/// A base class for classes which manage the PlaySpaceView view layer
open class PlaySpaceViewViewManagerBase: ViewManagerBase {
	
	// MARK: - Private Stored Properties
	
	fileprivate var viewAccessStrategy: 			ProtocolPlaySpaceViewViewAccessStrategy?
	public fileprivate(set) var playSpaceBitViews: 	[String:ProtocolPlaySpaceBitView] = [String:ProtocolPlaySpaceBitView]()
	
	
	// MARK: - Initializers
	
	public override init() {
		super.init()
	}
	
	public init(viewAccessStrategy: ProtocolPlaySpaceViewViewAccessStrategy) {
		super.init()
		
		self.viewAccessStrategy = viewAccessStrategy
	}
	
	
	// MARK: - Public Methods
	
	public func present(playSpaceBitView view: ProtocolPlaySpaceBitView) {
		
		// Set in playSpaceBitViews
		self.playSpaceBitViews[view.getWrapper()!.id] = view
		
		self.viewAccessStrategy!.present(playSpaceBitView: view)
		
	}
	
	public func refresh(playSpaceBitViewFor wrapper: PlaySpaceBitWrapper) {
		
		// Get PlaySpaceBitView
		let view: ProtocolPlaySpaceBitView? = self.playSpaceBitViews[wrapper.id]
		
		guard (view != nil) else { return }
		
		view!.refresh()
		
	}
	
	public func present(playMoves wrappers: [PlayMoveWrapper]) {
		
		self.viewAccessStrategy!.present(playMoves: wrappers)
		
	}
	
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
