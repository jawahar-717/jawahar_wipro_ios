// Topic 9: Closures Higher Order
// All three tasks are in this one file. Run it in a Playground or with `swift Topic09_Closures_Higher_Order.swift`.

import Foundation

// ======================================================================
// Topic 9 - Task 1: Student result analysis (Guided Activity)
// ======================================================================
print("\n===== Task 1 =====")

struct Student {
    let name: String
    let marks: Int
    let dept: String
}

// small extra property, needed for the key path version in step 7
extension Student {
    var hasPassed: Bool { marks >= 40 }
}

// Step 1
let students = [
    Student(name: "Asha", marks: 82, dept: "IT"),
    Student(name: "Ravi", marks: 35, dept: "CSE"),
    Student(name: "Meena", marks: 91, dept: "IT"),
    Student(name: "Kiran", marks: 56, dept: "ECE"),
    Student(name: "Divya", marks: 67, dept: "CSE"),
    Student(name: "Arjun", marks: 40, dept: "IT")
]

// Step 2: filter, passed = 40 or more
let passed = students.filter { $0.marks >= 40 }
print("Passed: \(passed.count) students")                 // everyone except Ravi

// Step 3: map to names
let passedNames = passed.map { $0.name }
print("Names: \(passedNames)")

// Step 4: class average using map and reduce
let allMarks = students.map { $0.marks }
let average = Double(allMarks.reduce(0, +)) / Double(allMarks.count)
print("Class average: \(average)")                         // 371 / 6 = 61.83...

// Step 5: ranking, highest first
let ranking = students.sorted { $0.marks > $1.marks }
for (position, student) in ranking.enumerated() {
    print("\(position + 1). \(student.name) - \(student.marks)")
}

// Step 6: group by department
let byDepartment = Dictionary(grouping: students, by: { $0.dept })
for dept in byDepartment.keys.sorted() {
    let names = byDepartment[dept, default: []].map { $0.name }
    print("\(dept): \(names)")
}

// Step 7: the same filter written three ways
// full form
let fullForm = students.filter({ (student: Student) -> Bool in
    return student.marks >= 40
})
// shorthand with $0
let shorthand = students.filter { $0.marks >= 40 }
// key path, works because hasPassed is a Bool property
let keyPath = students.filter(\.hasPassed)

print(fullForm.count, shorthand.count, keyPath.count)     // 5 5 5

// ======================================================================
// Topic 9 - Task 2: Write your own higher-order functions (Practice Task)
// ======================================================================
print("\n===== Task 2 =====")
// (no filter or map used here)

// (a) keeps only the items the predicate says yes to
func myFilter(_ items: [Int], _ predicate: (Int) -> Bool) -> [Int] {
    var result: [Int] = []
    for item in items {
        if predicate(item) {
            result.append(item)
        }
    }
    return result
}

// (b) runs f two times in a row
func applyTwice(_ value: Int, _ f: (Int) -> Int) -> Int {
    return f(f(value))
}

// (c) a class that stores handlers and runs them all on tap
class Button {
    private var handlers: [() -> Void] = []

    func onTap(_ handler: @escaping () -> Void) {
        handlers.append(handler)
    }

    func tap() {
        for handler in handlers {
            handler()
        }
    }
}

print(myFilter([1, 2, 3, 4, 5, 6, 7, 8], { $0 % 2 == 0 }))     // [2, 4, 6, 8]
print(applyTwice(3, { $0 * 2 }))                                // 12

let button = Button()
button.onTap { print("First handler ran") }
button.onTap { print("Second handler ran") }
button.tap()

// WHY @escaping?
// A closure parameter is normally used only while the function runs and is gone when it returns.
// In onTap the closure is saved in the handlers array, so it is still alive after onTap has
// finished and gets called later from tap(). That is "escaping" the function, and Swift makes
// us write @escaping so we know the closure may outlive the call (and may need [weak self]).

// ======================================================================
// Topic 9 - Task 3: Predict Task, closure capture
// ======================================================================
print("\n===== Task 3 =====")

func makeCounter() -> () -> Int {
    var count = 0
    return {
        count += 1
        return count
    }
}

let a = makeCounter()
let b = makeCounter()
print(a(), a(), b(), a())

// PREDICTION AND OUTPUT:  1 2 1 3
//
// Every call to makeCounter() creates a brand new `count` variable. The returned closure
// captures that variable (a reference to it, not a copy of the value), so it keeps it alive
// and keeps updating it between calls. a and b came from two separate calls, so each one
// has its own private count. a counts 1, 2, 3 and b starts from 1 on its own.
