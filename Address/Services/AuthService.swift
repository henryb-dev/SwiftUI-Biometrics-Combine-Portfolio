//
//  AuthService.swift
//  Address
//
//  Created by Henry Bautista on 22/07/25.
//

import LocalAuthentication
import Combine

class AuthService {
    static func authenticate(using ctx: LAContext = LAContext()) -> Future<Bool, Never> {
        return Future { promise in
            
            let reason = "Accede como administrador"
            var error: NSError?

            if ctx.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
                ctx.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics,
                                   localizedReason: reason) { success, _ in
                    DispatchQueue.main.async {
                        promise(.success(success))
                    }
                }
            } else {
                DispatchQueue.main.async {
                    promise(.success(false))
                }
            }
        }
    }
}

