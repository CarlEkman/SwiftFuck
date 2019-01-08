//
//  lang.swift
//  SwiftFuck
//
//  Created by Carl Ekman on 2019-01-08.
//

import Foundation

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
    /// Session options.
    var options: Options
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

    init(cellCount: Int, input: [Character]? = nil, newLine: Bool = true) {
        self.options = Options(printWithNewLine: newLine)
        self.data = Array(repeating: 0, count: cellCount)
        self.input = input
    }
}

extension Session {
    struct Options {
        /// End each character printout with new line.
        let printWithNewLine: Bool
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
                let newLine = options.printWithNewLine || instructions.isEmpty
                writeByte(data[pointer], withNewLine: newLine)
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
