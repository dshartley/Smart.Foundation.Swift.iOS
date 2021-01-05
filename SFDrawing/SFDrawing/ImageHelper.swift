//
//  ImageHelper.swift
//  SFDrawing
//
//  Created by David on 22/06/2017.
//  Copyright © 2017 com.smartfoundation. All rights reserved.
//

import UIKit

public class ImageHelper: NSObject {

	// MARK: - Public Static Methods
	
	public static func scaleImage(_ image: UIImage, maxDimension: CGFloat) -> UIImage {
		
		var scaledSize    = CGSize(width: maxDimension, height: maxDimension)
		var scaleFactor   : CGFloat
		
		if image.size.width > image.size.height {
			scaleFactor = image.size.height / image.size.width
			scaledSize.width = maxDimension
			scaledSize.height = scaledSize.width * scaleFactor
		} else {
			scaleFactor = image.size.width / image.size.height
			scaledSize.height = maxDimension
			scaledSize.width = scaledSize.height * scaleFactor
		}
		
		UIGraphicsBeginImageContext(scaledSize)
		image.draw(in: CGRect(x: 0, y: 0, width: scaledSize.width, height: scaledSize.height))
		let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()
		
		return scaledImage!
	}
	
}
