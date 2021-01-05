//
//  ProtocolWebSocketsClientStrategy.swift
//  SFNet
//
//  Created by David on 12/04/2018.
//  Copyright © 2018 com.smartfoundation. All rights reserved.
//

import UIKit

/// Defines a class which provides a strategy for managing a WebSocketsClient
public protocol ProtocolWebSocketsClientStrategy {

    // MARK: - Properties
    
    var webSocketID:    		String? { get }
    var urlString:            	String? { get }
	var isConnectedYN:			Bool { get set }
	var isAwaitingConnectYN:	Bool { get set }
	var isAwaitingDisconnectYN:	Bool { get set }
	var attemptReconnectYN:		Bool { get set }
	var isWebSocketSetupYN:		Bool { get set }
	
    
    // MARK: - Methods
	
	func dispose()
	
	func isDuplicate(of: ProtocolWebSocketsClientStrategy) -> Bool
	
    func connect(oncomplete completionHandler:@escaping (WebSocketsClientResultCode) -> Void)
    
    func connect() -> WebSocketsClientResultCode
    
    func disconnect(oncomplete completionHandler:@escaping (WebSocketsClientResultCode) -> Void)
    
    func disconnect() -> WebSocketsClientResultCode
    
    func send(message: WebSocketsMessageWrapper) -> WebSocketsClientResultCode
	
	func set(webSocketID: String)
	
	func set(property key: String, value: String)
	
}
