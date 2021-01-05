//
//  ProtocolModelAccessStrategyDelegate.swift
//  SFModel
//
//  Created by David on 02/10/2018.
//  Copyright © 2018 com.smartfoundation. All rights reserved.
//

import UIKit

/// Defines a delegate for a ModelAccessStrategy class
public protocol ProtocolModelAccessStrategyDelegate: class {
	
	// MARK: - Methods
	
	func modelAccessStrategy(getModelAdministratorProvider sender: ProtocolModelAccessStrategy) -> ProtocolModelAdministratorProvider?

}
