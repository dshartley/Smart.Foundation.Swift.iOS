//
//  CoreDataHelper.swift
//  Smart.Foundation
//
//  Created by David on 08/11/2017.
//  Copyright © 2017 com.smartfoundation. All rights reserved.
//

import UIKit
import CoreData

/// A helper for managing CoreData
public class CoreDataHelper {
	
	// MARK: - Initializers
	
	private init () {}
	
	
	// MARK: - Public Static Methods
	
	public static func getManagedObjectContext() -> NSManagedObjectContext
	{
		// Get appDelegate
		let appDelegate:			AppDelegate				= UIApplication.shared.delegate as! AppDelegate
		
		// Get managedObjectContext
		let managedObjectContext:	NSManagedObjectContext	= appDelegate.persistentContainer.viewContext
		
		return managedObjectContext
	}
	
}
