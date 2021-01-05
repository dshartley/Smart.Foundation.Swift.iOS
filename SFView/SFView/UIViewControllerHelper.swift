//
//  UIViewControllerHelper.swift
//  SFView
//
//  Created by David on 11/11/2017.
//  Copyright © 2017 com.smartfoundation. All rights reserved.
//

import UIKit

/// A helper for handling UITextView
public final class UIViewControllerHelper {

	// MARK: - Initializers
	
	private init () {}
	
	
	// MARK: - Class Methods
	
	public class func getPresentedViewController() -> UIViewController {
		
		var result: UIViewController? = UIApplication.shared.keyWindow?.rootViewController
		
		while result?.presentedViewController != nil {
			result = result?.presentedViewController
		}
		
		return result!
	}
	

}
