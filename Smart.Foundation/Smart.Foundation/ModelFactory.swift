//
//  ModelFactory.swift
//  Smart.Foundation
//
//  Created by David on 20/07/2017.
//  Copyright © 2017 com.smartfoundation. All rights reserved.
//

import SFModel

/// Creates model administrators
public class ModelFactory {
	
	// MARK: - Initializers
	
	private init() {
		
	}
	
	
	// MARK: - Public Class Methods
	
	fileprivate static var _modelManager: ModelManager?
	
	public class var modelManager: ModelManager {
		get {
			if (_modelManager == nil) {
				_modelManager = ModelManager()
			}
			
			return _modelManager!
		}
	}
	
	
	// MARK: - DM
	
	public class var getDMModelAdministrator: DMModelAdministrator {
		get {
			if (self.modelManager.getDMModelAdministrator == nil) {
				self.setupDMModelAdministrator(modelManager: self.modelManager)
			}
			
			return self.modelManager.getDMModelAdministrator!
		}
	}
	
	public class func setupDMModelAdministrator(modelManager: ModelManager) {
		
		// Connection string
		let connectionString: String = ""
		
		// Create model access strategy
		//let modelAccessStrategy: ProtocolModelAccessStrategy = DMDummyModelAccessStrategy(connectionString: connectionString)
		
		let modelAccessStrategy: ProtocolModelAccessStrategy = DMFirebaseModelAccessStrategy(connectionString: connectionString)
		
		modelManager.setupDMModelAdministrator(modelAccessStrategy: modelAccessStrategy)
	}
	
}
