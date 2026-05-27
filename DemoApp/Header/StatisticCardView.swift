//
//  StatisticCardView.swift
//  DemoApp
//
//  Created by Lazzat Seiilova on 27.05.2026.
//

import SwiftUI

struct StatisticCardView: View {
    
    var title: String
    var count: Int
    var iconName: String
    var units: String?
    
    var body: some View {
        ZStack {
            Color.red
            HStack {
                Image(systemName: iconName)
                VStack(alignment: .leading) {
                    Text(title)
                        .font(.headline)
                    Text(String(count))
                    Text(units ?? "")
                }
            }
        }
        .frame(width: 100, height: 100)
        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
        .overlay {
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .stroke(.gray, lineWidth: 3)
        }
    }
}

#Preview {
    ContentView()
}
