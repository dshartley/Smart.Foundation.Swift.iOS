//
//  ProtocolSocialManagerDelegate.swift
//  SFSocial
//
//  Created by David on 14/01/2018.
//  Copyright © 2018 com.smartfoundation. All rights reserved.
//

/// Defines a delegate for a SocialManager class
public protocol ProtocolSocialManagerDelegate: class {

	// MARK: - Methods

	func socialManagerSetStateBeforeLoad()
	
	func socialManagerSetStateAfterLoad()
	
	func socialManager(item: RelativeMemberWrapper, loadedAvatarImage sender: SocialManager)
	
}
