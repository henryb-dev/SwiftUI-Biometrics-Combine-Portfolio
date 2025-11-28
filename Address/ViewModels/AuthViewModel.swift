//
//  AuthViewModel.swift
//  Address
//
//  Created by Henry Bautista on 22/07/25.
//

import Combine
import SwiftUI

class AuthViewModel: ObservableObject {
    @Published var isAuthenticated = false
    private var cancellable: AnyCancellable?

    func login() {
        cancellable = AuthService.authenticate()
            .sink { [weak self] success in
                self?.isAuthenticated = success
            }
    }
}
