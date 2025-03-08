//
//  ContentView.swift
//  PlantPal
//
//  Created by Gimhan Rajapaksha on 2024-11-26.
//

import SwiftUI
import AVKit

struct ContentView: View {
    @StateObject private var authService = AuthService()
    
    var body: some View {
        Group {
            if authService.isAuthenticated {
                HomeView()
             //   ProfileView()
               //     .environmentObject(authService)
            } else {
                AuthenticationView()
            }
        }
    }

}

#Preview {
    ContentView()
}
