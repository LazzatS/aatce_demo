//
//  HeaderView.swift
//  DemoApp
//
//  Created by Lazzat Seiilova on 27.05.2026.
//

import SwiftUI

struct HeaderView: View {
    var firstName: String?
    var surname: String?
    var onProfileTap: () -> Void
    
    var body: some View {
        HStack(alignment: .center) {
            VStack(alignment: .leading, spacing: 2) {
                Text("Good morning 👋")
                    .font(.subheadline)
                    .foregroundColor(.secondaryText)
                HStack(spacing: 0) {
                    Text("Hello, ")
                        .font(.largeTitle).fontWeight(.bold).foregroundColor(.primaryText)
                    Text(displayName)
                        .font(.largeTitle).fontWeight(.bold).foregroundColor(.purpleAccent)
                }
            }
            Spacer()
            Button(action: onProfileTap) {
                ZStack {
                    Circle()
                        .fill(Color.purpleAccent)
                        .frame(width: 50, height: 50)
                    Text(initials)
                        .foregroundColor(.white)
                        .fontWeight(.semibold)
                }
            }
        }
    }
    
    private var displayName: String {
        let trimmed = firstName?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        return trimmed.isEmpty ? "Aisha" : trimmed
    }
    
    private var initials: String {
        let firstInitial = initial(from: firstName)
        let lastInitial = initial(from: surname)
        let combined = "\(firstInitial)\(lastInitial)"
        return combined.isEmpty ? "AI" : combined
    }
    
    private func initial(from value: String?) -> String {
        let trimmed = value?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        guard let firstChar = trimmed.first else { return "" }
        return String(firstChar).uppercased()
    }
}
