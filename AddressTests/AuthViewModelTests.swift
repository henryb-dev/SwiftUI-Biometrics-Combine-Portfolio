//
//  AuthViewModelTests.swift
//  Address
//
//  Created by Henry Bautista on 1/12/25.
//


import XCTest
import LocalAuthentication
import Combine
@testable import Address

final class AuthViewModelTests: XCTestCase {

    func testAuthViewModelSuccess() {
        let mock = MockLAContext()
        mock.canEval = true
        mock.evalSucceeds = true

        let vm = AuthViewModel()

        let expectation = XCTestExpectation(description: "VM auth success")

        vm.$isAuthenticated
            .dropFirst() // skip initial false
            .sink { value in
                XCTAssertTrue(value)
                expectation.fulfill()
            }
            .store(in: &TestCancellables.set)

        vm.login(using: mock)

        wait(for: [expectation], timeout: 1.0)
    }

    func testAuthViewModelFailure() {
        let mock = MockLAContext()
        mock.canEval = true
        mock.evalSucceeds = false

        let vm = AuthViewModel()

        let expectation = XCTestExpectation(description: "VM auth fail")

        vm.$isAuthenticated
            .first()
            .sink { value in
                XCTAssertFalse(value)
                expectation.fulfill()
            }
            .store(in: &TestCancellables.set)

        vm.login(using: mock)

        wait(for: [expectation], timeout: 1.0)
    }
}
