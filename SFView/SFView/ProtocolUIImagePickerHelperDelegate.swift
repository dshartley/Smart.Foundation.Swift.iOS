//
//  ProtocolUIImagePickerHelperDelegate.swift
//  SFView
//
//  Created by David on 16/11/2017.
//  Copyright © 2017 com.smartfoundation. All rights reserved.
//

/// Defines a delegate for a UIImagePickerHelper class
public protocol ProtocolUIImagePickerHelperDelegate: class {
	
	// MARK: - Methods

	func uiimagePickerHelper(didCancel sender: UIImagePickerHelper)
	
	func uiimagePickerHelper(didFinishPickingMediaWithInfo info: [String : Any])
	
}
