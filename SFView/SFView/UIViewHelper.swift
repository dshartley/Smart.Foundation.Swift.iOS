//
//  UIViewHelper.swift
//  SFView
//
//  Created by David on 10/12/2017.
//  Copyright © 2017 com.smartfoundation. All rights reserved.
//

import UIKit

/// A helper for handling UIView
public final class UIViewHelper {
	
	// MARK: - Initializers
	
	private init () {}
	
	
	// MARK: - Class Methods
	
	public class func setShadow(view: UIView) {
		
		view.layer.shadowColor 		= UIColor.black.cgColor
		view.layer.shadowOffset 	= CGSize(width: 0, height: 2.0)
		view.layer.shadowRadius 	= 4.0;
		view.layer.shadowOpacity 	= 0.5;
		view.layer.masksToBounds 	= false;
		view.layer.shadowPath 		= UIBezierPath(roundedRect:view.bounds, cornerRadius: view.layer.cornerRadius).cgPath;

	}
	
	public class func makeCircle(view: UIView) {
		
		view.layer.cornerRadius = view.frame.size.width / 2
		
	}
	
	public class func roundCorners(view: UIView, corners: UIRectCorner, radius: CGFloat) {
		
		let path = UIBezierPath(roundedRect: view.layer.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
		
		let mask = CAShapeLayer()
		
		mask.path 			= path.cgPath
		
		view.layer.mask 	= mask
		view.clipsToBounds 	= true
		
	}
	
}
