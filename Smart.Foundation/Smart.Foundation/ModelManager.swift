//
//  ModelManager.swift
//  Smart.Foundation
//
//  Created by David on 20/07/2017.
//  Copyright © 2017 com.smartfoundation. All rights reserved.
//

import SFModel

/// Manages the model layer and provides access to the model administrators
public class ModelManager: ModelManagerBase {

	// MARK: - Initializers

	public override init() {
		super.init()
	}

	
	// MARK: - Public Methods

	fileprivate var _dmModelAdministrator: DMModelAdministrator?
	
	public func setupDMModelAdministrator(modelAccessStrategy: ProtocolModelAccessStrategy) {
	
		if (self.modelAdministrators.keys.contains("DMs")) { self.modelAdministrators.removeValue(forKey: "DMs") }
		
		self._dmModelAdministrator = DMModelAdministrator(modelAccessStrategy: modelAccessStrategy, modelAdministratorProvider: self)
		
		self.modelAdministrators["DMs"] = self._dmModelAdministrator
	}
	
	public var getDMModelAdministrator: DMModelAdministrator? {
		get {
			return self._dmModelAdministrator
		}
	}

}

