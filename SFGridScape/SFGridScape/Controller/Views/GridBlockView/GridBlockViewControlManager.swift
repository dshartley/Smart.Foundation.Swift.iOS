//
//  GridBlockViewControlManager.swift
//  SFGridScape
//
//  Created by David on 24/11/2017.
//  Copyright © 2017 com.smartfoundation. All rights reserved.
//

import UIKit
import SFController

/// Manages the GridBlockView control layer
public class GridBlockViewControlManager {
	
	// MARK: - Public Stored Properties
	
	public weak var delegate:							ProtocolGridBlockViewControlManagerDelegate?
	public var viewManager:								GridBlockViewViewManager?
	public fileprivate(set) var gridProperties:			GridProperties?
	public fileprivate(set) var gridBlockProperties:	GridBlockProperties?
	
	
	// MARK: - Private Stored Properties


	// MARK: - Initializers
	
	public init() {
	}
	
	public init(viewManager: GridBlockViewViewManager) {

		self.viewManager = viewManager
	}
	
	
	// MARK: - Public Methods
	
	public func set(gridBlockProperties: GridBlockProperties,
					gridProperties: GridProperties) {
	
		self.gridBlockProperties 	= gridBlockProperties
		self.gridProperties 		= gridProperties
		
	}
	
	
	// MARK: - Override Methods
	
	
	// MARK: - Private Methods
	
}
