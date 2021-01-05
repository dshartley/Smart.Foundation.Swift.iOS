//
//  GridCellViewBase.swift
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

/// A view class for a GridCellViewBase
open class GridCellViewBase: UIView, ProtocolGridCellView {

	// MARK: - Private Stored Properties
	
	fileprivate var controlManager:							GridCellViewControlManager?

	
	// MARK: - Public Stored Properties
	
	public fileprivate(set) weak var delegate:				ProtocolGridCellViewDelegate?
	public fileprivate(set) var id: 						UUID = UUID()
	public fileprivate(set) var cellWrapper: 				CellWrapperBase = CellWrapperBase()
	public fileprivate(set) var tileViews:					[String: ProtocolGridTileView] = [String: ProtocolGridTileView]()
	public fileprivate(set) var tokenViews:					[String: ProtocolGridTokenView] = [String: ProtocolGridTokenView]()
	public fileprivate(set)	var isPresentedYN:				Bool = false

	@IBOutlet public weak var contentView:					UIView!
	@IBOutlet public weak var highlightFilterView: 			UIView!
	@IBOutlet public weak var gridTilesView: 				UIView!
	@IBOutlet public weak var gridTokensView: 				UIView!
	@IBOutlet public weak var rotatableContainerView: 		UIView!
	@IBOutlet public weak var cellImageView: 				UIImageView!
	@IBOutlet var contentViewTapGestureRecognizer: 			UITapGestureRecognizer!

	
	// MARK: - Public Computed Properties
	
	public var gridCellProperties: GridCellProperties? {
		get {
			
			return self.controlManager?.gridCellProperties
			
		}
		set {
			
			self.controlManager!.gridCellProperties = newValue
			
			self.doAfterSetGridCellProperties()
			
		}
	}

	public var isHighlighted: Bool {
		get {
			
			return self.controlManager!.isHighlightedYN
			
		}
		set {
			
			self.set(highlight: newValue)
			
		}
	}
	
	
	// MARK: - Initializers
	
	public init(frame: CGRect, id: UUID) {
		super.init(frame: frame)
		
		self.id = id
		
		self.setupContentView()
		
		self.setup()
		self.setupView()
		
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
		self.delegate?.gridCellView(touchesBegan: self)
		
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
		
		// Nb: Check whether to handle the event in subviews

		// Go through each tokenView
		for tokenView in self.gridTokensView.subviews.reversed() {
			
			if let tokenView = tokenView as? GridTokenViewBase {
				
				// Convert to point inside tokenView
				let tokenViewPoint = self.gridTokensView.convert(point, to: tokenView)
				
				// Get subView from tokenView
				if let sv = tokenView.checkHitTest(point: tokenViewPoint, withEvent: event) {
					
					return sv
					
				}
				
			}
			
		}
		
		// Go through each tileView
		for tileView in self.gridTilesView.subviews.reversed() {
			
			if let tileView = tileView as? GridTileViewBase {
				
				// Convert to point inside tileView
				let tileViewPoint = self.gridTilesView.convert(point, to: tileView)
				
				// Get subView from tileView
				if let sv = tileView.checkHitTest(point: tileViewPoint, withEvent: event) {
					
					return sv
					
				}
				
			}
			
		}
		
		return v
		
	}
	
	public func checkHitTest(onCell point: CGPoint) -> ProtocolGridCellView? {
		
		guard (self.gridCellProperties!.canLongPressYN) else { return nil }
		
		// Check point inside
		if (!self.rotatableContainerView.point(inside: point, with: nil)) {
			
			return nil
			
		}
		
		return self
		
	}
	
	public func checkHitTest(onTile point: CGPoint) -> ProtocolGridTileView? {
		
		var result: ProtocolGridTileView? = nil
		
		// Go through each item
		for tv in self.tileViews.values {
		
			// Convert to point inside tileView
			let tileViewPoint = self.gridTilesView.convert(point, to: tv as! UIView)
			
			result = tv.checkHitTest(onTile: tileViewPoint)
			
		}
		
		return result
		
	}
	
