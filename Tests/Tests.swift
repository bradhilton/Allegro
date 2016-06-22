//
//  AllegroTests.swift
//  AllegroTests
//
//  Created by Bradley Hilton on 1/28/16.
//  Copyright © 2016 Brad Hilton. All rights reserved.
//

import XCTest
@testable import Allegro

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

func ==(lhs: Person, rhs: Person) -> Bool {
    return lhs.firstName == rhs.firstName && lhs.lastName == rhs.lastName && lhs.age == rhs.age
}

class ReferencePerson : Initializable, Equatable {
    
    var firstName: String
    var lastName: String
    var age: Int
    
    required init() {
        self.firstName = ""
        self.lastName = ""
        self.age = 0
    }
    
    init(firstName: String, lastName: String, age: Int) {
        self.firstName = firstName
        self.lastName = lastName
        self.age = age
    }
    
}

func ==(lhs: ReferencePerson, rhs: ReferencePerson) -> Bool {
    return lhs.firstName == rhs.firstName && lhs.lastName == rhs.lastName && lhs.age == rhs.age
}

class Tests: XCTestCase {
    
    func testMemoryProperties() {
        func testMemoryProperties<T>(type: T.Type) {
            XCTAssert(alignof((T.self as Any.Type)) == Swift.alignof(T.self))
            XCTAssert(sizeof((T.self as Any.Type)) == Swift.sizeof(T.self))
            XCTAssert(strideof((T.self as Any.Type)) == Swift.strideof(T.self))
        }
        testMemoryProperties(Bool)
        testMemoryProperties(UInt8)
        testMemoryProperties(UInt16)
        testMemoryProperties(UInt32)
        testMemoryProperties(Float)
        testMemoryProperties(Double)
        testMemoryProperties(String)
        testMemoryProperties(Array<Int>)
    }
    
    func testConstructType() {
        for _ in 0..<1000 {
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
    
    func testConstructFlags() {
        struct Flags {
            let x: Bool
            let y: Bool?
            let z: (Bool, Bool)
        }
        do {
            let flags: Flags = try constructType([
                    "x": false,
                    "y": Optional<Bool>(),
                    "z": (true, false)
                ])
            XCTAssert(!flags.x)
            XCTAssert(flags.y == nil)
            XCTAssert(flags.z == (true, false))
        } catch {
            XCTFail(String(error))
        }
    }
    
    func testConstructObject() {
        struct Object {
            let flag: Bool
            let pair: (UInt8, UInt8)
            let float: Float?
            let integer: Int
            let string: String
        }
        do {
            let object: Object = try constructType([
                    "flag": true,
                    "pair": (UInt8(1), UInt8(2)),
                    "float": Optional(Float(89.0)),
                    "integer": 123,
                    "string": "Hello, world"
                ])
            XCTAssert(object.flag)
            XCTAssert(object.pair == (1, 2))
            XCTAssert(object.float == 89.0)
            XCTAssert(object.integer == 123)
            XCTAssert(object.string == "Hello, world")
        } catch {
            XCTFail(String(error))
        }
    }
    
    func testConstructReferenceType() {
        for _ in 0..<1000 {
            do {
                let person: ReferencePerson = try constructType {
                    (["firstName" : "Brad", "lastName": "Hilton", "age": 27] as [String : Any])[$0.name]!
                }
                let other = ReferencePerson(firstName: "Brad", lastName: "Hilton", age: 27)
                XCTAssert(person == other)
            } catch {
                XCTFail(String(error))
            }
        }
    }
    
    func testPropertiesForInstance() {
        var properties = [Property]()
        do {
            let person = Person(firstName: "Brad", lastName: "Hilton", age: 27)
            properties = try propertiesForInstance(person)
            guard properties.count == 3 else {
                XCTFail("Unexpected number of properties"); return
            }
            guard let firstName = properties[0].value as? String, let lastName = properties[1].value as? String, let age = properties[2].value as? Int else {
                XCTFail("Unexpected properties"); return
            }
            XCTAssert(person.firstName == firstName)
            XCTAssert(person.lastName == lastName)
            XCTAssert(person.age == age)
        } catch {
            XCTFail(String(error))
        }
    }
    
    func testSetValueForKeyOfInstance() {
        do {
            var person = Person(firstName: "Brad", lastName: "Hilton", age: 27)
            try Allegro.setValue("Lawrence", forKey: "firstName", ofInstance: &person)
            XCTAssert(person.firstName == "Lawrence")
        } catch {
            XCTFail(String(error))
        }

    }
    
    func testValueForKeyOfInstance() {
        do {
            let person = Person(firstName: "Brad", lastName: "Hilton", age: 29)
            let firstName: String = try Allegro.valueForKey("firstName", ofInstance: person)
            XCTAssert(person.firstName == firstName)
        } catch {
            XCTFail(String(error))
        }
    }
    
}
