//
//  util.swift
//  SwiftFuck
//
//  Created by Carl Ekman on 2018-12-29.
//  Copyright © 2018 Carl Ekman. All rights reserved.
//

import Foundation

extension Array {
    /// Like `popLast()`, but with the first Element. Naturally also reorders the array.
    mutating func popFirst() -> Element? {
        guard let first = self.first else { return nil }
        remove(at: 0)
        return first
    }
}

extension Array where Element == Instruction {
    /// Returns the subset of instructions until the next matching `]`,
    /// while also removing the subset from the array.
    mutating func popNextClosure() -> [Instruction] {
        var count = 1
        for (i, instr) in self.enumerated() {
            if instr == .loop {
                count += 1
            } else if instr == .end {
                count -= 1
                if count == 0 {
                    let result = prefix(i)
                    for _ in 0...i {
                        self.remove(at: 0)
                    }
                    return Array(result)
                }
            }
        }
        return []
    }
}
