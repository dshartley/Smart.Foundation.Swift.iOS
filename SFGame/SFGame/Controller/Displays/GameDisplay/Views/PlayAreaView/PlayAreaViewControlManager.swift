//
//  PlayAreaViewControlManager.swift
//  SFGame
//
//  Created by David on 24/11/2017.
//  Copyright © 2017 com.smartfoundation. All rights reserved.
//

import UIKit
import SFCore
import SFController
import SFSocial

/// Manages the PlayAreaView control layer
open class PlayAreaViewControlManager: ControlManagerBase {
	
	// MARK: - Public Stored Properties
	
	public weak var delegate:						ProtocolPlayAreaViewControlManagerDelegate?
	public var viewManager:							PlayAreaViewViewManager?
	public fileprivate(set) var playDataWrapper:	PlayDataWrapper?
	
	
	// MARK: - Private Stored Properties

	
	// MARK: - Initializers
	
	public override init() {
		super.init()
	}
	
	public init(modelManager: GameModelManager, viewManager: PlayAreaViewViewManager) {
		super.init(modelManager: modelManager)
		
		self.viewManager				= viewManager
	}
	
	
	// MARK: - Public Methods
	
	public func loadPlayData(for relativeMemberWrapper: RelativeMemberWrapper, applicationID: String, oncomplete completionHandler:@escaping ([PlayDataWrapper]?, Error?) -> Void) {

		// Create completion handler
		let selectCompletionHandler: (([Any]?, Error?) -> Void) =
		{
			[unowned self] (data, error) -> Void in

			// Set state
			self.setStateAfterLoad()

			if (data != nil && error == nil) {

				// Process the loaded playDataWrappers
				self.doAfterLoadPlayData(oncomplete: completionHandler)

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
				self.getPlayDataModelAdministrator().select(byRelativeMemberID: relativeMemberWrapper.id, applicationID: applicationID, oncomplete: selectCompletionHandler)

			}

		} else {

			// Notify the delegate
			self.delegate?.playAreaViewControlManager(isNotConnected: nil)

		}

	}
	
	public func displayPlayData() {
		
		var totalNumberOfExperiencePoints: 	Int = 0
		var totalNumberOfFeathers: 			Int = 0
		var totalNumberOfPoints: 			Int = 0
		
		// Go through each item
		for item in PlayWrapper.current!.playData!.values {
			
			totalNumberOfExperiencePoints 	+= item.numberOfExperiencePoints
			totalNumberOfFeathers 			+= item.numberOfFeathers
			totalNumberOfPoints 			+= item.numberOfPoints
			
		}
		
		// totalNumberOfFeathers
		self.viewManager!.displayTotalNumberOfFeathers(value: totalNumberOfFeathers)
		
		// totalNumberOfPoints
		self.viewManager!.displayTotalNumberOfPoints(value: totalNumberOfPoints)
		
	}

	public func displayPlayMoves(wrappers: [String:Any]) {
		
		// Get playMoveWrappers
		let playMoveWrappers: [PlayMoveWrapper]? = wrappers["PlayMoves"] as? [PlayMoveWrapper]
		
		guard (playMoveWrappers != nil) else { return }
		
		// Present PlaySpaceTypes
		self.viewManager!.present(playMoves: playMoveWrappers!)
		
	}
	
	public func displayPlaySpaces(wrappers: [String:Any]) {

		// Get playSpaceWrappers
		let playSpaceWrappers: [PlaySpaceWrapper]? = wrappers["PlaySpaces"] as? [PlaySpaceWrapper]

		guard (playSpaceWrappers != nil) else { return }
		
		// Go through each item
		for psw in playSpaceWrappers! {
			
			// Display PlaySpaceWrapper
			self.doDisplayPlaySpace(wrapper: psw)
			
		}

	}
	
	public func doAfterPlayExperienceCompleted(wrapper: PlayExperienceWrapper, oncomplete completionHandler:@escaping (Error?) -> Void) {
		
		// Check playExperienceResult and playMove
		guard (wrapper.playExperienceResult != nil && wrapper.playMove != nil) else {
			
			// Call completion handler
			completionHandler(NSError())
			
			return
			
		}
		
		// Check playReferenceType and playReferenceActionType
		if (wrapper.playMove!.playReferenceType == .PlaySpaceType
			&& wrapper.playMove!.playReferenceActionType == .AddPlaySpace) {
			
			self.handlePlayReferenceActionAddPlaySpace(wrapper: wrapper, oncomplete: completionHandler)
			
		} else {
			
			// Call completion handler
			completionHandler(NSError())
			
		}
		
	}
	
