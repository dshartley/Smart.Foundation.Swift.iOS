//
//  UIImagePickerHelper.swift
//  SFView
//
//  Created by David on 16/11/2017.
//  Copyright © 2017 com.smartfoundation. All rights reserved.
//

import UIKit
import SFGlobalization

/// A helper for handling UIImagePicker
public final class UIImagePickerHelper: NSObject {

	// MARK: - Private Stored Properties
	
	fileprivate var alertController: 				UIAlertController?
	fileprivate var imagePicker: 					UIImagePickerController?
	fileprivate weak var presentedViewController: 	UIViewController!
	fileprivate weak var popoverSourceView: 		UIView?
	fileprivate var localizationHelper:				LocalizationHelper?
	fileprivate var image: 							UIImage?
	
	
	// MARK: - Public Stored Properties
	
	public weak var delegate: 						ProtocolUIImagePickerHelperDelegate?
	
	
	// MARK: - Initializers
	
	public override init() {
		
		// Setup localizationHelper
		self.localizationHelper = LocalizationHelper(bundle: Bundle(for: type(of: self)))
	}
	
	
	// MARK: - Public Methods
	
	public func setup(presentedViewController: 	UIViewController,
	                  popoverSourceView: 		UIView) {
		
		self.presentedViewController 	= presentedViewController
		self.popoverSourceView 			= popoverSourceView
		
		self.setupImagePicker()
		self.setupAlertController()
		
	}
	
	public func pick() {
		
		self.presentActionSheet()
	}
	
	public func getImage() -> UIImage? {
		
		return self.image
	}
	
	
	// MARK: - Private Methods
	
	fileprivate func setupImagePicker() {
		
		self.imagePicker 					= UIImagePickerController()
		
		self.imagePicker!.delegate 			= self
		self.imagePicker!.allowsEditing 	= false

	}
	
	fileprivate func presentImagePicker(sourceType: UIImagePickerControllerSourceType) {
		
		if (sourceType == .photoLibrary) {
			
			// Set image picker source type
			self.imagePicker!.sourceType 									= sourceType
			
			self.imagePicker!.modalPresentationStyle 						= .popover
			self.imagePicker!.popoverPresentationController?.sourceView 	= self.popoverSourceView!
			self.imagePicker!.popoverPresentationController?.sourceRect 	= self.popoverSourceView!.bounds

		} else if (sourceType == .camera) {
			
			// Set image picker source type
			self.imagePicker!.sourceType 				= sourceType
			
			self.imagePicker!.modalPresentationStyle 	= .fullScreen	// Camera must be full screen
		
		}
		
		// Present image picker
		self.presentedViewController.present(self.imagePicker!, animated: true, completion: nil)
		
	}
	
	fileprivate func setupAlertController() {
		
		// Create alertController
		let alertTitle: 		String = self.localizationHelper!.localizedString(forKey: "UIImagePickerHelperAlertControllerTitle")!
		self.alertController 	= UIAlertController(title: alertTitle, message: nil, preferredStyle: .actionSheet)
		
		// Setup Camera action
		self.setupAlertCameraAction(alertController: self.alertController!)
	
		// Setup Library action
		self.setupAlertLibraryAction(alertController: self.alertController!)
		
		// Setup Cancel action
		self.setupAlertCancelAction(alertController: self.alertController!)
		
	}
	
	fileprivate func setupAlertCameraAction(alertController: UIAlertController) {
		
		// Check camera available (Note: Not available in simulator)
		if UIImagePickerController.isSourceTypeAvailable(.camera) {
			
			let title: 			String = self.localizationHelper!.localizedString(forKey: "UIImagePickerHelperCameraAlertActionTitle")!
			
			// Create the alert action
			let alertAction: 	UIAlertAction = UIAlertAction(title: title, style: .default) {
				(alert) -> Void in
				
				self.presentImagePicker(sourceType: .camera)
				
			}
			
			// Add alert action to alert controller
			alertController.addAction(alertAction)
			
		}
		
	}
	
	fileprivate func setupAlertLibraryAction(alertController: UIAlertController) {
		
		let title: 			String = self.localizationHelper!.localizedString(forKey: "UIImagePickerHelperLibraryAlertActionTitle")!
		
		// Create the alert action
		let alertAction: 	UIAlertAction = UIAlertAction(title: title, style: .default) {
			(alert) -> Void in
			
			self.presentImagePicker(sourceType: .photoLibrary)
			
		}
		
		// Add alert action to alert controller
		alertController.addAction(alertAction)
		
	}

	fileprivate func setupAlertCancelAction(alertController: UIAlertController) {
		
		let title: 			String = self.localizationHelper!.localizedString(forKey: "UIImagePickerHelperCancelAlertActionTitle")!
		
		// Create the alert action
		let alertAction: 	UIAlertAction = UIAlertAction(title: title, style: .default) {
			(alert) -> Void in
		}
		
		// Add alert action to alert controller
		alertController.addAction(alertAction)
		
	}
	
	fileprivate func presentActionSheet() {
	
		// Setup popover presentation style
		self.alertController!.modalPresentationStyle 					= .popover
		self.alertController!.popoverPresentationController?.sourceView = self.popoverSourceView!
		self.alertController!.popoverPresentationController?.sourceRect = self.popoverSourceView!.bounds
		
		self.presentedViewController!.present(self.alertController!, animated: true, completion: nil)
	}
	
}

// MARK: - Extension UIImagePickerControllerDelegate, UINavigationControllerDelegate

extension UIImagePickerHelper: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
	
	// MARK: - Public Methods
	
	public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {

		self.image = nil
		
		// Dismiss the image picker
		UIViewControllerHelper.getPresentedViewController().dismiss(animated: true, completion: nil)
		
		// Notify the delegate
		self.delegate?.uiimagePickerHelper(didCancel: self)
		
	}
	
	public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
		
		self.image = info[UIImagePickerControllerOriginalImage] as? UIImage

		// Dismiss the image picker
		UIViewControllerHelper.getPresentedViewController().dismiss(animated: true, completion: nil)
		
		// Notify the delegate
		self.delegate?.uiimagePickerHelper(didFinishPickingMediaWithInfo: info)
		
	}
	
}
