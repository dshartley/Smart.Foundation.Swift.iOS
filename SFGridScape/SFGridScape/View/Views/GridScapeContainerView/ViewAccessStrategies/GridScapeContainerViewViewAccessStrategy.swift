//
//  GridScapeContainerViewViewAccessStrategy.swift
//  SFGridScape
//
//  Created by David on 24/11/2017.
//  Copyright © 2017 com.smartfoundation. All rights reserved.
//

import UIKit

/// A strategy for accessing the GridScapeContainerView view
public class GridScapeContainerViewViewAccessStrategy {
	
	// MARK: - Private Stored Properties

	fileprivate var gridScapeView: ProtocolGridScapeView?
	
	
	// MARK: - Initializers
	
	public init() {
		
	}
	
	
	// MARK: - Public Methods
	
	public func setup(gridScapeView: ProtocolGridScapeView) {

		self.gridScapeView = gridScapeView
		
	}
	
}

// MARK: - Extension ProtocolGridScapeContainerViewViewAccessStrategy

extension GridScapeContainerViewViewAccessStrategy: ProtocolGridScapeContainerViewViewAccessStrategy {
	
	// MARK: - Methods

}
