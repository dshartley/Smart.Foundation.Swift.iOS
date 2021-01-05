//
//  WebSocketsClientManager.swift
//  SFNet
//
//  Created by David on 12/04/2018.
//  Copyright © 2018 com.smartfoundation. All rights reserved.
//

import UIKit
import SFCore

public enum WebSocketsClientResultCode: Int32 {
	case NotImplemented = 0
	case AwaitingResult = 1
	case Error = 2
	case ErrorAlreadyConnected = 3
	case DidConnect = 4
	case ErrorAlreadyDisconnected = 5
	case DidDisconnect = 6
	case ErrorStrategyWithWebSocketIDDoesNotExist = 7
	case ErrorNotConnected = 8
	case ErrorAlreadyAwaitingConnect = 9
	case ErrorAlreadyAwaitingDisconnect = 10
	case ErrorNotConnectedToNetwork = 11
	case ErrorAwaitingReconnect = 12
	case DidSendMessage = 13
}

/// Manages a WebSocketsClient
public class WebSocketsClientManager {

    // MARK: - Private Stored Properties
    
    fileprivate var webSocketsClientStrategies:     [String:ProtocolWebSocketsClientStrategy]?
    
    
    // MARK: - Private Static Properties
    
    fileprivate static var singleton:               WebSocketsClientManager?
    
    
    // MARK: - Public Stored Properties
    
    public weak var delegate:                       ProtocolWebSocketsClientManagerDelegate?
    
    
    // MARK: - Initializers
    
    fileprivate init() {
        
        // Setup dictionary of strategies
        self.webSocketsClientStrategies = [String:ProtocolWebSocketsClientStrategy]()

    }
    
    
    // MARK: - Public Class Computed Properties
    
    public class var shared: WebSocketsClientManager {
        get {
            
            if (WebSocketsClientManager.singleton == nil) {
                WebSocketsClientManager.singleton = WebSocketsClientManager()
            }
            
            return WebSocketsClientManager.singleton!
        }
    }
    
    
    // MARK: - Public Methods
	
	public func dispose() {
		
		// Go through each strategy
		for item in self.webSocketsClientStrategies! {
			
			// Dispose the strategy
			item.value.dispose()
			
		}
		
		self.webSocketsClientStrategies 	= nil
		
		WebSocketsClientManager.singleton 	= nil
	}
	
    public func add(strategy: ProtocolWebSocketsClientStrategy) -> String? {
		
		let strategy = strategy as? WebSocketsClientStrategyBase
		
		var isDuplicate: Bool = false
		
		// Check if a duplicate strategy exists
		for item in self.webSocketsClientStrategies! {
			
			if (strategy!.isDuplicate(of: item.value as! WebSocketsClientStrategyBase)) {
				
				isDuplicate = true
				
			}
		}
		
		guard (!isDuplicate) else { return nil }
		
        // Create webSocketID
        let webSocketID: String = UUID().uuidString
		
		// Set webSocketID in the strategy
		strategy!.set(webSocketID: webSocketID)
		
		// Set strategy delegate
		strategy!.delegate = self

        // Put the strategy in the dictionary
        self.webSocketsClientStrategies![webSocketID] = strategy
        
        return webSocketID
        
    }
    
    public func connect(webSocketID: String, oncomplete completionHandler:@escaping (WebSocketsClientResultCode) -> Void) {
		
		// Check isConnected to network
		guard (self.checkIsConnected()) else {
			
			// Call completion handler
			completionHandler(WebSocketsClientResultCode.ErrorNotConnectedToNetwork)
			
			return
		}
		
        let strategy: ProtocolWebSocketsClientStrategy? = self.getStrategy(webSocketID: webSocketID)
		
		// Check strategy found
        guard (strategy != nil) else {
            
            // Call completion handler
            completionHandler(WebSocketsClientResultCode.ErrorStrategyWithWebSocketIDDoesNotExist)
            
            return
        }
        
        strategy!.connect(oncomplete: completionHandler)
        
    }

    public func connect(webSocketID: String) -> WebSocketsClientResultCode {
		
		// Check isConnected to network
		guard (self.checkIsConnected()) else { return WebSocketsClientResultCode.ErrorNotConnectedToNetwork }
		
        let strategy: ProtocolWebSocketsClientStrategy? = self.getStrategy(webSocketID: webSocketID)
		
		// Check strategy found
        guard (strategy != nil) else {

            return WebSocketsClientResultCode.ErrorStrategyWithWebSocketIDDoesNotExist
        }
		
		// Check not isConnectedYN
		guard (!(strategy!.isConnectedYN && !strategy!.isAwaitingDisconnectYN)) else {
			
			return WebSocketsClientResultCode.ErrorAlreadyConnected
		}

		// Check not isAwaitingConnectYN
		guard (!strategy!.isAwaitingConnectYN) else {

			return WebSocketsClientResultCode.ErrorAlreadyAwaitingConnect
		}
		
		let result: WebSocketsClientResultCode = strategy!.connect()
        
        return result
        
    }

