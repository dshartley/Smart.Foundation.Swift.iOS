//
//  DataJSONWrapper.swift
//  SFSerialization
//
//  Created by David on 01/03/2018.
//  Copyright © 2018 com.smartfoundation. All rights reserved.
//

import UIKit

public class DataJSONWrapper: Codable {

	// MARK: - Private Stored Properties
	
	
	// MARK: - Public Stored Properties
	
	public var 	ID: String = ""
	public var 	Items: [DataJSONWrapper] = [DataJSONWrapper]()
	public var 	Params: [ParameterJSONWrapper] = [ParameterJSONWrapper]()
	
	
	// MARK: - Initializers
	
	public init() {
		
	}
	
	
	// MARK: - Public Methods
	
	public func hasParameterYN(key: String) -> Bool {
		
		var result: Bool = false
		
		// Go through each parameter
		for parameter in self.Params {
			
			if (parameter.Key.lowercased() == key.lowercased()) {
				
				result = true

			}
			
			
		}
		
		return result
	}
	
	public func getParameterValue(key: String) -> String? {
		
		var result: String? = nil
		
		// Go through each parameter
		for parameter in self.Params {
			
			if (parameter.Key.lowercased() == key.lowercased()) {
				
				result = parameter.Value
				
			}
			
		}
		
		return result
	}
	
	public func setParameterValue(key: String, value: String) {
		
		var p: ParameterJSONWrapper? = nil
		
		// Go through each parameter
		for parameter in self.Params {
			
			if (parameter.Key.lowercased() == key.lowercased()) {
				
				p = parameter
				
			}
			
		}
		
		// If the parameter was not found then create it
		if (p == nil) {
			
			p = ParameterJSONWrapper(key: key, value: value)
			self.Params.append(p!)
			
		} else {
			
			p!.Value = value
			
		}
		
	}
	
	public func deleteParameterValue(key: String) {
		
		var p: 	ParameterJSONWrapper? = nil
		var i: 	Int = -1
		
		// Go through each parameter
		for (index, parameter) in self.Params.enumerated() {
			
			if (parameter.Key.lowercased() == key.lowercased()) {
				
				p = parameter
				i = index
				
			}
			
		}
		
		// If the parameter was found then remove it
		if (p != nil) {
			
			self.Params.remove(at: i)
			
		}
			
	}
	
	public func getItem(id: String) -> DataJSONWrapper? {
	
		var result: DataJSONWrapper? = nil
		
		// Go through each item
		for item in self.Items {
		
			if (item.ID == id) {
			
				result = item
				
			}
			
		}
		
		return result
		
	}
	
	public func deleteItem(id: String) {
		
		// Get index
		let index: Int? = self.Items.index(where: { $0.ID == id })
		
		guard (index != nil) else { return }
		
		self.Items.remove(at: index!)
		
	}

	public func deleteItem(item: DataJSONWrapper) {
		
		// Get index
		let index: Int? = self.Items.index(where: { $0 === item })
		
		guard (index != nil) else { return }
		
		self.Items.remove(at: index!)
		
	}
	
}
