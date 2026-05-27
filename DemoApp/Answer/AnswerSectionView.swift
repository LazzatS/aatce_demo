//
//  AnswerSectionView.swift
//  DemoApp
//
//  Created by Lazzat Seiilova on 27.05.2026.
//

import SwiftUI

struct AnswerSectionView: View {
    @Binding var answeredCards: Int
    @Binding var correctCount: Int
    @Binding var currentQuestion: QuizQuestion?
    @Binding var selectedAnswer: String?
    @Binding var showResult: Bool
    
    var onSwapCard: (() -> Void)?
    
    private var selectedOptionState: (String, AnswerState)? {
        guard let selected = selectedAnswer else { return nil }
        for option in currentQuestion?.options ?? [] {
            if option.letter == selected {
                return (selected, option.isCorrect ? .correct : .selected)
            }
        }
        return nil
    }
    
    func selectOption(_ letter: String) {
        guard selectedAnswer == nil else { return }
        
        // Find the selected option
        if let option = currentQuestion?.options.first(where: { $0.letter == letter }) {
            selectedAnswer = letter
            
            // Update correct count if answer is correct
            if option.isCorrect {
                correctCount += 1
            }
            
            // Show result briefly before swapping card
            showResult = true
            
            // After 1.5 seconds, swap the card and reset
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                swapCard()
            }
        }
    }
    
    func swapCard() {
        // Reset for next card
        selectedAnswer = nil
        showResult = false
        
        // Trigger card swap
        onSwapCard?()
        
        // Mark as answered
        answeredCards += 1
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 8) {
                Image(systemName: "list.bullet")
                Text("Choose the correct answer")
                    .font(.headline)
            }
            .foregroundColor(.primaryText)

            VStack(spacing: 10) {
                ForEach(currentQuestion?.options ?? [], id: \.letter) { option in
                    let isSelected = selectedAnswer == option.letter
                    let state: AnswerState = {
                        if !showResult {
                            return isSelected ? .selected : .normal
                        } else if option.isCorrect {
                            return .correct
                        } else if isSelected {
                            return .selected
                        } else {
                            return .normal
                        }
                    }()
                    
                    AnswerOptionView(
                        letter: option.letter,
                        text: option.text,
                        state: state,
                        action: selectedAnswer == nil ? {
                            selectOption(option.letter)
                        } : nil
                    )
                }
            }

            // Type your answer
            HStack {
                Rectangle().fill(Color.tertiaryText.opacity(0.3)).frame(height: 1)
                Text("or type your answer")
                    .font(.caption).foregroundColor(.tertiaryText)
                    .fixedSize()
                Rectangle().fill(Color.tertiaryText.opacity(0.3)).frame(height: 1)
            }

            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.cardBg)
                    .frame(height: 50)
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.gray.opacity(0.25), lineWidth: 1)
                    .frame(height: 50)
                Text("e.g.,  [2, 4]")
                    .font(.system(.body, design: .monospaced))
                    .foregroundColor(Color.tertiaryText.opacity(0.5))
                    .padding(.leading, 16)
            }
            
            if showResult {
                HStack(spacing: 8) {
                    Image(systemName: selectedOptionState?.1 == .correct ? "checkmark.circle.fill" : "xmark.circle.fill")
                        .foregroundColor(selectedOptionState?.1 == .correct ? .correctGreen : .red)
                    Text(selectedOptionState?.1 == .correct ? "Correct!" : "Incorrect")
                        .font(.caption)
                        .foregroundColor(selectedOptionState?.1 == .correct ? .correctGreen : .red)
                }
                .padding(.top, 8)
            }
        }
    }
}
