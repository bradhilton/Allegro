import Allegro

struct Object {
    
    lazy var string = "Brad"
    
}

if let fields = try? fieldsForType(Object) {
    dump(fields)
}
