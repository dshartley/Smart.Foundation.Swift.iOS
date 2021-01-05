//
//  GridTileViewBase.swift
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

/// A view class for a GridTileViewBase
open class GridTileViewBase: UIView, ProtocolGridTileView {

	// MARK: - Private Stored Properties
	
	fileprivate var controlManager:							GridTileViewControlManager?

	
	// MARK: - Public Stored Properties
	
	public weak var delegate:								ProtocolGridTileViewDelegate?
	public fileprivate(set) var tileWrapper: 				TileWrapperBase = TileWrapperBase()

	@IBOutlet public weak var contentView:					UIView!
	@IBOutlet public weak var rotatableContainerView: 		UIView!
	@IBOutlet public weak var tileImageView: 				UIImageView!
	@IBOutlet var contentViewTapGestureRecognizer: 			UITapGestureRecognizer!

	
	// MARK: - Public Computed Properties
	
	public var gridTileProperties: GridTileProperties? {
		get {
			
			return self.controlManager?.gridTileProperties
			
		}
		set {
			
			self.controlManager!.gridTileProperties = newValue
			
			self.doAfterSetGridTileProperties()
			
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
		self.delegate?.gridTileView(touchesBegan: self)
		
	}

	
	// MARK: - Public Methods

	public func checkHitTest(point: CGPoint, withEvent event: UIEvent?) -> UIView? {
		
		// Check gestures enabled
		if (!self.rotatableContainerView.isUserInteractionEnabled || self.rotatableContainerView.isHidden || self.rotatableContainerView.alpha == 0) {
			
			return nil
			
		}
		
		let v: UIView? = self.rotatableContainerView
		
		// Check point inside
		if (!self.rotatableContainerView.point(inside: point, with: event)) {
			
			return nil
			
		}
		
		return v
		
	}
	
	public func checkHitTest(onTile point: CGPoint) -> ProtocolGridTileView? {
		
		guard (self.gridTileProperties!.canLongPressYN) else { return nil }
		
		// Check point inside
		if (!self.rotatableContainerView.point(inside: point, with: nil)) {
			
			return nil
			
		}
		
		return self
		
	}
	
	public func present() {

		guard (self.controlManager!.gridTileProperties != nil) else { return }
		
		self.setSize()
		self.setRotation()
		
	}
	
	public func set(tileWrapper: TileWrapperBase) {
		
		self.tileWrapper = tileWrapper
		
		// TODO: Set properties???
		
	}
	
	public func set(width: CGFloat, height: CGFloat) {
		
		// Set gridTileProperties
		self.gridTileProperties!.tileWidth 		= width
		self.gridTileProperties!.tileHeight 	= height
		
		self.setSize()
		
	}
	
	public func set(position: CellContentPositionTypes, positionFixToCellRotationYN: Bool) {
		
		self.gridTileProperties!.position 						= position
		self.gridTileProperties!.positionFixToCellRotationYN 	= positionFixToCellRotationYN
		
		// Notify the delegate
		self.delegate?.gridTileView(setPosition: self)
		
	}
	
	public func set(image: UIImage?, with imageName: String?) {
		
		self.tileWrapper.imageName 		= imageName ?? ""
		
		if (image != nil) {
			
			// Get imageData
			let imageData: 				Data? = ImageHelper.toPNGData(image: image!)
			
			self.tileWrapper.imageData 	= imageData
			
		} else {
			
			self.tileWrapper.imageData	= nil
			
		}
		
		self.tileImageView.image 	= image
		self.tileImageView.alpha 	= (image != nil) ? 1 : 0
		
	}
	
	public func set(canDragYN: Bool) {
		
		guard (self.gridTileProperties != nil) else { return }
		
		self.gridTileProperties!.canDragYN = canDragYN
		
	}
	
	public func set(canTapYN: Bool) {
		
		guard (self.gridTileProperties != nil) else { return }
		
		self.gridTileProperties!.canTapYN = canTapYN
		
		self.setContentViewTapGestureRecognizer()
		
	}
	
	public func set(canLongPressYN: Bool) {
		
		guard (self.gridTileProperties != nil) else { return }
		
		self.gridTileProperties!.canLongPressYN = canLongPressYN
		
	}

	public func set(tileAttributes: String) {

		self.tileWrapper.set(tileAttributesString: tileAttributes)
		
	}
	
	public func set(attribute key: String, value: String?) {
		
		// Create propertyChangedWrapper
		let pcw: 		CellPropertyChangedWrapper = CellPropertyChangedWrapper(type: .Attribute, key: key)
		pcw.newValue 	= value
		pcw.oldValue 	= self.tileWrapper.tileAttributesWrapper.get(attribute: key)
		
		// Set attribute
		self.tileWrapper.tileAttributesWrapper.set(attribute: key, value: value)
		
		// Refresh attributes string
		self.tileWrapper.refreshTileAttributesString()
		
		// Notify the delegate
		self.delegate?.gridTileView(propertyChanged: pcw, cellCoord: self.gridTileProperties!.cellCoord!, with: self)

	}
	
	public func set(tileSideAttributes: String) {
		
		self.tileWrapper.set(tileSideAttributesString: tileSideAttributes)
		
	}
	
	public func set(attribute key: String, value: String?, forSide side: CellSideTypes) {
		
		// Get true degrees
		let trueDegrees: 	Int = GridScapeHelper.toTrueDegrees(from: side, withRotation: self.controlManager!.gridTileProperties!.rotationDegrees)
		
		// Create propertyChangedWrapper
		let pcw: 			CellPropertyChangedWrapper = CellPropertyChangedWrapper(type: .SideAttribute, side: side, key: key)
		pcw.newValue 		= value
		pcw.oldValue 		= self.tileWrapper.tileSideAttributesWrapper.get(attribute: key, forSideByTrueDegrees: trueDegrees)
		
		// Set attribute
		self.tileWrapper.tileSideAttributesWrapper.set(attribute: key, value: value, forSideByTrueDegrees: trueDegrees)
		
		// Refresh attributes string
		self.tileWrapper.refreshTileSideAttributesString()
		
		// Notify the delegate
		self.delegate?.gridTileView(propertyChanged: pcw, cellCoord: self.gridTileProperties!.cellCoord!, with: self)
		
	}
	
	public func get(attribute key: String) -> String? {
		
		var result: 	String? = nil
		
		result 			= self.tileWrapper.tileAttributesWrapper.get(attribute: key)
		
		return result
		
	}
	
	public func get(attribute key: String, forSide side: CellSideTypes) -> String? {
		
		var result: 		String? = nil
		
		// Get true degrees
		let trueDegrees: 	Int = GridScapeHelper.toTrueDegrees(from: side, withRotation: self.controlManager!.gridTileProperties!.rotationDegrees)
		
		result 				= self.tileWrapper.tileSideAttributesWrapper.get(attribute: key, forSideByTrueDegrees: trueDegrees)
		
		return result
		
	}
	
	public func get(tileSideAttributes side: CellSideTypes) -> [String: String] {
		
		var result: 		[String: String] = [String: String]()
		
		// Get true degrees
		let trueDegrees: 	Int = GridScapeHelper.toTrueDegrees(from: side, withRotation: self.controlManager!.gridTileProperties!.rotationDegrees)
		
		// Get tileWrapper side attributes
		let twtsa: 			[String: String] = self.tileWrapper.tileSideAttributesWrapper.get(forSideByTrueDegrees: trueDegrees)
		
		// Merge to result
		result 				= result.merging(twtsa) { (_, new) in new }

		if (self.tileWrapper.tileTypeWrapper != nil) {
			
			// Get tileTypeWrapper side attributes
			let ttwtsa: 	[String: String] = self.tileWrapper.tileTypeWrapper!.tileSideAttributesWrapper.get(forSideByTrueDegrees: trueDegrees)
			
			// Merge to result
			result 			= result.merging(ttwtsa) { (_, new) in new }
			
		}
		
		return result
		
	}
	
	public func rotateRight() {
		
		// Create propertyChangedWrapper
		let pcw: 	CellPropertyChangedWrapper = CellPropertyChangedWrapper(type: .Property, key: "\(GridCellPropertyKeys.rotationDegrees)")
		
		// Get gridTileProperties
		let gtp: 	GridTileProperties = self.gridTileProperties!
		
		gtp.rotationDegrees += 90
		
		if (gtp.rotationDegrees >= 360) { gtp.rotationDegrees = 0 }
		
		self.setRotation()
		
		// Notify the delegate
		self.delegate?.gridTileView(propertyChanged: pcw, cellCoord: self.gridTileProperties!.cellCoord!, with: self)
		
	}

	public func rotateLeft() {
		
		// Create propertyChangedWrapper
		let pcw: 	CellPropertyChangedWrapper = CellPropertyChangedWrapper(type: .Property, key: "\(GridCellPropertyKeys.rotationDegrees)")
		
		// Get gridTileProperties
		let gtp: 	GridTileProperties = self.gridTileProperties!
		
		gtp.rotationDegrees -= 90
		
		if (gtp.rotationDegrees < 0) { gtp.rotationDegrees = 270 }
		
		self.setRotation()
		
		// Notify the delegate
		self.delegate?.gridTileView(propertyChanged: pcw, cellCoord: self.gridTileProperties!.cellCoord!, with: self)
		
	}
	
	
	// MARK: - Open [Overridable] Methods
	
	open func setupContentView() {
		
		// Load xib
		let frameworkBundle: 			Bundle = Bundle(for: GridScapeView.self)
		frameworkBundle.loadNibNamed("GridTileViewBase", owner: self, options: nil)
		
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
	
	open func spawn(frame: CGRect) -> ProtocolGridTileView {
		
		// Override
		
		let result: ProtocolGridTileView = GridTileViewBase(frame: frame)
		
		return result
		
	}
	
	open func clone() -> ProtocolGridTileView {
		
		// Create clone
		var result: 	ProtocolGridTileView = self.spawn(frame: CGRect(x: self.frame.minX, y: self.frame.minY, width: self.frame.width, height: self.frame.height))
		
		// gridTileProperties
		result.gridTileProperties 		= self.gridTileProperties?.copy()
		
		// delegate
		result.delegate 				= self.delegate
		
		result.set(tileWrapper: self.tileWrapper)
		
		// TODO: tokenViews
		
		// image
		result.set(image: self.tileImageView.image, with: self.tileWrapper.imageName)
		
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
		self.controlManager 			= GridTileViewControlManager()
		
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
		let viewAccessStrategy: GridTileViewViewAccessStrategy = GridTileViewViewAccessStrategy()
		
		viewAccessStrategy.setup()
		
		// Setup the view manager
		self.controlManager!.viewManager = GridTileViewViewManager(viewAccessStrategy: viewAccessStrategy)
	}
	
	fileprivate func setupView() {

		self.tileImageView.alpha = 0
		
	}
	
	fileprivate func doAfterSetGridTileProperties() {
		
		guard (self.gridTileProperties != nil) else { return }
		
		self.setContentViewTapGestureRecognizer()

	}
	
	fileprivate func setContentViewTapGestureRecognizer() {
		
		// Set contentViewTapGestureRecognizer
		self.contentViewTapGestureRecognizer.isEnabled = self.gridTileProperties!.canTapYN
		
	}
	
	fileprivate func setSize() {
	
		guard (self.controlManager != nil && self.controlManager!.gridTileProperties != nil) else { return }
		
		// Get playGridTileProperties
		let p: 	GridTileProperties = self.controlManager!.gridTileProperties!
		
		// Set constraints
		self.widthAnchor.constraint(equalToConstant: p.tileWidth).isActive 	= true
		self.heightAnchor.constraint(equalToConstant: p.tileHeight).isActive = true
		
		// Set frame size
		self.frame.size = CGSize(width: p.tileWidth, height: p.tileHeight)
		
		// Notify the delegate
		self.delegate?.gridTileView(setPosition: self)
		
	}

	fileprivate func setRotation() {
		
		// Get degrees
		let degrees: 	CGFloat = CGFloat(GridScapeHelper.toValidRotation(rotation: self.gridTileProperties!.rotationDegrees))
		
		//let radians
		let radians:	CGFloat = MathHelper.toRadians(degrees: degrees)
		
		// Create transform
		let transform: 	CGAffineTransform = CGAffineTransform(rotationAngle: radians)
		
		self.rotatableContainerView.transform = transform
		
	}
	
	
	// MARK: - contentView TapGestureRecognizer Methods
	
	@IBAction func contentViewTapped(_ sender: Any) {

		guard (self.gridTileProperties!.canTapYN) else { return }
		
		let sender = sender as! UITapGestureRecognizer
		
		// Notify the delegate
		self.delegate?.gridTileView(for: sender, tapped: self)
		
	}
	
}

// MARK: - Extension ProtocolGridTileViewControlManagerDelegate

extension GridTileViewBase: ProtocolGridTileViewControlManagerDelegate {
	
	// MARK: - Public Methods
	
}



