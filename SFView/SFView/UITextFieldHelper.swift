//
//  UITextFieldHelper.swift
//  SFView
//
//  Created by David on 30/10/2017.
//  Copyright © 2017 com.smartfoundation. All rights reserved.
//

import UIKit

/// A helper for handling UITextField
public final class UITextFieldHelper {
	
	// MARK: - Initializers
	
	private init () {}
	
	
	// MARK: - Class Methods
	
	public class func checkMaxLength(textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String, maxLength: Int) -> Bool {
		
		guard let unchangedText = textField.text else { return true }
		
		var result: 		Bool = true
		
		// Get length
		let length: 		Int = unchangedText.count + string.count - range.length

		if (length > maxLength) { result = false }
		
		return result
		
	}
	
}
