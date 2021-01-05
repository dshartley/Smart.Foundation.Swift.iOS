//
//  DemoSecurityHomeViewController.swift
//  Smart.Foundation
//
//  Created by David on 07/08/2017.
//  Copyright © 2017 com.smartfoundation. All rights reserved.
//

import UIKit
import SFSecurity

class DemoSecurityHomeViewController: UIViewController {

	// MARK: - Private Stored Properties
	
	fileprivate var controlManager:		DemoSecurityHomeControlManager?
	
	@IBOutlet weak var signOutButton:	UIButton!
	@IBOutlet weak var userInfoLabel:	UILabel!
	
	
	// MARK: - Override Methods
	
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		
		self.setup()
		
		self.checkIsSignedIn()
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
		self.setupAuthenticationManager()
	}
	
	fileprivate func setupControlManager() {
		
		// Setup the control manager
		self.controlManager = DemoSecurityHomeControlManager()
		
		// Set delegate
		self.controlManager!.add(delegate: self)
	}
	
	fileprivate func setupModelManager() {
		
		// Set the model manager
		self.controlManager!.set(modelManager: ModelFactory.modelManager)
		
		// Setup the model administrators
		//ModelFactory.setupDMModelAdministrator(modelManager: self.controlManager!.modelManager!)
	}
	
	fileprivate func setupViewManager() {
		
		// Create view strategy
		let viewAccessStrategy: ProtocolDemoSecurityHomeViewAccessStrategy = DemoSecurityHomeViewAccessStrategy(signOutButton, userInfoLabel)
		
		// Setup the view manager
		self.controlManager!.viewManager = DemoSecurityHomeViewManager(viewAccessStrategy: viewAccessStrategy)
	}
	
	fileprivate func setupAuthenticationManager() {
		
		// Create authentication strategy
		let authenticationStrategy: ProtocolAuthenticationStrategy = FirebaseAuthenticationStrategy()
		
		// Setup the authentication manager
		let authenticationManager	= AuthenticationManager(authenticationStrategy: authenticationStrategy)
		
		self.controlManager!.set(authenticationManager: authenticationManager)
	}
	
	fileprivate func checkIsSignedIn() {
		
		self.controlManager!.checkIsSignedIn()
		
		// If not signed in then present signin view
		if (!self.controlManager!.isSignedInYN()) {
			
			self.presentSignInView()
		}
	}
	
	fileprivate func presentSignInView() {
		
		if let signInViewController = storyboard?.instantiateViewController(withIdentifier: "DemoSecurityView") as? DemoSecurityViewController {
			
			// Set delegate
			signInViewController.delegate = self
			
			// Present the view
			present(signInViewController, animated: true, completion: nil)
		}
	}

	fileprivate func onSignOutSuccessful() {
		
		self.presentSignInView()
	}
	
	
	// MARK: - signOutButton Methods
	
	@IBAction func signOutButtonTapped(_ sender: Any) {
		
		self.controlManager!.signOut()
	}

}

// MARK: - Extension ProtocolDemoSecurityHomeControlManagerDelegate

extension DemoSecurityHomeViewController: ProtocolDemoSecurityHomeControlManagerDelegate {
	
	// MARK: - Public Methods
	
	public func demoSecurityHomeControlManager(signOutSuccessful userProperties: UserProperties) {
		
		self.onSignOutSuccessful()
	}
}

// MARK: - Extension ProtocolDemoSecurityViewControllerDelegate

extension DemoSecurityHomeViewController: ProtocolDemoSecurityViewControllerDelegate {

	// MARK: - Public Methods
	
	public func demoSecurityViewController(dismiss controller: UIViewController) {
		
		self.checkIsSignedIn()
		
		// Dismiss the view
		controller.dismiss(animated: true, completion: nil)
	}
}

