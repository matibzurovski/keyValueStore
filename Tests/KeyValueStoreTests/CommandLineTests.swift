//
//  CommandLineTests.swift
//  
//
//  Created by Matias Bzurovski on 07/09/2022.
//

import XCTest
@testable import KeyValueStore

final class CommandLineTests: XCTestCase {
    private var result: CommandLine.Option!

    func testOption_set() {
        var input = "SET name Homer"
        result = .init(input: input)

        XCTAssertEqual(result, .set(key: "name", value: "Homer"))

        // Test a value with multiple words
        input = "SET name Homer Simpson"
        result = .init(input: input)

        XCTAssertEqual(result, .set(key: "name", value: "Homer Simpson"))

        // Test an invalid case without value
        input = "SET name"
        result = .init(input: input)

        XCTAssertEqual(result, .unknown)
    }

    func testOption_get() {
        var input = "GET name"
        result = .init(input: input)

        XCTAssertEqual(result, .get(key: "name"))

        // Test an invalid case without key
        input = "GET"
        result = .init(input: input)

        XCTAssertEqual(result, .unknown)
    }

    func testOption_delete() {
        var input = "DELETE name"
        result = .init(input: input)

        XCTAssertEqual(result, .delete(key: "name"))

        // Test an invalid case without key
        input = "DELETE"
        result = .init(input: input)

        XCTAssertEqual(result, .unknown)
    }

    func testOption_count() {
        var input = "COUNT Homer"
        result = .init(input: input)

        XCTAssertEqual(result, .count(value: "Homer"))

        // Test an invalid case without value
        input = "COUNT"
        result = .init(input: input)

        XCTAssertEqual(result, .unknown)
    }

    func testOption_begin() {
        var input = "BEGIN"
        result = .init(input: input)

        XCTAssertEqual(result, .begin)
    }

    func testOption_commit() {
        var input = "COMMIT"
        result = .init(input: input)

        XCTAssertEqual(result, .commit)
    }

    func testOption_rollback() {
        var input = "ROLLBACK"
        result = .init(input: input)

        XCTAssertEqual(result, .rollback)
    }

    func testOption_exit() {
        var input = "EXIT"
        result = .init(input: input)

        XCTAssertEqual(result, .exit)
    }

    func testOption_help() {
        var input = "HELP"
        result = .init(input: input)

        XCTAssertEqual(result, .help)
    }
}
