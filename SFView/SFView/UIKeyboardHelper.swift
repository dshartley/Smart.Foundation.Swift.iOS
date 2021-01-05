//
//  UIKeyboardObserver.swift
//  SFView
//
//  Created by David on 14/11/2017.
//  Copyright © 2017 com.smartfoundation. All rights reserved.
//

import Foundation
import UIKit

/// A helper for handling the keyboard
public struct UIKeyboardHelper {

	// MARK: - Private Stored Properties
	
	// MARK: - Public Stored Properties

	public weak var delegate: ProtocolUIKeyboardHelperDelegate?
	
	
	// MARK: - Initializers
	
	public init() {
	}

	
	// MARK: - Public Methods
	
	public func setup() {
		
		self.setupKeyboardWillShowNotification()
		self.setupKeyboardWillHideNotification()
		
	}
	
	public func dispose() {
		
		self.removeKeyboardNotifications()
	}
	
	
	// MARK: - Private Methods
	
	fileprivate func setupKeyboardWillShowNotification() {
		
		// Create completion handler
		let keyboardWillShowCompletionHandler: (Notification) -> Void =
		{
			(sender) -> Void in
			
			self.keyboardWillShow(sender)
		}
		
		NotificationCenter.default.addObserver(forName: .UIKeyboardWillShow,
		                                       object: 	nil,
		                                       queue: 	OperationQueue.main,
		                                       using: 	keyboardWillShowCompletionHandler)
	}
	
	fileprivate func setupKeyboardWillHideNotification() {
		
		// Create completion handler
		let keyboardWillHideCompletionHandler: (Notification) -> Void =
		{
			(sender) -> Void in
			
			self.keyboardWillHide(sender)
		}
		
		NotificationCenter.default.addObserver(forName: .UIKeyboardWillHide,
		                                       object: 	nil,
		                                       queue: 	OperationQueue.main,
		                                       using: 	keyboardWillHideCompletionHandler)
	}
	
	fileprivate func removeKeyboardNotifications() {
		
		NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
		NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
	}
	
	fileprivate func keyboardWillShow(_ sender:Notification) {
		
		// Notify the delegate
		self.delegate?.uikeyboardHelper(keyboardWillShow: sender)
		
	}
	
	fileprivate func keyboardWillHide(_ sender:Notification) {

		// Notify the delegate
		self.delegate?.uikeyboardHelper(keyboardWillHide: sender)
		
	}
	
}
