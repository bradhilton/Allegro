//
//  HeapObject.swift
//  Allegro
//
//  Created by Bradley Hilton on 3/4/16.
//  Copyright © 2016 Brad Hilton. All rights reserved.
//

class ClassInstance {
    
    var heapObject: HeapObject {
        get {
            return UnsafePointer<HeapObject>(unsafeAddressOf(self)).memory
        }
        set {
            UnsafeMutablePointer<HeapObject>(unsafeAddressOf(self)).memory = newValue
        }
    }
    
    var pointer: UnsafeMutablePointer<Int> {
        return UnsafeMutablePointer<Int>(unsafeAddressOf(self)).advancedBy(2)
    }
    
}

struct HeapObject {
    
    var metadata: Any.Type
    var reserved = 0
    var buffer = (0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                0, 0, 0, 0, 0, 0, 0, 0, 0, 0)
    
}
