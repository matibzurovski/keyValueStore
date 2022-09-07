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
        #if DEBUG
        // When running on DEBUG mode, we will just print the message on Xcode's console.
        print(message)
        #else
        // When running on RELEASE mode, we will set the terminal's text color corresponding to the type.
        switch type {
            case .standard:
                 print("\u{001B}[;m\(message)")
            case .error:
                 fputs("\u{001B}[0;31m\(message)\n\u{001B}[;m", stderr)
        }
        #endif
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
