//
//  GridScapeView.swift
//  SFGridScape
//
//  Created by David on 15/11/2017.
//  Copyright © 2017 com.smartfoundation. All rights reserved.
//

import UIKit
import SFView

/// A view class for a GridScapeView
public class GridScapeView: UIView, ProtocolGridScapeView {
	
	// MARK: - Private Stored Properties
	
	fileprivate var controlManager:						GridScapeViewControlManager?
	fileprivate var panGestureHelper:					PanGestureHelper?
	fileprivate var gridProperties: 					GridProperties? = nil
	fileprivate var gridState: 							GridState? = nil
	
	
	// MARK: - Public Stored Properties
	
	public weak var delegate:							ProtocolGridScapeViewDelegate?

	@IBOutlet weak var contentView:						UIView!
	@IBOutlet var panGestureRecognizer: 				UIPanGestureRecognizer!
	@IBOutlet weak var containerView: 					UIView!
	@IBOutlet weak var stateView: 						UIView!
	@IBOutlet weak var gvxLabel: 						UILabel!
	@IBOutlet weak var gvyLabel: 						UILabel!
	@IBOutlet weak var marginFrameLabel: 				UILabel!
	@IBOutlet weak var indicatedCoordLabel: 			UILabel!
	@IBOutlet weak var trueCoordLabel: 					UILabel!
	@IBOutlet weak var cellCoordLabel: 					UILabel!
	@IBOutlet weak var blockCoordLabel: 				UILabel!
	@IBOutlet weak var numberofBlocksLabel: 			UILabel!
	@IBOutlet weak var selectedBlockCellRangeLabel: 	UILabel!
	@IBOutlet weak var blocksLayoutTruePositionsLabel: 	UILabel!
	@IBOutlet weak var firstPopulatedCellColumnLabel: 	UILabel!
	@IBOutlet weak var firstPopulatedCellRowLabel: 		UILabel!
	@IBOutlet weak var lastPopulatedCellColumnLabel: 	UILabel!
	@IBOutlet weak var lastPopulatedCellRowLabel: 		UILabel!
	
	
	// MARK: - Public Computed Properties
	
	
	// MARK: - Initializers
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		self.setupContentView()
		
