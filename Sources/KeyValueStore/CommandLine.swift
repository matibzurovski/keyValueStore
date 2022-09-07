//
//  File.swift
//  
//
//  Created by Matias Bzurovski on 07/09/2022.
//

import Foundation

class CommandLine {
    let console = Console()
    let store = Store()

    func start() {
        console.write("Welcome to KeyValueStore!\nType a command to get started, or type 'HELP' to see the available options.")

        var exit = false
        while !exit {
            guard let input = console.read() else {
                exit = true
                continue
            }
            let option = Option(input: input)
            switch option {
                case let .set(key, value):
                    store.set(key: key, value: value)
                case let .get(key):
                    let result = store.get(key: key) ?? "key not set"
                    console.write(result)
                case let .delete(key):
                    store.delete(key: key)
                case let .count(value):
                    let count = store.count(value: value)
                    console.write("\(count)")
                case .begin:
                    store.begin()
                case .commit:
                    let success = store.commit()
                    if !success {
                        console.write("no transaction", type: .error)
                    }
                case .rollback:
                    let success = store.rollback()
                    if !success {
                        console.write("no transaction", type: .error)
                    }
                case .exit:
                    exit = true
                case .help:
                    console.write(helpText)
                case .unknown:
                    console.write("Unknown command, type 'HELP' to see the available options.", type: .error)
            }
        }
    }
}

// MARK: - Option

extension CommandLine {
    enum Option: Equatable {
        case set(key: String, value: String)
        case get(key: String)
        case delete(key: String)
        case count(value: String)
        case begin
        case commit
        case rollback
        case exit
        case help
        case unknown

        init(input: String) {
            let components = input.split(separator: " ", maxSplits: 1)
            guard components.count > 0 else {
                self = .unknown
                return
            }
            switch components[0] {
                case "SET":
                    guard components.count == 2 else {
                        self = .unknown
                        return
                    }
                    let subComponents = components[1].split(separator: " ", maxSplits: 1)
                    guard subComponents.count == 2 else {
                        self = .unknown
                        return
                    }
                    self = .set(key: String(subComponents[0]), value: String(subComponents[1]))
                case "GET":
                    if let key = components.secondIfLast {
                        self = .get(key: key)
                    } else {
                        self = .unknown
                    }
                case "DELETE":
                    if let key = components.secondIfLast {
                        self = .delete(key: key)
                    } else {
                        self = .unknown
                    }
                case "COUNT":
                    if let value = components.secondIfLast {
                        self = .count(value: value)
                    } else {
                        self = .unknown
                    }
                case "BEGIN":
                    self = .begin
                case "COMMIT":
                    self = .commit
                case "ROLLBACK":
                    self = .rollback
                case "EXIT":
                    self = .exit
                case "HELP":
                    self = .help
                default:
                    self = .unknown
            }
        }
    }
}

// MARK: - Help text

extension CommandLine {
    private var helpText: String {
        """
        SET <key> <value> // store the value for key
        GET <key>         // return the current value for key
        DELETE <key>      // remove the entry for key
        COUNT <value>     // return the number of keys that have the given value
        BEGIN             // start a new transaction
        COMMIT            // complete the current transaction
        ROLLBACK          // revert to state prior to BEGIN call
        EXIT              // finish using KeyValueStore tool
        HELP              // display available commands
        """
    }
}
