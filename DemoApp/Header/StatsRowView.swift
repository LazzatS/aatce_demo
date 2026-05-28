//
//  StatsRowView.swift
//  DemoApp
//
//  Created by Lazzat Seiilova on 27.05.2026.
//

import SwiftUI

struct StatsRowView: View {
    let streakDays: Int
    let xp: Int
    let rankText: String
    
    var body: some View {
        HStack(spacing: 10) {
            StatisticCardView(title: "Streak", value: "\(streakDays)", iconName: "flame.fill", units: "days")
            StatisticCardView(title: "XP total", value: "\(xp)", iconName: "star")
            StatisticCardView(title: "Rank", value: rankText, iconName: "trophy.fill")
        }
    }
}
