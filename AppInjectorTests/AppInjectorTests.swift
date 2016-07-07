//
//  AppInjectorTests.swift
//  AppInjectorTests
//
//  Created by will3 on 7/07/16.
//  Copyright © 2016 will3. All rights reserved.
//

import XCTest
import AppInjector

class Car: NSObject {
    var name = ""
    var engine: Engine?
}

class Engine: NSObject { }

class AppInjectorTests: XCTestCase {
    
    func testBindValue() {
        let injector = Injector()
        injector.bind("name", value: "private")
        assert(injector.resolve("name") as! String == "private")
    }

    func testBindFactory() {
        let injector = Injector()
        injector.bind("car") {
            let car = Car()
            car.name = "batmobile"
            return car
        }
        
        let car = injector.resolve("car") as! Car
        assert(car.name == "batmobile")
    }
    
    func testBindType() {
        let injector = Injector()
        injector.bind("car", type: Car.self)
        assert(injector.resolve("car") is Car)
    }
    
    func testBindPropertyInjection() {
        let injector = Injector()
        injector.bind("engine") { Engine() }
        injector.bind("name", value: "private")
        injector.bind("car", type: Car.self).withDependencies(["name", "engine"])
        
        let car = injector.resolve("car") as! Car
        
        assert(car.engine != nil)
        assert(car.name == "private")
    }
    
    func testBindPropertyInjectionWithMapping() {
        let injector = Injector()
        // Dependencies are named differently from property keys
        injector.bind("engine2", type: Engine.self)
        injector.bind("name2", value: "private")
        // Custom mapping
        injector.bind("car", type: Car.self)
            .withDependencies(["name2": "name", "engine2": "engine"])
        
        let car = injector.resolve(Car.self)
        
        // Results should be the same
        assert(car.engine != nil)
        assert(car.name == "private")   
    }
    
    func testBindOnce_createSingleton() {
        let injector = Injector()
        injector.bind("car", type:Car.self).createOnce(true)
        let car1 = injector.resolve("car")
        let car2 = injector.resolve("car")
        
        assert(car1 === car2)
    }
    
    func testBindOnce_createSingleton_negative() {
        let injector = Injector()
        injector.bind("car", type:Car.self).createOnce(false)
        let car1 = injector.resolve("car")
        let car2 = injector.resolve("car")
        
        assert(car1 !== car2)
    }
}
