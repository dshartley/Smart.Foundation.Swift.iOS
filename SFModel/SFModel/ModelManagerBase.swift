//
//  ModelManagerBase.swift
//  SFModel
//
//  Created by David on 08/08/2017.
//  Copyright © 2017 com.smartfoundation. All rights reserved.
//

/// A base class for classes which manage the model layer and provide access to the model administrators
open class ModelManagerBase {

	// MARK: - Public Stored Properties
	
	public var modelAdministrators:		[String : ProtocolModelAdministrator] = [String : ProtocolModelAdministrator]()
	
	// Culture information formatters used to define how data is stored and how data is output
	public var storageDateFormatter:	DateFormatter?
	
	
	// MARK: - Initializers
	
	public init() {
		
	}
	
	public init(storageDateFormatter: DateFormatter) {
		
		self.storageDateFormatter = storageDateFormatter
		
	}
	
}

// MARK: - Extension ProtocolModelAdministratorProvider

extension ModelManagerBase: ProtocolModelAdministratorProvider {
	
	// MARK: - Public Methods
	
	public func getModelAdministrator(key: String) -> ProtocolModelAdministrator? {
		
		if (self.modelAdministrators.keys.contains(key)) {
			
			return self.modelAdministrators[key]
			
		} else {
			
			return nil
		}
	}
	
}
