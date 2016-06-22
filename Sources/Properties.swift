//
//  Properties.swift
//  Allegro
//
//  Created by Bradley Hilton on 4/5/16.
//  Copyright © 2016 Brad Hilton. All rights reserved.
//

/// Represents an instance property
public struct Property {
    public let key: String
    public let value: Any
}

/// Retrieve the properties for `instance`
public func propertiesForInstance(instance: Any) throws -> [Property] {
    let fields = try fieldsForType(instance.dynamicType)
    var copy = instance
    return fields.map { nextPropertyForField($0, pointer: storageForInstance(&copy)) }
}

private func nextPropertyForField(field: Field, pointer: UnsafePointer<UInt8>) -> Property {
    return Property(key: field.name, value: AnyExistentialContainer(type: field.type, pointer: pointer.advancedBy(field.offset)).any)
}
