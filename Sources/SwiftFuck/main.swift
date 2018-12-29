//
//  main.swift
//  SwiftFuck
//
//  Created by Carl Ekman on 2018-12-28.
//  Copyright © 2018 Carl Ekman. All rights reserved.
//

import Foundation//-Swiftline

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
//                let input: Int8 = ask("Input byte:")
//                data[pointer] = input
                if let input = readByte() {
                    data[pointer] = input
                }

            case .write:
                writeByte(data[pointer])
            }
        }
    }
}

// MARK: - REPL

printOutput("Running Brainfuck REPL. Enter 'q' to quit.")
let session = Session()
var input: String = ""
repeat {
    session.printCells()
    printPrompt()
    input = readLine() ?? ""
    let instructions = input.compactMap { Instruction(rawValue: $0) }
    session.execute(instructions)
} while input != "q"

printOutput("Quitting")
