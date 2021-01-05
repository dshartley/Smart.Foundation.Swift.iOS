//
//  GridTokenViewBase.swift
//  SFGridScape
//
//  Created by David on 15/11/2017.
//  Copyright © 2017 com.smartfoundation. All rights reserved.
//

import UIKit
import SFView
import SFCore
import SFSerialization
import SFGraphics

/// A view class for a GridTokenViewBase
open class GridTokenViewBase: UIView, ProtocolGridTokenView {
	
	// MARK: - Private Stored Properties
	
	fileprivate var controlManager:							GridTokenViewControlManager?

	
	// MARK: - Public Stored Properties
	
	public weak var delegate:								ProtocolGridTokenViewDelegate?
	public fileprivate(set) var tokenWrapper: 				TokenWrapperBase = TokenWrapperBase()

	@IBOutlet public weak var contentView:					UIView!
	@IBOutlet public weak var containerView: 				UIView!
	@IBOutlet public weak var tokenImageView: 				UIImageView!
	@IBOutlet var contentViewTapGestureRecognizer: 			UITapGestureRecognizer!

	
	// MARK: - Public Computed Properties
	
	public var gridTokenProperties: GridTokenProperties? {
		get {
			
			return self.controlManager?.gridTokenProperties
			
		}
		set {
			
			self.controlManager!.gridTokenProperties = newValue
			
			self.doAfterSetGridTokenProperties()
			
		}
	}


	// MARK: - Initializers
	
	fileprivate convenience init(frame: CGRect, id: UUID) {
		self.init(frame: frame)
		
	}
	
	public override init(frame: CGRect) {
		super.init(frame: frame)
		
		self.setupContentView()
		
		self.setup()
		self.setupView()
		
	}
	
	public init(frame: CGRect, s: String) {
		super.init(frame: frame)
		
		self.setup()
		
	}
	
	required public init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		
		self.setupContentView()
		
