//
//  WebSocketsClientStrategyBase.swift
//  SFNet
//
//  Created by David on 12/04/2018.
//  Copyright © 2018 com.smartfoundation. All rights reserved.
//

import SFSerialization

/// A base class for WebSocketsClient strategy classes
open class WebSocketsClientStrategyBase {

    // MARK: - Public Stored Properties
    
    public weak var delegate:					ProtocolWebSocketsClientStrategyDelegate?
	public var webSocket: 						Any?
	
	
	// MARK: - Private Stored Properties

	
    // MARK: - ProtocolWebSocketsClientStrategy Public Stored Properties
	
    public fileprivate(set) var webSocketID:    String?
    public fileprivate(set) var urlString:      String?
	public fileprivate(set) var properties:		[String:String]? = [String:String]()
	public var isWebSocketSetupYN:				Bool = false
	public var isConnectedYN:					Bool = false
	public var isAwaitingConnectYN:				Bool = false
	public var isAwaitingDisconnectYN:			Bool = false
	public var attemptReconnectYN:				Bool = true		// The socket needs to be reconnected unless it is disconnected intentionally
	public var connectCompletionHandler: 		((WebSocketsClientResultCode) -> Void)?
	public var disconnectCompletionHandler: 	((WebSocketsClientResultCode) -> Void)?
	public var reconnectCompletionHandler: 		((WebSocketsClientResultCode) -> Void)?
	
    
    // MARK: - Initializers
    
    public init() {
		
    }

    public init(urlString: String) {
		
        self.urlString = urlString
		
    }

	
	deinit {
		
		self.dispose()
		
	}
	
    
    // MARK: - Public Methods
	

    // MARK: - Open [Overridable] Methods
	
	open func dispose() {
		
		self.delegate 						= nil
		self.connectCompletionHandler 		= nil
		self.reconnectCompletionHandler 	= nil
		self.disconnectCompletionHandler 	= nil
		
	}
	
	open func isDuplicate(of: ProtocolWebSocketsClientStrategy) -> Bool {
		
		// Not implemented
		
		return false
		
	}
	
	open func setupWebSocket() {
		
		// Override
		
	}
		
	open var getWebSocket: Any? {
		get {
			// Override
			return nil
		}
	}
	
	open func doConnect() -> WebSocketsClientResultCode {
		
		// Override
		return WebSocketsClientResultCode.NotImplemented
		
	}
	
	open func doDisconnect() -> WebSocketsClientResultCode {
		
		// Override
		return WebSocketsClientResultCode.NotImplemented
		
	}
	
	open func doSend(messageString: String) -> WebSocketsClientResultCode {
		
		// Override
		return WebSocketsClientResultCode.NotImplemented
		
	}
	
	open func doError() {
		
	}
	
    open func connect(oncomplete completionHandler:@escaping (WebSocketsClientResultCode) -> Void) {

		if (self.webSocket == nil || !self.isWebSocketSetupYN) {

			self.setupWebSocket()
			
		}
		
		// Check webSocket
		guard (self.webSocket != nil) else {
			
			// Call completion handler
			completionHandler(WebSocketsClientResultCode.Error)
			return
		}
		
		// Check not isAwaitingConnectYN
		guard (!self.isAwaitingConnectYN) else {
			
			// Call completion handler
			completionHandler(WebSocketsClientResultCode.ErrorAlreadyAwaitingConnect)
			return
		}
		
		// Set completion handler
		self.connectCompletionHandler 	= completionHandler
		
		self.isAwaitingDisconnectYN 	= false
		self.isAwaitingConnectYN 		= true
		
		// Connect
		let result: WebSocketsClientResultCode = self.doConnect()
		
		if (result != .AwaitingResult) {
			
			// Call completion handler
			completionHandler(result)

		}
		
    }
    
	open func connect() -> WebSocketsClientResultCode {
		
		if (self.webSocket == nil || !self.isWebSocketSetupYN) {
			
			self.setupWebSocket()
			
		}
		
		// Check webSocket
		guard (self.webSocket != nil) else { return WebSocketsClientResultCode.Error }
		
		// Check not isAwaitingConnectYN
		guard (!self.isAwaitingConnectYN) else { return WebSocketsClientResultCode.ErrorAlreadyAwaitingConnect }
		
		self.isAwaitingDisconnectYN 	= false
		self.isAwaitingConnectYN 		= true
		
		// Connect
		let result: WebSocketsClientResultCode = self.doConnect()
		
		return result
		
	}
    
    open func disconnect(oncomplete completionHandler:@escaping (WebSocketsClientResultCode) -> Void) {
		
		guard (self.webSocket != nil) else {
			
			// Call completion handler
			completionHandler(WebSocketsClientResultCode.Error)
			return
		}
		
		// Check not isAwaitingDisconnectYN
		guard (!self.isAwaitingDisconnectYN) else {
			
			// Call completion handler
			completionHandler(WebSocketsClientResultCode.ErrorAlreadyAwaitingDisconnect)
			return
		}
		
		// Set completion handlers
		self.disconnectCompletionHandler 	= completionHandler
		self.connectCompletionHandler 		= nil
		self.reconnectCompletionHandler 	= nil
		
		self.isAwaitingDisconnectYN 		= true
		self.isAwaitingConnectYN 			= false
		self.attemptReconnectYN 			= false		// Don't attempt to reconnect if intentionally disconnected
		
		// Disconnect
		let result: WebSocketsClientResultCode = self.doDisconnect()
		
		if (result != .AwaitingResult) {
			
			// Call completion handler
			completionHandler(result)
			
		}
		
    }
    
