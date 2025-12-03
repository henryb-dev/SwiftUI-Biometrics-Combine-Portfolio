//
//  LoginView.swift
//  Address
//
//  Created by Henry Bautista on 22/07/25.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var authVM: AuthViewModel

    var body: some View {
        VStack(spacing: 40) {
            Text("Admin Login").font(.largeTitle)
            Button("Iniciar sesión con Touch/Face ID") {
                authVM.login()
            }
            .accessibilityIdentifier("touchFaceIdButton")
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(8)
        }
    }
}
