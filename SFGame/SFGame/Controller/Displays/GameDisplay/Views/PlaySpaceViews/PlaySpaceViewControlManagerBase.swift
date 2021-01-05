//
//  TreePlaySpaceViewControlManager.swift
//  SFGame
//
//  Created by David on 24/11/2017.
//  Copyright © 2017 com.smartfoundation. All rights reserved.
//

import UIKit
import SFCore
import SFController

/// A base class for classes which manage the PlaySpaceView control layer
open class PlaySpaceViewControlManagerBase: ControlManagerBase {
	
	// MARK: - Public Stored Properties
	
	public weak var delegate:						ProtocolPlaySpaceViewControlManagerDelegate?
	public var viewManager:							PlaySpaceViewViewManagerBase?
	public fileprivate(set) var playSpaceWrapper: 	PlaySpaceWrapper?
	
	
	// MARK: - Private Stored Properties

	
	// MARK: - Initializers
	
	public override init() {
		super.init()
	}
	
	public init(modelManager: GameModelManager, viewManager: PlaySpaceViewViewManagerBase) {
		super.init(modelManager: modelManager)
		
		self.viewManager = viewManager
	}
	
	
	// MARK: - Public Methods
	
	public func set(wrappers: [String:Any]) {
		
		// Get playSpaceWrappers
		let playSpaceWrappers: [PlaySpaceWrapper]? = wrappers["PlaySpaces"] as? [PlaySpaceWrapper]
		
		self.playSpaceWrapper = playSpaceWrappers?.first
		
		if let psdw = self.playSpaceWrapper?.playSpaceData {
			
			self.doDisplayPlaySpaceData(wrapper: psdw)
		
		}
	}
	
	public func displayPlayMoves(wrappers: [String:Any]) {
		
		// Get playMoveWrappers
		let playMoveWrappers: [PlayMoveWrapper]? = wrappers["PlayMoves"] as? [PlayMoveWrapper]
		
		guard (playMoveWrappers != nil) else { return }
		
		// Display list of PlayMoves
		self.viewManager!.present(playMoves: playMoveWrappers!)
		
	}
	
