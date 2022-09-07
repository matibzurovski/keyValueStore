//
//  Console.swift
//  
//
//  Created by Matias Bzurovski on 07/09/2022.
//

import Foundation

class Console {
    /// Writes the given message to Console.
    func write(_ message: String, type: WriteType = .standard) {
        switch type {
            case .standard:
                print(message)
                // print("\u{001B}[;m\(message)")
            case .error:
                fputs(message, stderr)
                // fputs("\u{001B}[0;31m\(message)\n", stderr)
        }
    }

    /// Reads user input from Console.
    func read() -> String? {
        let inputData = FileHandle.standardInput.availableData
        guard let strData = String(data: inputData, encoding: String.Encoding.utf8) else {
            return nil
        }
        return strData.trimmingCharacters(in: .newlines)
    }
}

// MARK: - Write Type

extension Console {
    enum WriteType {
        case standard
        case error
    }
}
