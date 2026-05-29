//
//  ProfileView.swift
//  DemoApp
//
//  Created by Codex on 28.05.2026.
//

import SwiftUI

struct ProfileView: View {
    let name: String
    let surname: String
    let location: String = "Almaty"
    let selectedLanguage: String
    let track: String = "iOS track"
    
    // Statistics
    let totalAttempts: Int
    let accuracy: Int
    let dayStreak: Int
    let missedAnswers: Int
    
    // Accuracy data for chart
    let accuracyData: [Int]
    let days: [String]
    
    // Topics to review
    let topicsToReview: [Topic] = [
        Topic(name: "Closures", percentage: 28, status: "Critical", statusColor: .red),
        Topic(name: "Control flow", percentage: 52, status: "Review", statusColor: .orange),
        Topic(name: "Optionals", percentage: 61, status: "Needs work", statusColor: .purpleAccent)
    ]
    
    var body: some View {
        ZStack {
            Color.appBackground.ignoresSafeArea()
            
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    // Header Profile Card
                    ProfileHeaderCard(
                        name: name,
                        surname: surname,
                        location: location,
                        selectedLanguage: selectedLanguage,
                        track: track
                    )
                    
                    // Statistics Section
                    VStack(alignment: .leading, spacing: 12) {
                        Text("STATISTICS")
                            .font(.caption)
                            .foregroundColor(.secondaryText)
                        
                        // 2x2 Grid of stats
                        VStack(spacing: 12) {
                            HStack(spacing: 12) {
                                StatisticCard(
                                    icon: "📋",
                                    value: "\(totalAttempts)",
                                    title: "Total attempts",
                                    subtitle: "Total quiz sessions"
                                )
                                
                                StatisticCard(
                                    icon: "✅",
                                    value: "\(accuracy)%",
                                    title: "Accuracy",
                                    subtitle: "Overall accuracy"
                                )
                            }
                            
                            HStack(spacing: 12) {
                                StatisticCard(
                                    icon: "🔥",
                                    value: "\(dayStreak)",
                                    title: "Day streak",
                                    subtitle: "Current streak"
                                )
                                
                                StatisticCard(
                                    icon: "❌",
                                    value: "\(missedAnswers)",
                                    title: "Missed answers",
                                    subtitle: "Incorrect answers"
                                )
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                    
                    // Accuracy Per Day Section
                    VStack(alignment: .leading, spacing: 12) {
                        Text("ACCURACY PER DAY")
                            .font(.caption)
                            .foregroundColor(.secondaryText)
                        
                        if accuracyData.isEmpty || days.isEmpty {
                            EmptyAccuracyChartCard()
                        } else {
                            AccuracyChartCard(
                                data: accuracyData,
                                days: days,
                                averageAccuracy: accuracy
                            )
                        }
                    }
                    .padding(.horizontal, 16)
                    
                    // Topics to Review Section
                    VStack(alignment: .leading, spacing: 12) {
                        Text("TOPICS TO REVIEW")
                            .font(.caption)
                            .foregroundColor(.secondaryText)
                        
                        VStack(spacing: 10) {
                            ForEach(topicsToReview, id: \.name) { topic in
                                TopicReviewCard(topic: topic)
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 20)
                }
                .padding(.top, 16)
            }
        }
        .navigationTitle("Profile")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            print("ProfileView dayStreak =", dayStreak)
        }
    }
}

// MARK: - Profile Header Card
struct ProfileHeaderCard: View {
    let name: String
    let surname: String
    let location: String
    let selectedLanguage: String
    let track: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(alignment: .top, spacing: 12) {
                // Avatar Circle
                Text(String(name.prefix(1)) + String(surname.prefix(1)))
                    .font(.system(size: 24, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(width: 56, height: 56)
                    .background(Color.purpleAccent)
                    .clipShape(Circle())
                
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        VStack(alignment: .leading, spacing: 2) {
                            Text("\(name) \(surname)")
                                .font(.headline)
                                .foregroundColor(.primaryText)
                            
                            Text("iOS developer • \(location)")
                                .font(.caption)
                                .foregroundColor(.secondaryText)
                        }
                        
                        Spacer()
                        
                        Button(action: {}) {
                            Image(systemName: "pencil")
                                .foregroundColor(.purpleAccent)
                        }
                    }
                }
            }
            
            // Language and Track
            HStack(spacing: 8) {
                Image(systemName: "swift")
                    .font(.caption)
                    .foregroundColor(.purpleAccent)
                
                Text(selectedLanguage)
                    .font(.subheadline)
                    .foregroundColor(.secondaryText)
                
                Spacer()
                
                Text(track)
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(Color.purpleAccent)
                    .cornerRadius(6)
            }
        }
        .padding(16)
        .background(Color.cardBg)
        .cornerRadius(16)
        .padding(.horizontal, 16)
    }
}

