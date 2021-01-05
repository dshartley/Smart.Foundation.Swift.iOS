//
//  ProtocolWebSocketsClientStrategyDelegate.swift
//  SFNet
//
//  Created by David on 12/04/2018.
//  Copyright © 2018 com.smartfoundation. All rights reserved.
//

import UIKit

/// Defines a delegate for a WebSocketsClientStrategy class
public protocol ProtocolWebSocketsClientStrategyDelegate: class {

    // MARK: - Methods
    
    func webSocketsClientStrategy(didConnect webSocketID: String, error: Error?, sender: ProtocolWebSocketsClientStrategy)
    
    func webSocketsClientStrategy(didDisconnect webSocketID: String, error: Error?, sender: ProtocolWebSocketsClientStrategy)
    
    func webSocketsClientStrategy(didSend webSocketID: String, message: WebSocketsMessageWrapper, error: Error?, sender: ProtocolWebSocketsClientStrategy)
    
    func webSocketsClientStrategy(didReceive webSocketID: String, message: WebSocketsMessageWrapper, error: Error?, sender: ProtocolWebSocketsClientStrategy)
	
}
