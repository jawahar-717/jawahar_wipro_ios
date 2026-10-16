// Topic 10: Protocols and Extensions
// All three tasks are in this one file. Run it in a Playground or with `swift Topic10_Protocols_and_Extensions.swift`.

import Foundation

// ======================================================================
// Topic 10 - Task 1: Payroll with protocols (Guided Activity)
// ======================================================================
print("\n===== Task 1 =====")


// Step 1: the contract
protocol Payable {
    var name: String { get }
    func monthlyPay() -> Double
}

// Step 2: default behaviour for every type that conforms
extension Payable {
    func payslip() -> String {
        let amount = String(format: "%.2f", monthlyPay())
        return "Payslip - \(name): Rs. \(amount)"
    }
}

// Step 3
struct FullTimeEmployee: Payable {
    let name: String
    let salary: Double          // annual

    func monthlyPay() -> Double {
        return salary / 12
    }
}

struct Intern: Payable {
    let name: String
    let stipend: Double         // monthly

    func monthlyPay() -> Double {
        return stipend
    }
}

// Step 4: one array, different types
var staff: [any Payable] = [
    FullTimeEmployee(name: "Asha", salary: 600_000),
    Intern(name: "Ravi", stipend: 15_000)
]

// Step 5: a new type, the loop below is untouched
struct Contractor: Payable {
    let name: String
    let hourlyRate: Double
    let hours: Double

    func monthlyPay() -> Double {
        return hourlyRate * hours
    }
}
staff.append(Contractor(name: "Meena", hourlyRate: 800, hours: 40))

for person in staff {
    print(person.payslip())
}
// Asha 50000.00, Ravi 15000.00, Meena 32000.00

// ======================================================================
// Topic 10 - Task 2: Extend existing types (Practice Task)
// ======================================================================
print("\n===== Task 2 =====")

// (a) Int
extension Int {
    var isEven: Bool {
        return self % 2 == 0
    }

    func squared() -> Int {
        return self * self
    }
}

// (b) [Int]
extension Array where Element == Int {
    var sum: Int {
        return reduce(0, +)
    }
}

// (c) String
extension String {
    var wordCount: Int {
        return split(whereSeparator: { $0.isWhitespace }).count
    }
}

// (d) Version, Comparable added through an extension
struct Version {
    let major: Int
    let minor: Int
}

extension Version: Comparable {
    static func < (lhs: Version, rhs: Version) -> Bool {
        if lhs.major != rhs.major {
            return lhs.major < rhs.major
        }
        return lhs.minor < rhs.minor
    }
}

print(10.isEven, 7.isEven)                      // true false
print(6.squared())                              // 36
print([1, 2, 3, 4].sum)                         // 10
print("Swift is really fun".wordCount)          // 4

let old = Version(major: 1, minor: 9)
let new = Version(major: 2, minor: 0)
print(old < new)                                // true

let versions = [Version(major: 2, minor: 0), Version(major: 1, minor: 9), Version(major: 1, minor: 2)]
for version in versions.sorted() {
    print("\(version.major).\(version.minor)")  // 1.2, 1.9, 2.0
}

// ======================================================================
// Topic 10 - Task 3: Protocol composition over inheritance (Design Task)
// ======================================================================
print("\n===== Task 3 =====")

protocol Flyable {
    func fly()
}

protocol Swimmable {
    func swim()
}

struct Duck: Flyable, Swimmable {
    func fly() { print("The duck flaps its wings and flies") }
    func swim() { print("The duck paddles across the pond") }
}

struct Eagle: Flyable {
    func fly() { print("The eagle soars high") }
}

struct Fish: Swimmable {
    func swim() { print("The fish swims in the river") }
}

// only accepts things that are BOTH Flyable and Swimmable
func showOff(_ animal: Flyable & Swimmable) {
    animal.fly()
    animal.swim()
}

showOff(Duck())
// showOff(Eagle())   // error: argument type 'Eagle' does not conform to expected type 'Swimmable'
// showOff(Fish())    // error: argument type 'Fish' does not conform to expected type 'Flyable'

// WHY THIS IS MORE FLEXIBLE THAN Bird AND FishAnimal BASE CLASSES
// With inheritance, Duck has to pick ONE parent. If it extends Bird it gets fly() but swim()
// has to be copied in, and if it extends FishAnimal it is the other way around. A class can
// only have one superclass, so abilities that cross the hierarchy cause duplicated code or an
// awkward tree. Also a penguin is a Bird that cannot fly, which breaks the Bird contract.
// With protocols each ability is a small separate piece. A type just lists the ones it has
// (Duck: Flyable, Swimmable), new abilities can be added later without touching old types, and
// functions like showOff can ask for exactly the abilities they need. Structs can use protocols
// too, while inheritance only works with classes.