	public func addPlaySpace(for playSpaceTypeWrapper: PlaySpaceTypeWrapper, oncomplete completionHandler:@escaping (Error?) -> Void) {
		
		// Create PlaySpaceWrapper
		let psw: PlaySpaceWrapper = self.doCreatePlaySpace(wrapper: playSpaceTypeWrapper)
		
		// Display PlaySpaceWrapper
		self.doDisplayPlaySpace(wrapper: psw)
		
		// Save PlaySpace
		self.doSavePlaySpace(wrapper: psw)
		
		// Call completion handler
		completionHandler(nil)
		
	}
	
	
	// MARK: - Override Methods
	
	
	// MARK: - Open [Overridable] Methods
	
	open func loadPlaySpaces(for relativeMemberWrapper: RelativeMemberWrapper, playAreaID: String, oncomplete completionHandler:@escaping ([String:Any]?, Error?) -> Void) {
		
		// Create completion handler
		let selectCompletionHandler: (([Any]?, Error?) -> Void) =
		{
			[unowned self] (data, error) -> Void in
			
			// Set state
			self.setStateAfterLoad()
			
			if (data != nil && error == nil) {
				
				// Process the loaded playSpaceWrappers
				self.doAfterLoadPlaySpaces(oncomplete: completionHandler)
				
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
				self.getPlaySpaceModelAdministrator().select(byRelativeMemberID: relativeMemberWrapper.id, playAreaID: playAreaID, loadRelationalTablesYN: true, oncomplete: selectCompletionHandler)
				
			}
			
		} else {
			
			// Notify the delegate
			self.delegate?.playAreaViewControlManager(isNotConnected: nil)
			
		}
		
	}

	
	// MARK: - Private Methods
	
	fileprivate func doAfterLoadPlayData(oncomplete completionHandler:@escaping ([PlayDataWrapper]?, Error?) -> Void) {

		// Get the PlayDataWrappers
		let playDataWrappers: 		[PlayDataWrapper] = self.getPlayDataModelAdministrator().toWrappers()

		// Set in PlayWrapper
		PlayWrapper.current?.set(wrappers: ["PlayData":playDataWrappers])

		self.playDataWrapper = playDataWrappers.first

		// Call completion handler
		completionHandler(playDataWrappers, nil)

	}

	fileprivate func doAfterLoadPlaySpaces(oncomplete completionHandler:@escaping ([String:Any]?, Error?) -> Void) {
		
		var result: [String:Any] = [String:Any]()
		
		// Get the PlaySpaceTypeWrappers
		let playSpaceTypeWrappers: 	[PlaySpaceTypeWrapper] = self.getPlaySpaceTypeModelAdministrator().toWrappers()
		result[self.getPlaySpaceTypeModelAdministrator().tableName] 	= playSpaceTypeWrappers
		
		// Get the PlaySpaceWrappers
		let playSpaceWrappers: 		[PlaySpaceWrapper] = self.getPlaySpaceModelAdministrator().toWrappers()
		result[self.getPlaySpaceModelAdministrator().tableName] 		= playSpaceWrappers

		// Get the PlaySpaceDataWrappers
		let playSpaceDataWrappers: 	[PlaySpaceDataWrapper] = self.getPlaySpaceDataModelAdministrator().toWrappers()
		result[self.getPlaySpaceDataModelAdministrator().tableName] 	= playSpaceDataWrappers

		// Get the PlayMoveWrappers
		let playMoveWrappers: 		[PlayMoveWrapper] = self.getPlayMoveModelAdministrator().toWrappers()
		result[self.getPlayMoveModelAdministrator().tableName] 			= playMoveWrappers
		
		// Set in PlayWrapper
		PlayWrapper.current?.set(wrappers: result)
		
		// Call completion handler
		completionHandler(result, nil)
		
	}
	
	fileprivate func doCreatePlaySpaceMarkerView(wrapper: PlaySpaceWrapper) -> ProtocolPlaySpaceMarkerView? {
		
		return self.delegate!.playAreaViewControlManager(createPlaySpaceMarkerViewFor: wrapper)
		
	}
	
