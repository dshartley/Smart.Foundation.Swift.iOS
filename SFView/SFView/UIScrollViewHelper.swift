//
//  UIScrollViewHelper.swift
//  SFView
//
//  Created by David on 07/04/2018.
//  Copyright © 2018 com.smartfoundation. All rights reserved.
//

import UIKit

/// A helper for handling UIScrollView
public final class UIScrollViewHelper {
	
	// MARK: - Initializers
	
	private init () {}
	
	
	// MARK: - Class Methods
	
	public class func correctOverScroll(scrollView: UIScrollView, animate: Bool) {

		let insetsHeightTotal: 	CGFloat = scrollView.contentInset.top + scrollView.contentInset.bottom
		
		let contentHeight: 		CGFloat = scrollView.contentSize.height
		let offsetY: 			CGFloat = scrollView.contentOffset.y
		let boundsHeight: 		CGFloat = scrollView.bounds.height
		
		// Check boundsHeight less than total content height
		guard (boundsHeight < (contentHeight + insetsHeightTotal)) else { return }
		
		let maxAllowedOffsetY:	CGFloat = contentHeight + insetsHeightTotal - boundsHeight
		
		// Check if scroll position beyond end of scroll view. This happens after rotating the view
		if (offsetY > maxAllowedOffsetY) {
			
			if (animate) {
				
				UIView.animate(withDuration: 0.3, animations: {
					
					scrollView.contentOffset.y = maxAllowedOffsetY
					
				})
				
			} else {
				
				scrollView.contentOffset.y = maxAllowedOffsetY
				
			}
			
		}
		
	}
	
	public class func isAtBottomZoneYN(scrollView: UIScrollView, bottomZoneHeight: CGFloat) -> Bool {
		
		var result: 			Bool = false
		
		// Check at bottom zone
		let contentOffset:		CGFloat = scrollView.contentOffset.y
		let maximumOffset:		CGFloat = scrollView.contentSize.height - scrollView.bounds.size.height
		
		if (maximumOffset - contentOffset <= bottomZoneHeight)
			&& (maximumOffset - contentOffset != -5.0) {
			
			result = true
			
		}
		
		return result
		
	}
	
	public class func abortScroll(scrollView: UIScrollView) {
		
		if (scrollView.isDragging || scrollView.isDecelerating) {
			
			scrollView.setContentOffset(scrollView.contentOffset, animated: false)
		}
	}
	
}
