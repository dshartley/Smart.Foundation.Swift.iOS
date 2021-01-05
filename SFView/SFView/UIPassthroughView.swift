//
//  UIPassthroughView.swift
//  SFView
//
//  Created by David on 27/10/2018.
//  Copyright © 2018 com.smartfoundation. All rights reserved.
//

import UIKit

public class UIPassthroughView: UIView {

	public override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
		
		let hitView = super.hitTest(point, with: event)
		
		return hitView == self ? nil : hitView
		
	}
}
