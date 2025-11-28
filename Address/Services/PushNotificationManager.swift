//
//  PushNotificationManager.swift
//  Address
//
//  Created by Henry Bautista on 22/07/25.
//

import UIKit
import UserNotifications
import Combine

class PushNotificationManager: NSObject, UNUserNotificationCenterDelegate, ObservableObject {
    // Si hay propiedades cuyo cambio debería notificar a la UI,
    // márcalas con @Published:
    @Published var isRegistered = false

    func registerForPush() {
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        center.requestAuthorization(options: [.alert, .badge, .sound]) { [weak self] granted, error in
            DispatchQueue.main.async {
                self?.isRegistered = granted
                if granted {
                    UIApplication.shared.registerForRemoteNotifications()
                }
            }
        }
    }

    // Delegate: cuando llega alguna notificación
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        // Manejo de la notificación si es necesario
        completionHandler()
    }
}

