//
//  RoleSelectionView.swift
//  DemoApp
//
//  Created by Codex on 28.05.2026.
//

import SwiftUI

struct RoleSelectionView: View {
    let onSelectStudent: () -> Void
    
    var body: some View {
        ZStack {
            Color.appBackground.ignoresSafeArea()
            
            VStack(alignment: .leading, spacing: 20) {
                Text("WELCOME")
                    .font(.caption)
                    .foregroundColor(.secondaryText)
                
                (
                    Text("Who are you in this ")
                        .foregroundColor(.primaryText)
                    + Text("journey?")
                        .foregroundColor(.purpleAccent)
                )
                .font(.system(size: 30, weight: .bold))
                
                Text("Choose your role to continue.")
                    .font(.subheadline)
                    .foregroundColor(.secondaryText)
                
                VStack(spacing: 12) {
                    Button(action: onSelectStudent) {
                        HStack(spacing: 10) {
                            Image(systemName: "graduationcap.fill")
                            Text("I am a Student")
                                .fontWeight(.semibold)
                        }
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 52)
                        .background(Color.purpleAccent)
                        .cornerRadius(14)
                    }
                    
                    Button(action: {}) {
                        HStack(spacing: 10) {
                            Image(systemName: "person.fill.badge.plus")
                            Text("I am a Teacher")
                                .fontWeight(.semibold)
                            Text("(coming soon)")
                                .font(.subheadline)
                                .foregroundColor(.secondaryText)
                        }
                        .font(.headline)
                        .foregroundColor(.primaryText.opacity(0.5))
                        .frame(maxWidth: .infinity)
                        .frame(height: 52)
                        .background(Color.cardBg.opacity(0.6))
                        .cornerRadius(14)
                    }
                    .disabled(true)
                }
            }
            .padding(20)
            .background(Color.appBackground)
            .padding(.horizontal, 20)
        }
    }
}

#Preview {
    RoleSelectionView(onSelectStudent: {})
}
