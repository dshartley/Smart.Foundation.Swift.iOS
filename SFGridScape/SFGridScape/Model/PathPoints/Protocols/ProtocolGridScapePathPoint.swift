//
//  ProtocolGridScapePathPoint.swift
//  SFGridScape
//
//  Created by David on 07/02/2019.
//  Copyright © 2019 David. All rights reserved.
//

import UIKit

public protocol ProtocolGridScapePathPoint: class {

	// MARK: - Methods
	
	var id: String { get set }
	var pathID: String { get set }
	var index: Int { get set }
	var column: Int { get set }
	var row: Int { get set }

}
