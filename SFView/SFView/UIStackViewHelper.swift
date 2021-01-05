//
//  UIStackViewHelper.swift
//  SFView
//
//  Created by David on 10/12/2017.
//  Copyright © 2017 com.smartfoundation. All rights reserved.
//

import UIKit

/// A helper for handling UIStackView
public final class UIStackViewHelper {

	// MARK: - Initializers
	
	private init () {}
	
	
	// MARK: - Class Methods

	public class func clearAllItems(from stackView: UIStackView) {
		
		for subview in stackView.subviews {
			
			// Remove from the stack view
			stackView.removeArrangedSubview(subview)
			
			// Remove from the view hierarchy
			subview.removeFromSuperview()
			
		}
		
	}
	
	public class func setBackgroundColor(of stackView: UIStackView, to color: UIColor) {
		
		// Create background view
		let backgroundView: UIView = UIView()
		backgroundView.backgroundColor 								= .purple
		backgroundView.translatesAutoresizingMaskIntoConstraints 	= false
		
		// Add background view to stack view
		stackView.insertSubview(backgroundView, at: 0)
		
		// Pin background view to stack view
		NSLayoutConstraint.activate([
			backgroundView.leadingAnchor.constraint(equalTo: 	stackView.leadingAnchor),
			backgroundView.trailingAnchor.constraint(equalTo: 	stackView.trailingAnchor),
			backgroundView.topAnchor.constraint(equalTo: 		stackView.topAnchor),
			backgroundView.bottomAnchor.constraint(equalTo: 	stackView.bottomAnchor)])
		
	}
	
}
