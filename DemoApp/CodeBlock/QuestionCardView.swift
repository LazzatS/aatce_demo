//
//  QuestionCardView.swift
//  DemoApp
//
//  Created by Lazzat Seiilova on 27.05.2026.
//

import SwiftUI

struct QuestionCardView: View {
    let question: QuizQuestion
    
    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            // Tags + skip
            HStack {
                Text(question.tag)
                    .font(.caption).fontWeight(.semibold).foregroundColor(.white)
                    .padding(.horizontal, 12).padding(.vertical, 6)
                    .background(Color.purpleAccent)
                    .cornerRadius(20)

                Spacer()

                HStack(spacing: 4) {
                    Image(systemName: "arrow.left.arrow.right")
                        .font(.caption)
                    Text("swipe to skip")
                        .font(.caption)
                }
                .foregroundColor(.gray)
            }

            Text(question.title)
                .font(.subheadline)
                .foregroundColor(.white)

            CodeBlockView(code: question.codeBlock)

            // Bottom row
            HStack {
                Text(question.difficulty)
                    .font(.caption)
                    .foregroundColor(.goldYellow)
                    .padding(.horizontal, 10).padding(.vertical, 4)
                    .background(Color.goldYellow.opacity(0.15))
                    .cornerRadius(20)

                Spacer()

                HStack(spacing: 8) {
                    Button(action: {}) {
                        Image(systemName: "bookmark")
                            .foregroundColor(.gray)
                            .frame(width: 34, height: 34)
                            .background(Color.black.opacity(0.3))
                            .cornerRadius(8)
                    }
                    Button(action: {}) {
                        Image(systemName: "info.circle")
                            .foregroundColor(.gray)
                            .frame(width: 34, height: 34)
                            .background(Color.black.opacity(0.3))
                            .cornerRadius(8)
                    }
                }
            }
        }
        .padding(16)
        .background(Color.cardBg)
        .cornerRadius(16)
    }
}
