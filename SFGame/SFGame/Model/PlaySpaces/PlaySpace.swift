//
//  PlaySpace.swift
//  SFGame
//
//  Created by David on 01/01/2018.
//  Copyright © 2018 com.smartfoundation. All rights reserved.
//

import SFModel
import SFSerialization

public enum PlaySpaceDataParameterKeys {
	case ID
	case RelativeMemberID
	case PlayAreaID
	case PlaySpaceType
	case PlayLanguageID
	case CoordX
	case CoordY
	case LoadRelationalTablesYN
}

/// Encapsulates a PlaySpace model item
public class PlaySpace: ModelItemBase {
	
	// MARK: - Public Stored Properties
	
	
	// MARK: - Initializers
	
	private override init() {
		super.init()
	}
	
	public override init(collection: ProtocolModelItemCollection,
						 storageDateFormatter: DateFormatter) {
		super.init(collection: collection,
				   storageDateFormatter: storageDateFormatter)
	}
	
	
	// MARK: - Public Methods
	
	let relativememberidKey: String = "RelativeMemberID"
	
	/// Gets or sets the relativeMemberID
	public var relativeMemberID: String {
		get {
			
			return self.getProperty(key: relativememberidKey)!
		}
		set(value) {
			
			self.setProperty(key: relativememberidKey, value: value, setWhenInvalidYN: false)
		}
	}

	let playareaidKey: String = "PlayAreaID"
	
	/// Gets or sets the playAreaID
	public var playAreaID: String {
		get {
			
			return self.getProperty(key: playareaidKey)!
		}
		set(value) {
			
			self.setProperty(key: playareaidKey, value: value, setWhenInvalidYN: false)
		}
	}
	
	let playspacetypeKey: String = "PlaySpaceType"
	
	/// Gets or sets the playSpaceType
	public var playSpaceType: Int {
		get {
			let i = Int(self.getProperty(key: playspacetypeKey)!)!
			
			return i
		}
		set(value) {
			
			self.setProperty(key: playspacetypeKey, value: String(value), setWhenInvalidYN: false)
		}
	}
	
	let playlanguageidKey: String = "PlayLanguageID"
	
	/// Gets or sets the playLanguageID
	public var playLanguageID: Int {
		get {
			
			return Int(self.getProperty(key: playlanguageidKey)!)!
		}
		set(value) {
			
			self.setProperty(key: playlanguageidKey, value: String(value), setWhenInvalidYN: false)
		}
	}

	let coordxKey: String = "CoordX"
	
	/// Gets or sets the coordX
	public var coordX: Int {
		get {
			
			return Int(self.getProperty(key: coordxKey)!)!
		}
		set(value) {
			
			self.setProperty(key: coordxKey, value: String(value), setWhenInvalidYN: false)
		}
	}

	let coordyKey: String = "CoordY"
	
	/// Gets or sets the coordY
	public var coordY: Int {
		get {
			
			return Int(self.getProperty(key: coordyKey)!)!
		}
		set(value) {
			
			self.setProperty(key: coordyKey, value: String(value), setWhenInvalidYN: false)
		}
	}
	
	public func toWrapper() -> PlaySpaceWrapper {
		
		let wrapper = PlaySpaceWrapper()
		
		wrapper.id							= self.id
		wrapper.relativeMemberID			= self.relativeMemberID
		wrapper.playAreaID					= self.playAreaID
		wrapper.playSpaceType				= self.playSpaceType
		wrapper.playLanguageID				= self.playLanguageID
		wrapper.coordX						= self.coordX
		wrapper.coordY						= self.coordY
		
		return wrapper
	}
	
	public func clone(fromWrapper wrapper: PlaySpaceWrapper) {
		
		// Validations should not be performed when cloning the item
		let doValidationsYN: 			Bool = self.doValidationsYN
		self.doValidationsYN			= false
		
		// Copy all properties from the wrapper
		self.id							= wrapper.id
		self.relativeMemberID			= wrapper.relativeMemberID
		self.playAreaID					= wrapper.playAreaID
		self.playSpaceType				= wrapper.playSpaceType
		self.playLanguageID				= wrapper.playLanguageID
		self.coordX						= wrapper.coordX
		self.coordY						= wrapper.coordY
		
		self.doValidationsYN 			= doValidationsYN
	}
	
	
	// MARK: - Override Methods
	
	public override func initialiseDataNode() {
		
		super.initialiseDataNode()
		
		// Setup the node data
		
		self.doSetProperty(key: relativememberidKey,			value: "")
		self.doSetProperty(key: playareaidKey,	    			value: "")
		self.doSetProperty(key: playspacetypeKey,	    		value: "1")
		self.doSetProperty(key: playlanguageidKey,	    		value: "0")
		self.doSetProperty(key: coordxKey,	    				value: "0")
		self.doSetProperty(key: coordyKey,	    				value: "0")
		
	}
	
