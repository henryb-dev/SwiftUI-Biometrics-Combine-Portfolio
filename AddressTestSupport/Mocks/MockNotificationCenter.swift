//
//  MockNotificationCenter.swift
//  Address
//
//  Created by Henry Bautista on 1/12/25.
//
import UserNotifications
@testable import Address

@MainActor
final class MockNotificationCenter: CustomNotificationCenter {

    var delegate: UNUserNotificationCenterDelegate?
    var didRequestAuthorization = false

    func requestAuthorization(
        options: UNAuthorizationOptions,
        completionHandler: @escaping @Sendable (Bool, Error?) -> Void
    ) {
        didRequestAuthorization = true
        completionHandler(true, nil)
    }
}