		self.setup()
		self.setupView()
		
	}
	
	required public init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		
		self.setupContentView()
		
		self.setup()
		self.setupView()
		
	}
	
	
	// MARK: - Override Methods
	
	public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		
		// Notify the delegate
		self.delegate?.gridScapeView(touchesBegan: self)
		
	}

	public override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {

		// Nb: If self is returned, then touchesBegan is called

		// checkHitTest on sub views
		return self.checkHitTest(point: point, withEvent: event)

	}
	
	
	// MARK: - Public Methods
	
	public func viewDidAppear() {
		
	}
	
	public func clearView() {
		
	}
	
	public func checkHitTest(point: CGPoint, withEvent event: UIEvent?) -> UIView? {
		
		// Check gestures enabled
		if (!self.containerView.isUserInteractionEnabled || self.containerView.isHidden || self.containerView.alpha == 0) {
			
			return nil
			
		}
		
		// Default return self, to handle touches on self
		let v: UIView? = self
		
		// Check point inside
		if (!self.containerView.point(inside: point, with: event)) {

			return nil
			
		}
		
		// Nb: Check whether to handle the event in subviews
		
		// Go through each blockView
		for blockView in self.containerView.subviews {
			
			if let blockView = blockView as? GridBlockView {
				
				// Convert to point inside blockView
				let blockViewPoint = self.containerView.convert(point, to: blockView)
				
				// Get subView from blockView
				if let sv = blockView.checkHitTest(point: blockViewPoint, withEvent: event) {
					
					return sv
					
				}
				
			}
			
		}
		
		return v
		
	}

	public func get(locationOf sender: UIGestureRecognizer) -> CGPoint {
		
		return sender.location(in: self.containerView)
		
	}
	
	public func present(blockView: GridBlockView) {
		
		DispatchQueue.main.async {
			
			self.containerView.addSubview(blockView)
			
			self.containerView.layoutIfNeeded()
			
		}
		
	}
	
	public func set(gridProperties: GridProperties, gridState: GridState) {
		
		self.gridProperties = gridProperties
		self.gridState		= gridState
		
		self.setupPanGesturePanDirection()
		
	}
	
	public func set(stateView visibleYN: Bool) {
		
		self.stateView.alpha = visibleYN ? 1 : 0
		
	}
	
	public func setScrollDirection() {
		
		self.setupPanGesturePanDirection()
		
	}

	public func reposition(cell cellView: ProtocolGridCellView, from fromCellCoord: CellCoord, fromBlockView: GridBlockView?, to toCellCoord: CellCoord, toBlockView: GridBlockView?, oncomplete completionHandler:@escaping (Error?) -> Void) {
		
		guard (fromBlockView != nil || toBlockView != nil) else {
			
			// Call the completion handler
			completionHandler(nil)
			
			return
		}
		
		// Get movingCellView as clone of cellView
		let movingCellView: 	ProtocolGridCellView = cellView.clone()
		
		let mcvv: 				UIView = movingCellView as! UIView
		
		// Create cellCoordVector
		let ccv: 				CellCoordVector = CellCoordVector(from: fromCellCoord.copy(), to: toCellCoord.copy())
		self.adjustOffGridCellCoordVector(cellCoordVector: ccv)
		
		// Get true point for fromCellCoord
		let fromTrue: 			CGPoint = GridScapeHelper.toTrue(fromCellCoord: ccv.from, gridProperties: self.gridProperties!)
		let fromIndicated:		CGPoint = GridScapeHelper.toIndicated(fromTrue: fromTrue, gridState: self.gridState!)
		
		// Set position and display properties
		mcvv.frame 				= CGRect(x: fromIndicated.x, y: fromIndicated.y, width: mcvv.frame.width, height: mcvv.frame.height)
		
		// Add to view
		self.containerView.addSubview(mcvv)
		
		// Get true point for toCellCoord
		let toTrue: 			CGPoint = GridScapeHelper.toTrue(fromCellCoord: ccv.to, gridProperties: self.gridProperties!)
		let toIndicated:		CGPoint = GridScapeHelper.toIndicated(fromTrue: toTrue, gridState: self.gridState!)
		
		// Reposition to toIndicated
		let repositionFrame: 	CGRect = CGRect(x: toIndicated.x, y: toIndicated.y, width: mcvv.frame.width, height: mcvv.frame.height)
		
		// Animate the transition
		UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseIn, animations: {
			
			// Set frame
			mcvv.frame 			= repositionFrame
			
		}, completion: { _ in
			
			// Remove view
			mcvv.removeFromSuperview()
			
			// Call the completion handler
			completionHandler(nil)
			
		})
		
	}

	public func reposition(cell cellView: ProtocolGridCellView, from fromIndicated: CGPoint, to toCellCoord: CellCoord, oncomplete completionHandler:@escaping (Error?) -> Void) {
		
		// Get movingCellView as clone of cellView
		let movingCellView: 	ProtocolGridCellView = cellView.clone()

		let mcvv: 				UIView = movingCellView as! UIView

		// Set position and display properties
		mcvv.frame 				= CGRect(x: fromIndicated.x, y: fromIndicated.y, width: mcvv.frame.width, height: mcvv.frame.height)

		// Add to view
		self.containerView.addSubview(mcvv)

		// Get true point for toCellCoord
		let toTrue: 			CGPoint = GridScapeHelper.toTrue(fromCellCoord: toCellCoord, gridProperties: self.gridProperties!)
		let toIndicated:		CGPoint = GridScapeHelper.toIndicated(fromTrue: toTrue, gridState: self.gridState!)

		// Reposition to toIndicated
		let repositionFrame: 	CGRect = CGRect(x: toIndicated.x, y: toIndicated.y, width: mcvv.frame.width, height: mcvv.frame.height)

		// Animate the transition
		UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseIn, animations: {

			// Set frame
			mcvv.frame 			= repositionFrame

		}, completion: { _ in

			// Remove view
			mcvv.removeFromSuperview()

			// Call the completion handler
			completionHandler(nil)

		})
		
	}
	
	public func reposition(tile tileView: ProtocolGridTileView, from fromCellCoord: CellCoord, fromCellView: ProtocolGridCellView?, to toCellCoord: CellCoord, toCellView: ProtocolGridCellView?, oncomplete completionHandler:@escaping (Error?) -> Void) {
		
		guard (fromCellView != nil || toCellView != nil) else {
			
			// Call the completion handler
			completionHandler(nil)
			
			return
		}
		
		// Get movingTileView as clone of tileView
		let movingTileView: 	ProtocolGridTileView = tileView.clone()
		
		let mtvv: 				UIView = movingTileView as! UIView
		
		// Create cellCoordVector
		let ccv: 				CellCoordVector = CellCoordVector(from: fromCellCoord.copy(), to: toCellCoord.copy())
		self.adjustOffGridCellCoordVector(cellCoordVector: ccv)
		
		// TODO:
		// Adjust for cell content positions
		
		// Get true point for fromCellCoord
		let fromTrue: 			CGPoint = GridScapeHelper.toTrue(fromCellCoord: ccv.from, gridProperties: self.gridProperties!)
		let fromIndicated:		CGPoint = GridScapeHelper.toIndicated(fromTrue: fromTrue, gridState: self.gridState!)
		
		// Set position and display properties
		mtvv.frame 				= CGRect(x: fromIndicated.x, y: fromIndicated.y, width: mtvv.frame.width, height: mtvv.frame.height)
		
		// Add to view
		self.containerView.addSubview(mtvv)
		
		// Get true point for toCellCoord
		let toTrue: 			CGPoint = GridScapeHelper.toTrue(fromCellCoord: ccv.to, gridProperties: self.gridProperties!)
		let toIndicated:		CGPoint = GridScapeHelper.toIndicated(fromTrue: toTrue, gridState: self.gridState!)
		
		// Reposition to toIndicated
		let repositionFrame: 	CGRect = CGRect(x: toIndicated.x, y: toIndicated.y, width: mtvv.frame.width, height: mtvv.frame.height)
		
		// Animate the transition
		UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseIn, animations: {
			
			// Set frame
			mtvv.frame 			= repositionFrame
			
		}, completion: { _ in
			
			// Remove view
			mtvv.removeFromSuperview()
			
			// Call the completion handler
			completionHandler(nil)
			
		})
		
	}
	
	public func reposition(tile tileView: ProtocolGridTileView, from fromIndicated: CGPoint, to toCellView: ProtocolGridCellView, oncomplete completionHandler:@escaping (Error?) -> Void) {
		
		let toCellCoord: 		CellCoord = toCellView.gridCellProperties!.cellCoord!
		
		// Get movingTileView as clone of tileView
		let movingTileView: 	ProtocolGridTileView = tileView.clone()
		
		let mtvv: 				UIView = movingTileView as! UIView
		
		// Set position and display properties
		mtvv.frame 				= CGRect(x: fromIndicated.x, y: fromIndicated.y, width: mtvv.frame.width, height: mtvv.frame.height)
		
		// Add to view
		self.containerView.addSubview(mtvv)
		
		// Get true point for toCellCoord
		//let toTrue: 			CGPoint = GridScapeHelper.toTrue(fromCellCoord: toCellCoord, gridProperties: self.gridProperties!)
		
		// Get GridTileProperties
		let gtp: 				GridTileProperties = tileView.gridTileProperties!
		
		// TODO:
		let toTrue: 			CGPoint = GridScapeHelper.toTrue(fromCellCoord: toCellCoord, gridProperties: self.gridProperties!, gridCellProperties: toCellView.gridCellProperties!, contentFrame: (tileView as! UIView).frame, contentPosition: gtp.position, positionFixedToCellRotation: gtp.positionFixToCellRotationYN)
		
		let toIndicated:		CGPoint = GridScapeHelper.toIndicated(fromTrue: toTrue, gridState: self.gridState!)
		
		// Reposition to toIndicated
		let repositionFrame: 	CGRect = CGRect(x: toIndicated.x, y: toIndicated.y, width: mtvv.frame.width, height: mtvv.frame.height)
		
		// Animate the transition
		UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseIn, animations: {
			
			// Set frame
			mtvv.frame 			= repositionFrame
			
		}, completion: { _ in
			
			// Remove view
			mtvv.removeFromSuperview()
			
			// Call the completion handler
			completionHandler(nil)
			
		})
		
	}
	
	public func reposition(token tokenView: ProtocolGridTokenView, from fromCellCoord: CellCoord, fromCellView: ProtocolGridCellView?, to toCellCoord: CellCoord, toCellView: ProtocolGridCellView?, oncomplete completionHandler:@escaping (Error?) -> Void) {
		
		guard (fromCellView != nil || toCellView != nil) else {
			
			// Call the completion handler
			completionHandler(nil)
			
			return
		}
		
		// Get movingTokenView as clone of tokenView
		let movingTokenView: 	ProtocolGridTokenView = tokenView.clone()
		
		let mtvv: 				UIView = movingTokenView as! UIView
		
		// Create cellCoordVector
		let ccv: 				CellCoordVector = CellCoordVector(from: fromCellCoord.copy(), to: toCellCoord.copy())
		self.adjustOffGridCellCoordVector(cellCoordVector: ccv)
		
		// Get true point for fromCellCoord
		let fromTrue: 			CGPoint = GridScapeHelper.toTrue(fromCellCoord: ccv.from, gridProperties: self.gridProperties!)
		let fromIndicated:		CGPoint = GridScapeHelper.toIndicated(fromTrue: fromTrue, gridState: self.gridState!)
		
		// Set position and display properties
		mtvv.frame 				= CGRect(x: fromIndicated.x, y: fromIndicated.y, width: mtvv.frame.width, height: mtvv.frame.height)
		
		// Add to view
		self.containerView.addSubview(mtvv)
		
		// Get true point for toCellCoord
		let toTrue: 			CGPoint = GridScapeHelper.toTrue(fromCellCoord: ccv.to, gridProperties: self.gridProperties!)
		let toIndicated:		CGPoint = GridScapeHelper.toIndicated(fromTrue: toTrue, gridState: self.gridState!)
		
		// Reposition to toIndicated
		let repositionFrame: 	CGRect = CGRect(x: toIndicated.x, y: toIndicated.y, width: mtvv.frame.width, height: mtvv.frame.height)
		
		// Animate the transition
		UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseIn, animations: {
			
			// Set frame
			mtvv.frame 			= repositionFrame
			
		}, completion: { _ in
			
			// Remove view
			mtvv.removeFromSuperview()
			
			// Call the completion handler
			completionHandler(nil)
			
		})
		
	}
	
	public func reposition(token tokenView: ProtocolGridTokenView, from fromIndicated: CGPoint, to toCellCoord: CellCoord, oncomplete completionHandler:@escaping (Error?) -> Void) {
		
		// Get movingTokenView as clone of tokenView
		let movingTokenView: 	ProtocolGridTokenView = tokenView.clone()
		
		let mtvv: 				UIView = movingTokenView as! UIView
		
		// Set position and display properties
		mtvv.frame 				= CGRect(x: fromIndicated.x, y: fromIndicated.y, width: mtvv.frame.width, height: mtvv.frame.height)
		
		// Add to view
		self.containerView.addSubview(mtvv)
		
		// Get true point for toCellCoord
		let toTrue: 			CGPoint = GridScapeHelper.toTrue(fromCellCoord: toCellCoord, gridProperties: self.gridProperties!)
		let toIndicated:		CGPoint = GridScapeHelper.toIndicated(fromTrue: toTrue, gridState: self.gridState!)
		
		// Reposition to toIndicated
		let repositionFrame: 	CGRect = CGRect(x: toIndicated.x, y: toIndicated.y, width: mtvv.frame.width, height: mtvv.frame.height)
		
		// Animate the transition
		UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseIn, animations: {
			
			// Set frame
			mtvv.frame 			= repositionFrame
			
		}, completion: { _ in
			
			// Remove view
			mtvv.removeFromSuperview()
			
			// Call the completion handler
			completionHandler(nil)
			
		})
		
	}
	

	// MARK: - Public Methods; State View
	
	public func displayPanProperties(gridState: GridState) {
		
		DispatchQueue.main.async {
		
			self.gvxLabel.text = "gvx=\(Int(gridState.indicatedOffsetX))"
			self.gvyLabel.text = "gvy=\(Int(gridState.indicatedOffsetY))"
			
			self.marginFrameLabel.text = "margin=[\(Int(gridState.marginFrame!.minX)),\(Int(gridState.marginFrame!.minY))..\(Int(gridState.marginFrame!.maxX)),\(Int(gridState.marginFrame!.maxY))]"
			
		}
		
	}
	
	public func displayTapProperties(gridState: GridState) {
		
		let indicatedPoint: CGPoint? = gridState.selectedIndicatedPoint
		
		if (indicatedPoint != nil) {
			
			self.indicatedCoordLabel.text = "ind=[\(Int(indicatedPoint!.x)),\(Int(indicatedPoint!.y))]"
			
		} else {
			
			self.indicatedCoordLabel.text = "ind=nil"
			
		}
		
		let truePoint: CGPoint? = gridState.selectedTruePoint
		
		if (truePoint != nil) {
			
			self.trueCoordLabel.text = "true=[\(Int(truePoint!.x)),\(Int(truePoint!.y))]"
			
		} else {
			
			self.trueCoordLabel.text = "true=nil"
			
		}
		
		let cellCoord: CellCoord? = gridState.selectedCellCoord
		
		if (cellCoord != nil) {
			
			self.cellCoordLabel.text = "cell=[\(cellCoord!.column),\(cellCoord!.row)]"
			
		} else {
			
			self.cellCoordLabel.text = "cell=nil"
			
		}
		
		let blockCoord: BlockCoord? = gridState.selectedBlockCoord
		
		if (blockCoord != nil) {
			
			self.blockCoordLabel.text = "block=[\(blockCoord!.column),\(blockCoord!.row)]"
			
		} else {
			
			self.blockCoordLabel.text = "block=nil"
			
		}
		
	}
	
	public func displaySelectedBlockProperties(blockView: GridBlockView?) {
		
		var cellRange: String = "cells=[none]"
		
		if (blockView != nil) {
			
			// Get cellCoordRange
			let ccr: CellCoordRange = blockView!.gridBlockProperties!.cellCoordRange!
			
			cellRange = "cells=[\(ccr.topLeft.column),\(ccr.topLeft.row)..\(ccr.bottomRight.column),\(ccr.bottomRight.row)]"
			
		}
		
		self.selectedBlockCellRangeLabel.text = cellRange
		
	}
	
	public func displayBlocksProperties(numberofBlocks: Int, gridState: GridState) {
		
		DispatchQueue.main.async {
			
			self.numberofBlocksLabel.text = "num=[\(numberofBlocks)]"
			
			self.blocksLayoutTruePositionsLabel.text = "true=[\(gridState.firstBlockColumnTrueMinX),\(gridState.firstBlockRowTrueMinY)..\(gridState.lastBlockColumnTrueMaxX),\(gridState.lastBlockRowTrueMaxY)]"
		
		}
		
	}

	public func displayPopulatedCellsProperties(gridState: GridState) {
		
		var firstColumn: String = "-"
		if (gridState.firstPopulatedCellColumnIndex != nil) {
			firstColumn = "\(gridState.firstPopulatedCellColumnIndex!)"
		}
		var firstRow: String = "-"
		if (gridState.firstPopulatedCellRowIndex != nil) {
			firstRow = "\(gridState.firstPopulatedCellRowIndex!)"
		}
		var lastColumn: String = "-"
		if (gridState.lastPopulatedCellColumnIndex != nil) {
			lastColumn = "\(gridState.lastPopulatedCellColumnIndex!)"
		}
		var lastRow: String = "-"
		if (gridState.lastPopulatedCellRowIndex != nil) {
			lastRow = "\(gridState.lastPopulatedCellRowIndex!)"
		}
		
		self.firstPopulatedCellColumnLabel.text = "firstCol=[\(firstColumn)]"
		self.firstPopulatedCellRowLabel.text = "firstRow=[\(firstRow)]"
		self.lastPopulatedCellColumnLabel.text = "lastCol=[\(lastColumn)]"
		self.lastPopulatedCellRowLabel.text = "lastRow=[\(lastRow)]"
		
	}
	
	
	// MARK: - Private Methods
	
	fileprivate func setup() {
		
		self.setupControlManager()
		self.setupModelManager()
		self.setupViewManager()
	}
	
	fileprivate func setupControlManager() {
		
		// Setup the control manager
		self.controlManager 			= GridScapeViewControlManager()
		
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
		let viewAccessStrategy: GridScapeViewViewAccessStrategy = GridScapeViewViewAccessStrategy()
		
		viewAccessStrategy.setup()
		
		// Setup the view manager
		self.controlManager!.viewManager = GridScapeViewViewManager(viewAccessStrategy: viewAccessStrategy)
	}
	
	fileprivate func setupContentView() {
		
		// Load xib
		let frameworkBundle: 			Bundle = Bundle(for: GridScapeView.self)
		frameworkBundle.loadNibNamed("GridScapeView", owner: self, options: nil)
		
		addSubview(contentView)
		
		self.layoutIfNeeded()
		
		// Position the contentView to fill the view
		contentView.frame				= self.bounds
		contentView.autoresizingMask	= [.flexibleHeight, .flexibleWidth]
	}
	
	fileprivate func setupView() {

		self.setupPanGestureHelper()

	}

	fileprivate func setupPanGestureHelper() {
		
		// Create panGestureHelper
		self.panGestureHelper				= PanGestureHelper(gesture: self.panGestureRecognizer!)
		
		self.panGestureHelper!.delegate		= self
		
		self.setupPanGesturePanDirection()
		
	}
	
	fileprivate func setupPanGesturePanDirection() {
		
		if (self.gridProperties != nil) {
			
			self.panGestureHelper!.horizontalPanYN 	= self.gridProperties!.horizontalScrollYN
			self.panGestureHelper!.verticalPanYN 	= self.gridProperties!.verticalScrollYN
			
		}
		
	}
	
	fileprivate func handleDraggingStarted(fromIndicated: CGPoint) {
		
		// Check gridDraggingState
		guard (self.gridState!.gridDraggingState == nil || (self.gridState!.gridDraggingState != nil && !self.gridState!.gridDraggingState!.isDraggingYN)) else { return }
		
		self.gridState!.gridDraggingState = GridDraggingState()
		let gds: 				GridDraggingState = self.gridState!.gridDraggingState!
		let gp:					GridProperties = self.gridProperties!
		
		// Set fromIndicated
		gds.set(fromIndicated: fromIndicated, gridProperties: self.gridProperties!, gridState: self.gridState!)
		
		// Set originCellView
		gds.set(originCellView: self.delegate!.gridScapeView(sender: self, cellForItemAt: gds.fromCellCoord!))
		
		guard (gds.originCellView != nil) else {
			
			gds.clear()
			self.gridState!.gridDraggingState = nil
			
			return
			
		}
		
		// Get canDragCellView
		var canDragCellView: 	Bool = false
		if (gp.dragAndDropCellsYN) { canDragCellView = self.delegate!.gridScapeView(sender: self, canDrag: gds.originCellView!) }
		
		// Set originTileView
		gds.set(originTileView: gds.originCellView!.tileViews.values.first)

		// Get canDragTileView
		var canDragTileView: 	Bool = false

		// Set originTokenView
		gds.set(originTokenView: gds.originCellView!.tokenViews.values.first)
		
		// Get canDragTokenView
		var canDragTokenView: 	Bool = false
		
		// Determine which view to drag
		if (gds.originTokenView != nil && gp.dragAndDropTokensYN) {
			
			canDragTokenView = self.delegate!.gridScapeView(sender: self, canDrag: gds.originTokenView!)
			
		} else if (gds.originTileView != nil && gp.dragAndDropTilesYN) {
			
			canDragTileView = self.delegate!.gridScapeView(sender: self, canDrag: gds.originTileView!)
			
		}
		
		// Start dragging the relevant view
		if (gds.originTokenView != nil && canDragTokenView) {
			
			// Start dragging tokenView
			self.startDraggingOriginTokenView()
			
		} else if (gds.originTileView != nil && canDragTileView) {
			
			// Start dragging tileView
			self.startDraggingOriginTileView()
			
		} else if (canDragCellView) {
			
			// Start dragging cellView
			self.startDraggingOriginCellView()
			
		} else {
			
			gds.clear()
			self.gridState!.gridDraggingState = nil
			
		}
		
	}
	
	fileprivate func startDraggingOriginCellView() {
		
		// Get gridDraggingState
		let gds: 		GridDraggingState? = self.gridState!.gridDraggingState
		gds!.type 		= .Cell
		
		// Check gridDraggingState
		guard (gds != nil && gds!.originCellView != nil) else { return }
		
		// Hide originCellView
		(gds!.originCellView! as! UIView).alpha = 0
		
		// Get draggingCellView as clone of originCellView
		gds!.set(draggingCellView: gds!.originCellView!.clone())

		guard (gds!.draggingCellView != nil) else { return }
		
		let dcvv: 		UIView = gds!.draggingCellView as! UIView
		
		// Set position and display properties
		dcvv.frame 		= CGRect(x: gds!.fromCellCoordIndicated!.x, y: gds!.fromCellCoordIndicated!.y, width: dcvv.frame.width, height: dcvv.frame.height)
		dcvv.alpha 		= 0.5
		UIViewHelper.setShadow(view: dcvv)
		
		// Add to view
		self.containerView.addSubview(dcvv)
		
		gds!.draggingCellView!.present()
		
		gds!.isDraggingYN = true
		
		// Notify the delegate
		self.delegate?.gridScapeView(sender: self, draggingStarted: gds!.originCellView!)
		
	}
	
	fileprivate func startDraggingOriginTileView() {
		
		// Get gridDraggingState
		let gds: 		GridDraggingState? = self.gridState!.gridDraggingState
		gds!.type 		= .Tile
		
		// Check gridDraggingState
		guard (gds != nil && gds!.originTileView != nil) else { return }
		
		// Hide originTileView
		(gds!.originTileView! as! UIView).alpha = 0
		
		// Get draggingTileView as clone of originTileView
		gds!.set(draggingTileView: gds!.originTileView!.clone())

		guard (gds!.draggingTileView != nil) else { return }
		
		let dtvv: 		UIView = gds!.draggingTileView as! UIView
		
		// Set position and display properties
		dtvv.frame 		= CGRect(x: gds!.fromCellCoordIndicated!.x, y: gds!.fromCellCoordIndicated!.y, width: dtvv.frame.width, height: dtvv.frame.height)
		dtvv.alpha 		= 0.5
		UIViewHelper.setShadow(view: dtvv)
		
		// Add to view
		self.containerView.addSubview(dtvv)
		
		gds!.draggingTileView!.present()
		
		gds!.isDraggingYN = true
		
		// Notify the delegate
		self.delegate?.gridScapeView(sender: self, draggingStarted: gds!.originTileView!)
		
	}

	fileprivate func startDraggingOriginTokenView() {
		
		// Get gridDraggingState
		let gds: 		GridDraggingState? = self.gridState!.gridDraggingState
		gds!.type 		= .Token
		
		// Check gridDraggingState
		guard (gds != nil && gds!.originTokenView != nil) else { return }
		
		// Hide originTokenView
		(gds!.originTokenView! as! UIView).alpha = 0
		
		// Get draggingTokenView as clone of originTokenView
		gds!.set(draggingTokenView: gds!.originTokenView!.clone())
		
		guard (gds!.draggingTokenView != nil) else { return }
		
		let dtvv: 		UIView = gds!.draggingTokenView as! UIView
		
		// Set position and display properties
		dtvv.frame 		= CGRect(x: gds!.fromCellCoordIndicated!.x, y: gds!.fromCellCoordIndicated!.y, width: dtvv.frame.width, height: dtvv.frame.height)
		dtvv.alpha 		= 0.5
		UIViewHelper.setShadow(view: dtvv)
		
		// Add to view
		self.containerView.addSubview(dtvv)
		
		gds!.draggingTokenView!.present()
		
		gds!.isDraggingYN = true
		
		// Notify the delegate
		self.delegate?.gridScapeView(sender: self, draggingStarted: gds!.originTokenView!)
		
	}
	
	fileprivate func handleDraggingContinued(currentIndicated: CGPoint) {
		
		// Check gridDraggingState
		guard (self.gridState!.gridDraggingState != nil && self.gridState!.gridDraggingState!.isDraggingYN) else { return }
		
		let gds: 				GridDraggingState = self.gridState!.gridDraggingState!
		
		guard (gds.draggingView != nil) else { return }
		
		// Create transform
		let t: 					CGAffineTransform = CGAffineTransform(translationX: currentIndicated.x - gds.fromIndicated!.x, y: currentIndicated.y - gds.fromIndicated!.y)
		
		// Set draggingView transform
		gds.draggingView!.transform = t
		
		// Set toCellCoord
		self.setDraggingToCellCoord()
		
	}
	
	fileprivate func setDraggingToCellCoord() {
		
		// Check gridDraggingState
		guard (self.gridState!.gridDraggingState != nil && self.gridState!.gridDraggingState!.isDraggingYN) else { return }
		
		let gds: 				GridDraggingState = self.gridState!.gridDraggingState!
		let gp:					GridProperties = self.gridProperties!
		
		guard (gds.draggingView != nil) else { return }
		
		// Get toIndicated from center of draggingView
		let toIndicated: 		CGPoint = CGPoint(x: gds.draggingView!.frame.minX + (gp.cellWidth / 2), y: gds.draggingView!.frame.minY + (gp.cellHeight / 2))
		
		// Get toTrue
		let toTrue: 			CGPoint = GridScapeHelper.toTrue(fromIndicated: toIndicated, gridState: self.gridState!)
		
		// Get toCellCoord
		let toCellCoord: 		CellCoord = GridScapeHelper.toCellCoord(fromTrue: toTrue, gridProperties: self.gridProperties!)
		
		// Check toCellCoord
		if (gds.toCellCoord == nil || !gds.toCellCoord!.equals(cellCoord: toCellCoord)) {
			
			// Set toCellCoord
			gds.set(toCellCoord: toCellCoord, gridProperties: self.gridProperties!, gridState: self.gridState!)
			
			// Check isFromCellCoordYN
			if (gds.isFromCellCoordYN) {
				
				gds.canDropYN 	= false
				
			} else {
			
				switch gds.type {
				case .Cell:
					
					// Set canDropYN
					gds.canDropYN 	= self.delegate!.gridScapeView(sender: self, canDrop: gds.originCellView!, at: gds.toCellCoord!)
					
				case .Tile:
					
					// Set canDropYN
					gds.canDropYN 	= self.delegate!.gridScapeView(sender: self, canDrop: gds.originTileView!, at: gds.toCellCoord!)
					
				case .Token:
					
					// Set canDropYN
					gds.canDropYN 	= self.delegate!.gridScapeView(sender: self, canDrop: gds.originTokenView!, at: gds.toCellCoord!)

				}
				
			}
			
		}
		
	}
	
	fileprivate func handleDraggingStopped() {
		
		// Check gridDraggingState
		guard (self.gridState!.gridDraggingState != nil && self.gridState!.gridDraggingState!.isDraggingYN) else { return }
		
		let gds: GridDraggingState = self.gridState!.gridDraggingState!
		
		if (gds.canDropYN) {
			
			// Did drop
			self.handleDidDrop()
			
		} else {
			
			// Dragging cancelled
			self.handleDraggingCancelled()
			
		}
		
	}
	
	fileprivate func handleDidDrop() {
		
		// Check gridDraggingState
		guard (self.gridState!.gridDraggingState != nil && self.gridState!.gridDraggingState!.isDraggingYN) else { return }
		
		let gds: 			GridDraggingState = self.gridState!.gridDraggingState!
		
		guard (gds.draggingView != nil) else { return }
		
		// Create completion handler
		let respositionViewCompletionHandler: ((Error?) -> Void) =
		{
			(error) -> Void in
			
			switch gds.type {
			case .Cell:
				
				// Notify the delegate
				self.delegate?.gridScapeView(sender: self, didDrop: gds.originCellView!, at: gds.toCellCoord!)
				
			case .Tile:
				
				// Notify the delegate
				self.delegate?.gridScapeView(sender: self, didDrop: gds.originTileView!, at: gds.toCellCoord!)
				
			case .Token:
				
				// Notify the delegate
				self.delegate?.gridScapeView(sender: self, didDrop: gds.originTokenView!, at: gds.toCellCoord!)
				
			}
			
			gds.clear()
			self.gridState!.gridDraggingState = nil
			
		}
		
		// Reposition view
		self.repositionViewAfterDidDrop(for: gds.draggingView!, oncomplete: respositionViewCompletionHandler)
		
	}
	
	fileprivate func handleDraggingCancelled() {
		
		// Check gridDraggingState
		guard (self.gridState!.gridDraggingState != nil && self.gridState!.gridDraggingState!.isDraggingYN) else { return }
		
		let gds: GridDraggingState = self.gridState!.gridDraggingState!
		
		guard (gds.draggingView != nil && gds.originView != nil) else { return }
		
		// Create completion handler
		let respositionViewCompletionHandler: ((Error?) -> Void) =
		{
			(error) -> Void in
			
			switch gds.type {
			case .Cell:
				
				// Notify the delegate
				self.delegate?.gridScapeView(sender: self, draggingCancelled: gds.originCellView!)
				
			case .Tile:
				
				// Notify the delegate
				self.delegate?.gridScapeView(sender: self, draggingCancelled: gds.originTileView!)
				
			case .Token:
				
				// Notify the delegate
				self.delegate?.gridScapeView(sender: self, draggingCancelled: gds.originTokenView!)
				
			}
			
			// Show originView
			gds.originView!.alpha = 1
			
			gds.clear()
			self.gridState!.gridDraggingState = nil
			
			// Remove view
			gds.draggingView!.removeFromSuperview()
			
		}
		
		// Reposition view
		self.repositionViewAfterDraggingCancelled(for: gds.draggingView!, oncomplete: respositionViewCompletionHandler)
		
	}
	
	fileprivate func repositionViewAfterDidDrop(for view: UIView, oncomplete completionHandler:@escaping (Error?) -> Void) {
		
		let gds: 				GridDraggingState = self.gridState!.gridDraggingState!
		
		// Reposition to toCellCoordIndicated
		let repositionFrame: 	CGRect = CGRect(x: gds.toCellCoordIndicated!.x, y: gds.toCellCoordIndicated!.y, width: view.frame.width, height: view.frame.height)
		
		// Animate the transition
		UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseIn, animations: {
			
			// Set frame
			view.frame = repositionFrame
			
		}, completion: { _ in
			
			// Remove view
			view.removeFromSuperview()
			
			// Call the completion handler
			completionHandler(nil)
			
		})
		
	}
	
	fileprivate func repositionViewAfterDraggingCancelled(for view: UIView, oncomplete completionHandler:@escaping (Error?) -> Void) {
		
		let gds: 				GridDraggingState = self.gridState!.gridDraggingState!
		
		// Reposition to fromCellCoordIndicated
		let repositionFrame: 	CGRect = CGRect(x: gds.fromCellCoordIndicated!.x, y: gds.fromCellCoordIndicated!.y, width: view.frame.width, height: view.frame.height)
		
		// Animate the transition
		UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseIn, animations: {
			
			// Set frame
			view.frame = repositionFrame
			
		}, completion: { _ in
			
			// Call the completion handler
			completionHandler(nil)
			
		})
		
	}
	
	fileprivate func adjustOffGridCellCoordVector(cellCoordVector: CellCoordVector) {
		
		let gs: 					GridState = self.gridState!
		let ccv: 					CellCoordVector = cellCoordVector
	
		// Get isFromOffGridYN
		let isFromOffGridYN: 		Bool = GridScapeHelper.isOffGridYN(cellCoord: cellCoordVector.from, gridState: gs)

		// Get isToOffGridYN
		let isToOffGridYN: 			Bool = GridScapeHelper.isOffGridYN(cellCoord: cellCoordVector.to, gridState: gs)
		
		guard (!isFromOffGridYN || !isToOffGridYN) else { return }
		
		let vx: 					Int = ccv.to.column - ccv.from.column
		let vy: 					Int = ccv.to.row - ccv.from.row
		
		var offGridX: 				Int = 0
		var offGridY: 				Int = 0
		var onGridX: 				Int = 0
		var onGridY: 				Int = 0
		var limitColumnIndex: 		Int = 0
		var limitRowIndex: 			Int = 0
		
		// Get offGridCellCoord
		let offGridCellCoord:		CellCoord = (isFromOffGridYN ? ccv.from : ccv.to)
		
		if (vx > 0) {			// Left to right
			
			limitColumnIndex 		= (isFromOffGridYN ? gs.firstCellColumnIndex : gs.lastCellColumnIndex)
			
			if ((isFromOffGridYN && offGridCellCoord.column < limitColumnIndex) ||
				(!isFromOffGridYN && offGridCellCoord.column > limitColumnIndex) ) {
				
				offGridX 			= abs(offGridCellCoord.column - limitColumnIndex)

			}
			
		} else if (vx < 0) {	// Right to left
			
			limitColumnIndex		= (isFromOffGridYN ? gs.lastCellColumnIndex : gs.firstCellColumnIndex)
			
			if ((isFromOffGridYN && offGridCellCoord.column > limitColumnIndex) ||
				(!isFromOffGridYN && offGridCellCoord.column < limitColumnIndex) ) {
				
				offGridX 			= abs(offGridCellCoord.column - limitColumnIndex)
				
			}
			
		}
		
		if (vy > 0) {			// Top to bottom
			
			limitRowIndex			= (isFromOffGridYN ? gs.firstCellRowIndex : gs.lastCellRowIndex)
			
			if ((isFromOffGridYN && offGridCellCoord.row < limitRowIndex) ||
				(!isFromOffGridYN && offGridCellCoord.row > limitRowIndex) ) {
				
				offGridY 			= abs(offGridCellCoord.row - limitRowIndex)
		
			}
			
		} else if (vy < 0) {	// Bottom to top
			
			limitRowIndex			= (isFromOffGridYN ? gs.lastCellRowIndex : gs.firstCellRowIndex)

			if ((isFromOffGridYN && offGridCellCoord.row > limitRowIndex) ||
				(!isFromOffGridYN && offGridCellCoord.row < limitRowIndex) ) {
				
				offGridY 			= abs(offGridCellCoord.row - limitRowIndex)
				
			}
			
		}
		
		// Get onGridX, onGridY
		onGridX						= abs(vx) - offGridX
		onGridY						= abs(vy) - offGridY
		
		// Get fx, fy
		var fx: 					Double = 0
		var fy: 					Double = 0
		
		if (vx != 0) {
			
			let xDiv: 				div_t = div(Int32(abs(vx)), Int32(abs(onGridX)))
			fx						= Double(xDiv.quot)
			
		}
		
		if (vy != 0) {
		
			let yDiv: 				div_t = div(Int32(abs(vy)), Int32(abs(onGridY)))
			fy						= Double(yDiv.quot)
			
		}
		
		// Get f
		let f: 						Double = (fx > fy) ? fx : fy

		// Get vfx, vfy
		var vfx: 					Int = 0
		var vfy: 					Int = 0
		
		if (vx != 0) {
			
			vfx 					= Int(CGFloat(abs(Double(vx) / f)).rounded(.up))
			
		}
		
		if (vy != 0) {
			
			vfy						= Int(CGFloat(abs(Double(vy) / f)).rounded(.up))
			
		}
		
		if (vx > 0) {			// Left to right
			
			if (isFromOffGridYN) {
				// Adjust from
				ccv.from.column = ccv.to.column - vfx
			} else {
				// Adjust to
				ccv.to.column = ccv.from.column + vfx
			}

		} else if (vx < 0) {	// Right to left
			
			if (isFromOffGridYN) {
				// Adjust from
				ccv.from.column = ccv.to.column + vfx
			} else {
				// Adjust to
				ccv.to.column = ccv.from.column - vfx
			}
			
		}
		
		if (vy > 0) {			// Top to bottom
			
			if (isFromOffGridYN) {
				// Adjust from
				ccv.from.row = ccv.to.row - vfy
			} else {
				// Adjust to
				ccv.to.row = ccv.from.row + vfy
			}
			
		} else if (vy < 0) {	// Bottom to top

			if (isFromOffGridYN) {
				// Adjust from
				ccv.from.row = ccv.to.row + vfy
			} else {
				// Adjust to
				ccv.to.row = ccv.from.row - vfy
			}
			
		}
		
		
	}
	
	fileprivate func handleLongPressed(sender: UILongPressGestureRecognizer, point: CGPoint) {
		
		// Notify the delegate
		self.delegate?.gridScapeView(for: sender, longPressed: point)
		
	}

	
	// MARK: - containerView TapGestureRecognizer Methods
	
	@IBAction func containerViewTapped(_ sender: Any) {
		
		let sender = sender as! UITapGestureRecognizer
		
		// Get tapped indicated point
		let indicatedPoint: CGPoint = sender.location(in: self.containerView)
		
		// Notify the delegate
		self.delegate?.gridScapeView(for: sender, tapped: indicatedPoint)
		
	}

	
	// MARK: - containerView LongPressGestureRecognizer Methods
	
	@IBAction func containerViewLongPressed(_ sender: Any) {
		
		let sender 		= sender as! UILongPressGestureRecognizer
		
		// Get point
		let point: 		CGPoint = sender.location(in: self.containerView)

		if (sender.state == .began) {
			
			self.handleLongPressed(sender: sender, point: point)
			
			// Dragging started
			self.handleDraggingStarted(fromIndicated: point)
			
		} else if (sender.state == .changed) {
			
			// Dragging continued
			self.handleDraggingContinued(currentIndicated: point)
			
		} else if (sender.state == .ended) {
			
			self.handleLongPressed(sender: sender, point: point)
			
			// Dragging stopped
			self.handleDraggingStopped()
			
		}
		
	}
	
}

