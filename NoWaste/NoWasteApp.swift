//
//  NoWasteApp.swift
//  NoWaste
//
//  Created by Carlos Alberto Lopez Figueroa on 29/04/23.
//

import SwiftUI
import FirebaseCore
import FirebaseAuth
import GoogleSignIn


@main
struct NoWasteApp: App {
    init(){
            FirebaseApp.configure()
        
    }
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
