//
//  UIColorHelper.swift
//  SFView
//
//  Created by David on 26/10/2018.
//  Copyright © 2018 com.smartfoundation. All rights reserved.
//

import UIKit

/// A helper for handling UIView
public final class UIColorHelper {
	
	// MARK: - Initializers
	
	private init () {}
	
	
	// MARK: - Public Class Methods
	
	public class func randomColor() -> UIColor {
		
		return UIColor(red: randomCGFloat(), green: randomCGFloat(), blue: randomCGFloat(), alpha: 1)
	}
	
	public class func toHex(color: UIColor) -> String {
		
		var r: CGFloat = 0
		var g: CGFloat = 0
		var b: CGFloat = 0
		var a: CGFloat = 0
		
		color.getRed(&r, green: &g, blue: &b, alpha: &a)
	
		let rgb: Int = (Int)(r*255)<<16 | (Int)(g*255)<<8 | (Int)(b*255)<<0
		
		return String(format: "#%06x", rgb)
		
	}
	
	public class func toColor(hex: String) -> UIColor {
		
		var c: String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
		
		if (c.hasPrefix("#")) {
			c.remove(at: c.startIndex)
		}
		
		if ((c.count) != 6) {
			return UIColor.gray
		}
		
		var rgbValue: UInt32 = 0
		Scanner(string: c).scanHexInt32(&rgbValue)
		
		return UIColor(red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
					   green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
					   blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
					   alpha: CGFloat(1.0))
		
	}
	
	
	// MARK: - Private Class Methods
	
	fileprivate class func randomCGFloat() -> CGFloat {
		
		return CGFloat(arc4random()) / CGFloat(UInt32.max)
	}
	
}