	fileprivate func doDisplayPlaySpace(wrapper: PlaySpaceWrapper) {
		
		// Create PlaySpaceMarkerView
		let playSpaceMarkerView: ProtocolPlaySpaceMarkerView? = self.doCreatePlaySpaceMarkerView(wrapper: wrapper)
		
		guard (playSpaceMarkerView != nil) else { return }
		
		// Present PlaySpaceMarkerView
		self.viewManager!.present(playSpaceMarkerView: playSpaceMarkerView!)
		
	}
	
	fileprivate func doCreatePlaySpace(wrapper: PlaySpaceTypeWrapper) -> PlaySpaceWrapper {
		
		// TODO:
		// Somehow figure out a clever way to set positions
		let coordX: Int = 40
		let coordY: Int = (PlayWrapper.current!.playSpaces!.count + 1) * 60
		
		
		let result: 				PlaySpaceWrapper = PlaySpaceWrapper()
		result.id 					= UUID().uuidString
		result.playSpaceType 		= wrapper.playSpaceType
		result.playAreaID 			= "1"
		result.coordX 				= coordX
		result.coordY 				= coordY
		result.playLanguageID 		= 1
		result.relativeMemberID 	= self.playDataWrapper!.relativeMemberID
		
		let psdw: 					PlaySpaceDataWrapper = PlaySpaceDataWrapper()
		psdw.id 					= UUID().uuidString
		psdw.playSpaceID 			= result.id
		psdw.relativeMemberID 		= self.playDataWrapper!.relativeMemberID
		
		result.set(playSpaceDataWrapper: psdw)

		return result
		
	}
	
	fileprivate func doSavePlaySpace(wrapper: PlaySpaceWrapper) {
		
		// Get ModelAdministrators
		let psma: 	PlaySpaceModelAdministrator = self.getPlaySpaceModelAdministrator()
		let psdma: 	PlaySpaceDataModelAdministrator = self.getPlaySpaceDataModelAdministrator()
		
		psma.initialise()
		psdma.initialise()
		
		guard (wrapper.playSpaceData != nil) else { return }
		
		// Create PlaySpace model item
		let ps: 	PlaySpace = psma.collection!.getNewItem() as! PlaySpace
		ps.clone(fromWrapper: wrapper)
		ps.status 	= .new
		psma.collection!.addItem(item: ps)
		
		// Create PlaySpaceData model item
		let psd: 	PlaySpaceData = psdma.collection!.getNewItem() as! PlaySpaceData
		psd.status 	= .new
		psd.clone(fromWrapper: wrapper.playSpaceData!)
		psdma.collection!.addItem(item: psd)
		
		
		// Create completion handler
		let saveCompletionHandler: ((Error?) -> Void) =
		{
			(error) -> Void in	// [unowned self]
			
			if (error == nil) {
				
				// Update the wrappers from the model items
				wrapper.id 							= ps.id
				wrapper.playSpaceData?.id 			= psd.id
				wrapper.playSpaceData?.playSpaceID 	= ps.id
				
				#if DEBUG
					
					if (ApplicationFlags.flag(key: "SaveDummyDataYN")) {
						
						wrapper.id 							= UUID().uuidString
						wrapper.playSpaceData?.id 			= UUID().uuidString
						wrapper.playSpaceData?.playSpaceID 	= wrapper.id
						
					}
					
				#endif
				
				// Set in PlayWrapper
				PlayWrapper.current?.playSpaces![wrapper.id] = wrapper
				
			}
			
		}
		
		
		// Set insertRelationalItemsYN
		psma.insertRelationalItemsYN = true
		
		psma.save(oncomplete: saveCompletionHandler)
		
	}

	fileprivate func handlePlayReferenceActionAddPlaySpace(wrapper: PlayExperienceWrapper, oncomplete completionHandler:@escaping (Error?) -> Void) {
		
		// Create completion handler
		let addPlaySpaceCompletionHandler: ((Error?) -> Void) =
		{
			(error) -> Void in		// [unowned self]
			
			// Call completion handler
			completionHandler(error)
			
		}
		
		// Get PlaySpaceTypeWrapper
		let pstw: PlaySpaceTypeWrapper? = PlayWrapper.current?.playSpaceTypes?[wrapper.playMove!.playReferenceID]
		
		if (pstw != nil) {
			
			// Add PlaySpace
			self.addPlaySpace(for: pstw!, oncomplete: addPlaySpaceCompletionHandler)
			
		} else {
			
			// Call completion handler
			completionHandler(NSError())
			
		}
		
	}
	
}
