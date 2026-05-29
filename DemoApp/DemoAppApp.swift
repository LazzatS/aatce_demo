//
//  DemoAppApp.swift
//  DemoApp
//
//  Created by Lazzat Seiilova on 27.05.2026.
//

import SwiftUI

@main
struct DemoAppApp: App {
    @State private var isLaunching = true
    
    var body: some Scene {
        WindowGroup {
            if isLaunching {
                SplashView()
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                            isLaunching = false
                        }
                    }
            } else {
                ContentView()
            }
        }
    }
}

struct SplashView: View {
    var body: some View {
        VStack {
            Image("AppLogo")
                .resizable()
                .frame(width: 100, height: 100)
                .clipShape(RoundedRectangle(cornerRadius: 30))
        }
    }
}
