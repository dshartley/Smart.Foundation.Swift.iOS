//
//  DMViewController.swift
//  Smart.Foundation
//
//  Created by David on 23/07/2017.
//  Copyright © 2017 com.smartfoundation. All rights reserved.
//

import UIKit

class DemoModelViewController: UIViewController {

	// MARK: - Private Stored Properties
	
	fileprivate var controlManager:					DMControlManager?
	
	@IBOutlet weak var idTextField:					UITextField!
	@IBOutlet weak var stringValueTextField:		UITextField!
	@IBOutlet weak var numericValueTextField:		UITextField!
	@IBOutlet weak var modelItemsTableView:			UITableView!
	
	
	// MARK: - Override Methods
	
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		
		self.setup()
		self.loadModel()
		
		self.setupModelItemsTableView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	
	// MARK: - Private Methods
	
	fileprivate func setup() {
		
		self.setupControlManager()
		self.setupModelManager()
		self.setupViewManager()
	}

	fileprivate func setupControlManager() {
		
		// Setup the control manager
		self.controlManager = DMControlManager()
	}
	
	fileprivate func setupModelManager() {
		
		// Set the model manager
		self.controlManager!.set(modelManager: ModelFactory.modelManager)

		// Setup the model administrators
		ModelFactory.setupDMModelAdministrator(modelManager: self.controlManager!.modelManager! as! ModelManager)
	}
	
	fileprivate func setupViewManager() {
		
		// Create view strategy
		let viewAccessStrategy: ProtocolDMViewAccessStrategy = DMViewAccessStrategy(idTextField, stringValueTextField, numericValueTextField)
		
		// Setup the view manager
		self.controlManager!.viewManager = DMViewManager(viewAccessStrategy: viewAccessStrategy)
	}
	
	fileprivate func setupModelItemsTableView() {
		
		// Enable table row automatic height
		modelItemsTableView.rowHeight			= UITableViewAutomaticDimension
		modelItemsTableView.estimatedRowHeight	= 100
		
		modelItemsTableView.delegate			= self
		modelItemsTableView.dataSource			= self
	}
	
	fileprivate func loadModel() {
		
		// Create completion handler
		let loadModelCompletionHandler: ((Error?) -> Void) =
		{
			(error) -> Void in
			
			// Refresh table view
			self.modelItemsTableView.reloadData()
		}
		
		self.controlManager!.loadModel(oncomplete: loadModelCompletionHandler)
	}
	
	fileprivate func displayModel() {
		
	}
	
	fileprivate func addItem() {
		
		// Create completion handler
		let addItemCompletionHandler: ((Error?) -> Void) =
		{
			(error) -> Void in
			
			// Refresh table view
			self.modelItemsTableView.reloadData()
		}
		
		self.controlManager!.addItem(oncomplete: addItemCompletionHandler)
	}
	
	fileprivate func countItems() {
		
		// Create completion handler
		let getNumberofItemsCompletionHandler: ((Int, Error?) -> Void) =
		{
			(count, error) -> Void in
			
			self.showAlert(message: "Number of items=\(count)")
		}
		
		self.controlManager!.getNumberofItems(oncomplete: getNumberofItemsCompletionHandler)
	}
	
	fileprivate func showAlert(message: String) {
		
		let alert	= UIAlertController(title: "Information", message: message, preferredStyle: .alert)
		
		let action	= UIAlertAction(title: "Ok", style: .default, handler: nil)
		alert.addAction(action)
		
		present(alert, animated: true, completion: nil)
	}
	
	
	// MARK: - updateItemButton Methods
	
	@IBAction func updateItemButtonTapped(_ sender: Any) {
		
		self.controlManager!.updateItem()
		
		// Refresh table view
		self.modelItemsTableView.reloadData()
	}
	
	
	// MARK: - deleteItem Methods
	
	@IBAction func deleteItemButtonTapped(_ sender: Any) {
		
		self.controlManager!.deleteItem()
		
		// Refresh table view
		self.modelItemsTableView.reloadData()
	}
	
	
	// MARK: - addItemButton Methods
	
	@IBAction func addItemButtonTapped(_ sender: Any) {
		
		self.addItem()
	}
	
	
	// MARK: - addItemButton Methods
	
	@IBAction func countItemsButtonTapped(_ sender: Any) {
		
		self.countItems()
	}
	
}

// MARK: - Extension UITableViewDelegate, UITableViewDataSource

extension DemoModelViewController : UITableViewDelegate, UITableViewDataSource {
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

		return self.controlManager!.getNumberofItemsLoaded()
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		// Get the item
		let items		= self.controlManager!.getItems()
		let item: DM	= items[indexPath.row]

		// Set the text to display in the cell
		let itemText	= item.id + ", " + item.stringvalue + ", " + String(item.numericvalue)
		
		// Create the table cell
		let cell = self.modelItemsTableView.dequeueReusableCell(withIdentifier: "DefaultCell", for: indexPath)
		
		cell.textLabel?.text = itemText
		
		return cell
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		
		// Get the item
		let items		= self.controlManager!.getItems()
		let item: DM	= items[indexPath.row]
		
		// Display the item
		self.idTextField.text				= item.id
		self.stringValueTextField.text		= item.stringvalue
		self.numericValueTextField.text		= String(item.numericvalue)
		
	}
}

