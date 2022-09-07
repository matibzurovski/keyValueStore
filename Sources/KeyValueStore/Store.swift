//
//  Store.swift
//  
//
//  Created by Matias Bzurovski on 07/09/2022.
//

import Foundation

class Store {
    // A stack of the transactions created by the users.
    private var transactions = Stack<Transaction>()

    // A base transaction we manually create to allow using the KeyStore even if no transaction was created.
    private var base = Transaction()

    /// Returns the peek transaction (if any) or the base one.
    private var peekOrBase: Transaction {
        transactions.peek() ?? base
    }

    /// Sets the current key/value pair.
    func set(key: String, value: String) {
        peekOrBase.set(key: key, value: value)
    }

    /// Returns the value for the given key, if any.
    func get(key: String) -> String? {
        for transaction in transactions.items {
            if let value = transaction.get(key: key) {
                return value
            }
        }
        return base.get(key: key)
    }

    /// Deletes the value for the given key.
    ///
    /// NOTE: This will only delete the value on the peek transaction, or in the base one
    /// if there wasn't any transaction created by the user. This means that if the user attempts
    /// to delete the value for a key added on a previous transaction, it won't be deleted.
    func delete(key: String) {
        peekOrBase.delete(key: key)
    }

    /// Returns the number of keys that have the given value.
    func count(value: String) -> Int {
        let result = transactions.items.reduce(0) { $0 + $1.count(value: value) }
        return result + base.count(value: value)
    }

    /// Start a new transction.
    func begin() {
        transactions.push(.init())
    }

    /// Complete the current transaction.
    func commit() -> Bool {
        guard let peek = transactions.pop() else {
            return false
        }
        peekOrBase.commit(transaction: peek)
        return true
    }

    /// Discards the last transaction, leaving the Store on the same state that it was
    /// prior to last `begin()` call.
    func rollback() -> Bool {
        return transactions.pop() != nil
    }
}

extension Store {
    private class Transaction {
        var storage: [String: String] = [:]

        func set(key: String, value: String) {
            storage[key] = value
        }

        func get(key: String) -> String? {
            storage[key]
        }

        func delete(key: String) {
            storage[key] = nil
        }

        func count(value: String) -> Int {
            storage.filter { $1 == value }.count
        }

        func commit(transaction: Transaction) {
            storage = storage.merging(transaction.storage) { (_, new) in new }
        }
    }
}