	public func checkHitTest(onToken point: CGPoint) -> ProtocolGridTokenView? {
		
		var result: ProtocolGridTokenView? = nil
		
		// Go through each item
		for tv in self.tokenViews.values {
			
			// Convert to point inside tokenView
			let tokenViewPoint = self.gridTokensView.convert(point, to: tv as! UIView)
			
			result = tv.checkHitTest(onToken: tokenViewPoint)
			
		}
		
		return result
		
	}
	
	public func present() {

		guard (self.controlManager!.gridCellProperties != nil) else { return }
		
		self.setSize()
		self.setRotation()
		self.setBackgroundColor()
		self.setBorder()
		self.setTileViews()
		self.setTokenViews()
		self.setHighlight()
		
		self.isPresentedYN = true
		
	}
	
	public func set(cellWrapper: CellWrapperBase) {
		
		self.cellWrapper = cellWrapper
		
		// TODO: Set properties???
		
	}
	
	public func set(delegate: ProtocolGridCellViewDelegate?) {
		
		self.delegate = delegate
		
		guard (self.delegate != nil) else { return }
		
		// Get tileViewDelegate
		let tileViewDelegate: ProtocolGridTileViewDelegate? = self.delegate?.gridCellView(getTileViewDelegate: self)
		
		guard (tileViewDelegate != nil) else { return }
		
		// Go through each item
		for tileView in self.tileViews.values {
			
			var tileView = tileView
			
			tileView.delegate = tileViewDelegate
			
		}
		
		// Get tokenViewDelegate
		let tokenViewDelegate: ProtocolGridTokenViewDelegate? = self.delegate?.gridCellView(getTokenViewDelegate: self)
		
		guard (tokenViewDelegate != nil) else { return }
		
		// Go through each item
		for tokenView in self.tokenViews.values {
			
			var tokenView = tokenView
			
			tokenView.delegate = tokenViewDelegate
			
		}
		
	}
	
	public func set(canDragYN: Bool) {
		
		guard (self.gridCellProperties != nil) else { return }
		
		self.gridCellProperties!.canDragYN = canDragYN
		
	}
	
	public func set(canTapYN: Bool) {
		
		guard (self.gridCellProperties != nil) else { return }
		
		self.gridCellProperties!.canTapYN = canTapYN
		
		self.setContentViewTapGestureRecognizer()
		
	}
	
	public func set(canLongPressYN: Bool) {
		
		guard (self.gridCellProperties != nil) else { return }
		
		self.gridCellProperties!.canLongPressYN = canLongPressYN

	}
	
	public func set(image: UIImage?, with imageName: String?) {
		
		self.cellWrapper.imageName 		= imageName ?? ""
		
		if (image != nil) {
			
			// Get imageData
			let imageData: 				Data? = ImageHelper.toPNGData(image: image!)
			
			self.cellWrapper.imageData 	= imageData
			
		} else {
			
			self.cellWrapper.imageData	= nil
			
		}
		
		self.cellImageView.image 	= image
		self.cellImageView.alpha 	= (image != nil) ? 1 : 0
		
	}
	
	public func set(cellAttributes: String) {
		
		self.cellWrapper.set(cellAttributesString: cellAttributes)

	}
	
	public func set(attribute key: String, value: String?) {
		
		// Create propertyChangedWrapper
		let pcw: 		CellPropertyChangedWrapper = CellPropertyChangedWrapper(type: .Attribute, key: key)
		pcw.newValue 	= value
		pcw.oldValue 	= self.cellWrapper.cellAttributesWrapper.get(attribute: key)
	
		// Set attribute
		self.cellWrapper.cellAttributesWrapper.set(attribute: key, value: value)
		
		// Refresh attributes string
		self.cellWrapper.refreshCellAttributesString()
		
		// Notify the delegate
		self.delegate?.gridCellView(propertyChanged: pcw, cellCoord: self.gridCellProperties!.cellCoord!, with: self)
		
	}
	
	public func set(cellSideAttributes: String) {
		
		self.cellWrapper.set(cellSideAttributesString: cellSideAttributes)
		
	}
	
