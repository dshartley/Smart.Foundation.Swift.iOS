//
//  ProtocolModelItem.swift
//  SFModel
//
//  Created by David on 22/06/2017.
//  Copyright © 2017 com.smartfoundation. All rights reserved.
//

import SFSerialization

/// Specifies model item status types
public enum ModelItemStatusTypes : Int {
	case new = 1
	case unmodified = 2
	case modified = 3
	case deleted = 4
	case obsolete = 5
}

/// Defines a model item
public protocol ProtocolModelItem {
	
	// MARK: - Properties
	
	/// id
	var id:					String { get set }

	/// previousID
	var previousID:			String { get set }
	
	/// rowNumber
	var rowNumber:			Int { get set }
	
	/// status
	var status:				ModelItemStatusTypes { get set }
	
	/// dataNode
	var dataNode:			[String: Any]? { get set }
	
	/// dataType
	var dataType:			String { get }
	
	/// doSavesYN
	var doSavesYN:			Bool { get set}
	
	/// doValidationsYN
	var doValidationsYN:	Bool { get set }
	
	var collection:			ProtocolModelItemCollection? { get }
	
	
	// MARK: - Methods
	
	/// Adds a delegate
	///
	/// - Parameter delegate: The delegate
	//func add(delegate: ProtocolModelItemDelegate)
	
	/// Validates all the properties of the data item
	///
	func validate()
	
	/// Ends the creation of the data item. Before this it can be undone
	///
	//func endCreate()
	
	/// Removes this data item from the data document
	///
	func remove()
	
	/// Copies the properties of the specified data item
	///
	/// - Parameter item: The item
	func clone(item: ProtocolModelItem)

	/// Copies the data item to the specified wrapper
	///
	/// - Parameter dataWrapper: The dataWrapper
	func copyToWrapper() -> DataJSONWrapper
	
	/// Copies the data item from the specified wrapper
	///
	/// - Parameter:
	///   - dataWrapper: The dataWrapper
	///   - fromDateFormatter: The fromDateFormatter
	func copyFromWrapper(dataWrapper: DataJSONWrapper, fromDateFormatter: DateFormatter)
	
	/// Gets a list of the property enum values
	///
	/// - Returns: The list of property enum values
	func getPropertyEnums() -> [Int]
	
	/// Gets a list of the property keys
	///
	/// - Returns: The list of property keys
	func getPropertyKeys() -> [String]
	
	/// Gets the property of the specified enum value
	///
	/// - Parameter propertyEnum: The propertyEnum
	/// - Returns: The property
	func getProperty(propertyEnum: Int) -> String?
	
	/// Gets the property of the specified enum value
	///
	/// - Parameters:
	///	  - propertyEnum: The propertyEnum
	///	  - toDateFormatter: The toDateFormatter
	/// - Returns: The property
	func getProperty(propertyEnum: Int, toDateFormatter: DateFormatter) -> String?
	
	/// Gets the property of the specified key
	///
	/// - Parameter key: The key
	/// - Returns: The property
	func getProperty(key: String) -> String?
	
	/// Gets the property of the specified key
	///
	/// - Parameters:
	///	  - key: The key
	///	  - toDateFormatter: The toDateFormatter
	/// - Returns: The property
	func getProperty(key: String, toDateFormatter: DateFormatter) -> String?
	
	/// Sets the property
	///
	/// - Parameters:
	///   - propertyEnum: The propertyEnum
	///   - value: The value
	///   - setWhenInvalidYN: If true set the property if invalid
	func setProperty(propertyEnum: Int, value: String, setWhenInvalidYN: Bool)
	
	/// Sets the property
	///
	/// - Parameters:
	///   - propertyEnum: The propertyEnum
	///   - value: The value
	///   - setWhenInvalidYN: If true set the property if invalid
	///	  - fromDateFormatter: The fromDateFormatter
	func setProperty(propertyEnum: Int, value: String, setWhenInvalidYN: Bool, fromDateFormatter: DateFormatter)
	
	/// Sets the property
	///
	/// - Parameters:
	///   - key: The key
	///   - value: The value
	///   - setWhenInvalidYN: If true set the property if invalid
	func setProperty(key: String, value: String, setWhenInvalidYN: Bool)
	
	/// Sets the property
	///
	/// - Parameters:
	///   - key: The key
	///   - value: The value
	///   - setWhenInvalidYN: If true set the property if invalid
	///	  - fromDateFormatter: The fromDateFormatter
	func setProperty(key: String, value: String, setWhenInvalidYN: Bool, fromDateFormatter: DateFormatter)
	
	/// Determines whether the item contains a property with the specified value
	///
	/// - Parameter value: The value
	/// - Returns: Return true if the value exists
	func containsPropertyValue(value: String) -> Bool

	
	// MARK: - Delegate Notifications
	
	/// Occurs when the data item is modified
	///
	/// - Parameters:
	///   - propertyEnum: The propertyEnum
	///   - message: The message
	func onModified(propertyEnum:Int, message: String)
	
	/// Occurs when the status of the data item is changed
	///
	/// - Parameters:
	///   - message: The message
	func onStatusChanged(message: String)
	
	/// Occurs when the primary key of the item is modified
	///
	/// - Parameters:
	///   - previousID: The previousID
	func onPrimaryKeyModified(previousID: String)
	
	
}
