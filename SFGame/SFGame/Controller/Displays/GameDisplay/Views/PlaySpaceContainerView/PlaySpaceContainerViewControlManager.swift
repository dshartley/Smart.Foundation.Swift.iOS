//
//  PlaySpaceContainerViewControlManager.swift
//  SFGame
//
//  Created by David on 24/11/2017.
//  Copyright © 2017 com.smartfoundation. All rights reserved.
//

import UIKit
import SFCore
import SFController
import SFSerialization

/// Manages the PlaySpaceContainerView control layer
public class PlaySpaceContainerViewControlManager: ControlManagerBase {
	
	// MARK: - Public Stored Properties
	
	public weak var delegate:						ProtocolPlaySpaceContainerViewControlManagerDelegate?
	public var viewManager:							PlaySpaceContainerViewViewManager?
	public fileprivate(set) var playSpaceWrapper: 	PlaySpaceWrapper?
	
	
	// MARK: - Private Stored Properties

	
	// MARK: - Initializers
	
	public override init() {
		super.init()
	}
	
	public init(modelManager: GameModelManager, viewManager: PlaySpaceContainerViewViewManager) {
		super.init(modelManager: modelManager)
		
		self.viewManager				= viewManager
	}
	
	
	// MARK: - Public Methods
	
	public func loadPlaySpace(playSpaceID: String, oncomplete completionHandler:@escaping ([String:Any]?, Error?) -> Void) {
		
		// Create completion handler
		let selectCompletionHandler: (([Any]?, Error?) -> Void) =
		{
			[unowned self] (data, error) -> Void in
			
			// Set state
			self.setStateAfterLoad()
			
			if (data != nil && error == nil) {
				
				// Process the loaded playSpaceWrappers
				self.doAfterLoadPlaySpace(oncomplete: completionHandler)
				
			} else {
				
				// Call completion handler
				completionHandler(nil, error)
				
			}
			
		}
		
		// Check is connected
		if (self.checkIsConnected()) {
			
			self.setStateBeforeLoad()
			
			DispatchQueue.main.async {
				
				// Load items
				self.getPlaySpaceModelAdministrator().select(byID: playSpaceID, loadRelationalTablesYN: true, oncomplete: selectCompletionHandler)
				
			}
			
		} else {
			
			// Notify the delegate
			self.delegate?.playSpaceContainerViewControlManager(isNotConnected: nil)
			
		}
		
	}
	
	public func unloadPlaySpace() {

		guard (self.playSpaceWrapper != nil) else { return }
		
		// Clear PlaySpace
		PlayWrapper.current?.clear(playSpace: self.playSpaceWrapper!)

	}
	
	
	// MARK: - Override Methods
	
	
	// MARK: - Private Methods
	
	fileprivate func doAfterLoadPlaySpace(oncomplete completionHandler:@escaping ([String:Any]?, Error?) -> Void) {
		
		var result: [String:Any] = [String:Any]()
		
		// Get the PlaySpaceWrappers
		let playSpaceWrappers: 			[PlaySpaceWrapper] = self.getPlaySpaceModelAdministrator().toWrappers()
		result[self.getPlaySpaceModelAdministrator().tableName] 		= playSpaceWrappers
		
		// Get the PlaySpaceDataWrappers
		let playSpaceDataWrappers: 		[PlaySpaceDataWrapper] = self.getPlaySpaceDataModelAdministrator().toWrappers()
		result[self.getPlaySpaceDataModelAdministrator().tableName] 	= playSpaceDataWrappers
		
		// Get the PlaySpaceBitTypeWrappers
		let playSpaceBitTypeWrappers: 	[PlaySpaceBitTypeWrapper] = self.getPlaySpaceBitTypeModelAdministrator().toWrappers()
		result[self.getPlaySpaceBitTypeModelAdministrator().tableName] 	= playSpaceBitTypeWrappers
		
		// Get the PlaySpaceBitWrappers
		let playSpaceBitWrappers: 		[PlaySpaceBitWrapper] = self.getPlaySpaceBitModelAdministrator().toWrappers()
		result[self.getPlaySpaceBitModelAdministrator().tableName] 		= playSpaceBitWrappers
		
		// Get the PlaySpaceBitDataWrappers
		let playSpaceBitDataWrappers: 	[PlaySpaceBitDataWrapper] = self.getPlaySpaceBitDataModelAdministrator().toWrappers()
		result[self.getPlaySpaceBitDataModelAdministrator().tableName] 	= playSpaceBitDataWrappers

		// Get the PlayMoveWrappers
		let playMoveWrappers: 			[PlayMoveWrapper] = self.getPlayMoveModelAdministrator().toWrappers()
		result[self.getPlayMoveModelAdministrator().tableName] 			= playMoveWrappers
		
		// Set in PlayWrapper
		PlayWrapper.current?.set(wrappers: result)
		
		self.playSpaceWrapper = playSpaceWrappers.first
		
		// Call completion handler
		completionHandler(result, nil)
		
	}
	
}
