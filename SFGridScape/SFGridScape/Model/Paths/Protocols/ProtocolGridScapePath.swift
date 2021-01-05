//
//  ProtocolGridScapePath.swift
//  SFGridScape
//
//  Created by David on 07/02/2019.
//  Copyright © 2019 David. All rights reserved.
//

import UIKit

public protocol ProtocolGridScapePath: class {

	// MARK: - Methods
	
	var id: String { get set }
	var pathAttributesString: String { get set }
	var pathLogString: String { get set }
	
}

