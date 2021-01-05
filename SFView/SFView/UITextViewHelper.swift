//
//  UITextViewHelper.swift
//  SFView
//
//  Created by David on 30/10/2017.
//  Copyright © 2017 com.smartfoundation. All rights reserved.
//

import UIKit

/// A helper for handling UITextView
public final class UITextViewHelper {
	
	// MARK: - Initializers
	
	private init () {}

	
	// MARK: - Class Methods
	
	public class func checkMaxLength(textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String, maxLength: Int) -> Bool {
		
		let unchangedText: 	String = textView.text as String
		
		var result: 		Bool = true
		
		// Get length
		let length: 		Int = unchangedText.count + text.count - range.length

		if (length > maxLength) { result = false }
		
		return result
	}
	
	public class func setSizeToFit(textView: 				UITextView,
								   widthLayoutConstraint: 	NSLayoutConstraint,
								   heightLayoutConstraint: 	NSLayoutConstraint,
								   maxWidth: 				CGFloat,
								   maxNumberofLines: 		Int?) {
		
		var width: 					CGFloat = 0
		var height: 				CGFloat = 0
		
		// Get required width for 1 line
		let singleLineWidth: 		CGFloat = UITextViewHelper.getWidthToFit(textView: textView, maxNumberofLines: 1)
		
		// Check singleLineWidth greater than maxWidth
		if (singleLineWidth > maxWidth) {
			
			let heightToFit: CGFloat = UITextViewHelper.getHeightToFit(textView: textView, maxWidth: maxWidth, maxNumberofLines: maxNumberofLines)
			
			width 	= maxWidth
			height 	= heightToFit
			
		} else {
			
			let singleLineHeight: 	CGFloat = textView.font!.lineHeight
			
			width 	= singleLineWidth
			height 	= singleLineHeight
			
		}
		
		// Set layout constraints
		widthLayoutConstraint.constant 	= width
		heightLayoutConstraint.constant = height
		
	}
	
	public class func setHeightToFit(textView: UITextView, heightLayoutConstraint: 	NSLayoutConstraint, maxNumberofLines: Int?) {
		
		// Get height
		let height: CGFloat = self.getHeightToFit(textView: textView, maxWidth: textView.frame.size.width, maxNumberofLines: maxNumberofLines)
		
		// Set layout constraint
		heightLayoutConstraint.constant = height
		
	}

	public class func setWidthToFit(textView: UITextView, widthLayoutConstraint: 	NSLayoutConstraint, maxNumberofLines: Int) {
		
		// Get width
		let width: CGFloat = self.getWidthToFit(textView: textView, maxNumberofLines: maxNumberofLines)
		
		// Set layout constraint
		widthLayoutConstraint.constant = width
		
	}
	
	public class func getHeightToFit(textView: UITextView, maxWidth: CGFloat, maxNumberofLines: Int?) -> CGFloat {
		
		// Create a textView to use for determining height
		let unusedTextView 				= UITextView()
		unusedTextView.attributedText 	= textView.attributedText
		
		// Get size
		let size 						= unusedTextView.sizeThatFits(CGSize(width: maxWidth, height: CGFloat.greatestFiniteMagnitude))
		
		// Get maxHeight for specified maxNumberofLines
		var maxHeight: 					CGFloat = CGFloat.greatestFiniteMagnitude
		
		if let maxNumberofLines = maxNumberofLines {
			
			maxHeight = textView.font!.lineHeight * CGFloat(maxNumberofLines)
		}
		
		// Get height
		let height: 					CGFloat = min(size.height, maxHeight)
		
		return height
		
	}
	
	public class func getWidthToFit(textView: UITextView, maxNumberofLines: Int) -> CGFloat {
		
		// Create a textView to use for determining size
		let unusedTextView 				= UITextView()
		unusedTextView.attributedText 	= textView.attributedText
		
		// Get maxHeight for specified maxNumberofLines
		let maxHeight: 					CGFloat = textView.font!.lineHeight * CGFloat(maxNumberofLines)
		
		// Get size
		let size 						= unusedTextView.sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude, height: maxHeight))
		
		return size.width
		
	}
	
}
