//
//  ImageHelper.swift
//  SFGraphics
//
//  Created by David on 16/11/2017.
//  Copyright © 2017 com.smartfoundation. All rights reserved.
//

import UIKit

/// A helper for handling images
public struct ImageHelper {

	// MARK: - Initializers
	
	private init () {}
	
	
	// MARK: - Public Static Methods
	
	public static func resize(image: UIImage, targetSize: CGSize) -> UIImage {
		
		let size: 			CGSize = image.size
		
		let widthRatio: 	CGFloat = targetSize.width / size.width
		let heightRatio:	CGFloat = targetSize.height / size.height
		
		// Figure out what our orientation is, and use that to form the rectangle
		var newSize: CGSize
		
		if (widthRatio > heightRatio) {
			
			newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
			
		} else {
			
			newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
			
		}
		
		// This is the rect that we've calculated out and this is what is actually used below
		let rect: 			CGRect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
		
		// Actually do the resizing to the rect using the ImageContext
		UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
		
		image.draw(in: rect)
		
		let newImage: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()
		
		return newImage!
		
	}
	
	public static func toJPEGData(image: UIImage) -> Data {
		
		var result: Data? = nil
		
		result = UIImageJPEGRepresentation(image, 1.0)

		return result!
		
	}
	
	public static func toPNGData(image: UIImage) -> Data {
		
		var result: Data? = nil
		
		result = UIImagePNGRepresentation(image)
		
		return result!
		
	}

	public static func imageofColor(color: UIColor) -> UIImage {
	
		// Create rect
		let rect: 	CGRect = CGRect(x: 0, y: 0, width: 1, height: 1)
		
		UIGraphicsBeginImageContextWithOptions(CGSize(width: 1, height: 1), false, 0)
		
		color.setFill()
		
		UIRectFill(rect)
		
		// Create image
		let image: 	UIImage = UIGraphicsGetImageFromCurrentImageContext()!
		
		UIGraphicsEndImageContext()
		
		return image
		
	}
	
}
