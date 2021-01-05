//
//  ProtocolUIKeyboardHelperDelegate.swift
//  SFView
//
//  Created by David on 14/11/2017.
//  Copyright © 2017 com.smartfoundation. All rights reserved.
//

/// Defines a delegate for a UIKeyboardHelper class
public protocol ProtocolUIKeyboardHelperDelegate: class {

	// MARK: - Methods
	
	func uikeyboardHelper(keyboardWillShow sender:Notification)
	
	func uikeyboardHelper(keyboardWillHide sender:Notification)
	
}
