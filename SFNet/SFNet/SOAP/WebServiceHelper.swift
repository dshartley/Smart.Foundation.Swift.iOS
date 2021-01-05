//
//  WebServiceHelper.swift
//  SFNet
//
//  Created by David on 20/06/2017.
//  Copyright © 2017 com.smartfoundation. All rights reserved.
//

import UIKit

public enum WebServiceHelperMode {
	case Delegate
	case CompletionHandler
}

/// A helper for handling web services
public class WebServiceHelper : NSObject {

	var processResponse:	((NSMutableData?, Error?) -> Void)
	var mode:				WebServiceHelperMode = WebServiceHelperMode.CompletionHandler
	
	// MARK: - Initializers
	
	public required init(processResponse:	@escaping ((NSMutableData?, Error?) -> Void),
						mode:				WebServiceHelperMode) {
		
		self.processResponse	= processResponse
		self.mode				= mode
	}
	
	
	// MARK: - Public Methods
	
	/// Call a web service
	///
	/// - Parameters:
	///   - urlString: The URL
	///   - soapMessage: The SOAP message
	public func call(urlString: String, soapMessage: String) {
		
		let url						= HTTPHelper.getURL(urlString: urlString)
		let request					= getRequest(soapMessage: soapMessage, url: url)
		
		var session:	URLSession
		var task:		URLSessionDataTask
		
		if (mode == WebServiceHelperMode.CompletionHandler) {
			
			session					= HTTPHelper.getSession()
			let completionHandler	= getSessionDataTaskCompletionHandler(processResponse: processResponse)
			task					= HTTPHelper.getSessionDataTask(session: session, request: request, oncomplete: completionHandler)
			task.resume()
			
		} else if (mode == WebServiceHelperMode.Delegate) {
			
			session					= HTTPHelper.getSession(request: request, delegate: self)
			task					= HTTPHelper.getSessionDataTask(session: session, request: request)
			task.resume()
		}
	}
	
	
	// MARK: - Private Methods
	
	private func getRequest(soapMessage:String, url:URL) -> URLRequest {
		
		// Create HTTP request
		let request			= NSMutableURLRequest(url: url)
		let contentLength	= soapMessage.count
		
		request.addValue("application/soap+xml; charset=utf-8", forHTTPHeaderField: "Content-Type")
		request.addValue(String(contentLength), forHTTPHeaderField: "Content-Length")
		request.httpMethod	= "POST"
		request.httpBody	= soapMessage.data(using: String.Encoding.utf8, allowLossyConversion: false)
		
		return request as URLRequest
	}
	
	private func getSessionDataTaskCompletionHandler(processResponse:@escaping ((NSMutableData?, Error?) -> Void)) -> ((Data?, URLResponse?, Error?) -> Void) {
		
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
						processResponse(mutableData, error)
						
					} else {
						
						// Data is nil
						processResponse(nil, error)
					}
					
					// Handle error
					if (error != nil) {
						
						processResponse(nil, error)
					}
					
				} else {
					// Invalid Status
					processResponse(nil, error)
				}
				
			} else {
				// Response is nil
				processResponse(nil, error)
			}
		}
		
		return completionHandler
	}
	
}

// MARK: - Extension URLSessionTaskDelegate

extension WebServiceHelper: URLSessionTaskDelegate {
	
	// 1
	public func urlSession(_ session: URLSession, task: URLSessionTask, didSendBodyData bytesSent: Int64, totalBytesSent: Int64, totalBytesExpectedToSend: Int64) {
		// TODO:
	}
	
	// 3
	public func urlSession(_ session: URLSession, task: URLSessionTask, didFinishCollecting metrics: URLSessionTaskMetrics) {
		// TODO:
	}
	
	// 4
	public func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
		
		if (error != nil) {
			print(error.debugDescription)
		}
	}
	
	public func urlSession(_ session: URLSession, task: URLSessionTask, needNewBodyStream completionHandler: @escaping (InputStream?) -> Void) {
		// TODO:
	}
	
	public func urlSession(_ session: URLSession, task: URLSessionTask, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
		// TODO:
	}
	
	public func urlSession(_ session: URLSession, task: URLSessionTask, willPerformHTTPRedirection response: HTTPURLResponse, newRequest request: URLRequest, completionHandler: @escaping (URLRequest?) -> Void) {
		// TODO:
	}
}

// MARK: - Extension URLSessionDataDelegate

extension WebServiceHelper: URLSessionDataDelegate {
	
	// 2
	public func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
		
		// Get data
		if ((data.count) > 0) {
			
			// Get data as NSMutableData
			let mutableData:NSMutableData = NSMutableData()
			mutableData.append(data)
			
			// Process the data
			processResponse(mutableData, nil)
		}
	}
	
}
