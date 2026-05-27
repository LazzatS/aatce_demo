//
//  HeaderView.swift
//  DemoApp
//
//  Created by Lazzat Seiilova on 27.05.2026.
//

import SwiftUI

struct HeaderView: View {
    var body: some View {
        HStack(alignment: .center) {
            VStack(alignment: .leading, spacing: 2) {
                Text("Good morning 👋")
                    .font(.subheadline)
                    .foregroundColor(.secondaryText)
                HStack(spacing: 0) {
                    Text("Hello, ")
                        .font(.largeTitle).fontWeight(.bold).foregroundColor(.primaryText)
                    Text("Aisha")
                        .font(.largeTitle).fontWeight(.bold).foregroundColor(.purpleAccent)
                }
            }
            Spacer()
            ZStack {
                Circle()
                    .fill(Color.purpleAccent)
                    .frame(width: 50, height: 50)
                Text("AI")
                    .foregroundColor(.white)
                    .fontWeight(.semibold)
            }
        }
    }
}