// MARK: - Extension ProtocolGridScapeViewControlManagerDelegate

extension GridScapeView: ProtocolGridScapeViewControlManagerDelegate {
	
	// MARK: - Public Methods
	
}

// MARK: - Extension ProtocolPanGestureHelperDelegate

extension GridScapeView: ProtocolPanGestureHelperDelegate {
	
	// MARK: - Public Methods
	
	public func panGestureHelper(for gesture: UIPanGestureRecognizer, panningStartedWith attributes: PanGestureAttributes) {
		
		// Notify the delegate
		self.delegate?.gridScapeView(for: gesture, panningStartedWith: attributes)

	}
	
	public func panGestureHelper(for gesture: UIPanGestureRecognizer, panningContinuedWith attributes: PanGestureAttributes) {

		// Notify the delegate
		self.delegate?.gridScapeView(for: gesture, panningContinuedWith: attributes)
		
	}
	
	public func panGestureHelper(for gesture: UIPanGestureRecognizer, panningStoppedWith attributes: PanGestureAttributes) {
		
		// Notify the delegate
		self.delegate?.gridScapeView(for: gesture, panningStoppedWith: attributes)
		
	}
	
	public func panGestureHelper(for gesture: UIPanGestureRecognizer, panningStoppedAfterThresholdWith attributes: PanGestureAttributes) {
		
		// Notify the delegate
		self.delegate?.gridScapeView(for: gesture, panningStoppedAfterThresholdWith: attributes)

	}
	
	public func panGestureHelper(for gesture: UIPanGestureRecognizer, panningStoppedBeforeThresholdWith attributes: PanGestureAttributes) {

		// Notify the delegate
		self.delegate?.gridScapeView(for: gesture, panningStoppedBeforeThresholdWith: attributes)
		
	}
	
}

// MARK: - Extension UIGestureRecognizerDelegate

extension GridScapeView: UIGestureRecognizerDelegate {


}



