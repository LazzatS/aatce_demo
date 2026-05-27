//
//  StatsRowView.swift
//  DemoApp
//
//  Created by Lazzat Seiilova on 27.05.2026.
//

import SwiftUI

struct StatsRowView: View {
    var body: some View {
        HStack(spacing: 10) {
            StatisticCardView(title: "Streak", count: 7, iconName: "flame.fill")
            StatisticCardView(title: "XP\ntoday", count: 340, iconName: "star")
            StatisticCardView(title: "Rank", count: 12, iconName: "trophy.fill")
        }
    }
}
