//
//  ProfileView.swift
//  DemoApp
//
//  Created by Codex on 28.05.2026.
//

import SwiftUI

struct ProfileView: View {
    let name: String
    let surname: String
    let selectedLanguage: String
    let testAttempts: Int
    let successPercent: Int
    
    var body: some View {
        ZStack {
            Color.appBackground.ignoresSafeArea()
            
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Text("PROFILE")
                        .font(.caption)
                        .foregroundColor(.secondaryText)
                    
                    (
                        Text("Your learning ")
                            .foregroundColor(.primaryText)
                        + Text("profile")
                            .foregroundColor(.purpleAccent)
                    )
                    .font(.system(size: 32, weight: .bold))
                    
                    VStack(spacing: 12) {
                        profileRow(title: "Name", value: name)
                        profileRow(title: "Surname", value: surname)
                        profileRow(title: "Selected language", value: selectedLanguage)
                        profileRow(title: "Test attempts", value: "\(testAttempts)")
                        profileRow(title: "Success percent", value: "\(successPercent)%")
                    }
                }
                .padding(20)
            }
        }
        .navigationTitle("Profile")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    @ViewBuilder
    private func profileRow(title: String, value: String) -> some View {
        HStack {
            Text(title)
                .font(.subheadline)
                .foregroundColor(.secondaryText)
            Spacer()
            Text(value)
                .font(.headline)
                .foregroundColor(.primaryText)
        }
        .padding(16)
        .background(Color.cardBg)
        .cornerRadius(12)
    }
}

#Preview {
    ProfileView(
        name: "Aisha",
        surname: "Khan",
        selectedLanguage: "Swift",
        testAttempts: 4,
        successPercent: 78
    )
}
