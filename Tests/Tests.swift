//
//  AllegroTests.swift
//  AllegroTests
//
//  Created by Bradley Hilton on 1/28/16.
//  Copyright © 2016 Brad Hilton. All rights reserved.
//

import XCTest
import Allegro

class Person : Equatable {
    
    var firstName: String
    var lastName: String
    var age: Int
    var base: Base
    
    init(firstName: String, lastName: String, age: Int, base: Base) {
        self.firstName = firstName
        self.lastName = lastName
        self.age = age
        self.base = base
    }
    
}

class Base {}

class Sub : Base {}

func ==(lhs: Person, rhs: Person) -> Bool {
    return lhs.firstName == rhs.firstName && lhs.lastName == rhs.lastName && lhs.age == rhs.age
}

class Tests: XCTestCase {
    
    func testExample() {
        measureBlock {
            do {
                let person: Person = try constructType {
                    (["firstName" : "Brad", "lastName": "Hilton", "age": 27, "base": Base()] as [String : Any])[$0.name]!
                }
                let other = Person(firstName: "Brad", lastName: "Hilton", age: 27, base: Base())
                XCTAssert(person == other)
            } catch {
                XCTFail(String(error))
            }
        }
    }
    
}
