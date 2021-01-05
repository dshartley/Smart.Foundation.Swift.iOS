//
//  DMModelAdministrator.swift
//  Smart.Foundation
//
//  Created by David on 20/07/2017.
//  Copyright © 2017 com.smartfoundation. All rights reserved.
//

import SFModel

/// Manages DM data
public class DMModelAdministrator: ModelAdministratorBase {
	
	// MARK: - Initializers
	
	private override init() {
		super.init()
	}
	
	public override init(modelAccessStrategy:			ProtocolModelAccessStrategy,
	                     modelAdministratorProvider:	ProtocolModelAdministratorProvider) {
		super.init(modelAccessStrategy: modelAccessStrategy, modelAdministratorProvider: modelAdministratorProvider)
	}
	
	
	// MARK: - Public Methods
	
	public func selectByNumericValue(numericValue: Int, oncomplete completionHandler:@escaping ([Any]?, Error?) -> Void) {
		
		self.setupCollection()
		
		// Create completion handler
		let doLoadDataTablesCompletionHandler: ((Error?) -> Void) =
		{
			(error) -> Void in
			
			self.doAfterLoad()
			
			// Call the completion handler
			completionHandler(self.collection!.dataDocument, nil)
		}
		
		// Create completion handler
		let selectByNumericValueCompletionHandler: (([Any]?, ProtocolModelItemCollection?, Error?) -> Void) =
		{
			(data, collection, error) -> Void in

			// Load any additional data tables
			self.doLoadDataTables(data: data!, oncomplete: doLoadDataTablesCompletionHandler)
		}
		
		// Load the data
		(self.modelAccessStrategy as! ProtocolDMModelAccessStrategy).selectByNumericValue(collection: self.collection!, numericValue: numericValue, oncomplete: selectByNumericValueCompletionHandler)
		
	}

	
	// MARK: - Override Methods
	
	public override func newCollection() -> ProtocolModelItemCollection? {
		
		return DMCollection(modelAdministrator: self)
	}

	public override func setupForeignKeys() {

		// No foreign keys
	}
	
	
	// MARK: - Private Methods
	
	fileprivate func doLoadDataTables(data: [Any], oncomplete completionHandler:@escaping (Error?) -> Void) {
	
		// Fill the [ForeignKeyItem] collection
		if (data.count >= 2) {
			let fkiModelAdministrator: ProtocolModelAdministrator = self.modelAdministratorProvider!.getModelAdministrator(key: "ForeignKeyTable")!
			
			//if (fkiModelAdministrator != nil) {
			fkiModelAdministrator.load(data: [data[0]], oncomplete: completionHandler)
			//}
		}
	}
	
}
