//
//  HTTPHelper.swift
//  SFNet
//
//  Created by David on 18/11/2017.
//  Copyright © 2017 com.smartfoundation. All rights reserved.
//

public enum HTTPMethods {
	case GET
	case POST
	case PUT
	case DELETE
}

/// A helper for handling HTTP requests
public class HTTPHelper {

	// MARK: - Initializers
	
	private init () {}
	
	
	// MARK: - Class Methods
	
	public class func getURL(urlString:String) -> URL {
		
		// Create URL
		let url = URL(string: urlString)
		
		return url!
	}
	
	public class func getSession() -> URLSession {
		
		let session = URLSession.shared
		
		return session
	}
	
	public class func getSession(request:URLRequest, delegate:URLSessionDelegate) -> URLSession {
		
		let session = URLSession(configuration: URLSessionConfiguration.default, delegate: delegate, delegateQueue: nil)
		
		return session
	}
	
	public class func getSessionDataTask(session:URLSession, request:URLRequest) -> URLSessionDataTask {
		
		let task = session.dataTask(with: request)
		
		return task
	}
	
	public class func getSessionDataTask(session:URLSession, request:URLRequest, oncomplete completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
		
		let task = session.dataTask(with: request, completionHandler: completionHandler)
		
		return task
	}
	
	public class func loadData(fromURL url: URL, oncomplete completionHandler:@escaping (Data?, Error?) -> Void) {
		
		let session:	URLSession			= URLSession.shared
		let request:	URLRequest			= URLRequest(url: url)
		
		let task:		URLSessionDataTask	= session.dataTask(with: request, completionHandler: {(data: Data?, response: URLResponse?, error: Error?) -> Void in
			
			// Call completion handler
			completionHandler(data, error)
			
		})
		
		task.resume()
	}
	
	public class func loadImageDataFromUrl(fileName: String, urlRoot: String, oncomplete completionHandler:@escaping (Bool, Data?) -> Void) {
		
		let url:		URL					= URL(string: urlRoot + fileName)!
		let session:	URLSession			= URLSession.shared
		let request:	URLRequest			= URLRequest(url: url)
		
		let task:		URLSessionDataTask	= session.dataTask(with: request, completionHandler: {(data: Data?, response: URLResponse?, error: Error?) -> Void in
			
			if let data = data {
				
				let isCachedYN: Bool = false
				
				// Call completion handler
				completionHandler(isCachedYN, data)
			}
			
		})
		
		task.resume()
	}
	
}
