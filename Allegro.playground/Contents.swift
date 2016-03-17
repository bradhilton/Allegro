import Allegro

struct Object {
    
    var string = "Brad"
    
}

if let fields = try? fieldsForType(Object) {
    dump(fields)
}

do {
    let fields = try fieldsForType(Object)
    var object = Object()
    withUnsafePointer(&object) {
        UnsafePointer<Int>($0)[0]
        UnsafePointer<Int>($0)[1]
        UnsafePointer<Int>($0)[2]
        UnsafePointer<Int>($0)[3]
    }
} catch {
    
}

let object = Object()
let value: String? = try? valueForKey("name", ofInstance: object)