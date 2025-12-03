//
//  AuthViewModel.swift
//  Address
//
//  Created by Henry Bautista on 22/07/25.
//

import Combine
import SwiftUI
import LocalAuthentication

class AuthViewModel: ObservableObject {
    @Published var isAuthenticated = false
    let authService: AuthService.Type
    var isUITestBiometricSuccess = true
    
    init(authService: AuthService.Type = AuthService.self) {
        self.authService = authService
    }

    func login(using ctx: LAContext = LAContext()) {
        #if DEBUG
        if isUITestBiometricSuccess {
            isAuthenticated = true
            return
        }
        #endif
        authService.authenticate(using: ctx)
            .sink { [weak self] result in
                self?.isAuthenticated = result
                
            }
            .store(in: &cancellables)
    }

    private var cancellables = Set<AnyCancellable>()
}