	public func set(attribute key: String, value: String?, forSide side: CellSideTypes) {
		
		// Get true degrees
		let trueDegrees: 	Int = GridScapeHelper.toTrueDegrees(from: side, withRotation: self.controlManager!.gridCellProperties!.rotationDegrees)
		
		// Create propertyChangedWrapper
		let pcw: 			CellPropertyChangedWrapper = CellPropertyChangedWrapper(type: .SideAttribute, side: side, key: key)
		pcw.newValue 		= value
		pcw.oldValue 		= self.cellWrapper.cellSideAttributesWrapper.get(attribute: key, forSideByTrueDegrees: trueDegrees)
		
		// Set attribute
		self.cellWrapper.cellSideAttributesWrapper.set(attribute: key, value: value, forSideByTrueDegrees: trueDegrees)
		
		// Refresh attributes string
		self.cellWrapper.refreshCellSideAttributesString()
		
		// Notify the delegate
		self.delegate?.gridCellView(propertyChanged: pcw, cellCoord: self.gridCellProperties!.cellCoord!, with: self)
		
	}
	
	public func get(attribute key: String) -> String? {
		
		var result: 	String? = nil
		
		result 			= self.cellWrapper.cellAttributesWrapper.get(attribute: key)
		
		return result
		
	}
	
	public func get(attribute key: String, forSide side: CellSideTypes) -> String? {
		
		var result: 		String? = nil
		
		// Get true degrees
		let trueDegrees: 	Int = GridScapeHelper.toTrueDegrees(from: side, withRotation: self.controlManager!.gridCellProperties!.rotationDegrees)
	
		result 				= self.cellWrapper.cellSideAttributesWrapper.get(attribute: key, forSideByTrueDegrees: trueDegrees)
		
		return result
		
	}
	
	public func get(cellSideAttributes side: CellSideTypes) -> [String: String] {
		
		var result: 		[String: String] = [String: String]()
		
		// Get true degrees
		let trueDegrees: 	Int = GridScapeHelper.toTrueDegrees(from: side, withRotation: self.controlManager!.gridCellProperties!.rotationDegrees)
		
		// Get cellWrapper side attributes
		let cwcsa: 			[String: String] = self.cellWrapper.cellSideAttributesWrapper.get(forSideByTrueDegrees: trueDegrees)
		
		// Merge to result
		result 				= result.merging(cwcsa) { (_, new) in new }

		if (self.cellWrapper.cellTypeWrapper != nil) {

			// Get cellTypeWrapper side attributes
			let ctwcsa: 	[String: String] = self.cellWrapper.cellTypeWrapper!.cellSideAttributesWrapper.get(forSideByTrueDegrees: trueDegrees)
			
			// Merge to result
			result 			= result.merging(ctwcsa) { (_, new) in new }
			
		}
		
		return result
		
	}
	
	public func rotateRight() {
		
		// Get gridCellProperties
		let gcp: 	GridCellProperties = self.gridCellProperties!
		
		// Create propertyChangedWrapper
		let pcw: 	CellPropertyChangedWrapper = CellPropertyChangedWrapper(type: .Property, key: "\(GridCellPropertyKeys.rotationDegrees)")
		pcw.oldValue = "\(gcp.rotationDegrees)"
		
		gcp.rotationDegrees += 90
		
		if (gcp.rotationDegrees >= 360) { gcp.rotationDegrees = 0 }
		
		pcw.newValue = "\(gcp.rotationDegrees)"
		
		self.setRotation()
		self.setTileViewPositionsAfterRotation()
		
		// Notify the delegate
		self.delegate?.gridCellView(propertyChanged: pcw, cellCoord: self.gridCellProperties!.cellCoord!, with: self)
		
	}

	public func rotateLeft() {
		
		// Get gridCellProperties
		let gcp: 	GridCellProperties = self.gridCellProperties!
		
		// Create propertyChangedWrapper
		let pcw: 	CellPropertyChangedWrapper = CellPropertyChangedWrapper(type: .Property, key: "\(GridCellPropertyKeys.rotationDegrees)")
		pcw.oldValue = "\(gcp.rotationDegrees)"

		gcp.rotationDegrees -= 90
		
		if (gcp.rotationDegrees < 0) { gcp.rotationDegrees = 270 }
		
		pcw.newValue = "\(gcp.rotationDegrees)"
		
		self.setRotation()
		self.setTileViewPositionsAfterRotation()
		
		// Notify the delegate
		self.delegate?.gridCellView(propertyChanged: pcw, cellCoord: self.gridCellProperties!.cellCoord!, with: self)
		
	}
	
