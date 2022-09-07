//
//  Stack.swift
//  
//
//  Created by Matias Bzurovski on 07/09/2022.
//

import Foundation

struct Stack<T> {
    var items: [T] = []

    mutating func push(_ item: T) {
        items.insert(item, at: 0)
    }

    mutating func pop() -> T? {
        return items.isEmpty ? nil : items.removeFirst()
    }

    func peek() -> T? {
        return items.first
    }
}
