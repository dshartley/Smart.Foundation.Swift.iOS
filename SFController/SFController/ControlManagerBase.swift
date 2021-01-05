//
//  ControlManagerBase.swift
//  SFController
//
//  Created by David on 22/06/2017.
//  Copyright © 2017 com.smartfoundation. All rights reserved.
//

import SFCore
import SFModel
import SFSecurity
import SFSocial
import SFNet

/// A base class for classes which manage the control layer
open class ControlManagerBase {

	// MARK: - Public Stored Properties
	
	public weak var baseDelegate:						ProtocolControlManagerBaseDelegate?
	public fileprivate(set) var modelManager:			ModelManagerBase?
	public fileprivate(set) var socialModelManager:		ModelManagerBase?
	public var isLoadingDataYN:							Bool = false
	
	
	// MARK: - Private Stored Properties
	
	
	// MARK: - Initializers
	
	public init() {
	}

	public init(modelManager: ModelManagerBase) {
		
		self.modelManager = modelManager
		
	}
	
	public init(modelManager: ModelManagerBase, socialModelManager: SocialModelManager) {
		
		self.modelManager 			= modelManager
		self.socialModelManager 	= socialModelManager
		
	}
	
	
	// MARK: - Public Methods
	
	public func set(modelManager: ModelManagerBase) {
		
		self.modelManager = modelManager
	}

	public func set(socialModelManager: ModelManagerBase) {
		
		self.socialModelManager = socialModelManager
		
		// Setup the social manager
		SocialManager.shared.set(modelManager: socialModelManager as! SocialModelManager)
		
	}
	
	public func isSignedInYN() -> Bool {

		return AuthenticationManager.shared.isSignedInYN()
	}
	
	public func signOut() {
	
		// Sign out
		AuthenticationManager.shared.signOut()

	}
	
	public func checkIsConnected() -> Bool {
		
		#if DEBUG
			
			if (ApplicationFlags.flag(key: "SkipCheckIsConnectedYN")) {
				return true
			}
			
		#endif
		
		var result = false
		
		result = ReachabilityHelper.isConnectedToNetwork()
		
		return result
	}
	
	public func setupAuthentication() {
		
		// Set delegate
		AuthenticationManager.shared.delegate = self
		
	}
	
	public func setupSocial() {
		
		// Set delegate
		SocialManager.shared.delegate = self
		
	}

    public func setupWebSocketsClient() {
        
        // Set delegate
        WebSocketsClientManager.shared.delegate = self
        
    }
    
	public func loadUserPropertiesPhoto(userProperties: UserProperties, oncomplete completionHandler:@escaping (Data?, UserProperties?, Error?) -> Void) {
		
		guard (self.baseDelegate != nil) else {
		
			// Call completion handler
			completionHandler(nil, userProperties, NSError())
			
			return
		}
		
		// Propogate to delegate
		self.baseDelegate?.controlManagerBase(loadUserPropertiesPhoto: userProperties, oncomplete: completionHandler)
		
	}
	
	
	// MARK: - Open [Overridable] Methods
	
	open func onSignInSuccessful(userProperties: UserProperties) {
		
		// Not implemented
	}
	
	open func onSignInFailed(userProperties: 	UserProperties?,
	                         error: 			Error?,
	                         code: 				AuthenticationErrorCodes?) {
		
		// Not implemented
	}
	
	open func onSignOutSuccessful(userProperties: UserProperties) {
		
		// Not implemented
	}
	
	open func onSignOutFailed(userProperties: 	UserProperties?,
	                          error: 			Error?,
	                          code: 			AuthenticationErrorCodes?) {
		
		// Not implemented
	}
	
	open func onSignUpSuccessful(userProperties: UserProperties) {
		
		// Not implemented
	}
	
	open func onSignUpFailed(userProperties: 	UserProperties?,
	                         error: 			Error?,
	                         code: 				AuthenticationErrorCodes?) {
		
		// Not implemented
	}
	
	open func onRecoverPasswordSuccessful() {
		
		// Not implemented
	}
	
	open func onRecoverPasswordFailed(error: Error?,
	                                  code: AuthenticationErrorCodes?) {
		
		// Not implemented
	}

	open func onUpdatePasswordSuccessful() {
		
		// Not implemented
	}
	
	open func onUpdatePasswordFailed(error: Error?,
									  code: AuthenticationErrorCodes?) {
		
		// Not implemented
	}
	
	open func onUserPropertiesPhotoLoaded(userProperties: UserProperties) {
		
		// Not implemented
	}
	
	open func setStateBeforeLoad() {
		
		self.isLoadingDataYN = true
		
	}
	
	open func setStateAfterLoad() {
		
		self.isLoadingDataYN = false
		
	}
	
    open func onWebSocketsClientManager(didConnect webSocketID: String, error: Error?, sender: WebSocketsClientManager) {
        
        // Not implemented
    }
    
    open func onWebSocketsClientManager(didDisconnect webSocketID: String, error: Error?, sender: WebSocketsClientManager) {
        
        // Not implemented
    }
    
    open func onWebSocketsClientManager(didSend webSocketID: String, message: WebSocketsMessageWrapper, error: Error?, sender: WebSocketsClientManager) {
        
        // Not implemented
    }
    