	public func present(tileView: ProtocolGridTileView) {
		
		// Get tileView
		let tv: 				ProtocolGridTileView? = self.get(tileView: tileView.gridTileProperties!.key)
		
		guard (tv == nil) else { return }
		
		// Check can set position
		let canSetPositionYN: 	Bool = self.canSet(tileView: tileView, at: tileView.gridTileProperties!.position)
		
		guard (canSetPositionYN) else { return }
		
		var tileView: 			ProtocolGridTileView = tileView
		
		tileView.delegate 		= self.delegate?.gridCellView(getTileViewDelegate: self)
		
		// Set gridTileProperties
		if (tileView.gridTileProperties == nil) {
			
			tileView.gridTileProperties = GridTileProperties(cellCoord: self.gridCellProperties!.cellCoord!)
			
		}
		
		let gtp: 				GridTileProperties = tileView.gridTileProperties!
		
		if (gtp.tileHeight == 0) {
			
			gtp.tileHeight 		= self.gridCellProperties!.cellHeight
			
		}
		
		if (gtp.tileWidth == 0) {
			
			gtp.tileWidth 		= self.gridCellProperties!.cellWidth
			
		}
		
		// Get positionPoint
		let positionPoint: 		CGPoint = self.getPositionPoint(for: tileView)
		
		// Get frame
		let f: 					CGRect = (tileView as! UIView).frame
		
		(tileView as! UIView).frame = CGRect(x: positionPoint.x, y: positionPoint.y, width: f.width, height: f.height)
		
		DispatchQueue.main.async {
			
			tileView.present()
			
			// Add to view
			self.gridTilesView.addSubview((tileView as! UIView))
			
			self.gridTilesView!.layoutIfNeeded()
			
		}
		
		// Set in collection
		self.set(tileView: tileView)
		
	}
	
	public func setPosition(tileView: ProtocolGridTileView) {
		
		// Get tileView
		let tv: 			ProtocolGridTileView? = self.get(tileView: tileView.gridTileProperties!.key)
		
		guard (tv != nil) else { return }
		
		// Get positionPoint
		let positionPoint: 	CGPoint = self.getPositionPoint(for: tileView)
		
		DispatchQueue.main.async {
			
			(tileView as! UIView).frame.origin.x 		= positionPoint.x
			(tileView as! UIView).frame.origin.y 		= positionPoint.y
			
			self.layoutIfNeeded()
			self.gridTilesView!.layoutIfNeeded()
			
		}
		
	}

	public func canSet(tileView: ProtocolGridTileView, at position: CellContentPositionTypes) -> Bool {
	
		// Nb: Check current tileViews to see if position is used. Look at all available positions in cell and cellType and check position not blocked
		
		guard (position != .Unspecified) else { return true }
		
		var result: Bool = true
		
		// Go through each item
		for tv in self.tileViews.values {
			
			// Check position
			if (tv.gridTileProperties!.position == position) {
				
				return false
				
			}
			
		}

		// Get cellTypeWrapper, blockedContentPositions
		if let ctw = self.cellWrapper.cellTypeWrapper, let bcp = ctw.blockedContentPositions {

			// Check blockedContentPositions
			if (bcp.contains(position)) { result = false }
			
		}
		
		return result
		
	}
	
