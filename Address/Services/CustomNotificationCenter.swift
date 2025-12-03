//
//  NotificationCenterType.swift
//  Address
//
//  Created by Henry Bautista on 1/12/25.
//

import UserNotifications

@MainActor
protocol CustomNotificationCenter: AnyObject {
    var delegate: UNUserNotificationCenterDelegate? { get set }

    func requestAuthorization(
        options: UNAuthorizationOptions,
        completionHandler: @escaping @Sendable (Bool, Error?) -> Void
    )
}

@MainActor
extension UNUserNotificationCenter: CustomNotificationCenter {}

