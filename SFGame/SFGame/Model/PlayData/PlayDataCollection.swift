//
//  PlayDataCollection.swift
//  SFGame
//
//  Created by David on 05/02/2018.
//  Copyright © 2018 com.smartfoundation. All rights reserved.
//

import SFModel

/// Encapsulates a collection of PlayData items
public class PlayDataCollection: ModelItemCollectionBase {
	
	// MARK: - Initializers
	
	public override init() {
		super.init()
	}
	
	public override init(modelAdministrator: 	ProtocolModelAdministrator,
						 storageDateFormatter: 	DateFormatter) {
		super.init(modelAdministrator: modelAdministrator,
				   storageDateFormatter: storageDateFormatter)
	}
	
	public override init(dataDocument:			[[String : Any]],
						 modelAdministrator: 	ProtocolModelAdministrator,
						 fromDateFormatter: 	DateFormatter,
						 storageDateFormatter: 	DateFormatter) {
		super.init(dataDocument: dataDocument,
				   modelAdministrator: modelAdministrator,
				   fromDateFormatter: fromDateFormatter,
				   storageDateFormatter: storageDateFormatter)
	}
	
	
	// MARK: - Override Methods
	
	public override var dataType: String {
		get {
			return "PlayData"
		}
	}
	
	public override func getNewItem() -> ProtocolModelItem? {
		
		// Create the new item
		let item: PlayData = PlayData(collection: self,
											  storageDateFormatter: self.storageDateFormatter!)
		
		// Set the ID
		item.id = self.getNextID()
		
		return item
		
	}
	
	public override func getNewItem(dataNode:[String: Any],
									fromDateFormatter: DateFormatter) -> ProtocolModelItem? {
		
		// Create the item
		let item: PlayData = self.getNewItem() as! PlayData
		
		// Go through each property
		for property in dataNode {
			
			// Set the property in the item
			item.setProperty(key: property.key,
							 value: String(describing: property.value),
							 setWhenInvalidYN: false,
							 fromDateFormatter: fromDateFormatter)
		}
		
		return item
	}
	
}