	public func get(positionFor tileView: ProtocolGridTileView) -> CellContentPositionTypes? {
		
		// Nb: Get all positions used for existing tileViews. Get all blocked positions in cell and cellType. If tileView position .Unspecified then return next available position. If not .Unspecified and is in the blocked positions list then return nil.

		let tvp: 						CellContentPositionTypes = tileView.tileWrapper.position
		
		// Get blockedContentPositions
		let blockedContentPositions: 	[CellContentPositionTypes] = self.getBlockedContentPositions()

		// Check if tileView position in blockedContentPositions
		if (tvp == .Unspecified) {
			
			// Get nextAvailablePosition
			let nextAvailablePosition: 	CellContentPositionTypes? = self.getNextAvailableContentPosition(blockedContentPositions: blockedContentPositions)
			
			return nextAvailablePosition
			
		}
		
		// Check if tileView position in blockedContentPositions
		if (blockedContentPositions.contains(tvp)) {
			
			return nil
			
		}
	
		return tvp
		
	}
	
	public func get(tileView key: String?) -> ProtocolGridTileView? {
		
		var result: 	ProtocolGridTileView? = nil
		
		guard (self.tileViews.count > 0) else { return nil }
		
		if (key != nil) {
			
			result = self.tileViews[key!]
			
		} else {
			
			result = self.tileViews.values.first
			
		}
		
		return result
		
	}
	
	public func hide(tileView key: String?) {
		
		// Get tileView
		var tileView: ProtocolGridTileView? = self.get(tileView: key)
		
		guard (tileView != nil) else { return }
		
		DispatchQueue.main.async {
			
			(tileView as! UIView).removeFromSuperview()
			
			self.gridTilesView!.layoutIfNeeded()
			
		}
		
		tileView!.clearView()
		
		tileView!.delegate = nil
		
		// Remove from collection
		self.remove(tileView: tileView!)
		
	}

	public func present(tokenView: ProtocolGridTokenView) {
		
		// Get tokenView
		let tv: 	ProtocolGridTokenView? = self.get(tokenView: tokenView.gridTokenProperties!.key)
		
		guard (tv == nil) else { return }
		
		var tokenView: ProtocolGridTokenView = tokenView
		
		tokenView.delegate 	= self.delegate?.gridCellView(getTokenViewDelegate: self)
		
		// Set gridTokenProperties
		if (tokenView.gridTokenProperties == nil) {
			
			tokenView.gridTokenProperties = GridTokenProperties(cellCoord: self.gridCellProperties!.cellCoord!)
			
		}
		
		let gtp: 		GridTokenProperties = tokenView.gridTokenProperties!
		
		gtp.tokenHeight 	= self.gridCellProperties!.cellHeight
		gtp.tokenWidth 	= self.gridCellProperties!.cellWidth
		
		// Get frame
		let f: CGRect = (tokenView as! UIView).frame
		
		(tokenView as! UIView).frame = CGRect(x: 0, y: 0, width: f.width, height: f.height)
		
		DispatchQueue.main.async {
			
			tokenView.present()
			
			// Add to view
			self.gridTokensView.addSubview((tokenView as! UIView))
			
			self.gridTokensView!.layoutIfNeeded()
			
		}
		
		// Set in collection
		self.set(tokenView: tokenView)
		
	}
	
	public func get(tokenView key: String?) -> ProtocolGridTokenView? {
		
		var result: 	ProtocolGridTokenView? = nil
		
		guard (self.tokenViews.count > 0) else { return nil }
		
		if (key != nil) {
			
			result = self.tokenViews[key!]
			
		} else {
			
			result = self.tokenViews.values.first
			
		}
		
		return result
		
	}
	
	public func hide(tokenView key: String?) {
		
		// Get tokenView
		var tokenView: ProtocolGridTokenView? = self.get(tokenView: key)
		
		guard (tokenView != nil) else { return }
		
		DispatchQueue.main.async {
			
			(tokenView as! UIView).removeFromSuperview()
			
			self.gridTokensView!.layoutIfNeeded()
			
		}
		
		tokenView!.clearView()
		
		tokenView!.delegate = nil
		
		// Remove from collection
		self.remove(tokenView: tokenView!)
		
	}
	
	public func setBackgroundColor() {
		
		guard (self.controlManager != nil && self.controlManager!.gridCellProperties != nil) else { return }
		guard (!self.controlManager!.isHighlightedYN) else { return }
		
		// Get playGridCellProperties
		let p: 	GridCellProperties = self.controlManager!.gridCellProperties!
		
		self.contentView!.backgroundColor = p.backgroundColor
		
	}
	
	
	// MARK: - Open [Overridable] Methods
	
