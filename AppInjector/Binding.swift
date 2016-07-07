//
//  Binding.swift
//  AppInjector
//
//  Created by will3 on 7/07/16.
//  Copyright © 2016 will3. All rights reserved.
//

import Foundation

/**
    Defines a dependency and how it should be resolved
*/
public class Binding {
    /// Name of binding
    public var name = ""
    /// Factory used to resolve this binding, if any
    public var factory: (() -> AnyObject)?
    /// Dependencies used by property injection, [binding name: property key]
    public var dependencies = [String: String]()
    /// Value of binding, if specified, should resolve using this value
    public var value: AnyObject?
    /// If true, only create one instance
    public var once = false
    
    /**
        Setter for `dependencies`
     
        - returns: self for chainability
    */
    public func withDependencies(dependencies: [String: String]) -> Self {
        self.dependencies = dependencies
        return self
    }
    
    /**
        Setter for `dependencies`, where <binding name> and <property key> are the same
     
        - returns: self for chainability
    */
    public func withDependencies(dependencies: [String]) -> Self {
        self.dependencies = expand(dependencies)
        return self
    }
    
    /**
        Setter for `once`
     
        - returns: self for chainability
    */
    public func createOnce(once: Bool) -> Self {
        self.once = once
        return self
    }
    
    private func expand(dependencies: [String]) -> [String: String] {
        var dic = [String: String]()
        for item in dependencies {
            dic[item] = item
        }
        return dic
    }
}