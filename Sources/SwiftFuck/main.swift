//
//  main.swift
//  SwiftFuck
//
//  Created by Carl Ekman on 2018-12-28.
//  Copyright © 2018 Carl Ekman. All rights reserved.
//

import Swiftline

// MARK: - Language

/// The eight Brainfuck instructions.
enum Instruction: Character {
    case left  = "<"
    case right = ">"
    case inc   = "+"
    case dec   = "-"
    case loop  = "["
    case end   = "]"
    case read  = ","
    case write = "."
}

/// A Brainfuck REPL session.
class Session {
    /// The Brainfuck data byte cells.
    var data: [Int8]
    /// Optional program input, if running with !.
    var input: [Character]?
    /// The highest data cell pointed to thus far.
    var highest: Int = 0
    /// The data pointer. Points to a data cell.
    var pointer: Int = 0 {
        didSet {
            if pointer >= data.count || pointer < 0 {
                printError("Pointer out of bounds.")
                pointer = oldValue
            } else {
                highest = highest > pointer ? highest : pointer
            }
        }
    }

    init(cells: Int = 30_000) {
        self.data = Array(repeating: 0, count: cells)
    }
}

extension Session {
    /// Execute a given stack of instructions.
    func execute(_ input: [Instruction]) {
        var instructions = input
        while let instruction = instructions.popFirst() {
            switch instruction {
            case .left:
                pointer -= 1
            case .right:
                pointer += 1
            case .inc:
                data[pointer] += 1
            case .dec:
                data[pointer] -= 1
            case .loop:
                let closure = instructions.popNextClosure()
                while data[pointer] != 0 {
                    execute(closure)
                }
            case .end:
                break
            case .read:
                readData()
            case .write:
                writeByte(data[pointer])
            }
        }
    }

    private func readData() {
        if input != nil, let next = input?.popFirst()?.toByte() {
            data[pointer] = next
        } else {
            data[pointer] = readByte()
        }
    }
}

// MARK: - REPL

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
