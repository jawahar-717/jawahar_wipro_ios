// Topic 4: Collections
// All three tasks are in this one file. Run it in a Playground or with `swift Topic04_Collections.swift`.

import Foundation

// ======================================================================
// Topic 4 - Task 1: Course registration (Guided Activity)
// ======================================================================
print("\n===== Task 1 =====")
// array = ordered data, set = unique data, dictionary = lookup by key

// Step 1: array
var subjects = ["Swift", "UIKit", "SwiftUI"]
subjects.append("Networking")
subjects.insert("Testing", at: 1)

if let index = subjects.firstIndex(of: "UIKit") {
    subjects.remove(at: index)
}
print("Sorted subjects: \(subjects.sorted())")
// ["Networking", "Swift", "SwiftUI", "Testing"]

// Step 2: set ignores duplicates
var registered = Set<String>()
registered.insert("Asha")
registered.insert("Ravi")
registered.insert("Asha")            // same name again, nothing happens
print("Registered count: \(registered.count)")      // 2

// Step 3: dictionary
var marks: [String: Int] = ["Asha": 82, "Ravi": 35, "Meena": 91]
marks["Kiran"] = 56                  // add a new student
marks["Ravi"] = 48                   // update an existing mark

// reading a student who is not in the dictionary gives nil, not a crash
if let divyaMark = marks["Divya"] {
    print("Divya scored \(divyaMark)")
} else {
    print("Divya is not in the dictionary")
}
print("Divya with a default: \(marks["Divya", default: 0])")

// Step 4: loop in order of student name (dictionaries have no order of their own)
for (name, mark) in marks.sorted(by: { $0.key < $1.key }) {
    print("\(name): \(mark)")
}

// Step 5: highest mark and who got it
if let topper = marks.max(by: { $0.value < $1.value }) {
    print("Highest mark: \(topper.value) by \(topper.key)")      // 91 by Meena
}

// ======================================================================
// Topic 4 - Task 2: Word frequency counter (Practice Task)
// ======================================================================
print("\n===== Task 2 =====")

let sentence = "swift is fun and swift is fast"
let words = sentence.split(separator: " ").map { String($0) }

// (a) number of words
print("Number of words: \(words.count)")                    // 7

// (b) unique words (a Set has no order, so sort for printing)
let uniqueWords = Set(words)
print("Unique words: \(uniqueWords.sorted())")              // and, fast, fun, is, swift

// (c) how often each word appears
var frequency: [String: Int] = [:]
for word in words {
    frequency[word, default: 0] += 1
}
for (word, count) in frequency.sorted(by: { $0.key < $1.key }) {
    print("\(word): \(count)")
}

// (d) ranked by frequency, ties broken alphabetically
let ranked = frequency.sorted { first, second in
    if first.value != second.value {
        return first.value > second.value
    }
    return first.key < second.key
}
print("Ranking:")
for (position, entry) in ranked.enumerated() {
    print("\(position + 1). \(entry.key) (\(entry.value))")
}
// 1. is (2)  2. swift (2)  3. and (1)  4. fast (1)  5. fun (1)

// ======================================================================
// Topic 4 - Task 3: Set algebra and de-duplication (Challenge Task)
// ======================================================================
print("\n===== Task 3 =====")

let swiftClub: Set<String> = ["Anu", "Ben", "Chitra", "Dev"]
let uiClub: Set<String> = ["Chitra", "Dev", "Esha"]

// (a) members in both clubs
print("Both clubs: \(swiftClub.intersection(uiClub).sorted())")                 // Chitra, Dev

// (b) members only in the Swift club
print("Only Swift club: \(swiftClub.subtracting(uiClub).sorted())")              // Anu, Ben

// (c) everyone
print("Everyone: \(swiftClub.union(uiClub).sorted())")                           // Anu, Ben, Chitra, Dev, Esha

// (d) members in exactly one club
print("Exactly one club: \(swiftClub.symmetricDifference(uiClub).sorted())")     // Anu, Ben, Esha

// De-duplicate while keeping the original order.
// A Set remembers what we have already seen, insert returns .inserted == false for repeats.
let numbers = [3, 1, 3, 2, 1, 4]
var seen = Set<Int>()
var uniqueNumbers: [Int] = []

for number in numbers {
    if seen.insert(number).inserted {
        uniqueNumbers.append(number)
    }
}
print("Without duplicates: \(uniqueNumbers)")      // [3, 1, 2, 4]