    public func disconnect(webSocketID: String, oncomplete completionHandler:@escaping (WebSocketsClientResultCode) -> Void) {
		
		// Check isConnected to network
		guard (self.checkIsConnected()) else {
			
			// Call completion handler
			completionHandler(WebSocketsClientResultCode.ErrorNotConnectedToNetwork)
			
			return
		}
		
        let strategy: ProtocolWebSocketsClientStrategy? = self.getStrategy(webSocketID: webSocketID)
		
		// Check strategy found
        guard (strategy != nil) else {
            
            // Call completion handler
            completionHandler(WebSocketsClientResultCode.ErrorStrategyWithWebSocketIDDoesNotExist)
            
            return
        }
        
        strategy!.disconnect(oncomplete: completionHandler)
        
    }
    
    public func disconnect(webSocketID: String) -> WebSocketsClientResultCode {
		
		// Check isConnected to network
		guard (self.checkIsConnected()) else { return WebSocketsClientResultCode.ErrorNotConnectedToNetwork }
		
        let strategy: ProtocolWebSocketsClientStrategy? = self.getStrategy(webSocketID: webSocketID)
		
		// Check strategy found
        guard (strategy != nil) else {
            
            return WebSocketsClientResultCode.ErrorStrategyWithWebSocketIDDoesNotExist
        }
		
		// Check isConnectedYN
		guard (strategy!.isConnectedYN) else {
			
			return WebSocketsClientResultCode.ErrorAlreadyDisconnected
		}
		
        let result: WebSocketsClientResultCode = strategy!.disconnect()
        
        return result
        
    }

    public func send(webSocketID: String, message: WebSocketsMessageWrapper) -> WebSocketsClientResultCode {
		
		// Check isConnected to network
		guard (self.checkIsConnected()) else { return WebSocketsClientResultCode.ErrorNotConnectedToNetwork }
		
        let strategy: ProtocolWebSocketsClientStrategy? = self.getStrategy(webSocketID: webSocketID)
		
		// Check strategy found
        guard (strategy != nil) else {
            
            return WebSocketsClientResultCode.ErrorStrategyWithWebSocketIDDoesNotExist
        }
		
		// Check isConnectedYN
		guard (strategy!.isConnectedYN) else {
			
			return WebSocketsClientResultCode.ErrorNotConnected
		}
		
        let result: WebSocketsClientResultCode = strategy!.send(message: message)
        
        return result
        
    }
    
    
    // MARK: - Open [Overridable] Methods
    
    
    // MARK: - Private Methods
 
    fileprivate func getStrategy(webSocketID: String) -> ProtocolWebSocketsClientStrategy? {
        
        return self.webSocketsClientStrategies![webSocketID]
        
    }
	
	fileprivate func checkIsConnected() -> Bool {
		
		#if DEBUG
			
			if (ApplicationFlags.flag(key: "SkipCheckIsConnectedYN")) {
				return true
			}
			
		#endif
		
		var result = false
		
		result = ReachabilityHelper.isConnectedToNetwork()
		
		return result
	}
	
}

// MARK: - Extension ProtocolWebSocketsClientStrategyDelegate

extension WebSocketsClientManager: ProtocolWebSocketsClientStrategyDelegate {    

    // MARK: - Public Methods
    
    public func webSocketsClientStrategy(didConnect webSocketID: String, error: Error?, sender: ProtocolWebSocketsClientStrategy) {
        
        // Notify the delegate
        self.delegate?.webSocketsClientManager(didConnect: webSocketID, error: error, sender: self)
        
    }
    
    public func webSocketsClientStrategy(didDisconnect webSocketID: String, error: Error?, sender: ProtocolWebSocketsClientStrategy) {

        // Notify the delegate
        self.delegate?.webSocketsClientManager(didDisconnect: webSocketID, error: error, sender: self)
        
    }
    
    public func webSocketsClientStrategy(didSend webSocketID: String, message: WebSocketsMessageWrapper, error: Error?, sender: ProtocolWebSocketsClientStrategy) {
        
        // Notify the delegate
        self.delegate?.webSocketsClientManager(didSend: webSocketID, message: message, error: error, sender: self)
        
    }
    
    public func webSocketsClientStrategy(didReceive webSocketID: String, message: WebSocketsMessageWrapper, error: Error?, sender: ProtocolWebSocketsClientStrategy) {
        
        // Notify the delegate
        self.delegate?.webSocketsClientManager(didReceive: webSocketID, message: message, error: error, sender: self)
        
    }
		
}