		self.setup()
		self.setupView()
		
	}
	
	
	// MARK: - Override Methods
	
	open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		
		// Notify the delegate
		self.delegate?.gridTokenView(touchesBegan: self)
		
	}

	
	// MARK: - Public Methods

	public func checkHitTest(point: CGPoint, withEvent event: UIEvent?) -> UIView? {
		
		// Check gestures enabled
		if (!self.containerView.isUserInteractionEnabled || self.containerView.isHidden || self.containerView.alpha == 0) {
			
			return nil
			
		}
		
		let v: UIView? = self.containerView
		
		// Check point inside
		if (!self.containerView.point(inside: point, with: event)) {
			
			return nil
			
		}
		
		return v
		
	}
	
	public func checkHitTest(onToken point: CGPoint) -> ProtocolGridTokenView? {
		
		guard (self.gridTokenProperties!.canLongPressYN) else { return nil }
		
		// Check point inside
		if (!self.containerView.point(inside: point, with: nil)) {
			
			return nil
			
		}
		
		return self
		
	}
	
	public func present() {

		guard (self.controlManager!.gridTokenProperties != nil) else { return }
		
		self.setSize()

	}
	
	public func set(tokenWrapper: TokenWrapperBase) {
		
		self.tokenWrapper = tokenWrapper
		
		// TODO: Set properties???
		
	}
	
	public func set(canDragYN: Bool) {
		
		guard (self.gridTokenProperties != nil) else { return }
		
		self.gridTokenProperties!.canDragYN = canDragYN
		
	}
	
	public func set(canTapYN: Bool) {
		
		guard (self.gridTokenProperties != nil) else { return }
		
		self.gridTokenProperties!.canTapYN = canTapYN
		
		self.setContentViewTapGestureRecognizer()
		
	}
	
	public func set(canLongPressYN: Bool) {
		
		guard (self.gridTokenProperties != nil) else { return }
		
		self.gridTokenProperties!.canLongPressYN = canLongPressYN
		
	}
	
	public func set(image: UIImage?, with imageName: String?) {
		
		self.tokenWrapper.imageName 		= imageName ?? ""
		
		if (image != nil) {
			
			// Get imageData
			let imageData: 				Data? = ImageHelper.toPNGData(image: image!)
			
			self.tokenWrapper.imageData 	= imageData
			
		} else {
			
			self.tokenWrapper.imageData	= nil
			
		}
		
		self.tokenImageView.image 	= image
		self.tokenImageView.alpha 	= (image != nil) ? 1 : 0
		
	}
	
	public func set(tokenAttributes: String) {
		
		self.tokenWrapper.set(tokenAttributesString: tokenAttributes)
		
	}
	
	public func set(attribute key: String, value: String?) {
		
		// Create propertyChangedWrapper
		let pcw: 		CellPropertyChangedWrapper = CellPropertyChangedWrapper(type: .Attribute, key: key)
		pcw.newValue 	= value
		pcw.oldValue 	= self.tokenWrapper.tokenAttributesWrapper.get(attribute: key)
		
		// Set attribute
		self.tokenWrapper.tokenAttributesWrapper.set(attribute: key, value: value)
		
		// Refresh attributes string
		self.tokenWrapper.refreshTokenAttributesString()
		
		// Notify the delegate
		self.delegate?.gridTokenView(propertyChanged: pcw, cellCoord: self.gridTokenProperties!.cellCoord!, with: self)

	}
	
	public func get(attribute key: String) -> String? {
		
		var result: 	String? = nil
		
		result 			= self.tokenWrapper.tokenAttributesWrapper.get(attribute: key)
		
		return result
		
	}
	
	
	// MARK: - Open [Overridable] Methods
	
	open func setupContentView() {
		
		// Load xib
		let frameworkBundle: 			Bundle = Bundle(for: GridScapeView.self)
		frameworkBundle.loadNibNamed("GridTokenViewBase", owner: self, options: nil)
		
		addSubview(contentView)
		
		self.layoutIfNeeded()
		
		// Position the contentView to fill the view
		contentView.frame				= self.bounds
		contentView.autoresizingMask	= [.flexibleHeight, .flexibleWidth]
	}
	
	open func viewDidAppear() {
		
	}
	
	open func clearView() {
		
		self.delegate = nil
		
	}
	
	open func isCompatible(with neighbour: GridCellNeighbour, neighbours: [GridCellNeighbour]) -> Bool {
		
		let result: Bool = true
		
		// Nb: Implementation should override
		
		return result
		
	}
	
	open func isCompatible(with neighbours: [GridCellNeighbour]) -> Bool {
		
		let result: Bool = true
		
		// Nb: Implementation should override
		
		//if (neighbours.count == 0) { result = false }
		
		return result
		
	}
	
	open func spawn(frame: CGRect) -> ProtocolGridTokenView {
		
		// Override
		
		let result: ProtocolGridTokenView = GridTokenViewBase(frame: frame)
		
		return result
		
	}
	
	open func clone() -> ProtocolGridTokenView {
		
		// Create clone
		var result: 	ProtocolGridTokenView = self.spawn(frame: CGRect(x: self.frame.minX, y: self.frame.minY, width: self.frame.width, height: self.frame.height))
		
		// gridTokenProperties
		result.gridTokenProperties 		= self.gridTokenProperties?.copy()
		
		// delegate
		result.delegate 				= self.delegate
		
		result.set(tokenWrapper: self.tokenWrapper)
		
		// TODO: tokenViews
		
		// image
		result.set(image: self.tokenImageView.image, with: self.tokenWrapper.imageName)
		
		// present
		result.present()
		
		return result
		
	}
	
	
	// MARK: - Private Methods
	
	fileprivate func setup() {
		
		self.setupControlManager()
		self.setupModelManager()
		self.setupViewManager()
	}
	
	fileprivate func setupControlManager() {
		
		// Setup the control manager
		self.controlManager 			= GridTokenViewControlManager()
		
		self.controlManager!.delegate 	= self
		
	}
	
	fileprivate func setupModelManager() {
		
		// Set the model manager
		//self.controlManager!.set(modelManager: ModelFactory.modelManager)
		
		// Setup the model administrators
		//ModelFactory.setupUserProfileModelAdministrator(modelManager: self.controlManager!.modelManager! as! ModelManager)
	}
	
	fileprivate func setupViewManager() {
		
		// Create view strategy
		let viewAccessStrategy: GridTokenViewViewAccessStrategy = GridTokenViewViewAccessStrategy()
		
		viewAccessStrategy.setup()
		
		// Setup the view manager
		self.controlManager!.viewManager = GridTokenViewViewManager(viewAccessStrategy: viewAccessStrategy)
	}
	
	fileprivate func setupView() {

		self.tokenImageView.alpha = 0
		
	}
	
	fileprivate func doAfterSetGridTokenProperties() {
		
		guard (self.gridTokenProperties != nil) else { return }
		
		self.setContentViewTapGestureRecognizer()
		
	}
	
	fileprivate func setContentViewTapGestureRecognizer() {
		
		// Set contentViewTapGestureRecognizer
		self.contentViewTapGestureRecognizer.isEnabled = self.gridTokenProperties!.canTapYN
		
	}
		
	fileprivate func setSize() {
	
		guard (self.controlManager != nil && self.controlManager!.gridTokenProperties != nil) else { return }
		
		// Get playGridTokenProperties
		let p: 	GridTokenProperties = self.controlManager!.gridTokenProperties!
		
		// Set constraints
		self.widthAnchor.constraint(equalToConstant: p.tokenWidth).isActive 	= true
		self.heightAnchor.constraint(equalToConstant: p.tokenHeight).isActive = true
		
		// Set frame size
		self.frame.size = CGSize(width: p.tokenWidth, height: p.tokenHeight)
		
	}

	
	// MARK: - contentView TapGestureRecognizer Methods
	
	@IBAction func contentViewTapped(_ sender: Any) {

		guard (self.gridTokenProperties!.canTapYN) else { return }
		
		let sender = sender as! UITapGestureRecognizer
		
		// Notify the delegate
		self.delegate?.gridTokenView(for: sender, tapped: self)
		
	}
	
}

// MARK: - Extension ProtocolGridTokenViewControlManagerDelegate

extension GridTokenViewBase: ProtocolGridTokenViewControlManagerDelegate {
	
	// MARK: - Public Methods
	
}



