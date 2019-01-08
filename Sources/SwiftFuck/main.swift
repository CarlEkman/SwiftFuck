//
//  main.swift
//  SwiftFuck
//
//  Created by Carl Ekman on 2018-12-28.
//  Copyright © 2018 Carl Ekman. All rights reserved.
//

import Swiftline

private func runRepl(cellCount: Int, newLine: Bool) {
    let cells = "(\(cellCount) " + (cellCount > 1 ? "cells" : "cell") + ")."
    print("Running Brainfuck REPL " + cells + " Enter 'q' to quit.")
    let session = Session(cellCount: cellCount, newLine: newLine)
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

private func run(program: [Instruction], input: [Character]?, cellCount: Int, newLine: Bool) {
    let cells = "(\(cellCount) " + (cellCount > 1 ? "cells" : "cell") + ")…"
    if input != nil {
        print("Running Brainfuck program with input " + cells)
    } else {
        print("Running Brainfuck program " + cells)
    }
    let session = Session(cellCount: cellCount, input: input, newLine: newLine)
    session.execute(program)
}

private func fail(if condition: Bool = false, with message: String) {
    if condition {
        printError(message)
        fatalError()
    }
}

let allowedFlags: [String] = ["e", "i", "n", "l"]
Args.parsed.flags
    .filter { !allowedFlags.contains($0.key) }
    .forEach { fail(with: "Unknown flag: \($0.key)") }

var instructions = [Instruction]()
var input: [Character]? = nil
var cellCount: Int = 30_000

if let program = Args.parsed.flags["i"] {
    instructions = program.compactMap { Instruction(rawValue: $0) }
    fail(if: instructions.isEmpty, with: "No program to execute.")
    if let rawInput = program.split(separator: "!").last {
        input = Array(rawInput.unicodeScalars).compactMap { Character($0) }
    }
} else if let program = Args.parsed.flags["e"] {
    instructions = program.compactMap { Instruction(rawValue: $0) }
    fail(if: instructions.isEmpty, with: "No program to execute.")
}

if let string = Args.parsed.flags["n"], let count = Int(string) {
    fail(if: count < 1, with: "Must use at least one data cell.")
    cellCount = count
}

let newLine = !Args.parsed.flags.keys.contains("l")

if instructions.isEmpty {
    runRepl(cellCount: cellCount, newLine: newLine)
} else {
    run(program: instructions, input: input, cellCount: cellCount, newLine: newLine)
}
