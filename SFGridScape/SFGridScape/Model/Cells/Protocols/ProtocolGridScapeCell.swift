//
//  ProtocolGridScapeCell.swift
//  SFGridScape
//
//  Created by David on 07/02/2019.
//  Copyright © 2019 David. All rights reserved.
//

import UIKit

public protocol ProtocolGridScapeCell: class {

	// MARK: - Methods
	
	var id: String { get set }
	var cellTypeID: String { get set }
	var column: Int { get set }
	var row: Int { get set }
	var rotationDegrees: Int { get set }
	var imageName: String { get set }
	var cellAttributesString: String { get set }
	var cellSideAttributesString: String { get set }
	
}
