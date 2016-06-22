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

func bytesForInstance(inout instance: Any) -> UnsafeBufferPointer<UInt8> {
    let size = sizeofValue(instance)
    let pointer: UnsafePointer<UInt8> = withUnsafePointer(&instance) { pointer in
        if size <= 3 * sizeof(Int) {
            return UnsafePointer(pointer)
        } else {
            return UnsafePointer(bitPattern: UnsafePointer<Int>(pointer)[0])
        }
    }
    return UnsafeBufferPointer(start: pointer, count: size)
}

extension UnsafeMutablePointer {
    
    func consumeBuffer(buffer: UnsafeBufferPointer<UInt8>) {
        let pointer = UnsafeMutablePointer<UInt8>(self)
        for (i, byte) in buffer.enumerate() {
            pointer[i] = byte
        }
    }
    
}