// MARK: - Statistic Card
struct StatisticCard: View {
    let icon: String
    let value: String
    let title: String
    let subtitle: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(icon)
                .font(.system(size: 20))
            
            Text(value)
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(.primaryText)
            
            Text(title)
                .font(.caption)
                .foregroundColor(.secondaryText)
            
            Text(subtitle)
                .font(.caption2)
                .foregroundColor(.tertiaryText)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(12)
        .background(Color.cardBg)
        .cornerRadius(12)
    }
}

// MARK: - Empty Accuracy Chart Card
struct EmptyAccuracyChartCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 10) {
                Image(systemName: "chart.bar.xaxis")
                    .foregroundColor(.purpleAccent)
                Text("No daily accuracy data yet")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.primaryText)
            }

            Text("Complete quizzes on different days to build your accuracy chart.")
                .font(.caption)
                .foregroundColor(.secondaryText)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .background(Color.cardBg)
        .cornerRadius(12)
    }
}

// MARK: - Accuracy Chart Card
struct AccuracyChartCard: View {
    let data: [Int]
    let days: [String]
    let averageAccuracy: Int
    
    var maxValue: Int { 100 }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Last 7 days")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.primaryText)
                
                Spacer()
                
                Text("avg \(averageAccuracy)%")
                    .font(.caption)
                    .foregroundColor(.secondaryText)
            }
            
            // Chart bars
            HStack(alignment: .bottom, spacing: 8) {
                ForEach(0..<min(data.count, days.count), id: \.self) { index in
                    VStack(alignment: .center, spacing: 6) {
                        // Bar
                        VStack {
                            Spacer()
                            
                            RoundedRectangle(cornerRadius: 4)
                                .fill(Color.purpleAccent)
                                .frame(height: CGFloat(data[index]) / CGFloat(maxValue) * 120)
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 120)
                        .background(
                            RoundedRectangle(cornerRadius: 4)
                                .fill(Color.cardBg)
                        )
                        
                        // Day label
                        Text(days[index])
                            .font(.caption2)
                            .foregroundColor(.secondaryText)
                    }
                }
            }
            .frame(height: 180)
        }
        .padding(16)
        .background(Color.cardBg)
        .cornerRadius(12)
    }
}

// MARK: - Topic Model
struct Topic {
    let name: String
    let percentage: Int
    let status: String
    let statusColor: Color
}

// MARK: - Topic Review Card
struct TopicReviewCard: View {
    let topic: Topic
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(topic.name)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(.primaryText)
                    
                    // Progress bar
                    GeometryReader { geometry in
                        ZStack(alignment: .leading) {
                            RoundedRectangle(cornerRadius: 4)
                                .fill(Color.cardBg)
                            
                            RoundedRectangle(cornerRadius: 4)
                                .fill(topic.statusColor)
                                .frame(width: geometry.size.width * CGFloat(topic.percentage) / 100)
                        }
                    }
                    .frame(height: 4)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    Text("\(topic.percentage)%")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(.primaryText)
                    
                    Text(topic.status)
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundColor(topic.statusColor)
                }
            }
        }
        .padding(12)
        .background(Color.cardBg)
        .cornerRadius(12)
    }
}

#Preview {
    NavigationStack {
        ProfileView(
            name: "Aisha",
            surname: "Kenzhe",
            selectedLanguage: "Swift",
            totalAttempts: 148,
            accuracy: 74,
            dayStreak: 7,
            missedAnswers: 38,
            accuracyData: [],
            days: []
        )
    }
}
