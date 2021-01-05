//
//  UIAlertControllerHelper.swift
//  SFView
//
//  Created by David on 22/11/2017.
//  Copyright © 2017 com.smartfoundation. All rights reserved.
//

import UIKit
import SFGlobalization

public enum UIAlertControllerHelperAlertTypes {
	case Ok
	case OkCancel
}

/// A helper for handling UIAlertController
public final class UIAlertControllerHelper {
	
	// MARK: - Initializers
	
	private init () {}
	
	
	// MARK: - Class Methods
	
	public class func presentAlert(alertTitle: String, alertMessage: String, oncomplete completionHandler:((UIAlertAction) -> Void)?) {
		
		// Setup localizationHelper
		let localizationHelper:	LocalizationHelper = LocalizationHelper(bundle: Bundle(for: UIAlertControllerHelper.self))
		
		// Create alertController
		let alertController: 	UIAlertController = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: UIAlertControllerStyle.alert)
		
		// Create 'OK' action
		let okAlertActionTitle: String = localizationHelper.localizedString(forKey: "AlertActionTitleOk")!
		let alertAction:		UIAlertAction = UIAlertAction(title: okAlertActionTitle, style: .default, handler: completionHandler)
		alertController.addAction(alertAction)

		DispatchQueue.main.async {
		
			// Present alertController
			UIViewControllerHelper.getPresentedViewController().present(alertController, animated: true, completion: nil)
			
		}
		
	}

	public class func presentAlert(alertType: UIAlertControllerHelperAlertTypes, alertTitle: String, alertMessage: String, onok okCompletionHandler:((UIAlertAction) -> Void)?, oncancel cancelCompletionHandler:((UIAlertAction) -> Void)?) {
		
		// Setup localizationHelper
		let localizationHelper:				LocalizationHelper = LocalizationHelper(bundle: Bundle(for: UIAlertControllerHelper.self))
		
		// Create alertController
		let alertController: 				UIAlertController = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: UIAlertControllerStyle.alert)
		
		if (alertType == .OkCancel || alertType == .Ok) {
			
			// Create 'OK' action
			let okAlertActionTitle: 		String = localizationHelper.localizedString(forKey: "AlertActionTitleOk")!
			let okAlertAction:				UIAlertAction = UIAlertAction(title: okAlertActionTitle, style: .default, handler: okCompletionHandler)
			alertController.addAction(okAlertAction)
			
		}
		
		if (alertType == .OkCancel) {
		
			// Create 'Cancel' action
			let cancelAlertActionTitle: 	String = localizationHelper.localizedString(forKey: "AlertActionTitleCancel")!
			let cancelAlertAction:			UIAlertAction = UIAlertAction(title: cancelAlertActionTitle, style: .cancel, handler: cancelCompletionHandler)
			alertController.addAction(cancelAlertAction)
			
		}
		
		DispatchQueue.main.async {
			
			// Present alertController
			UIViewControllerHelper.getPresentedViewController().present(alertController, animated: true, completion: nil)
			
		}
		
	}
	
}
