//
//  DMCollection.swift
//  Smart.Foundation
//
//  Created by David on 20/07/2017.
//  Copyright © 2017 com.smartfoundation. All rights reserved.
//

import SFModel

/// Encapsulates a collection of DM items
public class DMCollection: ModelItemCollectionBase {
	
	// MARK: - Initializers
	
	private override init() {
		super.init()
	}

	public override init(modelAdministrator: ProtocolModelAdministrator) {
		super.init(modelAdministrator: modelAdministrator)
	}
	
	public override init(dataDocument:		[[String : Any]],
						modelAdministrator: ProtocolModelAdministrator) {
		super.init(dataDocument: dataDocument, modelAdministrator: modelAdministrator)
	}
	
	
	// MARK: - Override Methods
	
	public override var dataType: String {
		get {
			return "DM"
		}
	}
	
	public override func getNewItem() -> ProtocolModelItem? {
		
		// Create the new item
		let item: DM = DM(collection: self)
		
		// Set the ID
		item.id = self.getNextID()
		
		return item
		
	}
	
	open override func getNewItem(dataNode:[String: Any]) -> ProtocolModelItem? {
		
		// Create the item
		let item: DM = self.getNewItem() as! DM
		
		// Go through each property
		for property in dataNode {
			
			// Set the property in the item
			item.setProperty(key: property.key, value: String(describing: property.value), setWhenInvalidYN: false)
		}
		
		return item
	}
	
}
