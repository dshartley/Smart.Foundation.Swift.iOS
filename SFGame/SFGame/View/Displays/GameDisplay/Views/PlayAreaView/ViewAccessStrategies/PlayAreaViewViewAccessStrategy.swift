//
//  PlayAreaViewViewAccessStrategy.swift
//  SFGame
//
//  Created by David on 24/11/2017.
//  Copyright © 2017 com.smartfoundation. All rights reserved.
//

import UIKit

/// A strategy for accessing the PlayAreaView view
public class PlayAreaViewViewAccessStrategy {
	
	// MARK: - Private Stored Properties

	fileprivate var totalNumberOfFeathersLabel: 	UILabel?
	fileprivate var totalNumberOfPointsLabel: 		UILabel?
	fileprivate var playAreaView: 					ProtocolPlayAreaView?
	
	
	// MARK: - Initializers
	
	public init() {
		
	}
	
	
	// MARK: - Public Methods
	
	public func setup(totalNumberOfFeathersLabel: 	UILabel,
					  totalNumberOfPointsLabel: 	UILabel,
					  playAreaView: 				ProtocolPlayAreaView) {

		self.totalNumberOfFeathersLabel = totalNumberOfFeathersLabel
		self.totalNumberOfPointsLabel 	= totalNumberOfPointsLabel
		self.playAreaView 				= playAreaView
		
	}
	
}

// MARK: - Extension ProtocolPlayAreaViewViewAccessStrategy

extension PlayAreaViewViewAccessStrategy: ProtocolPlayAreaViewViewAccessStrategy {
	
	// MARK: - Methods
	
	public func displayTotalNumberOfFeathers(value: Int) {
		
		self.totalNumberOfFeathersLabel!.text = "\(value)"
	}

	public func displayTotalNumberOfPoints(value: Int) {
		
		self.totalNumberOfPointsLabel!.text = "\(value)"
	}
	
	public func present(playMoves wrappers: [PlayMoveWrapper]) {
		
		self.playAreaView!.present(playMoves: wrappers)
		
	}
	
	public func present(playSpaceMarkerView view: ProtocolPlaySpaceMarkerView) {
		
		self.playAreaView!.present(playSpaceMarkerView: view)
		
	}
	
}
