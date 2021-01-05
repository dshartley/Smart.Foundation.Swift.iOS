//
//  SlideOutMenuInteractiveTransition.swift
//  SFView
//
//  Created by David on 21/06/2017.
//  Copyright © 2017 com.smartfoundation. All rights reserved.
//

import UIKit

/// An interactive transition for a slide out menu
public class SlideOutMenuInteractiveTransition: UIPercentDrivenInteractiveTransition {
	
	var hasStarted		= false		// Indicates whether an interaction is underway
	var shouldFinish	= false		// Determines whether the interaction should complete, or roll back
	
}
