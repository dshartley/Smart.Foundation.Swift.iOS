//
//  ReachabilityHelper.swift
//  SFNet
//
//  Created by David on 22/06/2017.
//  Copyright © 2017 com.smartfoundation. All rights reserved.
//
import Foundation
import SystemConfiguration

/// A helper for checking internet reachability
/// - note: Usage; ReachabilityHelper.shared.isConnectedToNetwork()
public struct ReachabilityHelper {
	
	// MARK: - Initializers
	
	private init () {}
	
	
	// MARK: - Public Static Methods
	
	/// Check is connected to network
	///
	/// - Returns: Return true if connected to network, otherwise false
	public static func isConnectedToNetwork() -> Bool {
		
		guard let flags = getFlags() else {
			return false
		}
		
		let isReachable			= flags.contains(.reachable)
		let needsConnection		= flags.contains(.connectionRequired)
		
		return (isReachable && !needsConnection)
	}
	
	
	// MARK: - Private Static Methods
	
	fileprivate static func getFlags() -> SCNetworkReachabilityFlags? {
		
		guard let reachability = ipv4Reachability() ?? ipv6Reachability() else {
			return nil
		}
		
		var flags = SCNetworkReachabilityFlags()
		
		if !SCNetworkReachabilityGetFlags(reachability, &flags) {
			
			return nil
		}
		
		return flags
	}
	
	fileprivate static func ipv6Reachability() -> SCNetworkReachability? {
		
		var zeroAddress = sockaddr_in6()
		zeroAddress.sin6_len	= UInt8(MemoryLayout<sockaddr_in>.size)
		zeroAddress.sin6_family = sa_family_t(AF_INET6)
		
		return withUnsafePointer(to: &zeroAddress, {
			$0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
				SCNetworkReachabilityCreateWithAddress(nil, $0)
			}
		})
	}
	
	fileprivate static func ipv4Reachability() -> SCNetworkReachability? {
		
		var zeroAddress = sockaddr_in()
		zeroAddress.sin_len		= UInt8(MemoryLayout<sockaddr_in>.size)
		zeroAddress.sin_family	= sa_family_t(AF_INET)
		
		return withUnsafePointer(to: &zeroAddress, {
			$0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
				SCNetworkReachabilityCreateWithAddress(nil, $0)
			}
		})
	}
}


