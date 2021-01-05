//
//  SFProtocolCollectionViewLayoutDelegate.swift
//  SFView
//
//  Created by David on 29/06/2017.
//  Copyright © 2017 com.smartfoundation. All rights reserved.
//

import Foundation

/// Defines a SFCollectionViewLayout delegate
public protocol SFProtocolCollectionViewLayoutDelegate: class {
	
	// MARK: - Methods
	
	/// Returns the height for the cell at the index path.
	///
	/// - Parameters:
	///   - collectionView: The collectionView
	///   - indexPath: The indexPath
	///   - withWidth: The withWidth
	/// - Returns: The height
	func collectionView(collectionView:UICollectionView, heightForCellAtIndexPath indexPath:NSIndexPath, withWidth:CGFloat) -> CGFloat

	/// Returns the width for the cell at the index path.
	///
	/// - Parameters:
	///   - collectionView: The collectionView
	///   - indexPath: The indexPath
	/// - Returns: The width
	func collectionView(collectionView:UICollectionView, widthForCellAtIndexPath indexPath:NSIndexPath) -> CGFloat
	
	/// Sets the custom attributes.
	///
	/// - Parameter attributes: The attributes
	func setCustomAttributes(attributes: SFCollectionViewLayoutAttributes)
}
