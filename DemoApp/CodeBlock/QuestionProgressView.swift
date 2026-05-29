//
//  QuestionProgressView.swift
//  DemoApp
//
//  Created by Lazzat Seiilova on 27.05.2026.
//

import SwiftUI

struct QuestionProgressView: View {
    let current: Int
    let total: Int
    let completed: Int

    var body: some View {
        HStack(spacing: 12) {
            VStack(alignment: .leading, spacing: 10) {
                Text("Question progress")
                    .font(.subheadline)
                    .foregroundColor(.secondaryText)
                    .lineLimit(2)

                HStack(spacing: 5) {
                    ForEach(0..<total, id: \.self) { i in
                        RoundedRectangle(cornerRadius: 3)
                            .fill(i < completed ? Color.purpleAccent : Color.gray.opacity(0.25))
                            .frame(height: 6)
                    }
                }
            }

            Spacer()

            HStack(spacing: 0) {
                Text("\(current)")
                    .font(.title2).fontWeight(.bold).foregroundColor(.primaryText)
                Text("/")
                    .foregroundColor(.secondaryText)
                Text("\(total)")
                    .font(.title2).foregroundColor(.secondaryText)
            }.padding()
        }
        .padding(16)
        .background(Color.cardBg)
        .cornerRadius(14)
    }
}
