// Topic 7: ARC Memory Management
// All three tasks are in this one file. Run it in a Playground or with `swift Topic07_ARC_Memory_Management.swift`.

import Foundation

// ======================================================================
// Topic 7 - Task 1: Create and break a retain cycle (Guided Activity)
// ======================================================================
print("\n===== Task 1 =====")

// ---------- Part A: the retain cycle (both references are strong) ----------

class LeakyPerson {
    let name: String
    var apartment: LeakyApartment?

    init(name: String) { self.name = name }
    deinit { print("LeakyPerson \(name) is deallocated") }
}

class LeakyApartment {
    let unit: String
    var tenant: LeakyPerson?          // strong, this is the problem

    init(unit: String) { self.unit = unit }
    deinit { print("LeakyApartment \(unit) is deallocated") }
}

print("--- Part A: strong references both ways ---")
var leakyPerson: LeakyPerson? = LeakyPerson(name: "John")
var leakyApartment: LeakyApartment? = LeakyApartment(unit: "4A")

leakyPerson?.apartment = leakyApartment
leakyApartment?.tenant = leakyPerson

leakyPerson = nil
leakyApartment = nil
print("Both variables are nil, but no deinit message was printed. Memory leak!")

// ---------- Part B: same thing with tenant made weak ----------

class Person {
    let name: String
    var apartment: Apartment?

    init(name: String) { self.name = name }
    deinit { print("Person \(name) is deallocated") }
}

class Apartment {
    let unit: String
    weak var tenant: Person?          // weak, does not keep the Person alive

    init(unit: String) { self.unit = unit }
    deinit { print("Apartment \(unit) is deallocated") }
}

print("--- Part B: tenant is weak ---")
var person: Person? = Person(name: "Asha")
var apartment: Apartment? = Apartment(unit: "7B")

person?.apartment = apartment
apartment?.tenant = person

person = nil          // Person is freed here, nothing else owns it strongly
apartment = nil       // then the Apartment is freed
// Output: Person Asha is deallocated, then Apartment 7B is deallocated

// Step 5 (one sentence): a weak reference does not increase the retain count, so when
// the last strong reference to the object goes away ARC can free it, and the cycle is gone.

// ======================================================================
// Topic 7 - Task 2: Closure capture cycle (Practice Task)
// ======================================================================
print("\n===== Task 2 =====")

// ---------- The problem: the closure captures self strongly ----------

class LeakyDownloader {
    let name: String
    var onFinish: (() -> Void)?

    init(name: String) { self.name = name }

    func start() {
        // self owns onFinish, and onFinish owns self -> retain cycle
        onFinish = {
            print("Finished \(self.name)")
        }
    }

    deinit { print("LeakyDownloader \(name) is deallocated") }
}

print("--- Strong capture ---")
var leaky: LeakyDownloader? = LeakyDownloader(name: "movie.zip")
leaky?.start()
leaky?.onFinish?()
leaky = nil
print("leaky is nil but no deinit message appeared, so the object was never freed")

// ---------- The fix: a capture list with [weak self] ----------

class Downloader {
    let name: String
    var onFinish: (() -> Void)?

    init(name: String) { self.name = name }

    func start() {
        onFinish = { [weak self] in
            guard let self = self else { return }
            print("Finished \(self.name)")
        }
    }

    deinit { print("Downloader \(name) is deallocated") }
}

print("--- Weak capture ---")
var fixed: Downloader? = Downloader(name: "notes.pdf")
fixed?.start()
fixed?.onFinish?()      // Finished notes.pdf
fixed = nil             // Downloader notes.pdf is deallocated

// ======================================================================
// Topic 7 - Task 3: Predict Task, when does the object die?
// ======================================================================
print("\n===== Task 3 =====")

class Box {
    deinit { print("Box gone") }
}

var a: Box? = Box()     // retain count 1
var b = a               // 2
var c = a               // 3
a = nil                 // 2
b = nil                 // 1
print("before c")
c = nil                 // 0 -> deinit runs right here
print("end")

// MY PREDICTION (and the real output):
//   before c
//   Box gone
//   end
//
// The Box has three strong references. Setting a and b to nil does not free it because
// c still holds it. Only when c becomes nil does the count hit zero.

// WHEN TO USE WHAT
//
// | Reference | Use it when                                                   | Example                              |
// |-----------|---------------------------------------------------------------|--------------------------------------|
// | strong    | Default. You own the object and want it kept alive.           | a view controller owning its model   |
// | weak      | The other object can disappear first. Must be an optional var, | delegate, parent pointer,            |
// |           | it becomes nil automatically.                                 | Apartment -> tenant                  |
// | unowned   | The other object always lives at least as long as you.        | CreditCard -> customer               |
// |           | Non-optional, but crashes if you use it after it is freed.    |                                      |
