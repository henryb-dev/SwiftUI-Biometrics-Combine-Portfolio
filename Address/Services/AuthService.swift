//
//  AuthService.swift
//  Address
//
//  Created by Henry Bautista on 22/07/25.
//

import LocalAuthentication
import Combine

class AuthService {
    static func authenticate() -> Future<Bool, Never> {
        return Future { promise in
            let ctx = LAContext()
            var error: NSError?
            let reason = "Accede como administrador"
            if ctx.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
                ctx.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, _ in
                    DispatchQueue.main.async { promise(.success(success)) }
                }
            } else {
                // Fallback
                DispatchQueue.main.async { promise(.success(false)) }
            }
        }
    }
}
