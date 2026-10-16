// Topic 2: Variables and Constants
// All three tasks are in this one file. Run it in a Playground or with `swift Topic02_Variables_and_Constants.swift`.

import Foundation

// ======================================================================
// Topic 2 - Task 1: Student profile card (Guided Activity)
// ======================================================================
print("\n===== Task 1 =====")


// Step 1: constants for values that never change
let studentName = "Susi"
let rollNumber: Int = 2301          // change this to your own roll number

// Step 2: variables for values that change, constant for isHosteller
var semester = 5
var cgpa: Double = 8.4
let isHosteller: Bool = true

// Step 3: first line using string interpolation
print("Name: \(studentName), Roll: \(rollNumber), Semester: \(semester)")

// Step 4: move to the next semester and update the cgpa
semester += 1
cgpa = 8.6
print("Name: \(studentName), Roll: \(rollNumber), Semester: \(semester), CGPA: \(cgpa)")

// Step 5: trying to change a constant
// studentName = "Someone Else"
// Compiler error: cannot assign to value: 'studentName' is a 'let' constant
// (I commented the line out so the rest of the file still compiles)

// Step 6: check the types Swift gave us
print("studentName is a \(type(of: studentName))")     // String
print("rollNumber is a \(type(of: rollNumber))")       // Int
print("semester is a \(type(of: semester))")           // Int (inferred from 5)
print("cgpa is a \(type(of: cgpa))")                    // Double
print("isHosteller is a \(type(of: isHosteller))")     // Bool

// ======================================================================
// Topic 2 - Task 2: Temperature converter (Practice Task)
// ======================================================================
print("\n===== Task 2 =====")


// conversion factors never change, so they are constants
let fahrenheitMultiplier = 9.0
let fahrenheitDivisor = 5.0
let fahrenheitOffset = 32.0
let kelvinOffset = 273.15

// the temperature changes, so it is a variable
var celsius = 36.6

// the formulas are written only once, inside this function
func printConversions(for celsius: Double) {
    let fahrenheit = celsius * fahrenheitMultiplier / fahrenheitDivisor + fahrenheitOffset
    let kelvin = celsius + kelvinOffset

    print("\(String(format: "%.1f", celsius)) C = \(String(format: "%.1f", fahrenheit)) F = \(String(format: "%.1f", kelvin)) K")
}

printConversions(for: celsius)

// change the Celsius value and print again, no formula rewritten
celsius = 100.0
printConversions(for: celsius)

celsius = -40.0
printConversions(for: celsius)

// ======================================================================
// Topic 2 - Task 3: Debug Task, fix the compile errors
// ======================================================================
print("\n===== Task 3 =====")
//
// ORIGINAL CODE (does not compile):
//
//   let price = 250
//   var quantity: Int = 3
//   let taxRate = 0.18
//   price = 300
//   let total = price * quantity * taxRate
//   var title = "Order"
//   title = 42
//   print(total)
//
// COMPILER ERRORS
//
// 1. `price = 300`
//    error: cannot assign to value: 'price' is a 'let' constant
//    price was declared with let, so it can never be changed.
//    Fix: declare it with var.
//
// 2. `let total = price * quantity * taxRate`
//    error: binary operator '*' cannot be applied to operands of type 'Int' and 'Double'
//    price and quantity are Int, taxRate was inferred as Double (0.18).
//    Swift never mixes Int and Double automatically.
//    Fix: convert the Int values with Double(...).
//
// 3. `title = 42`
//    error: cannot assign value of type 'Int' to type 'String'
//    title was inferred as String from "Order", so it cannot hold a number.
//    Fix: give it a String ("42") or remove the line.
//
// (There is also a warning: 'quantity' is never mutated, so it could be a let.)
//
// One more thing: the original formula price * quantity * taxRate only gives
// the tax amount, not the total including tax. The fixed version adds it to the subtotal.


var price = 250                      // var, because we change it below
let quantity: Int = 3                // let, it never changes
let taxRate = 0.18

price = 300

let subtotal = Double(price * quantity)     // Int * Int first, then convert
let tax = subtotal * taxRate
let total = subtotal + tax

var title = "Order"
title = "Order #42"                          // a String, not an Int

print("\(title): subtotal \(String(format: "%.2f", subtotal)), tax \(String(format: "%.2f", tax))")
print("Total including tax: \(String(format: "%.2f", total))")     // 1062.00
