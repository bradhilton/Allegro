//
//  ConstructType.swift
//  Allegro
//
//  Created by Bradley Hilton on 3/17/16.
//  Copyright © 2016 Brad Hilton. All rights reserved.
//


/// Create a class or struct with a constructor method. Return a value of `field.type` for each field. Classes must conform to `Initializable`.
public func constructType(type: Any.Type, constructor: Field throws -> Any) throws -> Any {
    return try anyConstructor(type).constructAnyType(constructor)
}

protocol AnyConstructor {
    static func constructAnyType(constructor: Field throws -> Any) throws -> Any
}

struct _AnyConstructor<T> : AnyConstructor {
    static func constructAnyType(constructor: Field throws -> Any) throws -> Any {
        let result: T = try constructType(constructor)
        return result
    }
}

func anyConstructor(type: Any.Type) -> AnyConstructor.Type {
    unsafeBitCast(_AnyConstructor<Void>.self as Any.Type, UnsafeMutablePointer<Int>.self)[3] = unsafeBitCast(type, Int.self)
    return _AnyConstructor<Void>.self
}

public protocol Initializable : class {
    init()
}

/// Create a class or struct with a constructor method. Return a value of `field.type` for each field. Classes must conform to `Initializable`.
public func constructType<T>(constructor: Field throws -> Any) throws -> T {
    guard case _? = Metadata(type: T.self).nominalType else { throw Error.NotStructOrClass(type: T.self) }
    if Metadata(type: T.self)?.kind == .Struct {
        return try constructValueType(constructor)
    } else if let initializable = T.self as? Initializable.Type {
        return try constructReferenceType(initializable.init() as! T, constructor: constructor)
    } else {
        throw Error.ClassNotInitializable(type: T.self)
    }
}

private func constructValueType<T>(constructor: Field throws -> Any) throws -> T {
    guard Metadata(type: T.self)?.kind == .Struct else { throw Error.NotStructOrClass(type: T.self) }
    let pointer = UnsafeMutablePointer<T>.alloc(1)
    defer { pointer.dealloc(1) }
    var values = [Any]()
    try constructType(UnsafeMutablePointer<UInt8>(pointer), values: &values, fields: fieldsForType(T.self), constructor: constructor)
    return pointer.memory
}

private func constructReferenceType<T>(value: T, constructor: Field throws -> Any) throws -> T {
    var copy = value
    var values = [Any]()
    try constructType(mutableStorageForInstance(&copy), values: &values, fields: fieldsForType(T.self), constructor: constructor)
    return copy
}

private func constructType(storage: UnsafeMutablePointer<UInt8>, inout values: [Any], fields: [Field], constructor: Field throws -> Any) throws {
    for field in fields {
        var value = try constructor(field)
        guard instanceValue(value, isOfType: field.type) else { throw Error.ValueIsNotOfType(value: value, type: field.type) }
        values.append(value)
        storage.advancedBy(field.offset).consumeBuffer(bytesForInstance(&value))
    }
}

/// Create a class or struct from a dictionary. Classes must conform to `Initializable`.
public func constructType<T>(dictionary: [String: Any]) throws -> T {
    return try constructType(constructorForDictionary(dictionary))
}

private func constructorForDictionary(dictionary: [String: Any]) -> Field throws -> Any {
    return { field in
        if let value = dictionary[field.name] {
            return value
        } else if let nilLiteralConvertible = field.type as? NilLiteralConvertible.Type {
            return nilLiteralConvertible.init(nilLiteral: ())
        } else {
            throw Error.RequiredValueMissing(key: field.name)
        }
    }
}
