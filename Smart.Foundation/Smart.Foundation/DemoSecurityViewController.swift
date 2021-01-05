//
//  DemoSecurityViewController.swift
//  Smart.Foundation
//
//  Created by David on 01/08/2017.
//  Copyright © 2017 com.smartfoundation. All rights reserved.
//

import UIKit
import SFSecurity

class DemoSecurityViewController: UIViewController {

	// MARK: - Private Stored Properties
	
	fileprivate var controlManager:			DemoSecurityControlManager?
	
	@IBOutlet weak var emailTextField:		UITextField!
	@IBOutlet weak var passwordTextField:	UITextField!
	@IBOutlet weak var buttonsStackView:	UIStackView!
	@IBOutlet weak var signInButton:		UIButton!
	@IBOutlet weak var signUpButton:		UIButton!
	@IBOutlet weak var userInfoLabel:		UILabel!
	
	
	// MARK: - Public Stored Properties
	
	public var delegate:					ProtocolDemoSecurityViewControllerDelegate?
	
	
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
	
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		
		// Focus out text fields
		self.emailTextField.resignFirstResponder()
		self.passwordTextField.resignFirstResponder()
	}

	
	// MARK: - Private Methods
	
	fileprivate func setup() {
		
		self.setupControlManager()
		self.setupModelManager()
		self.setupViewManager()
		self.setupAuthenticationManager()
		
		self.setupKeyboardNotifications()
		//self.setButtons()
	}
	
	fileprivate func setupControlManager() {
		
		// Setup the control manager
		self.controlManager = DemoSecurityControlManager()
		
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
		let viewAccessStrategy: ProtocolDemoSecurityViewAccessStrategy = DemoSecurityViewAccessStrategy(emailTextField, passwordTextField, signInButton, signUpButton, userInfoLabel)
		
		// Setup the view manager
		self.controlManager!.viewManager = DemoSecurityViewManager(viewAccessStrategy: viewAccessStrategy)
	}

	fileprivate func setupAuthenticationManager() {
		
		// Create authentication strategy
		let authenticationStrategy: ProtocolAuthenticationStrategy = FirebaseAuthenticationStrategy()
		
		// Setup the authentication manager
		let authenticationManager	= AuthenticationManager(authenticationStrategy: authenticationStrategy)
		
		// Setup Twitter sign in
		let twitterSignInButton		= self.setupSignInWithTwitter(using: authenticationManager)
		self.setupSignInButtonTwitter(twitterSignInButton)
		
		// Setup Facebook sign in
		let facebookSignInButton	= self.setupSignInWithFacebook(using: authenticationManager)
		self.setupSignInButtonFacebook(facebookSignInButton)
		
		self.controlManager!.set(authenticationManager: authenticationManager)
	}
	
	fileprivate func setupKeyboardNotifications() {
		
		NotificationCenter.default.addObserver(self, selector: #selector(onKeyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
		
		NotificationCenter.default.addObserver(self, selector: #selector(onKeyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
		
	}
	
	@objc fileprivate func onKeyboardWillShow() {
		// TODO: Move screen
	}
	
	@objc fileprivate func onKeyboardWillHide() {
		// TODO: Move screen
	}

	fileprivate func setupSignInWithTwitter(using authenticationManager: AuthenticationManager) -> UIButton {
		
		// Setup credential provider
		let credentialProvider = TwitterCredentialProvider()
		authenticationManager.add(credentialProvider: credentialProvider, key: .twitter)
		
		// Create completion handler
		let signInCompletionHandler: (([String : Any]?, Error?) -> Void) =
		{
			(attributes, error) -> Void in
			
			if (error == nil) {
				
				self.controlManager!.signInWithTwitter(attributes: attributes)
			}
		}

		// Get button from credential provider
		let signInButton = credentialProvider.getSignInButton(signInCompletion: signInCompletionHandler)
		
		return signInButton
	}

	fileprivate func setupSignInButtonTwitter(_ signInButton: UIButton) {
		
		// Setup size constraints
		let heightConstraint	= NSLayoutConstraint(item: signInButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 40)
		
		let widthConstraint		= NSLayoutConstraint(item: signInButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 300)
		
		signInButton.addConstraints([heightConstraint, widthConstraint])
		
		// Add button to view
		self.buttonsStackView.addArrangedSubview(signInButton)
	}
	
	fileprivate func setupSignInWithFacebook(using authenticationManager: AuthenticationManager) -> UIView {
		
		// Setup credential provider
		let credentialProvider = FacebookCredentialProvider()
		authenticationManager.add(credentialProvider: credentialProvider, key: .facebook)
		
		// Create completion handler
		let signInCompletionHandler: (([String : Any]?, Error?) -> Void) =
		{
			(attributes, error) -> Void in
			
			if (error == nil) {
				
				self.controlManager!.signInWithFacebook(attributes: attributes)
			}
		}
		
		// Get button from credential provider
		let signInButton = credentialProvider.getSignInButton(signInCompletion: signInCompletionHandler)
		
		return signInButton
	}
	
	fileprivate func setupSignInButtonFacebook(_ signInButton: UIView) {
		
		// Setup size constraints
		let heightConstraint	= NSLayoutConstraint(item: signInButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 40)
		
		let widthConstraint		= NSLayoutConstraint(item: signInButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 300)
		
		signInButton.addConstraints([heightConstraint, widthConstraint])
		
		// Add button to view
		self.buttonsStackView.addArrangedSubview(signInButton)
	}
	
	fileprivate func checkIsSignedIn() {
		
		self.controlManager!.checkIsSignedIn()
	}
	
	fileprivate func dismissSignInView() {
		
		self.delegate?.demoSecurityViewController(dismiss: self)
	}
	
	fileprivate func onSignInSuccessful() {
		
		// Dismiss view
		self.dismissSignInView()
	}

	fileprivate func onSignUpSuccessful() {
		
		self.controlManager!.checkIsSignedIn()
		
		if (self.controlManager!.isSignedInYN()) {
			
			// Dismiss view
			self.dismissSignInView()
		}
	}
	
	
	// MARK: - signInButton Methods
	
	@IBAction func signInButtonTapped(_ sender: Any) {
		
		self.controlManager!.signInWithEmail()
	}
	
	
	// MARK: - signUpButton Methods
	
	@IBAction func signUpButtonTapped(_ sender: Any) {
		
		self.controlManager!.signUp()
	}
	
}

// MARK: - Extension ProtocolDemoSecurityControlManagerDelegate

extension DemoSecurityViewController: ProtocolDemoSecurityControlManagerDelegate {
	
	// MARK: - Public Methods
	
	public func demoSecurityControlManager(signInSuccessful userProperties: UserProperties) {
		
		self.onSignInSuccessful()
	}
	
	public func demoSecurityControlManager(signUpSuccessful userProperties: UserProperties) {
		
		self.onSignUpSuccessful()
	}
}

