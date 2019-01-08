//
//  main.swift
//  SwiftFuck
//
//  Created by Carl Ekman on 2018-12-28.
//  Copyright © 2018 Carl Ekman. All rights reserved.
//

import Swiftline

let flags: [String] = ["!"]
Args.parsed.flags
    .filter { !flags.contains($0.key) }
    .forEach {
        printError("Unknown flag: \($0.key)")
        fatalError()
}

let session = Session()

if let program = Args.parsed.parameters.last, Args.parsed.flags.count == 0 {
    print("Running Brainfuck program…")
    let instructions = program.compactMap { Instruction(rawValue: $0) }
    session.execute(instructions)

} else if let program = Args.parsed.flags["!"] {
    print("Running Brainfuck program with input…")
    let instructions = program.compactMap { Instruction(rawValue: $0) }
    let rawInput = program.split(separator: "!")[1]
    let unicodeArray = Array(rawInput.unicodeScalars)
    session.input = unicodeArray.compactMap { Character($0) }
    session.execute(instructions)

} else {
    print("Running Brainfuck REPL. Enter 'q' to quit.")
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
