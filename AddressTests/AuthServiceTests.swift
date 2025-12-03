//
//  AuthServiceTests.swift
//  Address
//
//  Created by Henry Bautista on 1/12/25.
//

import XCTest
import LocalAuthentication
import Combine
@testable import Address


final class AuthServiceTests: XCTestCase {

    func testAuthenticationSuccess() {
        let ctx = MockLAContext()
        ctx.canEval = true
        ctx.evalSucceeds = true

        let expectation = XCTestExpectation(description: "Auth success")

        AuthService.authenticate(using: ctx)
            .sink { success in
                XCTAssertTrue(success)
                expectation.fulfill()
            }
            .store(in: &TestCancellables.set)

        wait(for: [expectation], timeout: 1.0)
    }

    func testAuthenticationFailure() {
        let ctx = MockLAContext()
        ctx.canEval = true
        ctx.evalSucceeds = false

        let expectation = XCTestExpectation(description: "Auth fail")

        AuthService.authenticate(using: ctx)
            .first()
            .sink { success in
                XCTAssertFalse(success)
                expectation.fulfill()
            }
            .store(in: &TestCancellables.set)

        wait(for: [expectation], timeout: 2)
    }

    func testAuthenticationUnavailable() {
        let ctx = MockLAContext()
        ctx.canEval = false  // biometría no disponible

        let expectation = XCTestExpectation(description: "No biometrics")

        AuthService.authenticate(using: ctx)
            .sink { success in
                XCTAssertFalse(success)
                expectation.fulfill()
            }
            .store(in: &TestCancellables.set)

        wait(for: [expectation], timeout: 1.0)
    }
}