    open func disconnect() -> WebSocketsClientResultCode {
        
		guard (self.webSocket != nil) else { return WebSocketsClientResultCode.Error }
		
		// Check not isAwaitingDisconnectYN
		guard (!self.isAwaitingDisconnectYN) else { return WebSocketsClientResultCode.ErrorAlreadyAwaitingDisconnect }
		
		// Set completion handlers
		self.disconnectCompletionHandler 	= nil
		self.connectCompletionHandler 		= nil
		self.reconnectCompletionHandler 	= nil
		
		self.isAwaitingDisconnectYN 		= true
		self.isAwaitingConnectYN 			= false
		self.attemptReconnectYN 			= false		// Don't attempt to reconnect if intentionally disconnected
		
		// Disconnect
		let result: WebSocketsClientResultCode = self.doDisconnect()
		
		return result
		
    }
    
    open func send(message: WebSocketsMessageWrapper) -> WebSocketsClientResultCode {
		
		guard (self.webSocket != nil) else { return WebSocketsClientResultCode.Error }
		
		// Create completion handler
		let reconnectCompletionHandler: ((WebSocketsClientResultCode) -> Void) =
		{
			[weak self] (result) -> Void in
			
			let _: WebSocketsClientResultCode? = self?.send(message: message)
		}
		self.reconnectCompletionHandler = reconnectCompletionHandler
		
		// Attempt to reconnect if required
		if (!self.isConnectedYN && self.attemptReconnectYN) {
			
			let _: WebSocketsClientResultCode = self.connect()
			
			return WebSocketsClientResultCode.ErrorAwaitingReconnect
		}
		
		// Get messageString
		let messageString: String = message.toString()
		
		guard (messageString.count > 0) else { return WebSocketsClientResultCode.Error }
		
		// Send
		let result: WebSocketsClientResultCode = self.doSend(messageString: messageString)

		return result
		
    }
    
    open func processMessage(messageString: String) -> WebSocketsMessageWrapper {

        let result:         WebSocketsMessageWrapper = WebSocketsMessageWrapper()
        
        // Get dataWrapper
        let dataWrapper:    DataJSONWrapper? = JSONHelper.DeserializeDataJSONWrapper(dataString: messageString)
        
        guard (dataWrapper != nil) else { return result }
        
        // Copy from the DataJSONWrapper
        result.copyFromWrapper(wrapper: dataWrapper!)
        
        return result
        
    }
	
	open func didConnect() {
		
		self.isAwaitingConnectYN 			= false
		self.isConnectedYN 					= true
		self.attemptReconnectYN				= true		// The socket needs to be reconnected unless it is disconnected intentionally
		
		// Call completion handler
		if (self.reconnectCompletionHandler != nil) {
			
			self.reconnectCompletionHandler?(WebSocketsClientResultCode.DidConnect)
			
		} else {
			
			self.connectCompletionHandler?(WebSocketsClientResultCode.DidConnect)

		}
		
		// Dispose the completion handlers
		self.reconnectCompletionHandler 	= nil
		self.connectCompletionHandler 		= nil
		
		// Notify the delegate
		self.delegate?.webSocketsClientStrategy(didConnect: self.webSocketID!, error: nil, sender: self)
		
	}

	open func didDisconnect() {
		
		self.isAwaitingDisconnectYN 		= false
		self.isConnectedYN 					= false
		
		// Call completion handler
		self.disconnectCompletionHandler?(WebSocketsClientResultCode.DidDisconnect)
		
		// Dispose the completion handlers
		self.disconnectCompletionHandler 	= nil
		
		// Notify the delegate
		self.delegate?.webSocketsClientStrategy(didDisconnect: self.webSocketID!, error: nil, sender: self)
		
		// Attempt to reconnect if required
		if (self.attemptReconnectYN) {
			
			let _: WebSocketsClientResultCode = self.connect()
			
		}
		
	}
	
	open func didReceiveMessage(messageString: String) {
		
		// Get messageWrapper from string
		let messageWrapper: WebSocketsMessageWrapper = self.processMessage(messageString: messageString)
		
		// Notify the delegate
		self.delegate?.webSocketsClientStrategy(didReceive: self.webSocketID!, message: messageWrapper, error: nil, sender: self)
		
	}
	
}

// MARK: - Extension ProtocolAuthenticationStrategy

extension WebSocketsClientStrategyBase: ProtocolWebSocketsClientStrategy {

    // MARK: - Public Methods
	
	public func set(webSocketID: String) {
		
		// Check webSocketID has not been set
		guard (self.webSocketID == nil) else { return }
		
		self.webSocketID = webSocketID
		
	}
	
	public func set(property key: String, value: String) {
		
		self.isWebSocketSetupYN = false
		
		self.properties![key] = value
		
	}
	
}
