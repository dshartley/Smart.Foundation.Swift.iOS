//
//  WebSocketsMessageWrapper.swift
//  SFNet
//
//  Created by David on 19/04/2018.
//  Copyright © 2018 com.smartfoundation. All rights reserved.
//

import SFSerialization

public enum WebSocketsMessageWrapperParameterKeys {
    case FunctionName
    case Text
}

/// A wrapper for a WebSocketsMessage
public class WebSocketsMessageWrapper {
    
    // MARK: - Public Stored Properties
    
    
    // MARK: - Public Stored Properties
	
    public var functionName:                    String = ""
    public var text:                            String = ""
    public fileprivate(set) var parameters:     [String:String] = [String:String]()
    public fileprivate(set) var wrapper: 		DataJSONWrapper?
	
    
    // MARK: - Initializers
    
    public init() {
        
    }
    
    
    // MARK: - Public Methods
    
    public func setParameter(key: String, value: String) {
        
        self.parameters[key] = value
        
    }
    
    public func getParameter(key: String) -> String? {

        return self.parameters[key]
        
    }
    
    public func clearParameters() {
        
        self.parameters.removeAll()
        
    }
    
    public func copyToWrapper() -> DataJSONWrapper {
        
        let result: DataJSONWrapper = DataJSONWrapper()
        
        // Set functionName
        if (self.functionName.count > 0) {
            
            result.setParameterValue(key: "\(WebSocketsMessageWrapperParameterKeys.FunctionName)", value: self.functionName)
            
        }

        // Set text
        if (self.text.count > 0) {
            
            result.setParameterValue(key: "\(WebSocketsMessageWrapperParameterKeys.Text)", value: self.text)
            
        }
        
        // Go through each parameter
        for parameter in self.parameters {
            
            result.setParameterValue(key: parameter.key, value: parameter.value)
            
        }

        return result
    }

    public func copyFromWrapper(wrapper: DataJSONWrapper) {
		
		self.wrapper = wrapper
		
        // Get functionName
        self.functionName   = wrapper.getParameterValue(key: "\(WebSocketsMessageWrapperParameterKeys.FunctionName)") ?? ""
        
        // Get text
        self.text           = wrapper.getParameterValue(key: "\(WebSocketsMessageWrapperParameterKeys.Text)") ?? ""
        
        self.parameters = [String:String]()
        
        // Go through each parameter
        for parameter in wrapper.Params {
            
            self.setParameter(key: parameter.Key, value: parameter.Value)
        }
        
    }
	
	public func toString() -> String {
		
		// Get dataWrapper
		let dataWrapper: 	DataJSONWrapper? = self.copyToWrapper()
		
		guard (dataWrapper != nil) else { return "" }
		
		// Get string
		let result: 		String = JSONHelper.SerializeDataJSONWrapper(dataWrapper: dataWrapper!)!
		
		return result
	}
	
}
