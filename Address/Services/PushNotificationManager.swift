//
//  PushNotificationManager.swift
//  Address
//
//  Created by Henry Bautista on 22/07/25.
//

import UIKit
import UserNotifications
import Combine

@MainActor
class PushNotificationManager: NSObject, UNUserNotificationCenterDelegate, ObservableObject {

    private let center: CustomNotificationCenter
    @Published var isRegistered = false

    init(center: CustomNotificationCenter = UNUserNotificationCenter.current()) {
        self.center = center
        super.init()
    }

    func registerForPush() {
        center.delegate = self

        center.requestAuthorization(options: [.alert, .badge, .sound]) { [weak self] granted, error in
            Task { @MainActor in
                self?.isRegistered = granted

                if granted {
                    UIApplication.shared.registerForRemoteNotifications()
                }
            }
        }
    }
    
  /*  func userNotificationCenter(_ center: UNUserNotificationCenter,
                                   didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        // Manejo de la notificación si es necesario
        completionHandler()
    }*/
}