	open func setupContentView() {
		
		// Load xib
		let frameworkBundle: 			Bundle = Bundle(for: GridScapeView.self)
		frameworkBundle.loadNibNamed("GridCellViewBase", owner: self, options: nil)
		
		addSubview(contentView)
		
		self.layoutIfNeeded()
		
		// Position the contentView to fill the view
		contentView.frame				= self.bounds
		contentView.autoresizingMask	= [.flexibleHeight, .flexibleWidth]
	}
	
	open func viewDidAppear() {
		
	}
	
	open func clearView() {
		
		// Go through each item
		for tileView in self.tileViews.values {
			
			tileView.clearView()
			
		}
		
		self.tileViews.removeAll()
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
	
	open func set(highlight isHighlightedYN: Bool) {
		
		self.controlManager!.isHighlightedYN = isHighlightedYN
		
		if (isHighlightedYN) {
			
			self.setHighlightBackgroundColor()
			self.setHighlightBorder()
			self.setHighlightFilterOn()
			
		} else {
			
			self.setBackgroundColor()
			self.setBorder()
			self.setHighlightFilterOff()
			
		}
		
	}
	
	open func spawn(frame: CGRect, id: UUID) -> ProtocolGridCellView {
		
		// Override
		
		let result: ProtocolGridCellView = GridCellViewBase(frame: frame, id: id)
		
		return result
		
	}
	
	open func clone() -> ProtocolGridCellView {
		
		// Create clone
		var result: 	ProtocolGridCellView = self.spawn(frame: CGRect(x: self.frame.minX, y: self.frame.minY, width: self.frame.width, height: self.frame.height), id: self.id)
		
		// gridCellProperties
		result.gridCellProperties 		= self.gridCellProperties?.copy()
		
		// delegate
		result.set(delegate: self.delegate)
		
		result.set(cellWrapper: self.cellWrapper)
		
		// Go through each tileView
		for tileView in self.tileViews.values {
		
			// Create clone of tileView
			let tv: ProtocolGridTileView = tileView.clone()
			
			result.present(tileView: tv)
			
		}
		
		// image
		result.set(image: self.cellImageView.image, with: self.cellWrapper.imageName)
		
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
		self.controlManager 			= GridCellViewControlManager()
		
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
		let viewAccessStrategy: GridCellViewViewAccessStrategy = GridCellViewViewAccessStrategy()
		
		viewAccessStrategy.setup()
		
		// Setup the view manager
		self.controlManager!.viewManager = GridCellViewViewManager(viewAccessStrategy: viewAccessStrategy)
	}

	fileprivate func setupView() {
		
		self.cellImageView.alpha 			= 0
		self.highlightFilterView.isHidden 	= true
		
	}
	
	fileprivate func doAfterSetGridCellProperties() {
	
		guard (self.gridCellProperties != nil) else { return }
		
		self.setContentViewTapGestureRecognizer()

	}

	fileprivate func setContentViewTapGestureRecognizer() {
		
		// Set contentViewTapGestureRecognizer
		self.contentViewTapGestureRecognizer.isEnabled = self.gridCellProperties!.canTapYN
		
	}

	fileprivate func setSize() {
	
		guard (self.controlManager != nil && self.controlManager!.gridCellProperties != nil) else { return }
		
		// Get playGridCellProperties
		let p: 	GridCellProperties = self.controlManager!.gridCellProperties!
		
		// Set constraints
		self.widthAnchor.constraint(equalToConstant: p.cellWidth).isActive 	= true
		self.heightAnchor.constraint(equalToConstant: p.cellHeight).isActive = true
		
		// Set frame size
		self.frame.size = CGSize(width: p.cellWidth, height: p.cellHeight)
		
	}

	fileprivate func setRotation() {
		
		// Get degrees
		let degrees: 	CGFloat = CGFloat(GridScapeHelper.toValidRotation(rotation: self.gridCellProperties!.rotationDegrees))
		
		//let radians
		let radians:	CGFloat = MathHelper.toRadians(degrees: degrees)
		
		// Create transform
		let transform: 	CGAffineTransform = CGAffineTransform(rotationAngle: radians)
		
		self.rotatableContainerView.transform = transform
		
	}
	
	fileprivate func setBorder() {
		
		guard (self.controlManager != nil && self.controlManager!.gridCellProperties != nil) else { return }
		
		// Get playGridCellProperties
		let p: 	GridCellProperties = self.controlManager!.gridCellProperties!
		
		if (p.borderColor != nil) {
			
			self.contentView.layer.borderWidth		= p.borderWidth ?? 1.0
			self.contentView.layer.borderColor 		= p.borderColor?.cgColor
			self.contentView.layer.masksToBounds 	= true;
			
		} else {
			
			self.contentView.layer.borderWidth		= 1.0;
			self.contentView.layer.borderColor 		= UIColor.clear.cgColor
			self.contentView.layer.masksToBounds 	= true;
			
		}
		
	}
	
	fileprivate func setHighlight() {
		
		guard (self.controlManager != nil) else { return }
		
		if (self.controlManager!.isHighlightedYN) {
			
			self.set(highlight: true)
			
		}
		
	}
	
	fileprivate func setHighlightFilterOn() {
		
		guard (self.controlManager != nil && self.controlManager!.gridCellProperties != nil) else { return }
		
		// Get playGridCellProperties
		let p: 				GridCellProperties = self.controlManager!.gridCellProperties!
		
		var showFilterYN: 	Bool = true
		
		if (!self.controlManager!.isHighlightedYN || p.highlightFilterColor == nil) {
			
			showFilterYN = false
			
		}
			
		self.highlightFilterView.isHidden 			= !showFilterYN
		self.highlightFilterView.backgroundColor 	= p.highlightFilterColor
		
	}
	
	fileprivate func setHighlightFilterOff() {
		
		self.highlightFilterView.isHidden 			= true
		
	}
	
	fileprivate func setHighlightBackgroundColor() {
		
		guard (self.controlManager != nil && self.controlManager!.gridCellProperties != nil) else { return }
		
		// Get playGridCellProperties
		let p: 	GridCellProperties = self.controlManager!.gridCellProperties!
		
		if (p.highlightBackgroundColor != nil) {
			
			self.contentView!.backgroundColor = p.highlightBackgroundColor!
			
		}
		
	}

	fileprivate func setHighlightBorder() {
		
		guard (self.controlManager != nil && self.controlManager!.gridCellProperties != nil) else { return }
		
		// Get playGridCellProperties
		let p: 	GridCellProperties = self.controlManager!.gridCellProperties!
		
		if (p.highlightBorderColor != nil) {
			
			self.contentView.layer.borderWidth		= p.highlightBorderWidth ?? 1.0
			self.contentView.layer.borderColor 		= p.highlightBorderColor!.cgColor
			self.contentView.layer.masksToBounds 	= true;
			
		}
		
	}
	
	fileprivate func setTileViews() {
	
		// Go through each item
		for tileView in self.tileViews.values {
			
			// Set gridTileProperties
			let gtp: 			GridTileProperties = tileView.gridTileProperties!

			if (gtp.tileHeight == 0 || gtp.tileWidth == 0) {
				
				gtp.tileHeight 	= self.gridCellProperties!.cellHeight
				gtp.tileWidth 	= self.gridCellProperties!.cellWidth
				
				tileView.present()
				
			}

		}
		
	}
	
	fileprivate func set(tileView: ProtocolGridTileView) {
		
		// Get gridTileProperties
		let p: 	GridTileProperties? = tileView.gridTileProperties
		
		guard (p != nil) else { return }
		
		let k: 	String = "\(p!.key ?? "0")"
		
		self.tileViews[k] = tileView
		
	}
	
	fileprivate func remove(tileView: ProtocolGridTileView) {
		
		// Get gridTileProperties
		let p: 	GridTileProperties? = tileView.gridTileProperties
		
		guard (p != nil) else { return }
		
		let k: 	String = "\(p!.key ?? "0")"
		
		self.tileViews.removeValue(forKey: k)
		
	}
	
	fileprivate func setTokenViews() {
		
		// Go through each item
		for tokenView in self.tokenViews.values {
			
			// Set gridTokenProperties
			let gtp: 			GridTokenProperties = tokenView.gridTokenProperties!
			
			gtp.tokenHeight 	= self.gridCellProperties!.cellHeight
			gtp.tokenWidth 		= self.gridCellProperties!.cellWidth
			
			tokenView.present()
			
		}
		
	}
	
	fileprivate func set(tokenView: ProtocolGridTokenView) {
		
		// Get gridTokenProperties
		let p: 	GridTokenProperties? = tokenView.gridTokenProperties
		
		guard (p != nil) else { return }
		
		let k: 	String = "\(p!.key ?? "0")"
		
		self.tokenViews[k] = tokenView
		
	}
	
	fileprivate func remove(tokenView: ProtocolGridTokenView) {
		
		// Get gridTokenProperties
		let p: 	GridTokenProperties? = tokenView.gridTokenProperties
		
		guard (p != nil) else { return }
		
		let k: 	String = "\(p!.key ?? "0")"
		
		self.tokenViews.removeValue(forKey: k)
		
	}
	
	
	// MARK: - Private Methods; CellContentPositionTypes
	
	fileprivate func getPositionPoint(for tileView: ProtocolGridTileView) -> CGPoint {
	
		let gcp: 		GridCellProperties = self.gridCellProperties!
		let gtp: 		GridTileProperties = tileView.gridTileProperties!
	
		if (gtp.tileHeight == gcp.cellHeight && gtp.tileWidth == gcp.cellWidth) {
		
			return CGPoint(x: 0, y: 0)
			
		}
		
		// Get positionPoint
		let result: 	CGPoint = GridScapeHelper.toPoint(from: gtp.position, withRotation: gcp.rotationDegrees, positionFixedToCellRotation: gtp.positionFixToCellRotationYN, cellWidth: gcp.cellWidth, cellHeight: gcp.cellHeight, contentWidth: gtp.tileWidth, contentHeight: gtp.tileHeight)
		
		return result
		
	}
	
	fileprivate func setTileViewPositionsAfterRotation() {
		
		// Go through each item
		for tileView in self.tileViews.values {
			
			// Set position
			self.setPosition(tileView: tileView)
			
		}
		
	}
	
	fileprivate func getBlockedContentPositions() -> [CellContentPositionTypes] {
		
		var result: [CellContentPositionTypes] = [CellContentPositionTypes]()
		
		// Go through each item
		for tv in self.tileViews.values {
			
			// Add tileView position to blockedContentPositions
			result.append(tv.gridTileProperties!.position)
			
		}
		
		// Get cellTypeWrapper, blockedContentPositions
		if let ctw = self.cellWrapper.cellTypeWrapper, let bcp = ctw.blockedContentPositions {
			
			result.append(contentsOf: bcp)
			
		}
		
		return result
		
	}
	
	fileprivate func getNextAvailableContentPosition(blockedContentPositions: [CellContentPositionTypes]) -> CellContentPositionTypes? {
		
		var availableContentPositions: 	[CellContentPositionTypes] = [CellContentPositionTypes]()
		
		// Go through each item
		for i in CellContentPositionTypes.Center.rawValue...CellContentPositionTypes.TopLeft.rawValue {
			
			let position: 				CellContentPositionTypes = CellContentPositionTypes(rawValue: i)!
			
			// Check blockedContentPositions
			if (!blockedContentPositions.contains(position)) {
				
				availableContentPositions.append(position)
				
			}
			
		}
		
		return availableContentPositions.first
		
	}
	
	
	// MARK: - contentView TapGestureRecognizer Methods
	
	@IBAction func contentViewTapped(_ sender: Any) {

		guard (self.gridCellProperties!.canTapYN) else { return }
		
		let sender = sender as! UITapGestureRecognizer
		
		// Notify the delegate
		self.delegate?.gridCellView(for: sender, tapped: self)
		
	}
	

}

// MARK: - Extension ProtocolGridCellViewControlManagerDelegate

extension GridCellViewBase: ProtocolGridCellViewControlManagerDelegate {
	
	// MARK: - Public Methods
	
}



