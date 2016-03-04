//
//  Allegro.swift
//  Allegro
//
//  Created by Bradley Hilton on 1/26/16.
//  Copyright © 2016 Brad Hilton. All rights reserved.
//

class Instance {}

private var is64BitPlatform: Bool {
    return sizeof(Int) == sizeof(Int64)
}

public func constructType<T>(constructor: Field throws -> Any) throws -> T {
    let pointer = UnsafeMutablePointer<T>.alloc(1)
    defer { pointer.dealloc(1) }
    var storage = storageForPointer(pointer)
    var values = [Any]()
    try constructType(&storage, values: &values, fields: fieldsForType(T.self), constructor: constructor)
    return pointer.move()
}

func storageForPointer<T>(pointer: UnsafeMutablePointer<T>) -> UnsafeMutablePointer<Int> {
    if T.self is AnyClass {
        let heap = UnsafeMutablePointer<Int>.alloc(32)
        for i in 0..<32 {
            heap.advancedBy(i).initialize(0)
        }
        UnsafeMutablePointer<Int>(pointer).memory = heap.hashValue
        heap.memory = Metadata(type: T.self).pointer.hashValue
        return heap.advancedBy(2)
    }
    return UnsafeMutablePointer<Int>(pointer)
}

private typealias FieldTypesFunction = @convention(c) UnsafePointer<Int> -> UnsafePointer<UnsafePointer<Int>>

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
    guard let nominalType = Metadata(type: type).nominalType else {
        throw Error.NotClassOrStruct(type: type)
    }
    let fieldNames = nominalType.nominalTypeDescriptor.fieldNames
    let fieldTypes = nominalType.fieldTypes ?? []
    return (0..<nominalType.nominalTypeDescriptor.numberOfFields).map { Field(name: fieldNames[$0], type: fieldTypes[$0]) }
}

public enum Error : ErrorType, CustomStringConvertible {
    
    case NotClassOrStruct(type: Any.Type)
    case ValueIsNotOfType(value: Any, type: Any.Type)
    
    public var description: String {
        return "Allegro Error: \(caseDescription)"
    }
    
    var caseDescription: String {
        switch self {
        case .NotClassOrStruct(type: let type): return "\(type) is not a class or struct"
        case .ValueIsNotOfType(value: let value, type: let type): return "Cannot set value of type \(value.dynamicType) as \(type)"
        }
    }
}

private func memory<T, U>(inout memory: T, _ path: Int...) -> U {
    var pointer = withUnsafePointer(&memory, memoryPointer)
    path.forEach { pointer = UnsafePointer<Int>(bitPattern: pointer.memory).advancedBy($0) }
    return UnsafePointer<U>(pointer).memory
}

private func memoryPointer<T>(memory: UnsafePointer<T>) -> UnsafePointer<Int> {
    let pointer = UnsafeMutablePointer<Int>.alloc(1)
    pointer.initialize(memory.hashValue)
    return UnsafePointer(pointer)
}
