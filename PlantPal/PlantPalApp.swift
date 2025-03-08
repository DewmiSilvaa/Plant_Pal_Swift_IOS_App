//
//  PlantPalApp.swift
//  PlantPal
//
//  Created by Gimhan Rajapaksha on 2024-11-26.
//

import SwiftUI
import Firebase
@main
struct PlantPalApp: App {
    init() {
           FirebaseApp.configure()
       }
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
