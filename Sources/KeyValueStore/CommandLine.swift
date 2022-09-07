//
//  File.swift
//  
//
//  Created by Matias Bzurovski on 07/09/2022.
//

import Foundation

class CommandLine {
    let console = Console()

    func start() {
        console.write("Welcome to KeyValueStore! Type a command to get started")

        var exit = false
        while !exit {
            guard let input = console.read() else {
                exit = true
                continue
            }
            if input == "bye" {
                console.write("Goodbye!")
                exit = true
            } else {
                console.write("You said \(input)")
            }
        }
    }
}
