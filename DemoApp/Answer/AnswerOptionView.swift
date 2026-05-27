//
//  AnswerOptionView.swift
//  DemoApp
//
//  Created by Lazzat Seiilova on 27.05.2026.
//

import SwiftUI

struct AnswerOptionView: View {
    let letter: String
    let text: String
    let state: AnswerState
    let action: (() -> Void)?

    private var borderColor: Color {
        switch state {
        case .normal:   return .clear
        case .correct:  return .correctGreen
        case .selected: return .purpleAccent
        }
    }

    private var bgColor: Color {
        switch state {
        case .normal:   return Color.cardBg
        case .correct:  return Color.correctGreen.opacity(0.12)
        case .selected: return Color.purpleAccent.opacity(0.08)
        }
    }

    private var circleColor: Color {
        switch state {
        case .normal:   return Color.gray.opacity(0.25)
        case .correct:  return Color.correctGreen
        case .selected: return Color.purpleAccent
        }
    }

    var body: some View {
        Button(action: { action?() }) {
            HStack(spacing: 14) {
                ZStack {
                    Circle().fill(circleColor).frame(width: 36, height: 36)
                    if state == .correct {
                        Image(systemName: "checkmark")
                            .foregroundColor(.primaryText)
                            .font(.system(size: 13, weight: .bold))
                    } else {
                        Text(letter)
                            .foregroundColor(.primaryText)
                            .font(.system(size: 15, weight: .semibold))
                    }
                }

                Text(text)
                    .foregroundColor(state == .correct ? .correctGreen : .primaryText)
                    .font(.system(size: 16))

                Spacer()

                if state == .correct {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.correctGreen)
                        .font(.title2)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
            .background(bgColor)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(borderColor, lineWidth: 1.5)
            )
        }
        .disabled(action == nil)
    }
}
