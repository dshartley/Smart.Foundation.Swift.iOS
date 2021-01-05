//
//  GridBlockView.swift
//  SFGridScape
//
//  Created by David on 15/11/2017.
//  Copyright © 2017 com.smartfoundation. All rights reserved.
//

import UIKit
import SFView

/// A view class for a GridBlockView
public class GridBlockView: UIView, ProtocolGridBlockView {
	
	// MARK: - Private Stored Properties
	
	fileprivate var controlManager:				GridBlockViewControlManager?
	fileprivate var gridLines:					[UIView]?
	fileprivate var cellViewsByID:				[String: ProtocolGridCellView] = [String: ProtocolGridCellView]()
	
	
	// MARK: - Public Stored Properties
	
	public weak var delegate:					ProtocolGridBlockViewDelegate?
	public fileprivate(set) var cellViews:		[String: ProtocolGridCellView] = [String: ProtocolGridCellView]()
	public fileprivate(set) var blockState:		GridBlockState = GridBlockState()
	
	@IBOutlet weak var contentView:				UIView!
	@IBOutlet weak var gridCellsView: 			UIView!
	@IBOutlet weak var gridLinesView: 			UIView!
	@IBOutlet weak var gridBlockCoordView: 		UIView!
	@IBOutlet weak var gridBlockCoordLabel: 	UILabel!
	
	
	// MARK: - Public Computed Properties
	
