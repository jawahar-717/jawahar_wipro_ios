// Topic 3: Operators and Expressions
// All three tasks are in this one file. Run it in a Playground or with `swift Topic03_Operators_and_Expressions.swift`.

import Foundation

// ======================================================================
// Topic 3 - Task 1: Restaurant bill calculator (Guided Activity)
// ======================================================================
print("\n===== Task 1 =====")


// Step 1: price and quantity, convert quantity to Double for the multiplication
let itemPrice = 450.0
let quantity = 3
let subtotal = itemPrice * Double(quantity)                  // 1350.0

// Step 2: discount with the ternary operator
let hasCoupon = true
let discount = (hasCoupon && subtotal > 1000) ? subtotal * 0.10 : 0.0     // 135.0

// Step 3: GST is charged on the discounted amount
let discountedAmount = subtotal - discount                   // 1215.0
let gst = discountedAmount * 0.18                            // 218.7
let total = discountedAmount + gst                           // 1433.7

print("Subtotal: Rs. \(String(format: "%.2f", subtotal))")
print("Discount: Rs. \(String(format: "%.2f", discount))")
print("GST (18%): Rs. \(String(format: "%.2f", gst))")
print("Total: Rs. \(String(format: "%.2f", total))")

// Step 4: split between 4 people
let people = 4
let share = total / Double(people)
print("Each of the \(people) people pays: Rs. \(String(format: "%.2f", share))")

// Step 5: integer / and % to break 1234 rupees into hundreds and the remainder
let amount = 1234
let hundreds = amount / 100          // 12 (integer division throws away the fraction)
let remainder = amount % 100         // 34
print("Rs. \(amount) = \(hundreds) hundreds and Rs. \(remainder) left over")

// ======================================================================
// Topic 3 - Task 2: Leap year and range checks (Practice Task)
// ======================================================================
print("\n===== Task 2 =====")
// Every answer is a single Bool expression, no if statements.

// 1. Leap year: divisible by 4, except centuries, unless divisible by 400
for year in [1900, 2000, 2024, 2026] {
    let isLeapYear = (year % 4 == 0 && year % 100 != 0) || year % 400 == 0
    print("\(year) is a leap year: \(isLeapYear)")
}
// 1900 false, 2000 true, 2024 true, 2026 false

// 2. Between 1 and 100 inclusive, using the closed range operator
for number in [0, 1, 57, 100, 101] {
    let inRange = (1...100).contains(number)
    print("\(number) is between 1 and 100: \(inRange)")
}

// 3. Even and not a multiple of 10
for number in [4, 7, 20, 30, 42] {
    let evenNotTen = number % 2 == 0 && number % 10 != 0
    print("\(number) is even and not a multiple of 10: \(evenNotTen)")
}
// 4 true, 7 false, 20 false, 30 false, 42 true

// 4. nil-coalescing operator gives a default for a missing value
let nickname: String? = nil
print("Hello, \(nickname ?? "Guest")")      // Hello, Guest

let anotherNickname: String? = "Susi"
print("Hello, \(anotherNickname ?? "Guest")")   // Hello, Susi

// ======================================================================
// Topic 3 - Task 3: Predict Task, what does it print?
// ======================================================================
print("\n===== Task 3 =====")
// My predictions are in the comments next to each line.

print(7 / 2)                              // 3     both are Int, so the decimal part is dropped
print(7 % 2)                              // 1     remainder of 7 / 2
print(-7 % 3)                             // -1    the result takes the sign of the left operand
print(7.0 / 2)                            // 3.5   one Double makes it a Double division
print(10 - 2 * 3 + 4 / 2)                 // 6     10 - 6 + 2, * and / go before + and -
print(5 > 3 && 2 > 4 || true)             // true  (true && false) || true, && binds tighter than ||
print(1 << 3)                             // 8     shift 1 left by 3 bits (0001 -> 1000)
print(6 & 3, 6 | 3, 6 ^ 3)                // 2 7 5 110 & 011 = 010, 110 | 011 = 111, 110 ^ 011 = 101
let x: UInt8 = 255
print(x &+ 1)                             // 0     &+ wraps around instead of crashing
// (plain `x + 1` would crash with an overflow error, UInt8 maxes out at 255)
