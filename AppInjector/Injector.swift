//
//  AppInjector.swift
//  AppInjector
//
//  Created by will3 on 7/07/16.
//  Copyright © 2016 will3. All rights reserved.
//

import Foundation

/** 
    Use Injector.defaultInjector, or create your own and manage it's life cycles
*/
public class Injector {
    
    /// Default instance
    public static let defaultInjector = Injector()
    
    private var bindings = [String: Binding]()
    private var typeToBindingName = [String: String]()
    
    /**
     Bind via factory
     
     - parameter name: name of binding
     - parameter factory: factory of binding
     - returns: binding object
     */
    public func bind(name: String, factory: () -> AnyObject) -> Binding {
        if bindings[name] != nil {
            fatalError("binding for \"\(name)\" already exists")
        }
        let binding = Binding()
        binding.name = name
        binding.factory = factory
        
        bindings[name] = binding
        
        return binding
    }
    
    /**
     Bind via contructor
     
     - parameter name: name of binding
     - parameter type: Type of object, needs to be NSObject
     - returns: binding object
     */
    public func bind<T: NSObject>(name: String, type: T.Type) -> Binding {
        let factory = { return T() }
        let className = "\(type)"
        typeToBindingName[className] = name
        return bind(name, factory: factory)
    }
    
    /**
     Bind constant, injector will resolve binding with value
     
     - parameter name: name of binding
     - returns: value of binding
     */
    public func bind(name: String, value: AnyObject) {
        let binding = Binding()
        binding.name = name
        binding.value = value
        
        bindings[name] = binding
    }
    
    /**
     Remove binding by name
     
     - parameter name: name of binding
     */
    public func unbind(name: String) {
        bindings[name] = nil
    }
    
    /**
     Query if binding by name is registered
     
     - paramter name: name of binding
     */
    public func has(name: String) -> Bool {
        return bindings[name] != nil
    }
    
    /**
     Resolve a binding by type, throw fatal error if binding by type is not registered
     
     - parameter type: type of binding
     - returns: resolved object
     */
    public func resolve<T>(type: T.Type) -> AnyObject {
        let className = "\(type)"
        if let name = typeToBindingName[className], let binding = bindings[name] {
            return resolve(binding)
        }
        
        fatalError("cannot find binding for \"\(className)\"")
    }
    
    /**
     Resolve a binding by name, throw fatal error if binding by name is not registered
     
     - parameter name: name of binding
     - returns: resolved object
     */
    public func resolve(name: String) -> AnyObject {
        guard let binding = bindings[name] else {
            fatalError("cannot find binding for \"\(name)\"")
        }
        return resolve(binding)
    }
    
    /**
     Resolve a binding
     
     - parameter binding: binding to resolve
     - returns: resolved object
     */
    public func resolve(binding: Binding) -> AnyObject {
        if binding.value != nil {
            return binding.value!
        }
        
        let object = binding.factory!()
        
        injectDependencies(object, binding: binding)
        
        if binding.once {
            binding.value = object
        }
        
        return object
    }
    
    /**
     Resolve dependenceis for object
     
     - parameter object: object to inject
     - paramter binding: optional binding to use
    */
    public func injectDependencies(object: AnyObject, binding: Binding? = nil) {
        guard let binding = binding ?? getBinding(object) else {
            fatalError("cannot find binding for object \(object)")
        }
        
        if binding.dependencies.count > 0 {
            guard let nsObject = object as? NSObject else {
                fatalError("dependencies specified, but the object is not injectable")
            }
            
            for (depName, propertyKey) in binding.dependencies {
                let dep = resolve(depName)
                nsObject.setValue(dep, forKey: propertyKey)
            }
        }
    }
    
    private func getBinding(object: AnyObject) -> Binding? {
        let typeName = "\(object.dynamicType)"
        guard let bindingName = typeToBindingName[typeName] else { return nil }
        return bindings[bindingName]
    }
}