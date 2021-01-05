//
//  ProtocolGridScapeTile.swift
//  SFGridScape
//
//  Created by David on 07/02/2019.
//  Copyright © 2019 David. All rights reserved.
//

import UIKit

public protocol ProtocolGridScapeTile: class {

	// MARK: - Methods
	
	var id: String { get set }
	var tileTypeID: String { get set }
	var column: Int { get set }
	var row: Int { get set }
	var rotationDegrees: Int { get set }
	var imageName: String { get set }
	var widthPixels: Int { get set }
	var heightPixels: Int { get set }
	var position: CellContentPositionTypes { get set }
	var positionFixToCellRotationYN: Bool { get set }
	var tileAttributesString: String { get set }
	var tileSideAttributesString: String { get set }
	
}
