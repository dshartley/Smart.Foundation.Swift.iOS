//
//  SocialModelManager.swift
//  SFSocial
//
//  Created by David on 30/10/2017.
//  Copyright © 2017 com.smartfoundation. All rights reserved.
//

import SFModel

/// Manages the model layer and provides access to the model administrators
public class SocialModelManager: ModelManagerBase {

	// MARK: - Initializers

	fileprivate override init() {
		super.init()
	}

	public override init(storageDateFormatter: DateFormatter) {
		super.init(storageDateFormatter: storageDateFormatter)
	}
	
	
	// MARK: - Public Methods
	
	// RelativeMember
	
	fileprivate var _relativeMemberModelAdministrator: RelativeMemberModelAdministrator?
	
	public func setupRelativeMemberModelAdministrator(modelAccessStrategy: ProtocolModelAccessStrategy,
													  loadAvatarImageStrategy: ProtocolRelativeMemberLoadAvatarImageStrategy?) {
		
		if (self.modelAdministrators.keys.contains("RelativeMembers")) { self.modelAdministrators.removeValue(forKey: "RelativeMembers") }
		
		self._relativeMemberModelAdministrator = RelativeMemberModelAdministrator(modelAccessStrategy: modelAccessStrategy, modelAdministratorProvider: self, storageDateFormatter: self.storageDateFormatter!)
		
		// loadAvatarImageStrategy
		self._relativeMemberModelAdministrator?.loadAvatarImageStrategy = loadAvatarImageStrategy
		
		self.modelAdministrators["RelativeMembers"] = self._relativeMemberModelAdministrator
	}
	
	public var getRelativeMemberModelAdministrator: RelativeMemberModelAdministrator? {
		get {
			return self._relativeMemberModelAdministrator
		}
	}
	
	
	// RelativeConnection
	
	fileprivate var _relativeConnectionModelAdministrator: RelativeConnectionModelAdministrator?
	
	public func setupRelativeConnectionModelAdministrator(modelAccessStrategy: ProtocolModelAccessStrategy) {
		
		if (self.modelAdministrators.keys.contains("RelativeConnections")) { self.modelAdministrators.removeValue(forKey: "RelativeConnections") }
		
		self._relativeConnectionModelAdministrator = RelativeConnectionModelAdministrator(modelAccessStrategy: modelAccessStrategy, modelAdministratorProvider: self, storageDateFormatter: self.storageDateFormatter!)
		
		self.modelAdministrators["RelativeConnections"] = self._relativeConnectionModelAdministrator
	}
	
	public var getRelativeConnectionModelAdministrator: RelativeConnectionModelAdministrator? {
		get {
			return self._relativeConnectionModelAdministrator
		}
	}
	
	
	// RelativeConnectionRequest
	
	fileprivate var _relativeConnectionRequestModelAdministrator: RelativeConnectionRequestModelAdministrator?
	
	public func setupRelativeConnectionRequestModelAdministrator(modelAccessStrategy: ProtocolModelAccessStrategy) {
		
		if (self.modelAdministrators.keys.contains("RelativeConnectionRequests")) { self.modelAdministrators.removeValue(forKey: "RelativeConnectionRequests") }
		
		self._relativeConnectionRequestModelAdministrator = RelativeConnectionRequestModelAdministrator(modelAccessStrategy: modelAccessStrategy, modelAdministratorProvider: self, storageDateFormatter: self.storageDateFormatter!)
		
		self.modelAdministrators["RelativeConnectionRequests"] = self._relativeConnectionRequestModelAdministrator
	}
	
	public var getRelativeConnectionRequestModelAdministrator: RelativeConnectionRequestModelAdministrator? {
		get {
			return self._relativeConnectionRequestModelAdministrator
		}
	}
	
	
	// RelativeInteraction
	
	fileprivate var _relativeInteractionModelAdministrator: RelativeInteractionModelAdministrator?
	
	public func setupRelativeInteractionModelAdministrator(modelAccessStrategy: ProtocolModelAccessStrategy) {
		
		if (self.modelAdministrators.keys.contains("RelativeInteractions")) { self.modelAdministrators.removeValue(forKey: "RelativeInteractions") }
		
		self._relativeInteractionModelAdministrator = RelativeInteractionModelAdministrator(modelAccessStrategy: modelAccessStrategy, modelAdministratorProvider: self, storageDateFormatter: self.storageDateFormatter!)
		
		self.modelAdministrators["RelativeInteractions"] = self._relativeInteractionModelAdministrator
	}
	
	public var getRelativeInteractionModelAdministrator: RelativeInteractionModelAdministrator? {
		get {
			return self._relativeInteractionModelAdministrator
		}
	}
	
	
	// RelativeTimelineEvent
	
	fileprivate var _relativeTimelineEventModelAdministrator: RelativeTimelineEventModelAdministrator?
	
	public func setupRelativeTimelineEventModelAdministrator(modelAccessStrategy: ProtocolModelAccessStrategy) {
		
		if (self.modelAdministrators.keys.contains("RelativeTimelineEvents")) { self.modelAdministrators.removeValue(forKey: "RelativeTimelineEvents") }
		
		self._relativeTimelineEventModelAdministrator = RelativeTimelineEventModelAdministrator(modelAccessStrategy: modelAccessStrategy, modelAdministratorProvider: self, storageDateFormatter: self.storageDateFormatter!)
		
		self.modelAdministrators["RelativeTimelineEvents"] = self._relativeTimelineEventModelAdministrator
	}
	
	public var getRelativeTimelineEventModelAdministrator: RelativeTimelineEventModelAdministrator? {
		get {
			return self._relativeTimelineEventModelAdministrator
		}
	}
	
}