	public func displayPlaySpaceBits(wrappers: [String:Any]) {
		
		// Get playSpaceBitWrappers
		let playSpaceBitWrappers: [PlaySpaceBitWrapper]? = wrappers["PlaySpaceBits"] as? [PlaySpaceBitWrapper]

		guard (playSpaceBitWrappers != nil) else { return }
		
		// Go through each item
		for psbw in playSpaceBitWrappers! {
			
			// Display PlaySpaceBitWrappers
			self.doDisplayPlaySpaceBit(wrapper: psbw)
			
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
		if (wrapper.playMove!.playReferenceType == .PlaySpaceBitType
			&& wrapper.playMove!.playReferenceActionType == .AddPlaySpaceBit) {

			self.handlePlayReferenceActionAddPlaySpaceBit(wrapper: wrapper, oncomplete: completionHandler)
			
		} else if (wrapper.playMove!.playReferenceType == .PlaySpaceBit
			&& wrapper.playMove!.playReferenceActionType == .SetPlaySpaceBitAttribute) {
			
			self.handlePlayReferenceActionSetPlaySpaceBitAttribute(wrapper: wrapper, oncomplete: completionHandler)
			
		} else {
			
			// Call completion handler
			completionHandler(NSError())
			
		}
		
	}
	
	public func addPlaySpaceBit(for playSpaceBitTypeWrapper: PlaySpaceBitTypeWrapper, oncomplete completionHandler:@escaping (Error?) -> Void) {
		
		// Create PlaySpaceBitWrapper
		let psbw: PlaySpaceBitWrapper = self.doCreatePlaySpaceBit(wrapper: playSpaceBitTypeWrapper)

		// Create completion handler
		let loadPlayMovesCompletionHandler: (([String:Any]?, Error?) -> Void) =
		{
			(wrappers, error) -> Void in	// [unowned self]
			
			if (error == nil) {
				
				// Display PlaySpaceBitWrappers
				self.doDisplayPlaySpaceBit(wrapper: psbw)
				
			}
			
			// Call completion handler
			completionHandler(error)
			
		}
		
		// Create completion handler
		let saveCompletionHandler: ((Error?) -> Void) =
		{
			(error) -> Void in	// [unowned self]
			
			if (error == nil) {
				
				// Load PlayMoves
				self.loadPlayMoves(forPlaySpaceBit: psbw, oncomplete: loadPlayMovesCompletionHandler)

			} else {
				
				// Call completion handler
				completionHandler(error)
				
			}
			
		}
		
		// Save PlaySpaceBit
		self.doSavePlaySpaceBit(wrapper: psbw, oncomplete: saveCompletionHandler)
		
	}
	
	
	// MARK: - Override Methods
	
	
	// MARK: - Private Methods
	
	fileprivate func doCreatePlaySpaceBitView(wrapper: PlaySpaceBitWrapper) -> ProtocolPlaySpaceBitView {
		
		return self.delegate!.playSpaceViewControlManager(createPlaySpaceBitViewFor: wrapper)
		
	}

	fileprivate func doAfterLoadPlayMoves(forPlaySpaceBit playSpaceBitWrapper: PlaySpaceBitWrapper, oncomplete completionHandler:@escaping ([String:Any]?, Error?) -> Void) {
		
		var result: 				[String:Any] = [String:Any]()
		
		// Get the PlayMoveWrappers
		let playMoveWrappers: 		[PlayMoveWrapper] = self.getPlayMoveModelAdministrator().toWrappers()
		result[self.getPlayMoveModelAdministrator().tableName] = playMoveWrappers
		
		
		#if DEBUG
			
			if (ApplicationFlags.flag(key: "LoadPlayMovesDummyDataYN")) {
				
				// Go through each item
				for pmw in playMoveWrappers {
				
					pmw.id 				= UUID().uuidString
					pmw.playReferenceID = playSpaceBitWrapper.id
				}
				
			}
				
		#endif
		
		
		// Set in PlayWrapper
		PlayWrapper.current?.set(wrappers: result)
		
		// Call completion handler
		completionHandler(result, nil)
		
	}
	
	fileprivate func doDisplayPlaySpaceData(wrapper: PlaySpaceDataWrapper) {
		
		self.viewManager!.display(numberOfExperiencePoints: wrapper.numberOfExperiencePoints)
		self.viewManager!.display(numberOfPoints: wrapper.numberOfPoints)
		self.viewManager!.display(numberOfFeathers: wrapper.numberOfFeathers)
		
	}
	
	fileprivate func doDisplayPlaySpaceBit(wrapper: PlaySpaceBitWrapper) {
		
		// Create PlaySpaceBitView
		let playSpaceBitView: ProtocolPlaySpaceBitView = self.doCreatePlaySpaceBitView(wrapper: wrapper)
		
		// Present PlaySpaceBitView
		self.viewManager!.present(playSpaceBitView: playSpaceBitView)
		
	}
	
	fileprivate func doCreatePlaySpaceBit(wrapper: PlaySpaceBitTypeWrapper) -> PlaySpaceBitWrapper {
		
		// TODO:
		// Somehow figure out a clever way to set positions
		let coordX: Int = 40
		let coordY: Int = (self.playSpaceWrapper!.playSpaceBits!.count + 1) * 60
		
		
		let result: 				PlaySpaceBitWrapper = PlaySpaceBitWrapper()
		result.id 					= UUID().uuidString
		result.relativeMemberID 	= self.playSpaceWrapper!.relativeMemberID
		result.playSpaceID 			= self.playSpaceWrapper!.id
		result.playSpaceBitType 	= wrapper.playSpaceBitType
		result.coordX 				= coordX
		result.coordY 				= coordY
		
		let psbdw: 					PlaySpaceBitDataWrapper = PlaySpaceBitDataWrapper()
		psbdw.id 					= UUID().uuidString
		psbdw.relativeMemberID		= self.playSpaceWrapper!.relativeMemberID
		psbdw.playSpaceBitID 		= result.id
		
		result.set(playSpaceBitDataWrapper: psbdw)
		
		return result
		
	}
	
	fileprivate func doSavePlaySpaceBit(wrapper: PlaySpaceBitWrapper, oncomplete completionHandler:@escaping (Error?) -> Void) {
		
		// Get ModelAdministrators
		let psbma: 		PlaySpaceBitModelAdministrator = self.getPlaySpaceBitModelAdministrator()
		let psbdma: 	PlaySpaceBitDataModelAdministrator = self.getPlaySpaceBitDataModelAdministrator()
		
		psbma.initialise()
		psbdma.initialise()
		
		guard (wrapper.playSpaceBitData != nil) else {
			
			// Call completion handler
			completionHandler(NSError())
			
			return
			
		}
		
		// Create PlaySpaceBit model item
		let psb: 		PlaySpaceBit = psbma.collection!.getNewItem() as! PlaySpaceBit
		psb.clone(fromWrapper: wrapper)
		psb.status 		= .new
		psbma.collection!.addItem(item: psb)
		
		// Create PlaySpaceBitData model item
		let psbd: 		PlaySpaceBitData = psbdma.collection!.getNewItem() as! PlaySpaceBitData
		psbd.status 	= .new
		psbd.clone(fromWrapper: wrapper.playSpaceBitData!)
		psbdma.collection!.addItem(item: psbd)
		
		
		// Create completion handler
		let saveCompletionHandler: ((Error?) -> Void) =
		{
			(error) -> Void in	// [unowned self]
			
			if (error == nil) {
				
				// Update the wrappers from the model items
				wrapper.id 										= psb.id
				wrapper.playSpaceBitData?.id 					= psbd.id
				wrapper.playSpaceBitData?.playSpaceBitID 		= psb.id
				
				#if DEBUG
					
					if (ApplicationFlags.flag(key: "SaveDummyDataYN")) {
						
						wrapper.id 									= UUID().uuidString
						wrapper.playSpaceBitData?.id 				= UUID().uuidString
						wrapper.playSpaceBitData?.playSpaceBitID 	= wrapper.id
						
					}
					
				#endif
				
				self.playSpaceWrapper!.set(playSpaceBitWrapper: wrapper)
				
				// Set in PlayWrapper
				PlayWrapper.current?.playSpaceBits![wrapper.id] = wrapper
				
			}
			
			// Call completion handler
			completionHandler(error)
			
		}
		
		
		// Set insertRelationalItemsYN
		psbma.insertRelationalItemsYN = true
		
		psbma.save(oncomplete: saveCompletionHandler)
		
	}
	
	fileprivate func loadPlayMoves(forPlaySpaceBit playSpaceBitWrapper: PlaySpaceBitWrapper, oncomplete completionHandler:@escaping ([String:Any]?, Error?) -> Void) {
		
		// Create completion handler
		let selectCompletionHandler: (([Any]?, Error?) -> Void) =
		{
			[unowned self] (data, error) -> Void in
			
			// Set state
			self.setStateAfterLoad()
			
			if (data != nil && error == nil) {
				
				// Process the loaded playMoveWrappers
				self.doAfterLoadPlayMoves(forPlaySpaceBit: playSpaceBitWrapper, oncomplete: completionHandler)
				
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
				self.getPlayMoveModelAdministrator().select(byPlayReferenceID: playSpaceBitWrapper.id, playReferenceType: .PlaySpaceBit, oncomplete: selectCompletionHandler)
				
			}
			
		} else {
			
			// Notify the delegate
			self.delegate?.playSpaceViewControlManager(isNotConnected: nil)
			
		}
		
	}

	fileprivate func doUpdatePlayData(wrapper: PlayExperienceWrapper) {
		
		guard (wrapper.playExperienceResult != nil && wrapper.playMove != nil) else { return }
		
		// Get playSpaceData
		if let psdw = self.playSpaceWrapper?.playSpaceData {
			
			// Update playSpaceData
			psdw.numberOfExperiencePoints 		+= wrapper.playExperienceResult!.numberOfExperiencePoints
			psdw.numberOfPoints 				+= wrapper.playExperienceResult!.numberOfPoints
			psdw.numberOfFeathers 				+= wrapper.playExperienceResult!.numberOfFeathers
			
			self.doDisplayPlaySpaceData(wrapper: psdw)
			
		}
		
		// Check playReferenceType
		if (wrapper.playMove!.playReferenceType == .PlaySpaceBit) {
			
			// Get playSpaceBit
			let psbw: PlaySpaceBitWrapper? 		= PlayWrapper.current?.playSpaceBits?[wrapper.playMove!.playReferenceID]
			
			if let psbdw = psbw?.playSpaceBitData {
				
				// Update playSpaceBitData
				psbdw.numberOfExperiencePoints 	+= wrapper.playExperienceResult!.numberOfExperiencePoints
				psbdw.numberOfPoints 			+= wrapper.playExperienceResult!.numberOfPoints
				psbdw.numberOfFeathers 			+= wrapper.playExperienceResult!.numberOfFeathers
				
			}
			
		}
		
		// Notify the delegate
		self.delegate?.playSpaceViewControlManager(playSpaceDataChanged: self.playSpaceWrapper!)
		
	}

	fileprivate func handlePlayReferenceActionAddPlaySpaceBit(wrapper: PlayExperienceWrapper, oncomplete completionHandler:@escaping (Error?) -> Void) {
		
		// Create completion handler
		let addPlaySpaceBitCompletionHandler: ((Error?) -> Void) =
		{
			(error) -> Void in		// [unowned self]
			
			// Call completion handler
			completionHandler(error)
			
		}
		
		// Update PlayData
		self.doUpdatePlayData(wrapper: wrapper)
		
		// Get PlaySpaceBitTypeWrapper
		let psbtw: PlaySpaceBitTypeWrapper? = PlayWrapper.current?.playSpaceBitTypes?[wrapper.playMove!.playReferenceID]
		
		if (psbtw != nil) {
			
			// Add PlaySpaceBit
			self.addPlaySpaceBit(for: psbtw!, oncomplete: addPlaySpaceBitCompletionHandler)
			
		} else {
			
			// Call completion handler
			completionHandler(NSError())
			
		}
		
	}
	
	fileprivate func handlePlayReferenceActionSetPlaySpaceBitAttribute(wrapper: PlayExperienceWrapper, oncomplete completionHandler:@escaping (Error?) -> Void) {
		
		guard (wrapper.playMove != nil
			&& wrapper.playMove!.playReferenceType == .PlaySpaceBit
			&& wrapper.playMove!.playReferenceActionType == .SetPlaySpaceBitAttribute
			&& wrapper.playMove!.playMoveOnCompleteData != nil) else {
			
			// Call completion handler
			completionHandler(NSError())
			
			return
			
		}

		// Get PlayMoveWrapper
		let pmw: 			PlayMoveWrapper = wrapper.playMove!
		
		// Get PlaySpaceBitWrapper
		let psbw: 			PlaySpaceBitWrapper? = PlayWrapper.current?.playSpaceBits![pmw.playReferenceID]
		let psbdw: 			PlaySpaceBitDataWrapper? = psbw?.playSpaceBitData
		
		guard (psbdw != nil) else {
			
			// Call completion handler
			completionHandler(NSError())
			
			return
			
		}
		
		// Get onCompleteDataWrapper
		let onCompleteDataWrapper: PlayMoveOnCompleteDataWrapper = wrapper.playMove!.playMoveOnCompleteData!
		
		// Get function properties
		let functionKey: 	String = onCompleteDataWrapper.get(key: "FunctionKey") ?? ""
		let functionValue: 	String = onCompleteDataWrapper.get(key: "FunctionValue") ?? ""
		let attributeKey: 	String = onCompleteDataWrapper.get(key: "AttributeKey") ?? ""

		guard (functionKey.count > 0 && functionValue.count > 0 && attributeKey.count > 0) else {
			
			// Call completion handler
			completionHandler(NSError())
			
			return
			
		}
		
		
		// Get currentValue from playSpaceBitDataAttributeData
		let currentValue: 	String? = psbdw!.playSpaceBitDataAttributeData!.get(key: attributeKey)
		
		
		switch functionKey {
			
		case "add":
			
			let v: 			String = currentValue ?? "0"
			let x: 			Int = Int(v) ?? 0
			let y: 			Int = Int(functionValue) ?? 0
			let newValue: 	Int = x + y
			
			// Set attribute value in playSpaceBitDataAttributeData
			psbdw!.playSpaceBitDataAttributeData!.set(key: attributeKey, value: "\(newValue)")
			psbdw!.refreshAttributeDataString()
			
		default:
			
			// Call completion handler
			completionHandler(NSError())
			
			return
			
		}

		// Create completion handler
		let saveCompletionHandler: ((Error?) -> Void) =
		{
			(error) -> Void in	// [unowned self]
			
			if (error == nil) {
				
				// Update PlayData
				self.doUpdatePlayData(wrapper: wrapper)
				
				
				// Refresh the PlaySpaceBitView
				self.viewManager!.refresh(playSpaceBitViewFor: psbw!)
				
			}
			
			// Call completion handler
			completionHandler(error)
			
		}

		self.doSavePlaySpaceBitData(wrapper: psbdw!, oncomplete: saveCompletionHandler)
		
	}
	
	fileprivate func doSavePlaySpaceBitData(wrapper: PlaySpaceBitDataWrapper, oncomplete completionHandler:@escaping (Error?) -> Void) {
		
		// Get ModelAdministrator
		let psbdma: 	PlaySpaceBitDataModelAdministrator = self.getPlaySpaceBitDataModelAdministrator()
		
		psbdma.initialise()
		
		// Create PlaySpaceBitData model item
		let psbd: 		PlaySpaceBitData = psbdma.collection!.getNewItem() as! PlaySpaceBitData
		psbd.status 	= .modified
		psbd.clone(fromWrapper: wrapper)
		psbdma.collection!.addItem(item: psbd)
		
		// Create completion handler
		let saveCompletionHandler: ((Error?) -> Void) =
		{
			(error) -> Void in	// [unowned self]
			
			if (error == nil) {
				
			}
			
			// Call completion handler
			completionHandler(error)
			
		}
		
		psbdma.save(oncomplete: saveCompletionHandler)
		
	}
	
}
