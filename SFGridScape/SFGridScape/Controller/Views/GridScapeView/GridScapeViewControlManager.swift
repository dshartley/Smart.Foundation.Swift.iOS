//
//  GridScapeViewControlManager.swift
//  SFGridScape
//
//  Created by David on 24/11/2017.
//  Copyright © 2017 com.smartfoundation. All rights reserved.
//

import UIKit
import SFController

/// Manages the GridScapeView control layer
public class GridScapeViewControlManager {
	
	// MARK: - Public Stored Properties
	
	public weak var delegate:			ProtocolGridScapeViewControlManagerDelegate?
	public var viewManager:				GridScapeViewViewManager?

	
	// MARK: - Private Stored Properties


	// MARK: - Initializers
	
	public init() {
	}
	
	public init(viewManager: GridScapeViewViewManager) {

		self.viewManager = viewManager
		
	}
	
	
	// MARK: - Public Methods
	
	
	// MARK: - Override Methods
	
	
	// MARK: - Private Methods
	
}
