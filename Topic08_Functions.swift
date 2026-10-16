// Topic 8: Functions
// All three tasks are in this one file. Run it in a Playground or with `swift Topic08_Functions.swift`.

import Foundation

// ======================================================================
// Topic 8 - Task 1: Marks and grades toolkit (Guided Activity)
// ======================================================================
print("\n===== Task 1 =====")

// Step 1: variadic parameter, returns 0 if nothing is passed
func average(of marks: Int...) -> Double {
    if marks.isEmpty {
        return 0
    }
    let total = marks.reduce(0, +)
    return Double(total) / Double(marks.count)
}

// Step 2: grade from the average
func grade(for average: Double) -> String {
    switch average {
    case 90...:
        return "O"
    case 80..<90:
        return "A+"
    case 70..<80:
        return "A"
    case 60..<70:
        return "B"
    default:
        return "RA"
    }
}

// Step 3: tuple result, optional because an empty array has no min or max
func stats(of marks: [Int]) -> (min: Int, max: Int, average: Double)? {
    guard let lowest = marks.min(), let highest = marks.max() else {
        return nil
    }
    let mean = Double(marks.reduce(0, +)) / Double(marks.count)
    return (min: lowest, max: highest, average: mean)
}

// Step 4: inout changes the caller's array, default bonus of 5, capped at 100
func curve(_ marks: inout [Int], by bonus: Int = 5) {
    for index in marks.indices {
        marks[index] = min(marks[index] + bonus, 100)
    }
}

// Step 5: call everything
var marks = [82, 35, 91, 56, 67]

let avg = average(of: 82, 35, 91, 56, 67)
print("Average: \(avg)")                        // 66.2
print("Average of nothing: \(average())")   // 0.0
print("Grade: \(grade(for: avg))")              // B

if let result = stats(of: marks) {
    print("Min \(result.min), Max \(result.max), Average \(result.average)")
}
if stats(of: []) == nil {
    print("stats returned nil for an empty array")
}

curve(&marks)                                    // default bonus 5
print("After default curve: \(marks)")           // [87, 40, 96, 61, 72]
curve(&marks, by: 10)
print("After curve by 10: \(marks)")             // [97, 50, 100, 71, 82]

// ======================================================================
// Topic 8 - Task 2: Text utilities (Practice Task)
// ======================================================================
print("\n===== Task 2 =====")

// ignores case, spaces and punctuation: keep only letters and digits
func isPalindrome(_ text: String) -> Bool {
    let cleaned = text.lowercased().filter { $0.isLetter || $0.isNumber }
    return cleaned == String(cleaned.reversed())
}

func vowelCount(in text: String) -> Int {
    let vowels = "aeiou"
    return text.lowercased().filter { vowels.contains($0) }.count
}

// words are the pieces left after splitting on anything that is not a letter
func wordCount(in text: String) -> Int {
    return text.split(whereSeparator: { !$0.isLetter }).count
}

// overload: same name, extra parameter, only counts words long enough
func wordCount(in text: String, minLength: Int) -> Int {
    let words = text.split(whereSeparator: { !$0.isLetter })
    return words.filter { $0.count >= minLength }.count
}

let sentence = "A man, a plan, a canal: Panama"

print("Palindrome? \(isPalindrome(sentence))")                    // true
print("Palindrome? \(isPalindrome("Swift is fun"))")              // false
print("Vowels: \(vowelCount(in: sentence))")                      // 10
print("Words: \(wordCount(in: sentence))")                        // 7
print("Words with 4+ letters: \(wordCount(in: sentence, minLength: 4))")   // 3 (plan, canal, Panama)

// ======================================================================
// Topic 8 - Task 3: Functions as values (Challenge Task)
// ======================================================================
print("\n===== Task 3 =====")

// returns a function: (Int) -> Int
func makeMultiplier(_ factor: Int) -> (Int) -> Int {
    return { number in
        return number * factor
    }
}

let double = makeMultiplier(2)
let triple = makeMultiplier(3)

print(double(5))      // 10
print(triple(5))      // 15

// takes a function as a parameter
func apply(_ values: [Int], using transform: (Int) -> Int) -> [Int] {
    var result: [Int] = []
    for value in values {
        result.append(transform(value))
    }
    return result
}

let numbers = [1, 2, 3, 4]

print(apply(numbers, using: double))               // [2, 4, 6, 8]
print(apply(numbers, using: triple))               // [3, 6, 9, 12]
print(apply(numbers, using: { $0 * $0 }))          // [1, 4, 9, 16]  inline closure that squares

// WHAT "FUNCTIONS ARE FIRST-CLASS VALUES" MEANS
// A function can be treated like any other value (an Int or a String):
//  - it can be stored in a constant:      let double = makeMultiplier(2)
//  - it can be returned from a function:  makeMultiplier returns (Int) -> Int
//  - it can be passed as an argument:     apply(numbers, using: double)
//  - it can be written inline as a closure without a name: { $0 * $0 }
// Notice that double and triple remember their own factor (2 and 3). That is the closure
// capturing a value from makeMultiplier.
