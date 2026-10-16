// Topic 5: Enums Structs Classes
// All three tasks are in this one file. Run it in a Playground or with `swift Topic05_Enums_Structs_Classes.swift`.

import Foundation

// ======================================================================
// Topic 5 - Task 1: Library item model (Guided Activity)
// ======================================================================
print("\n===== Task 1 =====")

// Steps 1 and 2: enum with associated values and a computed label
enum BookStatus {
    case available
    case borrowed(by: String, dueIn: Int)      // dueIn = days left
    case reserved(for: String)

    var label: String {
        switch self {
        case .available:
            return "Available"
        case .borrowed(let by, let dueIn):
            return "Borrowed by \(by), due in \(dueIn) days"
        case .reserved(let person):
            return "Reserved for \(person)"
        }
    }
}

// Step 3: struct (value type)
struct Book {
    var title: String
    var status: BookStatus = .available
}

// Step 4: class (reference type)
class Member {
    var name: String
    var borrowedBooks: [Book] = []

    init(name: String) {
        self.name = name
    }
}

// Step 5: copying a struct gives an independent copy
let original = Book(title: "Swift Programming")
var copy = original
copy.status = .borrowed(by: "Asha", dueIn: 7)

print("Original: \(original.title) - \(original.status.label)")
print("Copy:     \(copy.title) - \(copy.status.label)")
// the original is still Available, only the copy changed

// Step 6: assigning a class instance shares the same object
let member = Member(name: "Asha")
let sameMember = member
sameMember.name = "Ravi"          // allowed even though sameMember is a let

print("member.name = \(member.name)")            // Ravi
print("sameMember.name = \(sameMember.name)")    // Ravi
// both constants point to one object, so the change shows up in both

// ======================================================================
// Topic 5 - Task 2: Shapes and areas (Practice Task)
// ======================================================================
print("\n===== Task 2 =====")


enum Shape {
    case circle(radius: Double)
    case rectangle(width: Double, height: Double)
    case triangle(base: Double, height: Double)

    var area: Double {
        switch self {
        case .circle(let radius):
            return Double.pi * radius * radius
        case .rectangle(let width, let height):
            return width * height
        case .triangle(let base, let height):
            return 0.5 * base * height
        }
    }
}

let shapes: [Shape] = [
    .circle(radius: 3),
    .rectangle(width: 4, height: 5),
    .triangle(base: 6, height: 2)
]
for shape in shapes {
    print("\(shape) has area \(String(format: "%.2f", shape.area))")
}

struct Rectangle {
    var width: Double
    var height: Double

    var perimeter: Double {
        return 2 * (width + height)
    }

    // mutating because a struct method that changes its own properties must say so
    mutating func scale(by factor: Double) {
        width *= factor
        height *= factor
    }
}

let originalRect = Rectangle(width: 4, height: 5)
var scaledCopy = originalRect
scaledCopy.scale(by: 2)

print("Original: \(originalRect.width) x \(originalRect.height), perimeter \(originalRect.perimeter)")
print("Scaled copy: \(scaledCopy.width) x \(scaledCopy.height), perimeter \(scaledCopy.perimeter)")
// originalRect stays 4 x 5 because structs are copied, not shared

// ======================================================================
// Topic 5 - Task 3: Why does this not compile? (Challenge Task)
// ======================================================================
print("\n===== Task 3 =====")
//
// The original code has ONE compile error:
//
//   let c = Counter()
//   c.increment()
//   error: cannot use mutating member on immutable value: 'c' is a 'let' constant
//
// WHY: Counter is a struct, a value type. A mutating method changes the struct's own
// data (value += 1), and with `let c` the whole value is frozen, including its properties.
//
// FIX: declare it with var.
//
// WHY THE CLASS VERSION IS FINE: Box is a class, a reference type. `let b` only means
// the constant b can never point to a different object. The object it points to is
// still allowed to change its own properties, so b.increment() compiles.

struct Counter {
    var value = 0
    mutating func increment() { value += 1 }
}

class Box {
    var value = 0
    func increment() { value += 1 }
}

var c = Counter()          // was `let`, now `var`
c.increment()
print("Counter value: \(c.value)")     // 1

let b = Box()
b.increment()
print("Box value: \(b.value)")         // 1

// === checks whether two constants refer to the exact same object
let anotherB = b
print("b and anotherB are the same object: \(b === anotherB)")     // true

let differentBox = Box()
print("b and differentBox are the same object: \(b === differentBox)")   // false

anotherB.increment()
print("b.value after incrementing through anotherB: \(b.value)")   // 2
