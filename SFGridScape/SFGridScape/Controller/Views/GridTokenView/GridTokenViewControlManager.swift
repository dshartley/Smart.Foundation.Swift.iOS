//
//  GridTokenViewControlManager.swift
//  SFGridScape
//
//  Created by David on 24/11/2017.
//  Copyright © 2017 com.smartfoundation. All rights reserved.
//

import UIKit
import SFController

/// Manages the GridTokenView control layer
public class GridTokenViewControlManager {
	
	// MARK: - Public Stored Properties
	
	public weak var delegate:			ProtocolGridTokenViewControlManagerDelegate?
	public var viewManager:				GridTokenViewViewManager?
	public var gridTokenProperties:		GridTokenProperties?
	
	
	// MARK: - Private Stored Properties


	// MARK: - Initializers
	
	public init() {
	}
	
	public init(viewManager: GridTokenViewViewManager) {

		self.viewManager 			= viewManager

	}
	
	
	// MARK: - Public Methods
	
	public func set(gridTokenProperties: GridTokenProperties) {
	
		self.gridTokenProperties = gridTokenProperties
		
	}
	
	
	// MARK: - Override Methods
	
	
	// MARK: - Private Methods
	
}
