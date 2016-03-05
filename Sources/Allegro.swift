//
//  Allegro.swift
//  Allegro
//
//  Created by Bradley Hilton on 1/26/16.
//  Copyright © 2016 Brad Hilton. All rights reserved.
//

var is64BitPlatform: Bool {
    return sizeof(Int) == sizeof(Int64)
}

public func constructType<T>(constructor: Field throws -> Any) throws -> T {
    let pointer = UnsafeMutablePointer<T>.alloc(1)
    defer { pointer.dealloc(1) }
    var storage = UnsafeMutablePointer<Int>(pointer)
    var values = [Any]()
    try constructType(&storage, values: &values, fields: fieldsForType(T.self), constructor: constructor)
    return pointer.memory
}

private func constructType(inout storage: UnsafeMutablePointer<Int>, inout values: [Any], fields: [Field], constructor: Field throws -> Any) throws {
    for field in fields {
        var value = try constructor(field)
        guard instance(value, isOfType: field.type) else {
            throw Error.ValueIsNotOfType(value: value, type: field.type)
        }
        values.append(value)
        storage.consumeBuffer(bufferForInstance(&value))
    }
}

public struct Field {
    public let name: String
    public let type: Any.Type
}

public func fieldsForType(type: Any.Type) throws -> [Field] {
    guard let metadata = Metadata.Struct(type: type) else {
        throw Error.NotStruct(type: type)
    }
    let fieldNames = metadata.nominalTypeDescriptor.fieldNames
    let fieldTypes = metadata.fieldTypes ?? []
    return (0..<metadata.nominalTypeDescriptor.numberOfFields).map { Field(name: fieldNames[$0], type: fieldTypes[$0]) }
}

public enum Error : ErrorType, CustomStringConvertible {
    
    case NotStruct(type: Any.Type)
    case ValueIsNotOfType(value: Any, type: Any.Type)
    
    public var description: String {
        return "Allegro Error: \(caseDescription)"
    }
    
    var caseDescription: String {
        switch self {
        case .NotStruct(type: let type): return "\(type) is not a struct"
        case .ValueIsNotOfType(value: let value, type: let type): return "Cannot set value of type \(value.dynamicType) as \(type)"
        }
    }
}
