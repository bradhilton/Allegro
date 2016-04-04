import Allegro

class Person {
    var name: String = ""
}

do {
    var object: Person = try constructType { field in return "Evan" }
} catch {
    error
}



