//
//  ProtocolRelativeMemberLoadAvatarImageStrategy.swift
//  SFSocial
//
//  Created by David on 10/05/2018.
//  Copyright © 2018 com.smartfoundation. All rights reserved.
//

/// Defines a class which provides a strategy for loading the RelativeMember avatarImageData
public protocol ProtocolRelativeMemberLoadAvatarImageStrategy {

	// MARK: - Methods
	
	func loadAvatarImageData(item: RelativeMemberWrapper, oncomplete completionHandler:@escaping (RelativeMemberWrapper, Data?, Error?) -> Void)
	
}
