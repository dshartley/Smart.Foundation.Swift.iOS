//
//  RESTApiHelper.swift
//  SFNet
//
//  Created by David on 22/02/2018.
//  Copyright © 2018 com.smartfoundation. All rights reserved.
//

import UIKit
import SFSerialization

public enum RESTApiHelperMode {
	case Delegate
	case CompletionHandler
}

/// A helper for handling REST Api calls
public class RESTApiHelper: NSObject {

	var processResponse:	((NSMutableData?, URLResponse?, Error?) -> Void)
	var mode:				RESTApiHelperMode = RESTApiHelperMode.CompletionHandler
	
	// MARK: - Initializers
	
	public required init(processResponse:	@escaping ((NSMutableData?, URLResponse?, Error?) -> Void),
						 mode:				RESTApiHelperMode) {
		
		self.processResponse	= processResponse
		self.mode				= mode
	}
	
	
	// MARK: - Public Methods
	
	/// Call a REST Api
	///
	/// - Parameters:
	///   - urlString: The URL
	///   - httpMethod: The httpMethod
	///	  - data: The data
	public func call(urlString: String, httpMethod: HTTPMethods, data: Any?) {
		
		let url						= HTTPHelper.getURL(urlString: urlString)
		let request					= getRequest(url: url, httpMethod: httpMethod, data: data)
		
		var session:				URLSession
		var task:					URLSessionDataTask
		
		if (mode == RESTApiHelperMode.CompletionHandler) {
			
			session					= HTTPHelper.getSession()
			let completionHandler	= getSessionDataTaskCompletionHandler(processResponse: self.processResponse)
			task					= HTTPHelper.getSessionDataTask(session: session, request: request, oncomplete: completionHandler)
			task.resume()
			
		} else if (mode == RESTApiHelperMode.Delegate) {
			
			// Not implemented

		}
	}
	
	
	// MARK: - Private Methods
	
	private func getRequest(url:URL, httpMethod: HTTPMethods, data: Any?) -> URLRequest {
		
		// Create HTTP request
		var request = URLRequest(url: url)
		
		request.addValue("application/json", forHTTPHeaderField: "Content-Type")
		request.httpMethod 		= "\(httpMethod)"
		
		if let s = data as? String {					// Data passed as String
			
			let d: 				Data = s.data(using: .utf8)!
			request.httpBody 	= try? JSONSerialization.data(withJSONObject: d, options: [])
			
		} else if let data = data as? Data {			// Data passed as Data
			
			request.httpBody 	= data
			
		} else if let w = data as? DataJSONWrapper {	// Data passed as DataJSONWrapper
			
			let s: 				String = JSONHelper.SerializeDataJSONWrapper(dataWrapper: w)!
			request.httpBody 	= s.data(using: .utf8)!
			print(s)
			
		} else if data != nil {
			
			request.httpBody 	= try? JSONSerialization.data(withJSONObject: data!, options: [])
			
		}
		
		return request
	}
	
	private func getSessionDataTaskCompletionHandler(processResponse:@escaping ((NSMutableData?, URLResponse?, Error?) -> Void)) -> ((Data?, URLResponse?, Error?) -> Void) {
		
		// Create completion handler
		let completionHandler: ((Data?, URLResponse?, Error?) -> Void) =
		{
			(data, response, error) -> Void in
			
			if (response != nil) {
				
				// Get status code
				let statusCode = (response as! HTTPURLResponse).statusCode
				
				if (statusCode == 200) {
					
					// Get data
					if ((data?.count)! > 0) {
						
						// Get data as NSMutableData
						let mutableData:NSMutableData = NSMutableData()
						mutableData.append(data!)
						
						// Process the data
						processResponse(mutableData, response, error)
						
					} else {
						
						// Data is nil
						processResponse(nil, response, error)
					}
					
//					// Handle error
//					if (error != nil) {
//
//						processResponse(nil, response, error)
//					}
					
				} else {
					
					let error: NSError? = NSError(domain:"", code: statusCode, userInfo: ["HTTPURLResponse.statusCode":statusCode])
					
					// Invalid Status
					processResponse(nil, response, error)
				}
				
			} else {
				// Response is nil
				processResponse(nil, response, error)
			}
		}
		
		return completionHandler
	}
}
