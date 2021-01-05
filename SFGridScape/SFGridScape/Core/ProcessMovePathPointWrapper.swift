//
//  ProcessMovePathPointWrapper.swift
//  SFGridScape
//
//  Created by David on 14/12/2018.
//  Copyright © 2018 David. All rights reserved.
//

import UIKit

/// A wrapper for a ProcessMovePathPointWrapper item
public class ProcessMovePathPointWrapper {
	
	// MARK: - Public Stored Properties
	
	public var pathPointWrapper:	PathPointWrapperBase? = nil
	public var cellView:			ProtocolGridCellView? = nil
	public var didMoveToYN:			Bool = false

	
	// MARK: - Initializers
	
	public init() {
		
	}
	
}

