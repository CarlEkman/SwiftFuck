//
//  io.swift
//  SwiftFuck
//
//  Created by Carl Ekman on 2018-12-29.
//  Copyright © 2018 Carl Ekman. All rights reserved.
//

import Foundation

func printError(_ message: String) {
    fputs("\u{001B}[0;31m\(message)\n", stderr)
}

func printOutput(_ message: String) {
    print("\u{001B}[;m\(message)")
}

func printPrompt(_ prompt: String = "→") {
    print("\u{001B}[;m\(prompt) ", terminator: "")
}

func readByte() -> Int8? {
    printPrompt("Input byte:")
    if let scalar = readLine()?.first?.unicodeScalars.first {
        return Int8(scalar.value)
    } else {
        printError("Invalid input.")
        return nil
    }
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
        printOutput(output)
    }
}