	public override func initialiseDataItem() {
		
		// Setup foreign key dependency helpers
	}
	
	public override func initialisePropertyIndexes() {
		
		// Define the range of the properties using the enum values
		
		startEnumIndex	= ModelProperties.playSpace_id.rawValue
		endEnumIndex	= ModelProperties.playSpace_coordY.rawValue
		
	}
	
	public override func initialisePropertyKeys() {
		
		// Populate the dictionary of property keys
		
		keys[idKey]							= ModelProperties.playSpace_id.rawValue
		keys[relativememberidKey]			= ModelProperties.playSpace_relativeMemberID.rawValue
		keys[playareaidKey]					= ModelProperties.playSpace_playAreaID.rawValue
		keys[playspacetypeKey]				= ModelProperties.playSpace_playSpaceType.rawValue
		keys[playlanguageidKey]				= ModelProperties.playSpace_playLanguageID.rawValue
		keys[coordxKey]						= ModelProperties.playSpace_coordX.rawValue
		keys[coordyKey]						= ModelProperties.playSpace_coordY.rawValue
		
	}
	
	public override var dataType: String {
		get {
			return "PlaySpace"
		}
	}
	
	public override func clone(item: ProtocolModelItem) {
		
		// Validations should not be performed when cloning the item
		let doValidationsYN: 				Bool = self.doValidationsYN
		self.doValidationsYN 				= false
		
		// Copy all properties from the specified item
		if let item = item as? PlaySpace {
			
			self.id							= item.id
			self.relativeMemberID			= item.relativeMemberID
			self.playAreaID					= item.playAreaID
			self.playSpaceType				= item.playSpaceType
			self.playLanguageID				= item.playLanguageID
			self.coordX						= item.coordX
			self.coordY						= item.coordY
	
		}
		
		self.doValidationsYN = doValidationsYN
	}
		
	public override func copyToWrapper() -> DataJSONWrapper {
		
		let result: 	DataJSONWrapper = DataJSONWrapper()

		result.ID 		= self.id

		result.setParameterValue(key: "\(PlaySpaceDataParameterKeys.RelativeMemberID)", value: self.relativeMemberID)
		result.setParameterValue(key: "\(PlaySpaceDataParameterKeys.PlayAreaID)", value: self.playAreaID)
		result.setParameterValue(key: "\(PlaySpaceDataParameterKeys.PlaySpaceType)", value: "\(self.playSpaceType)")
		result.setParameterValue(key: "\(PlaySpaceDataParameterKeys.PlayLanguageID)", value: "\(self.playLanguageID)")
		result.setParameterValue(key: "\(PlaySpaceDataParameterKeys.CoordX)", value: "\(self.coordX)")
		result.setParameterValue(key: "\(PlaySpaceDataParameterKeys.CoordY)", value: "\(self.coordY)")
		
		return result
	}
	
	public override func copyFromWrapper(dataWrapper: DataJSONWrapper, fromDateFormatter: DateFormatter) {
		
		// Validations should not be performed when copying the item
		let doValidationsYN: 			Bool = self.doValidationsYN
		self.doValidationsYN 			= false
		
		// Copy all properties
		self.id 						= dataWrapper.ID
		self.relativeMemberID 			= dataWrapper.getParameterValue(key: "\(PlaySpaceDataParameterKeys.RelativeMemberID)")!
		self.playAreaID 				= dataWrapper.getParameterValue(key: "\(PlaySpaceDataParameterKeys.PlayAreaID)")!
		self.playSpaceType 				= Int(dataWrapper.getParameterValue(key: "\(PlaySpaceDataParameterKeys.PlaySpaceType)")!)!
		self.playLanguageID 			= Int(dataWrapper.getParameterValue(key: "\(PlaySpaceDataParameterKeys.PlayLanguageID)")!) ?? 0
		self.coordX 					= Int(dataWrapper.getParameterValue(key: "\(PlaySpaceDataParameterKeys.CoordX)")!) ?? 0
		self.coordY 					= Int(dataWrapper.getParameterValue(key: "\(PlaySpaceDataParameterKeys.CoordY)")!) ?? 0
		
		self.doValidationsYN 			= doValidationsYN
	}
	
	public override func isValid(propertyEnum: Int, value: String) -> ValidationResultTypes {
		
		let result: ValidationResultTypes = ValidationResultTypes.passed
		
		// Perform validations for the specified property
		//		switch toProperty(propertyEnum: propertyEnum) {
		//		case .artworkComment_postedByName:
		//			result = self.isValidPostedByName(value: value)
		//			break
		//
		//		default:
		//			break
		//		}
		
		return result
	}
	
	
	// MARK: - Private Methods
	
	fileprivate func toProperty(propertyEnum: Int) -> ModelProperties {
		
		return ModelProperties(rawValue: propertyEnum)!
	}
	
	
	// MARK: - Validations
	
}
