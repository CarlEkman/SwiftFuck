//
//  io.swift
//  SwiftFuck
//
//  Created by Carl Ekman on 2018-12-29.
//  Copyright © 2018 Carl Ekman. All rights reserved.
//

import Swiftline

func printError(_ message: String) {
    print(message.f.Red)
}

func printPrompt(_ prompt: String = "→") {
    print(prompt.f.Black + " ", terminator: "")
}

func readByte() -> Int8 {
    let input = ask("Input byte:", type: Character.self) { settings in
        settings.addInvalidCase("Must be a valid 8-bit Unicode character.") { return $0.toByte() == nil }
    }
    return input.toByte()!
}

func writeByte(_ value: Int8) {
    if let scalar = UnicodeScalar(Int(value)) {
        print(scalar)
    } else {
        printError("Cannot write data as Unicode.")
    }
}

extension Session {
    func printCells() {
        var output = ""
        for i in 0...highest {
            let string = String(describing: data[i])
            let register = i == pointer ? "[\(string)]" : string
            let separator = i == highest ? "" : " "
            output += register + separator
        }
        print(output)
    }
}

extension Character {
    func toByte() -> Int8? {
        guard unicodeScalars.count == 1,
            let value = unicodeScalars.first?.value,
            value < 266 else { return nil }
        return Int8(value)
    }
}

extension Character: ArgConvertibleType {
    public static func fromString(_ string: String) -> Character? {
        return string.first
    }

    public static func typeName() -> String {
        return "Character"
    }
}
