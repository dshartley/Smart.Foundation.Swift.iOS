//
//  ProtocolWebSocketsClientManagerDelegate.swift
//  SFNet
//
//  Created by David on 12/04/2018.
//  Copyright © 2018 com.smartfoundation. All rights reserved.
//

import UIKit

/// Defines a delegate for a WebSocketsClientManager class
public protocol ProtocolWebSocketsClientManagerDelegate: class {

    // MARK: - Methods
    
    func webSocketsClientManager(didConnect webSocketID: String, error: Error?, sender: WebSocketsClientManager)
    
    func webSocketsClientManager(didDisconnect webSocketID: String, error: Error?, sender: WebSocketsClientManager)
    
    func webSocketsClientManager(didSend webSocketID: String, message: WebSocketsMessageWrapper, error: Error?, sender: WebSocketsClientManager)
    
    func webSocketsClientManager(didReceive webSocketID: String, message: WebSocketsMessageWrapper, error: Error?, sender: WebSocketsClientManager)
	
}
