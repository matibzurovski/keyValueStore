//
//  StoreTests.swift
//
//
//  Created by Matias Bzurovski on 07/09/2022.
//

import XCTest
@testable import KeyValueStore

final class StoreTests: XCTestCase {
    private var store: Store!

    override func setUp() {
        super.setUp()
        store = .init()
    }

    func testGetSetDelete() {
        let key = "my_key"

        // Verify we don't get any value before setting it
        XCTAssertNil(store.get(key: key))

        // Set a value and verify it is now being returned when fetched
        let value = "value"
        store.set(key: key, value: value)

        XCTAssertEqual(value, store.get(key: key))

        // Override the key with a new value and verify the second one is now returned
        let newValue = "new_value"
        store.set(key: key, value: newValue)

        XCTAssertEqual(newValue, store.get(key: key))

        // Delete the value and verify the result after deleting it is nil
        store.delete(key: key)
        XCTAssertNil(store.get(key: key))
    }

    func testCount() {
        let key1 = "key_one"
        let key2 = "key_two"
        let key3 = "key_three"

        let once = "once"
        let twice = "twice"

        // Store the "once" value under one key, and the "twice" under two keys
        store.set(key: key1, value: once)
        store.set(key: key2, value: twice)
        store.set(key: key3, value: twice)

        // Verify the count returns the expected result
        XCTAssertEqual(1, store.count(value: once))
        XCTAssertEqual(2, store.count(value: twice))
    }

    func testCommit() {
        // Add a value before beginning a transaction
        let keyBase = "key_base"
        let valueBase = "value_base"
        store.set(key: keyBase, value: valueBase)

        // Begin a transaction
        store.begin()

        // Store a new pair under this transaction
        let keyTx = "key_tx"
        let valueTx = "value_tx"

        store.set(key: keyTx, value: valueTx)

        // Verify both values are correctly fecthed
        XCTAssertEqual(valueBase, store.get(key: keyBase))
        XCTAssertEqual(valueTx, store.get(key: keyTx))

        // Commit the transaction and verify it is done successfully
        let result = store.commit()
        XCTAssertTrue(result)

        // Verify both values are still correctly fecthed
        XCTAssertEqual(valueBase, store.get(key: keyBase))
        XCTAssertEqual(valueTx, store.get(key: keyTx))

        // Verify that if we try to commit a new transaction, we fail as there is no transaction to commit
        let result2 = store.commit()
        XCTAssertFalse(result2)
    }

    func testRollback() {
        // Add a value before beginning a transaction
        let keyBase = "key_base"
        let valueBase = "value_base"
        store.set(key: keyBase, value: valueBase)

        // Begin a transaction
        store.begin()

        // Store a new pair under this transaction
        let keyTx = "key_tx"
        let valueTx = "value_tx"

        store.set(key: keyTx, value: valueTx)

        // Verify both values are correctly fecthed
        XCTAssertEqual(valueBase, store.get(key: keyBase))
        XCTAssertEqual(valueTx, store.get(key: keyTx))

        // Rollback the transaction and verify it is done successfully
        let result = store.rollback()
        XCTAssertTrue(result)

        // Verify the base pair is correctly fecthed, while the transaction pair was discarded
        XCTAssertEqual(valueBase, store.get(key: keyBase))
        XCTAssertNil(store.get(key: keyTx))

        // Verify that if we try to rollback a new transaction, we fail as there is no transaction to rollback
        let result2 = store.rollback()
        XCTAssertFalse(result2)
    }

    func testNestedTransactions() {
        // Add a value before beginning a transaction
        let keyBase = "key_base"
        let valueBase = "value_base"
        store.set(key: keyBase, value: valueBase)

        // Begin a transaction
        store.begin()

        // Store a new pair under this transaction
        let keyTx1 = "key_tx_one"
        let valueTx1 = "value_tx_one"

        store.set(key: keyTx1, value: valueTx1)

        // Begin a second transaction
        store.begin()

        // Store two pairs in this transaction:
        // - one that replaces the value stored for the base pair
        // - one that has the same value than the pair saved on the first transaction.
        let valueTx2 = "value_tx_two"
        let keyTx2 = "key_tx_two"
        store.set(key: keyBase, value: valueTx2)
        store.set(key: keyTx2, value: valueTx1)

        // Verify we have 2 occurrences of the value repeated in the transactions
        XCTAssertEqual(2, store.count(value: valueTx1))

        // Verify the keyBase has a new value
        XCTAssertEqual(valueTx2, store.get(key: keyBase))

        // Commit the second transaction
        XCTAssertTrue(store.commit())

        // Rollback the first transaction
        XCTAssertTrue(store.rollback())

        // Verify the keyBase still corresponds to the value set on the second transaction
        XCTAssertEqual(valueTx2, store.get(key: keyBase))

        // Verify we have only 1 occurrence of the keyTx1, as the first transaction was rollbacked.
        XCTAssertEqual(1, store.count(value: valueTx1))
    }
}
