//
//  UILabelHelper.swift
//  SFView
//
//  Created by David on 10/12/2017.
//  Copyright © 2017 com.smartfoundation. All rights reserved.
//

import UIKit

/// A helper for handling UILabel
public final class UILabelHelper {
	
	// MARK: - Initializers
	
	private init () {}
	
	
	// MARK: - Class Methods
	
	public class func setSizeToFit(label: 					UILabel,
								   widthLayoutConstraint: 	NSLayoutConstraint,
								   heightLayoutConstraint: 	NSLayoutConstraint,
								   maxWidth: 				CGFloat,
								   maxNumberofLines: 		Int?) {
		
		var width: 					CGFloat = 0
		var height: 				CGFloat = 0
		
		// Get required width for 1 line
		let singleLineWidth: 		CGFloat = UILabelHelper.getWidthToFit(label: label, maxNumberofLines: 1)
		
		// Check singleLineWidth greater than maxWidth
		if (singleLineWidth > maxWidth) {
			
			let heightToFit: CGFloat = UILabelHelper.getHeightToFit(label: label, maxWidth: maxWidth, maxNumberofLines: maxNumberofLines)
			
			width 	= maxWidth
			height 	= heightToFit
			
		} else {
			
			let singleLineHeight: 	CGFloat = label.font!.lineHeight
			
			width 	= singleLineWidth
			height 	= singleLineHeight
			
		}
		
		// Set layout constraints
		widthLayoutConstraint.constant 	= width
		heightLayoutConstraint.constant = height
		
	}
	
	public class func setHeightToFit(label: UILabel, heightLayoutConstraint: NSLayoutConstraint, maxNumberofLines: Int?) {
		
		// Get height
		let height: CGFloat = self.getHeightToFit(label: label, maxWidth: label.frame.size.width, maxNumberofLines: maxNumberofLines)
		
		// Set layout constraint
		heightLayoutConstraint.constant = height
		
	}
	
	public class func setWidthToFit(label: UILabel, widthLayoutConstraint: NSLayoutConstraint, maxNumberofLines: Int) {
		
		// Get width
		let width: CGFloat = self.getWidthToFit(label: label, maxNumberofLines: maxNumberofLines)
		
		// Set layout constraint
		widthLayoutConstraint.constant = width
		
	}

	public class func getHeightToFit(label: UILabel, maxWidth: CGFloat) -> CGFloat {
		
		return self.getHeightToFit(label: label, maxWidth: maxWidth, maxNumberofLines: nil)
		
	}
	
	public class func getHeightToFit(label: UILabel, maxWidth: CGFloat, maxNumberofLines: Int?) -> CGFloat {
		
		// Create a label to use for determining size
		let unusedLabel 				= UILabel()
		unusedLabel.attributedText 		= label.attributedText
		unusedLabel.font 				= label.font
		unusedLabel.numberOfLines 		= 0
		
		// Get size
		let size 						= unusedLabel.sizeThatFits(CGSize(width: maxWidth, height: CGFloat.greatestFiniteMagnitude))
		
		// Get maxHeight for specified maxNumberofLines
		var maxHeight: 					CGFloat = CGFloat.greatestFiniteMagnitude
		
		if let maxNumberofLines = maxNumberofLines {
			
			maxHeight = label.font!.lineHeight.rounded(.up) * CGFloat(maxNumberofLines)
		}
		
		// Get height
		let height: 					CGFloat = min(size.height, maxHeight)
		
		return height
		
	}
	
	public class func getWidthToFit(label: UILabel, maxNumberofLines: Int) -> CGFloat {
		
		// Get maxHeight for specified maxNumberofLines
		let maxHeight: 					CGFloat = label.font!.lineHeight.rounded(.up) * CGFloat(maxNumberofLines)
		
		return self.getWidthToFit(label: label, maxHeight: maxHeight)
		
	}

	public class func getWidthToFit(label: UILabel, maxHeight: CGFloat) -> CGFloat {
		
		// Create a label to use for determining size
		let unusedLabel 				= UILabel()
		unusedLabel.attributedText 		= label.attributedText
		unusedLabel.font 				= label.font
		unusedLabel.numberOfLines 		= 0
		
		// Get size
		var size 						= unusedLabel.sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude, height: maxHeight))
		
		let area: 		CGFloat = size.width * size.height
		var width:		CGFloat = area / maxHeight	// Get approximate width to give maxHeight
		var height: 	CGFloat = CGFloat.greatestFiniteMagnitude
		
		while (height > maxHeight) {
			
			// Get height for specified width
			size 	= unusedLabel.sizeThatFits(CGSize(width: width, height: 10))
			
			height 	= size.height
			
			// Increment width for next calculation
			width 	+= 10
		}
		
		return size.width
		
	}
	
}
