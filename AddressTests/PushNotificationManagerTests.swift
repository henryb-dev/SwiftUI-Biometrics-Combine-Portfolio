//
//  PushNotificationManagerTests.swift
//  Address
//
//  Created by Henry Bautista on 1/12/25.
//


import XCTest
@testable import Address

final class PushNotificationManagerTests: XCTestCase {

    @MainActor
    func testInitialization() {
        let manager = PushNotificationManager()
        XCTAssertNotNil(manager)
    }

    @MainActor
    func testDelegateAssignment() {
        let mockCenter = MockNotificationCenter()
        let manager = PushNotificationManager(center: mockCenter.self as CustomNotificationCenter)

        manager.registerForPush()

        XCTAssertTrue(mockCenter.delegate === manager)
        XCTAssertTrue(mockCenter.didRequestAuthorization)
    }

}