    open func onWebSocketsClientManager(didReceive webSocketID: String, message: WebSocketsMessageWrapper, error: Error?, sender: WebSocketsClientManager) {
        
        // Not implemented
    }
	
	open func onSocialManagerSetStateBeforeLoad() {
		
		// Not implemented
	}
	
	open func onSocialManagerSetStateAfterLoad() {
		
		// Not implemented
	}
	
	open func onSocialManager(item: RelativeMemberWrapper, loadedAvatarImage sender: SocialManager) {
		
		// Not implemented
	}
	
	
	// MARK: - Private Methods
	
}


// MARK: - Extension ProtocolAuthenticationManagerDelegate

extension ControlManagerBase: ProtocolAuthenticationManagerDelegate {
	
	// MARK: - Public Methods
	
	public func authenticationManager(signInSuccessful userProperties: UserProperties) {
		
		// Propagate the notification
		self.onSignInSuccessful(userProperties: userProperties)
	}
	
	public func authenticationManager(signInFailed userProperties: UserProperties?,
	                                  error: 	Error?,
	                                  code: 	AuthenticationErrorCodes?) {
		
		// Propagate the notification
		self.onSignInFailed(userProperties: userProperties, error: error, code: code)
	}
	
	public func authenticationManager(signOutSuccessful userProperties: UserProperties) {
		
		// Propagate the notification
		self.onSignOutSuccessful(userProperties: userProperties)
	}
	
	public func authenticationManager(signOutFailed userProperties: UserProperties?,
	                                  error: 	Error?,
	                                  code: 	AuthenticationErrorCodes?) {
		
		// Propagate the notification
		self.onSignOutFailed(userProperties: userProperties, error: error, code: code)
	}
	
	public func authenticationManager(signUpSuccessful userProperties: UserProperties) {
		
		// Propagate the notification
		self.onSignUpSuccessful(userProperties: userProperties)
	}
	
	public func authenticationManager(signUpFailed userProperties: UserProperties?,
	                                  error: 	Error?,
	                                  code: 	AuthenticationErrorCodes?) {
		
		// Propagate the notification
		self.onSignUpFailed(userProperties: userProperties, error: error, code: code)
	}
	
	public func authenticationManager(recoverPasswordSuccessful sender: AuthenticationManager) {
		
		// Propagate the notification
		self.onRecoverPasswordSuccessful()
	}
	
	public func authenticationManager(recoverPasswordFailed error: Error?,
	                                  code: AuthenticationErrorCodes?) {
		
		// Propagate the notification
		self.onRecoverPasswordFailed(error: error, code: code)
	}
	
	public func authenticationManager(updatePasswordSuccessful sender: AuthenticationManager) {
		
		// Propagate the notification
		self.onUpdatePasswordSuccessful()
	}
	
	public func authenticationManager(updatePasswordFailed error: Error?,
									  code: AuthenticationErrorCodes?) {
		
		// Propagate the notification
		self.onUpdatePasswordFailed(error: error, code: code)
	}
	
	public func authenticationManager(userPropertiesPhotoLoaded userProperties: UserProperties) {
		
		// Propagate the notification
		self.onUserPropertiesPhotoLoaded(userProperties: userProperties)
		
	}
	
	public func authenticationManager(loadUserPropertiesPhoto userProperties: UserProperties, oncomplete completionHandler:@escaping (Data?, UserProperties?, Error?) -> Void) {
		
		// Propagate the notification
		self.loadUserPropertiesPhoto(userProperties: userProperties, oncomplete: completionHandler)
		
	}
}


// MARK: - Extension ProtocolSocialManagerDelegate

extension ControlManagerBase: ProtocolSocialManagerDelegate {
	
	// MARK: - Open [Overridable] Methods
	
	open func socialManagerSetStateBeforeLoad() {
		
		self.onSocialManagerSetStateBeforeLoad()
		
	}
	
	open func socialManagerSetStateAfterLoad() {
		
		self.onSocialManagerSetStateAfterLoad()
		
	}
	
	open func socialManager(item: RelativeMemberWrapper, loadedAvatarImage sender: SocialManager) {
		
		self.onSocialManager(item: item, loadedAvatarImage: sender)
		
	}
	
}


// MARK: - Extension ProtocolWebSocketsClientManagerDelegate

extension ControlManagerBase: ProtocolWebSocketsClientManagerDelegate {

    open func webSocketsClientManager(didConnect webSocketID: String, error: Error?, sender: WebSocketsClientManager) {
        
        self.onWebSocketsClientManager(didConnect: webSocketID, error: error, sender: sender)
        
    }
    
    open func webSocketsClientManager(didDisconnect webSocketID: String, error: Error?, sender: WebSocketsClientManager) {
        
        self.onWebSocketsClientManager(didDisconnect: webSocketID, error: error, sender: sender)
        
    }
    
    open func webSocketsClientManager(didSend webSocketID: String, message: WebSocketsMessageWrapper, error: Error?, sender: WebSocketsClientManager) {
        
        self.onWebSocketsClientManager(didSend: webSocketID, message: message, error: error, sender: sender)
        
    }
    
    open func webSocketsClientManager(didReceive webSocketID: String, message: WebSocketsMessageWrapper, error: Error?, sender: WebSocketsClientManager) {
        
        self.onWebSocketsClientManager(didReceive: webSocketID, message: message, error: error, sender: sender)
        
    }
	
}

