//
//  Buffer.swift
//  Allegro
//
//  Created by Bradley Hilton on 3/4/16.
//  Copyright © 2016 Brad Hilton. All rights reserved.
//

protocol Advancable : RandomAccessIndexType {}

extension Advancable {
    
    mutating func advance() {
        self = advancedBy(1)
    }
    
}

extension UnsafePointer : Advancable {}
extension UnsafeMutablePointer : Advancable {}

func bufferForInstance(inout instance: Any) -> UnsafeBufferPointer<Int> {
    let size = Metadata(type: instance.dynamicType).valueWitnessTable.size
    let length = (size / sizeof(Int)) + (size % sizeof(Int) == 0 ? 0 : 1)
    let pointer: UnsafePointer<Int> = withUnsafePointer(&instance) { pointer in
        if length <= 3 {
            return UnsafePointer<Int>(pointer)
        } else {
            return UnsafePointer<Int>(bitPattern: UnsafePointer<Int>(pointer)[0])
        }
    }
    return UnsafeBufferPointer(start: pointer, count: length)
}

extension UnsafeMutableBufferPointer {
    
    mutating func consumeBuffer(buffer: UnsafeBufferPointer<Int>) {
        
    }
    
}

extension UnsafeMutablePointer {
    
    mutating func consumeBuffer(buffer: UnsafeBufferPointer<Int>) {
        var pointer = UnsafeMutablePointer<Int>(self)
        buffer.forEach {
            pointer.memory = $0
            pointer.advance()
        }
        self = UnsafeMutablePointer(pointer)
    }
    
}