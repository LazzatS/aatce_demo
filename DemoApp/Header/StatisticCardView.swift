//
//  StatisticCardView.swift
//  DemoApp
//
//  Created by Lazzat Seiilova on 27.05.2026.
//

import SwiftUI

struct StatisticCardView: View {
    
    var title: String
    var value: String
    var iconName: String
    var units: String?
    
    var body: some View {
        ZStack {
            Color.cardBg
            HStack {
                Image(systemName: iconName)
                    .font(.headline)
                    .foregroundColor(.purpleAccent)
                VStack(alignment: .leading) {
                    Text(title)
                        .font(.caption)
                        .foregroundColor(.secondaryText)
                    HStack(spacing: 2) {
                        Text(value)
                            .font(.headline)
                            .foregroundColor(.primaryText)
                        if let units = units {
                            Text(units)
                                .font(.caption)
                                .foregroundColor(.secondaryText)
                        }
                    }
                }
            }
            .padding(10)
        }
        .frame(height: 80)
        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
        .overlay {
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .stroke(Color.borderColor.opacity(0.5), lineWidth: 1)
        }
    }
}

#Preview {
    ContentView()
}
