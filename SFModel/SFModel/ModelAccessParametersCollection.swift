//
//  ParametersCollection.swift
//  SFModel
//
//  Created by David on 22/07/2017.
//  Copyright © 2017 com.smartfoundation. All rights reserved.
//

/// Encapsulates a collection of generic model access parameters
public class ModelAccessParametersCollection {
	
	// MARK: - Private Stored Properties
	
	fileprivate var parameters:			[String : ModelAccessParameter]?
	fileprivate var parameterItems:		[Any]?

	
	// MARK: - Initializers
	
	public init() {
		
		self.parameters			= [String : ModelAccessParameter]()
		self.parameterItems		= [Any]()
	}

}

// MARK: - Extension ProtocolParametersCollection

extension ModelAccessParametersCollection: ProtocolParametersCollection {
	
	// MARK: - Public Methods
	
	public func toArray() -> [Any] {
		return self.parameterItems!
	}
	
	public func add(parameterName: String, parameterValue: Any) -> Any {
		
		return self.add(parameterName: parameterName, parameterValue: parameterValue, direction: .inward)
	}
	
	public func add(parameterName: String, parameterValue: Any, direction: ParameterDirections) -> Any {
		
		// Create the parameter
		let parameter: ModelAccessParameter = ModelAccessParameter(name: parameterName, value: parameterValue, direction: direction)
		
		// Add it to the collection
		self.parameters![parameterName] = parameter
		
		// Add to the array of parameter items
		self.parameterItems?.append(parameter)
		
		return parameter
	}
	
	public func get(parameterName: String) -> Any? {
		
		return self.parameters![parameterName]
	}
	
	public func remove(parameterName: String) {
		
		// Remove it from the collection
		if (self.parameters!.keys.contains(parameterName)) {
			self.parameters!.removeValue(forKey: parameterName)
		}
		
		// Remove it from the array of parameter items
		var foundAtIndex: Int = -1
		for (index, parameter) in self.parameterItems!.enumerated() {

			if (parameter as! ModelAccessParameter).name == parameterName { foundAtIndex = index }
		}

		if (foundAtIndex >= 0) { self.parameterItems!.remove(at: foundAtIndex) }
	}

}
