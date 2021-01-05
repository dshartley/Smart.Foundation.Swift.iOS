//
//  UITableViewHelper.swift
//  SFView
//
//  Created by David on 07/05/2018.
//  Copyright © 2018 com.smartfoundation. All rights reserved.
//

import UIKit

/// A helper for handling UITableView
public final class UITableViewHelper {
	
	// MARK: - Initializers
	
	private init () {}
	
	
	// MARK: - Class Methods

	public class func clear(tableView: UITableView, oncomplete completionHandler: ((Error?) -> Void)?) {
		
		// Check items exist
		guard (tableView.numberOfRows(inSection: 0) > 0) else {
			
			// Call completion handler
			completionHandler?(nil)
			
			return
		}
		
		// Check not scrolling
		UIScrollViewHelper.abortScroll(scrollView: tableView)
		
		// Create index paths for items to be deleted
		var indexPaths:	[IndexPath] = [IndexPath]()
		let firstIndex:	Int			= 0
		
		for i in 0...tableView.numberOfRows(inSection: 0) - 1 {
			
			indexPaths.append(IndexPath(item: firstIndex + i, section: 0))
		}
		
		DispatchQueue.main.async(execute: {
			
			tableView.deleteRows(at: indexPaths, with: .none)
			
			// Call completion handler
			completionHandler?(nil)
		})
		
	}
	
}
