//
//  GradientView.swift
//  SFView
//
//  Created by David on 27/09/2017.
//  Copyright © 2017 com.smartfoundation. All rights reserved.
//

import UIKit

/// A view class for a GradientView
public class GradientView: UIView {

	// MARK: - Private Stored Properties
	
	private let gradientLayer: CAGradientLayer = CAGradientLayer()
	
	
	// MARK: - Initializers
	
	public override init(frame: CGRect) {
		super.init(frame: frame)

	}
	
	required public init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)

	}
	
	
	// MARK: - Public Methods
	
	public func setup() {
		
		self.layer.masksToBounds	= true
		
		gradientLayer.colors		= [UIColor.black.cgColor, UIColor.clear.cgColor]
		gradientLayer.locations		= [0.0, 1.0]
		
		self.layer.mask = gradientLayer
		
	}
	
	
	// MARK: - Override Methods
	
	public override func awakeFromNib() {
		
		self.setup()
	}
	
	public override func layoutSublayers(of layer: CALayer) {
		super.layoutSublayers(of: layer)
		
		self.gradientLayer.frame = self.bounds
	}
	
}
