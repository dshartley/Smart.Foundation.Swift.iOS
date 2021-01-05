//
//  DateHelper.swift
//  SFCore
//
//  Created by David on 28/02/2018.
//  Copyright © 2018 com.smartfoundation. All rights reserved.
//

import UIKit

/// A helper for handling Dates
public struct DateHelper {
	
	/// Get date to unixTimestamp
	///
	/// - Parameter date: The date
	public static func toUnixTimestamp(date: Date) -> Double {

		let ti: TimeInterval = date.timeIntervalSince1970
		
		return ti
	}

	/// Get date from unixTimestamp
	///
	/// - Parameter unixTimestamp: The unixTimestamp
	public static func fromUnixTimestamp(unixTimestamp: Double) -> Date {

		let d: Date = Date(timeIntervalSince1970: unixTimestamp)
		
		return d
	}
	
	public static func getTimestamp() -> String {
		
		let result: String?
		
		// Get dateFormatter
		let dateFormatter:			DateFormatter = DateFormatter()
		dateFormatter.timeZone 		= TimeZone(secondsFromGMT: 0)
		
		// "dd-MM-yyyy HH:mm:ss a"
		dateFormatter.dateFormat	= "dd-MM-yyyy HH:mm:ss a"
		result 						= dateFormatter.string(from: Date())
		
		return result!
		
	}

	public static func getDate(fromString dateString: String, fromDateFormatter: DateFormatter) -> Date {
		
		var result: 				Date? = nil
		
		// Use the specified fromDateFormatter
		result 						= fromDateFormatter.date(from: dateString)
		
		if (result != nil) { return result! }
		
		
		// Get dateFormatter
		let dateFormatter:			DateFormatter = DateFormatter()
		dateFormatter.timeZone 		= TimeZone(secondsFromGMT: 0)
		
		// "dd-MM-yyyy HH:mm:ss a"
		dateFormatter.dateFormat	= "dd-MM-yyyy HH:mm:ss a"
		result 						= dateFormatter.date(from: dateString)
		
		if (result != nil) { return result! }
		
		// "dd-MM-yyyy HH:mm:ss"
		dateFormatter.dateFormat	= "dd-MM-yyyy HH:mm:ss"
		result 						= dateFormatter.date(from: dateString)
		
		if (result != nil) { return result! }
		
		// "dd-MM-yyyy HH:mm"
		dateFormatter.dateFormat	= "dd-MM-yyyy HH:mm"
		result 						= dateFormatter.date(from: dateString)
		
		if (result != nil) { return result! }
		
		// "dd-MM-yyyy"
		dateFormatter.dateFormat	= "dd-MM-yyyy"
		result 						= dateFormatter.date(from: dateString)
		
		if (result != nil) { return result! }
		
		// "dd MMM ''yy"
		dateFormatter.dateFormat	= "dd MMM ''yy"
		result 						= dateFormatter.date(from: dateString)
		
		if (result != nil) { return result! }
		
		return Date()
		
	}

}
