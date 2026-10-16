// Topic 6: Optionals
// All three tasks are in this one file. Run it in a Playground or with `swift Topic06_Optionals.swift`.

import Foundation

// ======================================================================
// Topic 6 - Task 1: User profile with missing data (Guided Activity)
// ======================================================================
print("\n===== Task 1 =====")

// Step 1
struct Address {
    var city: String?
}

struct User {
    var name: String
    var age: Int?
    var address: Address?
}

// Steps 2 and 3
func describe(_ user: User) -> String {
    // guard let stops early if the age is unknown
    guard let age = user.age else {
        return "\(user.name): age is unknown, cannot build the profile"
    }

    // optional chaining (address?.city) and ?? for the default
    let city = user.address?.city ?? "unknown city"

    return "\(user.name), \(age) years old, lives in \(city)"
}

// Step 4: three users
let asha = User(name: "Asha", age: 20, address: Address(city: "Coimbatore"))
let ravi = User(name: "Ravi", age: nil, address: Address(city: "Chennai"))
let meena = User(name: "Meena", age: 21, address: Address(city: nil))

print(describe(asha))      // Asha, 20 years old, lives in Coimbatore
print(describe(ravi))      // Ravi: age is unknown, cannot build the profile
print(describe(meena))     // Meena, 21 years old, lives in unknown city

// Step 5: what an optional looks like when printed
print(Int("42") as Any)    // Optional(42)
print(Int("abc") as Any)   // nil

// ======================================================================
// Topic 6 - Task 2: Safe number parsing (Practice Task)
// ======================================================================
print("\n===== Task 2 =====")

let entries = ["10", "x", "25", "", "7.5", "40"]

// (a) Int(...) returns nil for bad text, compactMap drops those nils
let validNumbers = entries.compactMap { Int($0) }
print("Valid integers: \(validNumbers)")           // [10, 25, 40]

// (b) sum
let sum = validNumbers.reduce(0, +)
print("Sum: \(sum)")                                // 75

// (c) how many entries were invalid
let invalidCount = entries.count - validNumbers.count
print("Invalid entries: \(invalidCount)")           // 3 ("x", "" and "7.5")

// (d) .first is an optional, map only runs the closure if there is a value
let firstDoubled = validNumbers.first.map { $0 * 2 }
if let doubled = firstDoubled {
    print("First valid number doubled: \(doubled)")     // 20
} else {
    print("There were no valid numbers")
}

// ======================================================================
// Topic 6 - Task 3: Debug Task, remove the crashes
// ======================================================================
print("\n===== Task 3 =====")
//
// ORIGINAL CODE:
//
//   let scores = ["Asha": 90, "Ravi": 72]
//   let kiran = scores["Kiran"]!
//   let number = Int("12a")!
//   print(kiran + number)
//
// CRASH 1: scores["Kiran"]! - there is no "Kiran" key, so the lookup is nil and
//          force unwrapping nil gives "Fatal error: Unexpectedly found nil while unwrapping an Optional value".
// CRASH 2: Int("12a")! - "12a" is not a whole number, so Int(...) returns nil and
//          the force unwrap crashes in the same way.
//
// FIX: never use !, unwrap with if let and print a helpful message otherwise.

let scores = ["Asha": 90, "Ravi": 72]
var total = 0

if let kiranScore = scores["Kiran"] {
    total += kiranScore
} else {
    print("No score found for Kiran, counting it as 0")
}

if let number = Int("12a") {
    total += number
} else {
    print("\"12a\" is not a valid number, skipping it")
}

print("Total: \(total)")      // 0
