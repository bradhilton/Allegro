//
//  AllegroTests.swift
//  AllegroTests
//
//  Created by Bradley Hilton on 1/28/16.
//  Copyright © 2016 Brad Hilton. All rights reserved.
//

import XCTest
import Allegro

struct Person : Equatable {
    
    var firstName: String
    var lastName: String
    var age: Int
    
    init(firstName: String, lastName: String, age: Int) {
        self.firstName = firstName
        self.lastName = lastName
        self.age = age
    }

}

class Base {}

class Sub : Base {}

func ==(lhs: Person, rhs: Person) -> Bool {
    return lhs.firstName == rhs.firstName && lhs.lastName == rhs.lastName && lhs.age == rhs.age
}

class Tests: XCTestCase {
    
    func testExample() {
        for _ in 0..<100000 {
            do {
                let person: Person = try constructType {
                    (["firstName" : "Brad", "lastName": "Hilton", "age": 27] as [String : Any])[$0.name]!
                }
                let other = Person(firstName: "Brad", lastName: "Hilton", age: 27)
                XCTAssert(person == other)
            } catch {
                XCTFail(String(error))
            }
        }
    }
    
}