	public var gridBlockProperties: GridBlockProperties? {
		get {
			
			return self.controlManager?.gridBlockProperties
			
		}
	}
	
	
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
		//self.setupView()
		
	}
	
	
	// MARK: - Override Methods
	
	
	// MARK: - Public Methods
	
	public func viewDidAppear() {
		
	}
	
	public func clearView() {
		
		// Go through each item
		for cellView in self.cellViews.values {
		
			cellView.clearView()
			
		}
	
		self.cellViews.removeAll()
		self.cellViewsByID.removeAll()
		self.gridLines?.removeAll()
		self.delegate = nil
	
	}

	public func checkHitTest(point: CGPoint, withEvent event: UIEvent?) -> UIView? {
		
		// Check gestures enabled
		if (!self.gridCellsView.isUserInteractionEnabled || self.gridCellsView.isHidden || self.gridCellsView.alpha == 0) {
			
			return nil
			
		}
		
		// Default return gridCellsView
		let v: UIView? = self.gridCellsView
		
		// Check point inside
		if (!self.gridCellsView.point(inside: point, with: event)) {

			return nil

		}
		
		// Nb: Check whether to handle the event in subviews
		
		// Go through each cellView
		for cellView in self.gridCellsView.subviews {
			
			if let cellView = cellView as? GridCellViewBase {
				
				// Convert to point inside cellView
				let cellViewPoint = self.gridCellsView.convert(point, to: cellView)
				
				// Get subView from cellView
				if let sv = cellView.checkHitTest(point: cellViewPoint, withEvent: event) {
					
					return sv
					
				}
				
			}
			
		}
		
		return v
		
	}
	
	public func set(gridBlockProperties: GridBlockProperties, gridProperties: GridProperties) {
		
		self.controlManager!.set(gridBlockProperties: gridBlockProperties, gridProperties: gridProperties)
		
		self.setSize()
		self.setupGridLines()
		self.set(gridLinesVisible: gridProperties.gridLinesVisibleYN)
		self.set(backgroundColorOn: gridProperties.blockBackgroundColorOnYN)
		self.set(blockCoordsVisible: gridProperties.blockCoordsVisibleYN)
		self.displayGridBlockCoord()
		
	}
	
	public func present(cellView: ProtocolGridCellView) {

		// Get cellView
		let cv: 	ProtocolGridCellView? = self.get(cellView: cellView.gridCellProperties!.cellCoord!)
		
		guard (cv == nil) else { return }
		
		// Get gridProperties
		let gp: 	GridProperties = self.controlManager!.gridProperties!
		
		// Set cell background color
		self.setCellBackgroundColor(cellView: cellView, alternatingCellBackgroundColorOnYN: gp.alternatingCellBackgroundColorOnYN)
		
		// Get gridBlockProperties
		let gbp: 	GridBlockProperties = self.controlManager!.gridBlockProperties!
		
		// Get gridCellProperties
		let gcp: 	GridCellProperties = cellView.gridCellProperties!
		
		// Get cellCoordRange
		let ccr: 	CellCoordRange = gbp.cellCoordRange!
		
		// Get cell column in block
		let bc: 	Int = gcp.cellCoord!.column - ccr.topLeft.column

		// Get cell row in block
		let br: 	Int =  gcp.cellCoord!.row - ccr.topLeft.row
		
		// Get x position
		let x: 		CGFloat = CGFloat(bc) * gp.cellWidth
		
		// Get y position
		let y: 		CGFloat = CGFloat(br) * gp.cellHeight
		
		// Get frame
		let f: 		CGRect = (cellView as! UIView).frame
		
		(cellView as! UIView).frame = CGRect(x: x, y: y, width: f.width, height: f.height)

		DispatchQueue.main.async {
			
			cellView.present()
			
			// Add to view
			self.gridCellsView.addSubview((cellView as! UIView))
			
			self.gridCellsView!.layoutIfNeeded()
			
		}
		
		self.calculateBlockPopulatedCells(afterPresentCellView: gcp.cellCoord!)
		
		// Set in collection
		self.set(cellView: cellView)

	}
	
	public func get(cellView cellCoord: CellCoord) -> ProtocolGridCellView? {
		
		let k: 	String = "\(cellCoord.column),\(cellCoord.row)"
		
		return self.cellViews[k]
		
	}

	public func get(cellView id: String) -> ProtocolGridCellView? {
		
		return self.cellViewsByID[id]
		
	}
	
	public func hide(cellView cellCoord: CellCoord) {
		
		// Get cellView
		let cellView: ProtocolGridCellView? = self.get(cellView: cellCoord)

		guard (cellView != nil) else { return }
		
		DispatchQueue.main.async {
			
			(cellView as! UIView).removeFromSuperview()
			
			self.gridCellsView!.layoutIfNeeded()
			
		}
		
		self.calculateBlockPopulatedCells(afterHideCellView: cellCoord)
		
		// Remove from collection
		self.remove(cellView: cellView!)
		
	}
	
	public func set(blockCoordsVisible visibleYN: Bool) {
		
		self.gridBlockCoordView.alpha = visibleYN ? 1 : 0
		
	}
	
	public func set(gridLinesVisible visibleYN: Bool) {
		
		guard (self.gridLines != nil) else { return }
		
		// Go through each item
		for lineView in self.gridLines! {
			
			lineView.alpha = (visibleYN ? self.controlManager!.gridProperties!.gridLinesAlpha : 0)
			
		}
		
	}
	
	public func set(backgroundColorOn onYN: Bool) {
		
		let gp: GridProperties = self.controlManager!.gridProperties!
		
		if (onYN) {
			
			if (gp.blockBackgroundColor != nil) {
				
				self.contentView!.backgroundColor = gp.blockBackgroundColor!
				
			} else {
				
				self.contentView!.backgroundColor = UIColorHelper.randomColor()
				
			}
			
		} else {
			
			self.contentView!.backgroundColor = nil
			
		}
		
	}
	
	public func set(alternatingCellBackgroundColorON onYN: Bool) {
		
		// Go through each item
		for cellView in self.cellViews.values {
		
			self.setCellBackgroundColor(cellView: cellView, alternatingCellBackgroundColorOnYN: onYN)
			
		}
		
	}
	
	
	// MARK: - Private Methods
	
	fileprivate func setup() {
		
		self.setupControlManager()
		self.setupModelManager()
		self.setupViewManager()
	}
	
	fileprivate func setupControlManager() {
		
		// Setup the control manager
		self.controlManager 			= GridBlockViewControlManager()
		
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
		let viewAccessStrategy: GridBlockViewViewAccessStrategy = GridBlockViewViewAccessStrategy()
		
		viewAccessStrategy.setup()
		
		// Setup the view manager
		self.controlManager!.viewManager = GridBlockViewViewManager(viewAccessStrategy: viewAccessStrategy)
	}
	
	fileprivate func setupContentView() {
		
		// Load xib
		let frameworkBundle: 			Bundle = Bundle(for: GridScapeView.self)
		frameworkBundle.loadNibNamed("GridBlockView", owner: self, options: nil)
		
		addSubview(contentView)
		
		self.layoutIfNeeded()
		
		// Position the contentView to fill the view
		contentView.frame				= self.bounds
		contentView.autoresizingMask	= [.flexibleHeight, .flexibleWidth]
	}
	
	fileprivate func setupView() {

	}
	
	fileprivate func setSize() {
	
		guard (self.controlManager != nil && self.controlManager!.gridBlockProperties != nil) else { return }
		
		// Get gridProperties
		let gp: GridProperties = self.controlManager!.gridProperties!
		
		// Get width
		let w: 	CGFloat = CGFloat(gp.cellWidth) * CGFloat(gp.blockWidthCells)
		
		// Get height
		let h: 	CGFloat = CGFloat(gp.cellHeight) * CGFloat(gp.blockHeightCells)
		
		// Set constraints
		self.widthAnchor.constraint(equalToConstant: w).isActive 	= true
		self.heightAnchor.constraint(equalToConstant: h).isActive 	= true
		
		// Set frame size
		self.frame.size = CGSize(width: w, height: h)
		
	}
	
	fileprivate func setupGridLines() {
	
		guard (self.controlManager != nil && self.controlManager!.gridBlockProperties != nil) else { return }

		// Get gridProperties
		let gp: GridProperties = self.controlManager!.gridProperties!
		
		// Clear previous grid lines
		if (self.gridLines != nil && self.gridLines!.count > 0) {
		
			// Go through each item
			for lineView in self.gridLines! {
				
				// Remove from view
				lineView.removeFromSuperview()
				
			}

		}

		// Initialise collection
		self.gridLines = [UIView]()
		
		// Check properties
		guard (gp.blockHeightCells > 0 && gp.blockWidthCells > 0 && gp.cellHeight > 0 && gp.cellWidth > 0) else { return }
		
		// For each row
		for i in 0...gp.blockHeightCells - 1 {
			
			// Create horizontal grid line
			self.createGridLine(gridLineType: .horizontal, index: i, visibleYN: false)
			
		}

		// For each column
		for i in 0...gp.blockWidthCells - 1 {
			
			// Create vertical grid line
			self.createGridLine(gridLineType: .vertical, index: i, visibleYN: false)
			
		}
		
	}
	
	fileprivate func createGridLine(gridLineType: GridLineTypes, index: Int, visibleYN: Bool) {
		
		guard (self.controlManager!.gridBlockProperties != nil) else { return }
		
		// Get gridProperties
		let gp: GridProperties = self.controlManager!.gridProperties!

		// Create lineView
		let lineView: 	UIView = UIView()
		
		// Add to collection
		self.gridLines!.append(lineView)

		// Add to view
		self.gridLinesView.addSubview(lineView)
		
		if (gridLineType == .horizontal) {
			
			// Get y position
			let y: 	CGFloat = CGFloat(index) * gp.cellHeight
			
			// heightAnchor
			lineView.heightAnchor.constraint(equalToConstant: 1).isActive = true
			
			let lc 	= NSLayoutConstraint(item: lineView, attribute: .leading, relatedBy: .equal,
											toItem: self.gridLinesView, attribute: .leading,
											multiplier: 1.0, constant: 0)
			let trc = NSLayoutConstraint(item: lineView, attribute: .trailing, relatedBy: .equal,
												 toItem: self.gridLinesView, attribute: .trailing,
												 multiplier: 1.0, constant: 0)
			let tc 	= NSLayoutConstraint(item: lineView, attribute: .top, relatedBy: .equal,
											toItem: self.gridLinesView, attribute: .top,
											multiplier: 1.0, constant: y)
			
			self.gridLinesView.addConstraints([lc, trc, tc])
			
		} else if (gridLineType == .vertical) {
			
			// Get x position
			let x: 	CGFloat = CGFloat(index) * gp.cellWidth
			
			// widthAnchor
			lineView.widthAnchor.constraint(equalToConstant: 1).isActive = true
			
			let lc 	= NSLayoutConstraint(item: lineView, attribute: .leading, relatedBy: .equal,
											toItem: self.gridLinesView, attribute: .leading,
											multiplier: 1.0, constant: x)
			let tc 	= NSLayoutConstraint(item: lineView, attribute: .top, relatedBy: .equal,
											toItem: self.gridLinesView, attribute: .top,
											multiplier: 1.0, constant: 0)
			let bc 	= NSLayoutConstraint(item: lineView, attribute: .bottom, relatedBy: .equal,
											toItem: self.gridLinesView, attribute: .bottom,
											multiplier: 1.0, constant: 0)
			
			self.gridLinesView.addConstraints([lc, tc, bc])
			
		}

		lineView.translatesAutoresizingMaskIntoConstraints 	= false
		lineView.backgroundColor 							= ((gp.gridLinesColor != nil) ? gp.gridLinesColor! : UIColor.darkGray)
		lineView.alpha										= (visibleYN ? gp.gridLinesAlpha : 0)
		
		self.gridLinesView.layoutIfNeeded()
		
	}

	fileprivate func set(cellView: ProtocolGridCellView) {
		
		// Get gridCellProperties
		let p: 	GridCellProperties? = cellView.gridCellProperties
		
		guard (p != nil) else { return }
		
		let k: 	String = "\(p!.cellCoord!.column),\(p!.cellCoord!.row)"
		
		// Set in cellViews
		self.cellViews[k] = cellView
		
		// Set in cellViewsByID
		self.cellViewsByID[cellView.id.uuidString] = cellView
		
	}
	
	fileprivate func remove(cellView: ProtocolGridCellView) {
		
		// Get gridCellProperties
		let p: 	GridCellProperties? = cellView.gridCellProperties
		
		guard (p != nil) else { return }
		
		let k: 	String = "\(p!.cellCoord!.column),\(p!.cellCoord!.row)"
		
		// Remove from cellViews
		self.cellViews.removeValue(forKey: k)
		
		// Remove from cellViewsByID
		self.cellViewsByID.removeValue(forKey: cellView.id.uuidString)
		
	}
	
	fileprivate func displayGridBlockCoord() {
		
		let blockCoord: BlockCoord = self.gridBlockProperties!.blockCoord!
		
		self.gridBlockCoordLabel.text = "\(blockCoord.column),\(blockCoord.row)"
		
	}
	
	fileprivate func setCellBackgroundColor(cellView: ProtocolGridCellView, alternatingCellBackgroundColorOnYN: Bool) {
		
		// Get gridProperties
		let gp: 	GridProperties = self.controlManager!.gridProperties!
		
		// Get gridCellProperties
		let gcp: 	GridCellProperties = cellView.gridCellProperties!
		
		// Check alternatingCellBackgroundColorOnYN
		if (alternatingCellBackgroundColorOnYN) {
			
			var bc: UIColor? = nil
			
			let c: 	Int = gcp.cellCoord!.column
			let r: 	Int = gcp.cellCoord!.row
			
			// Check row is odd
			if (r % 2 != 0) {
				
				// Check row is odd
				if (c % 2 != 0) {
					
					bc = gp.cellBackgroundColor
					
				} else {
					
					bc = gp.alternateCellBackgroundColor
					
				}
				
			} else {
				
				// Check row is odd
				if (c % 2 != 0) {
					
					bc = gp.alternateCellBackgroundColor
					
				} else {
					
					bc = gp.cellBackgroundColor
					
				}
				
			}
			
			if (bc == nil) { bc = gp.cellBackgroundColor }
			
			gcp.backgroundColor = bc
			
		} else {
			
			gcp.backgroundColor = gp.cellBackgroundColor
			
		}
		
		// Check isPresentedYN
		if (cellView.isPresentedYN) { cellView.setBackgroundColor() }
		
	}
	
	fileprivate func calculateBlockPopulatedCells(afterPresentCellView cellCoord: CellCoord) {
		
		let bs: GridBlockState = self.blockState
		
		// firstPopulatedCellColumnIndex
		if (bs.firstPopulatedCellColumnIndex == nil || cellCoord.column < bs.firstPopulatedCellColumnIndex!) {
			
			bs.firstPopulatedCellColumnIndex = cellCoord.column
		
		}
		
		// lastPopulatedCellColumnIndex
		if (bs.lastPopulatedCellColumnIndex == nil || cellCoord.column > bs.lastPopulatedCellColumnIndex!) {
		
			bs.lastPopulatedCellColumnIndex = cellCoord.column
			
		}
		
		// firstPopulatedCellRowIndex
		if (bs.firstPopulatedCellRowIndex == nil || cellCoord.row < bs.firstPopulatedCellRowIndex!) {
			
			bs.firstPopulatedCellRowIndex = cellCoord.row
			
		}
		
		// lastPopulatedCellRowIndex
		if (bs.lastPopulatedCellRowIndex == nil || cellCoord.row > bs.lastPopulatedCellRowIndex!) {
			
			bs.lastPopulatedCellRowIndex = cellCoord.row
			
		}
		
	}

	fileprivate func calculateBlockPopulatedCells(afterHideCellView cellCoord: CellCoord) {
		
		let bs: 			GridBlockState = self.blockState
		
		// Check cellCoord
		guard (cellCoord.column == bs.firstPopulatedCellColumnIndex
			|| cellCoord.column == bs.lastPopulatedCellColumnIndex
			|| cellCoord.row == bs.firstPopulatedCellRowIndex
			|| cellCoord.row == bs.lastPopulatedCellRowIndex) else { return }
		
		var firstColumn: 	Int? = nil
		var lastColumn: 	Int? = nil
		var firstRow: 		Int? = nil
		var lastRow: 		Int? = nil
		
		// Go through each item
		for cellView in self.cellViews.values {
			
			// Get cellCoord
			let cc: CellCoord = cellView.gridCellProperties!.cellCoord!
			
			if (firstColumn == nil || cc.column < firstColumn!) { firstColumn = cc.column }
			if (lastColumn == nil || cc.column > lastColumn!) { lastColumn = cc.column }
			if (firstRow == nil || cc.row < firstRow!) { firstRow = cc.row }
			if (lastRow == nil || cc.row > lastRow!) { lastRow = cc.row }
			
		}
		
		bs.firstPopulatedCellColumnIndex 	= firstColumn
		bs.firstPopulatedCellRowIndex		= firstRow
		bs.lastPopulatedCellColumnIndex		= lastColumn
		bs.lastPopulatedCellRowIndex		= lastRow
		
	}
	
}

// MARK: - Extension ProtocolGridBlockViewControlManagerDelegate

extension GridBlockView: ProtocolGridBlockViewControlManagerDelegate {
	
	// MARK: - Public Methods
	
}



