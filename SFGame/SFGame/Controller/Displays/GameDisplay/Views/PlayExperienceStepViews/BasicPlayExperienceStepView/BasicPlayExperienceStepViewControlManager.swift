//
//  BasicPlayExperienceStepViewControlManager.swift
//  SFGame
//
//  Created by David on 24/11/2017.
//  Copyright © 2017 com.smartfoundation. All rights reserved.
//

/// Manages the BasicPlayExperienceStepView control layer
public class BasicPlayExperienceStepViewControlManager: PlayExperienceStepViewControlManagerBase {
	
	// MARK: - Public Stored Properties
	
	
	// MARK: - Private Stored Properties


	// MARK: - Initializers
	
	public override init() {
		super.init()
	}
	
	public override init(modelManager: GameModelManager, viewManager: PlayExperienceStepViewViewManagerBase) {
		super.init(modelManager: modelManager, viewManager: viewManager)

	}
	
	
	// MARK: - Public Methods

	
	// MARK: - Override Methods
	
	public override func display() {
		
		self.doDisplayQuestion()
		self.doDisplayOptions()
		
	}
	
	public func optionSelected(optionText: String, isCorrectYN: Bool) {
		
		self.doAfterOptionSelected(optionText: optionText,isCorrectYN: isCorrectYN)
		
	}
	
	
	// MARK: - Private Methods

	fileprivate func doDisplayQuestion() {
		
		let questionText: String = self.playExperienceStepWrapper!.playExperienceStepContentData!.get(key: "QuestionText")!
		
		(self.viewManager as? BasicPlayExperienceStepViewViewManager)?.display(questionText: questionText)
		
	}
	
	fileprivate func doDisplayOptions() {

		let correctOption: Int = Int(self.playExperienceStepWrapper!.playExperienceStepContentData!.get(key: "CorrectOption")!)!
		
		let option1Text: String = self.playExperienceStepWrapper!.playExperienceStepContentData!.get(key: "Option1Text")!

		let option2Text: String = self.playExperienceStepWrapper!.playExperienceStepContentData!.get(key: "Option2Text")!
		
		(self.viewManager as? BasicPlayExperienceStepViewViewManager)?.display(option1Text: option1Text, isCorrectYN: (correctOption == 1))
		
		(self.viewManager as? BasicPlayExperienceStepViewViewManager)?.display(option2Text: option2Text, isCorrectYN: (correctOption == 2))
		
	}
	
	fileprivate func doAfterOptionSelected(optionText: String, isCorrectYN: Bool) {
		
		if (isCorrectYN) {
			
			(self.viewManager as? BasicPlayExperienceStepViewViewManager)?.displayResult()
			
			self.doAfterExperienceStepCompleted()
			
			// Notify the delegate
			self.delegate?.playExperienceStepViewControlManager(playExperienceStepCompleted: self.playExperienceStepWrapper!)
			
		} else {
			
			self.repeatedYN = true
			
		}
		
	}
	
}
