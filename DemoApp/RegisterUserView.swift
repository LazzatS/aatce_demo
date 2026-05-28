//
//  RegisterUserView.swift
//  DemoApp
//
//  Created by Codex on 28.05.2026.
//

import SwiftUI

struct RegisterUserView: View {
    @Environment(\.dismiss) private var dismiss
    
    @State private var name = ""
    @State private var surname = ""
    
    let onSave: (String, String) -> Void
    
    var body: some View {
        ZStack {
            Color.appBackground.ignoresSafeArea()
            
            VStack(alignment: .leading, spacing: 20) {
                Text("REGISTRATION")
                    .font(.caption)
                    .foregroundColor(.secondaryText)
                
                (
                    Text("Let's personalize your ")
                        .foregroundColor(.primaryText)
                    + Text("study plan")
                        .foregroundColor(.purpleAccent)
                )
                .font(.system(size: 29, weight: .bold))
                
                Text("Enter your details to continue.")
                    .font(.subheadline)
                    .foregroundColor(.secondaryText)
                
                VStack(spacing: 12) {
                    styledField(title: "Name", text: $name)
                    styledField(title: "Surname", text: $surname)
                }
                
                HStack(spacing: 12) {
                    Button(action: { dismiss() }) {
                        Text("Cancel")
                            .font(.headline)
                            .foregroundColor(.primaryText)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(Color.cardBg)
                            .cornerRadius(14)
                    }
                    
                    Button(action: {
                        onSave(trimmedName, trimmedSurname)
                        dismiss()
                    }) {
                        Text("Continue")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(canSave ? Color.purpleAccent : Color.purpleAccent.opacity(0.35))
                            .cornerRadius(14)
                    }
                    .disabled(!canSave)
                }
            }
            .padding(20)
            .background(Color.appBackground)
            .padding(.horizontal, 20)
        }
    }
    
    private var trimmedName: String {
        name.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    private var trimmedSurname: String {
        surname.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    private var canSave: Bool {
        !trimmedName.isEmpty && !trimmedSurname.isEmpty
    }
    
    @ViewBuilder
    private func styledField(title: String, text: Binding<String>) -> some View {
        TextField(title, text: text)
            .textInputAutocapitalization(.words)
            .padding(.horizontal, 14)
            .frame(height: 48)
            .background(Color.appBackground.opacity(0.7))
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.borderColor.opacity(0.45), lineWidth: 1)
            )
            .foregroundColor(.primaryText)
    }
}

#Preview {
    RegisterUserView(onSave: { _, _ in })
}
