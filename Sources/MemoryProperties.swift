//
//  MemoryProperties.swift
//  Allegro
//
//  Created by Bradley Hilton on 6/16/16.
//  Copyright © 2016 Brad Hilton. All rights reserved.
//

public func alignof(x: Any.Type) -> Int {
    return Metadata(type: x).valueWitnessTable.align
}

public func sizeof(x: Any.Type) -> Int {
    return Metadata(type: x).valueWitnessTable.size
}

public func strideof(x: Any.Type) -> Int {
    return Metadata(type: x).valueWitnessTable.stride
}

public func alignofValue(x: Any) -> Int {
    return alignof(x.dynamicType)
}

public func sizeofValue(x: Any) -> Int {
    return sizeof(x.dynamicType)
}

public func strideofValue(x: Any) -> Int {
    return strideof(x.dynamicType)
}
