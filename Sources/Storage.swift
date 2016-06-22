//
//  Storage.swift
//  Allegro
//
//  Created by Bradley Hilton on 3/17/16.
//  Copyright © 2016 Brad Hilton. All rights reserved.
//

func mutableStorageForInstance(inout instance: Any) -> UnsafeMutablePointer<Int> {
    return UnsafeMutablePointer<Int>(storageForInstance(&instance))
}

func storageForInstance(inout instance: Any) -> UnsafePointer<UInt8> {
    return withUnsafePointer(&instance) { pointer in
        if instance is AnyObject {
            return UnsafePointer(bitPattern: UnsafePointer<Int>(pointer).memory)
        } else if sizeofValue(instance) <= 3 * sizeof(Int) {
            return UnsafePointer(pointer)
        } else {
            return UnsafePointer(bitPattern: UnsafePointer<Int>(pointer).memory)
        }
    }
}

func mutableStorageForInstance<T>(inout instance: T) -> UnsafeMutablePointer<UInt8> {
    return UnsafeMutablePointer(storageForInstance(&instance))
}

func storageForInstance<T>(inout instance: T) -> UnsafePointer<UInt8> {
    return withUnsafePointer(&instance) { pointer in
        if instance is AnyObject {
            return UnsafePointer(bitPattern: UnsafePointer<Int>(pointer).memory)
        } else {
            return UnsafePointer(pointer)
        }
    }
}
