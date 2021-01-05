//
//  JSONHelper.swift
//  SFSerialization
//
//  Created by David on 15/06/2017.
//  Copyright © 2017 com.smartfoundation. All rights reserved.
//

import Foundation

/// A helper for handling JSON data
public struct JSONHelper {
	
	// MARK: - Public Static Methods
	
//	public static func Serialize(item: Encodable?) -> String? {
//		
//		// Create encoder
//		let encoder: 	JSONEncoder = JSONEncoder()
//		encoder.outputFormatting = .prettyPrinted
//		
//		// Convert to data
//		let data: 		Data = try! encoder.encode(item)
//		
//		// Convert to string
//		let result: 	String = String(data: data, encoding: .utf8)!
//		
//		return result
//		
//	}
//	
//	public static func Deserialize(dataString: String) -> Decodable? {
//		
//		// Create decoder
//		let decoder: 	JSONDecoder = JSONDecoder()
//		
//		// Convert to data
//		let data: 		Data = dataString.data(using: .utf8)!
//		
//		// Convert to object
//		let result: 	Decodable? = try! decoder.decode(type, from: data)
//		
//		return result
//		
//	}
	
	public static func SerializeDataJSONWrapper(dataWrapper: DataJSONWrapper) -> String? {
		
		// Convert to data
		let data: 		Data = self.SerializeDataJSONWrapper(dataWrapper: dataWrapper)!

		// Convert to string
		let result: 	String = String(data: data, encoding: .utf8)!
		
		return result
		
	}

	public static func SerializeDataJSONWrapper(dataWrapper: DataJSONWrapper) -> Data? {
		
		// Create encoder
		let encoder: 	JSONEncoder = JSONEncoder()
		encoder.outputFormatting = .prettyPrinted
		
		// Convert to data
		let result: 	Data = try! encoder.encode(dataWrapper)

		return result
		
	}
	
	public static func DeserializeDataJSONWrapper(data: Data) -> DataJSONWrapper? {
		
		// Create decoder
		let decoder: 			JSONDecoder = JSONDecoder()
		
		// Convert to object
		var result: 			DataJSONWrapper? = nil
		
		do {
			
			// Decode data to wrapper
			result = try decoder.decode(DataJSONWrapper.self, from: data)
			
		} catch {
			
			// Convert data to string
			let dataString: 	String = String(data: data, encoding: .utf8) ?? ""
			
			// Put the string in the wrapper
			result = DataJSONWrapper()
			
			result!.setParameterValue(key: "Data", value: dataString)
			
		}
		
		return result
		
	}
	
	public static func DeserializeDataJSONWrapper(dataString: String) -> DataJSONWrapper? {
		
		// Convert to data
		let data: 		Data = dataString.data(using: .utf8)!
		
		return self.DeserializeDataJSONWrapper(data: data)
		
	}

	public static func DeserializeDataJSONWrapper(json: [String: Any]) -> DataJSONWrapper? {
		
		// Convert to data
		let data: 		Data = JSONHelper.JSONToData(json: json)!
		
		return self.DeserializeDataJSONWrapper(data: data)
		
	}
	
	/// Get JSON Data as JSON Dictionary
	///
	/// - Parameter data:	JSON Data
	/// - Returns:			JSON Dictionary
	public static func dataToJSON(data: Data) -> Any? {
		
		// Convert to JSON
		let result: Any? = try? JSONSerialization.jsonObject(with: data)

		return result
	}
	
	/// Get JSON Dictionary as JSON Data
	///
	/// - Parameter json:	JSON Dictionary
	/// - Returns:			JSON Data
	public static func JSONToData(json: [String: Any]) -> Data? {
		
		// Convert to Data
		guard let result: Data = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted) else {
			return nil
		}
		
		return result
	}
	
	/// Get JSON Dictionary as JSON String
	///
	/// - Parameter json:	JSON Dictionary
	/// - Returns:			JSON String
	public static func JSONToString(json: [String: Any]) -> String? {
		
		// Convert to Data
		guard let data: Data = JSONToData(json: json) else {
			return nil
		}
		
		// Convert to string
		let result	= String(data: data, encoding: .utf8)!
		
		return result
	}
	
	/// Get JSON String as JSON Dictionary
	///
	/// - Parameter jsonString:	JSON String
	/// - Returns:				JSON Dictionary
	public static func stringToJSON(jsonString:String) -> Any? {
		
		// Convert to Data
		guard let data: Data = jsonString.data(using: .utf8) else {
			return nil
		}
		
		// Convert to JSON
		let result: Any? = dataToJSON(data: data)
		
		return result
	}

	
	/// Get XML String as JSON Dictionary
	///
	/// - Parameter xmlString:	XML String
	/// - Returns:				JSON Dictionary
	public static func xmlToJSON(xmlString:String) -> [String: Any]? {

		let dic = try? XMLReader.dictionary(forXMLString: xmlString)
		
		let json = try? JSONSerialization.data(withJSONObject: dic! as [AnyHashable : Any], options: .prettyPrinted)
		
		let resDic = try? JSONSerialization.jsonObject(with: json!, options: .allowFragments)

		
		return resDic as? [String : Any]
	}
	
}
