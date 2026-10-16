// Topic 11: Generics and Error Handling
// All three tasks are in this one file. Run it in a Playground or with `swift Topic11_Generics_and_Error_Handling.swift`.

import Foundation

// ======================================================================
// Topic 11 - Task 1: A generic Stack (Guided Activity)
// ======================================================================
print("\n===== Task 1 =====")

// Step 1: works for any element type
struct Stack<Element> {
    private var items: [Element] = []

    mutating func push(_ item: Element) {
        items.append(item)
    }

    // optional, because an empty stack has nothing to pop
    mutating func pop() -> Element? {
        return items.popLast()
    }

    var top: Element? {
        return items.last
    }

    var isEmpty: Bool {
        return items.isEmpty
    }

    var count: Int {
        return items.count
    }
}

// Step 2: test with Int and String
var numberStack = Stack<Int>()
numberStack.push(10)
numberStack.push(20)
numberStack.push(30)
print("Top: \(numberStack.top as Any), count: \(numberStack.count)")     // Optional(30), 3
print("Popped: \(numberStack.pop() as Any)")                              // Optional(30)
print("Empty? \(numberStack.isEmpty)")                                    // false

var wordStack = Stack<String>()
wordStack.push("Swift")
wordStack.push("Generics")
print("Top: \(wordStack.top as Any)")                                     // Optional("Generics")
_ = wordStack.pop()
_ = wordStack.pop()
print("Pop from empty: \(wordStack.pop() as Any)")                        // nil

// Step 3: T must be Comparable so > works
func largest<T: Comparable>(in items: [T]) -> T? {
    guard var biggest = items.first else {
        return nil
    }
    for item in items.dropFirst() {
        if item > biggest {
            biggest = item
        }
    }
    return biggest
}

print(largest(in: [4, 19, 7]) as Any)                    // Optional(19)
print(largest(in: ["pear", "apple", "zebra"]) as Any)    // Optional("zebra")
print(largest(in: [Int]()) as Any)                       // nil

// Step 4: swap any two values of the same type
func swapValues<T>(_ a: inout T, _ b: inout T) {
    let temp = a
    a = b
    b = temp
}

var first = "left"
var second = "right"
swapValues(&first, &second)
print(first, second)                                      // right left

// Step 5: a type that is not Comparable
struct Point {
    var x: Int
    var y: Int
}
// let farthest = largest(in: [Point(x: 1, y: 2), Point(x: 3, y: 4)])
// error: global function 'largest(in:)' requires that 'Point' conform to 'Comparable'
// Swift cannot compare two Points with > unless we tell it how, so the constraint rejects it.

// ======================================================================
// Topic 11 - Task 2: ATM withdrawal with errors (Practice Task)
// ======================================================================
print("\n===== Task 2 =====")

enum ATMError: Error {
    case insufficientFunds(shortBy: Double)
    case invalidAmount
    case dailyLimitExceeded
}

struct Account {
    private(set) var balance: Double
    static let dailyLimit = 20_000.0

    mutating func withdraw(_ amount: Double) throws {
        guard amount > 0 else {
            throw ATMError.invalidAmount
        }
        guard amount <= Account.dailyLimit else {
            throw ATMError.dailyLimitExceeded
        }
        guard amount <= balance else {
            throw ATMError.insufficientFunds(shortBy: amount - balance)
        }
        balance -= amount
    }
}

// do-catch with a separate catch for each error
func attempt(_ amount: Double, on account: inout Account) {
    do {
        try account.withdraw(amount)
        print("Withdrew \(amount). Balance is now \(account.balance)")
    } catch ATMError.invalidAmount {
        print("\(amount): invalid amount, it must be more than 0")
    } catch ATMError.dailyLimitExceeded {
        print("\(amount): over the daily limit of \(Account.dailyLimit)")
    } catch ATMError.insufficientFunds(let shortBy) {
        print("\(amount): not enough money, short by \(shortBy)")
    } catch {
        print("Something unexpected happened: \(error)")
    }
}

var account = Account(balance: 10_000)

attempt(500, on: &account)        // Withdrew 500.0. Balance is now 9500.0
attempt(-10, on: &account)        // invalid amount
attempt(25_000, on: &account)     // over the daily limit
attempt(12_000, on: &account)     // short by 2500.0

// try? turns a throwing call into an optional, useful when we only care if it worked
let worked = (try? account.withdraw(100)) != nil
print("Withdrawing 100 worked: \(worked)")                  // true

let failed = (try? account.withdraw(-5)) == nil
print("Withdrawing -5 failed: \(failed)")                   // true

// ======================================================================
// Topic 11 - Task 3: Result type and defer (Challenge Task)
// ======================================================================
print("\n===== Task 3 =====")

enum ParseError: Error {
    case empty
    case notANumber
    case outOfRange
}

func parseAge(_ text: String) throws -> Int {
    if text.isEmpty {
        throw ParseError.empty
    }
    guard let age = Int(text) else {
        throw ParseError.notANumber
    }
    guard (1...120).contains(age) else {
        throw ParseError.outOfRange
    }
    return age
}

// Result { try ... } catches the thrown error and stores it inside the Result
for input in ["25", "", "abc", "150"] {
    let result = Result { try parseAge(input) }

    switch result {
    case .success(let age):
        print("\"\(input)\" -> valid age \(age)")
    case .failure(let error):
        print("\"\(input)\" -> failed with \(error)")
    }
}

// defer runs when the function exits, whether it returns normally or throws
enum ReportError: Error {
    case writeFailed
}

func saveReport(shouldFail: Bool = false) throws {
    print("Opening file")
    defer {
        print("Closing file")
    }

    if shouldFail {
        throw ReportError.writeFailed
    }
    print("Writing report")
}

print("--- normal run ---")
try saveReport()

print("--- failing run ---")
do {
    try saveReport(shouldFail: true)
} catch {
    print("Caught: \(error)")
}
// "Closing file" is printed before "Caught: writeFailed" even though the function threw
