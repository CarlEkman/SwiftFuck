//
//  main.swift
//  SwiftFuck
//
//  Created by Carl Ekman on 2018-12-28.
//  Copyright © 2018 Carl Ekman. All rights reserved.
//

import Swiftline

private func runRepl(cellCount: Int) {
    let cells = "(\(cellCount) " + (cellCount > 1 ? "cells" : "cell") + ")."
    print("Running Brainfuck REPL " + cells + " Enter 'q' to quit.")
    let session = Session(cellCount: cellCount)
    var input: String = ""
    repeat {
        session.printCells()
        printPrompt()
        input = readLine() ?? ""
        let instructions = input.compactMap { Instruction(rawValue: $0) }
        session.execute(instructions)
    } while input != "q"

    print("Quitting")
}

private func run(program: [Instruction], input: [Character]?, cellCount: Int) {
    let cells = "(\(cellCount) " + (cellCount > 1 ? "cells" : "cell") + ")…"
    if input != nil {
        print("Running Brainfuck program with input " + cells)
    } else {
        print("Running Brainfuck program " + cells)
    }
    let session = Session(cellCount: cellCount, input: input)
    session.execute(program)
}

private func fail(if condition: Bool = false, with message: String) {
    if !condition {
        printError(message)
        fatalError()
    }
}

let allowedFlags: [String] = ["!", "n"]
Args.parsed.flags
    .filter { !allowedFlags.contains($0.key) }
    .forEach { fail(with: "Unknown flag: \($0.key)") }

var instructions = [Instruction]()
var input: [Character]? = nil
var cellCount: Int = 30_000

if let program = Args.parsed.flags["!"] {
    fail(if: Args.parsed.parameters.isEmpty,
         with: "Unknown parameter(s): \(Args.parsed.parameters)")
    instructions = program.compactMap { Instruction(rawValue: $0) }
    let rawInput = program.split(separator: "!")[1]
    input = Array(rawInput.unicodeScalars).compactMap { Character($0) }
}
if let program = Args.parsed.parameters.last {
    fail(if: Args.parsed.parameters.count == 1,
         with: "Only one program input allowed.")
    instructions = program.compactMap { Instruction(rawValue: $0) }
}
if let string = Args.parsed.flags["n"], let count = Int(string) {
    fail(if: count > 0, with: "Number of byte cells must be > 0.")
    cellCount = count
}

if Args.parsed.flags.count == 0, Args.parsed.parameters.count == 0 {
    runRepl(cellCount: cellCount)
} else {
    run(program: instructions, input: input, cellCount: cellCount)
}
