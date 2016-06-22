//
//  Allegro.swift
//  Allegro
//
//  Created by Bradley Hilton on 1/26/16.
//  Copyright © 2016 Brad Hilton. All rights reserved.
//

/// Represents a type field
public struct Field {
    public let name: String
    public let type: Any.Type
    let offset: Int
}

/// Retrieve the fields for `type`
public func fieldsForType(type: Any.Type) throws -> [Field] {
    guard let nominalType = Metadata(type: type).nominalType else {
        throw Error.NotStructOrClass(type: type)
    }
    guard nominalType.nominalTypeDescriptor.numberOfFields != 0 else { return [] }
    guard let fieldTypes = nominalType.fieldTypes, let fieldOffsets = nominalType.fieldOffsets else {
        throw Error.Unexpected
    }
    let fieldNames = nominalType.nominalTypeDescriptor.fieldNames
    return (0..<nominalType.nominalTypeDescriptor.numberOfFields).map { i in
        return Field(name: fieldNames[i], type: fieldTypes[i], offset: fieldOffsets[i])
    }
}

