//
//  StudyPlanView.swift
//  DemoApp
//
//  Created by Lazzat Seiilova on 27.05.2026.
//

import SwiftUI

struct StudyPlanView: View {
    @Environment(\.dismiss) var dismiss
    @AppStorage("user.name") private var registeredName = ""
    @AppStorage("user.surname") private var registeredSurname = ""
    @AppStorage("user.selectedLanguage") private var selectedLanguage = "Swift"
    @AppStorage("stats.attempts") private var testAttempts = 0
    @AppStorage("stats.attemptsToday") private var attemptsToday = 0
    @AppStorage("stats.lastAttemptDate") private var lastAttemptDate = ""
    @AppStorage("stats.totalCorrectAnswers") private var totalCorrectAnswers = 0
    @AppStorage("stats.totalAnsweredQuestions") private var totalAnsweredQuestions = 0
    @State private var selectedTopics: Set<String> = ["Variables & types", "Control flow", "Closures"]
    @State private var selectedGoal = 10
    @State private var showRegistrationSheet = false
    @State private var showProfileScreen = false
    @State private var hasRecordedAttempt = false
    
    let quizResults: [QuizResult]?
    let correctCount: Int
    let totalQuestions: Int
    let onUserRegistered: (String, String) -> Void
    
    let languages = ["Swift", "Python", "JS", "Kotlin", "More"]
    let topics = [
        ("Variables & types", "12 questions"),
        ("Control flow", "10 questions"),
        ("Closures", "14 questions"),
        ("Classes & structs", "18 questions"),
        ("Optionals", "9 questions"),
        ("Concurrency", "Unlock after basics")
    ]
    
    init(
        quizResults: [QuizResult]? = nil,
        correctCount: Int = 0,
        totalQuestions: Int = 0,
        onUserRegistered: @escaping (String, String) -> Void = { _, _ in }
    ) {
        self.quizResults = quizResults
        self.correctCount = correctCount
        self.totalQuestions = totalQuestions
        self.onUserRegistered = onUserRegistered
    }
    
    var body: some View {
        ZStack {
            Color.appBackground.ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header
                HStack {
                    Button(action: { dismiss() }) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.purpleAccent)
                            .font(.system(size: 16, weight: .semibold))
                    }
                    Spacer()
                    Text("Step 2 of 3")
                        .font(.caption)
                        .foregroundColor(.secondaryText)
                }
                .padding(20)
                
                // Progress bar
                HStack(spacing: 4) {
                    ForEach(0..<3, id: \.self) { i in
                        if i < 2 {
                            RoundedRectangle(cornerRadius: 2)
                                .fill(Color.purpleAccent)
                                .frame(height: 3)
                        } else {
                            RoundedRectangle(cornerRadius: 2)
                                .fill(Color.borderColor.opacity(0.5))
                                .frame(height: 3)
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 24)
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                        // Quiz Results Summary
                        if let _ = quizResults, totalQuestions > 0 {
                            VStack(alignment: .leading, spacing: 12) {
                                Text("QUIZ RESULTS")
                                    .font(.caption)
                                    .foregroundColor(.secondaryText)
                                
                                VStack(spacing: 12) {
                                    HStack {
                                        VStack(alignment: .leading, spacing: 4) {
                                            Text("Correct Answers")
                                                .font(.subheadline)
                                                .foregroundColor(.secondaryText)
                                            Text("\(correctCount) out of \(totalQuestions)")
                                                .font(.title2)
                                                .fontWeight(.bold)
                                                .foregroundColor(.correctGreen)
                                        }
                                        Spacer()
                                        VStack(alignment: .trailing, spacing: 4) {
                                            Text("Score")
                                                .font(.subheadline)
                                                .foregroundColor(.secondaryText)
                                            Text("\(Int(Double(correctCount) / Double(totalQuestions) * 100))%")
                                                .font(.title2)
                                                .fontWeight(.bold)
                                                .foregroundColor(.purpleAccent)
                                        }
                                    }
                                    .padding(16)
                                    .background(Color.cardBg)
                                    .cornerRadius(12)
                                    
                                    // Progress Bar
                                    VStack(spacing: 8) {
                                        GeometryReader { geometry in
                                            ZStack(alignment: .leading) {
                                                RoundedRectangle(cornerRadius: 4)
                                                    .fill(Color.gray.opacity(0.2))
                                                
                                                RoundedRectangle(cornerRadius: 4)
                                                    .fill(Color.correctGreen)
                                                    .frame(width: geometry.size.width * CGFloat(correctCount) / CGFloat(totalQuestions))
                                            }
                                        }
                                        .frame(height: 8)
                                        
                                        HStack {
                                            Text("Answered: \(totalQuestions)")
                                                .font(.caption)
                                                .foregroundColor(.secondaryText)
                                            Spacer()
                                            Text("Correct: \(correctCount)")
                                                .font(.caption)
                                                .foregroundColor(.correctGreen)
                                        }
                                    }
                                    .padding(16)
                                    .background(Color.cardBg)
                                    .cornerRadius(12)
                                }
                            }
                            .padding(.horizontal, 20)
                            .padding(.bottom, 12)
                        }
                        
                        if !isAuthorized {
                            // Title
                            VStack(alignment: .leading, spacing: 8) {
                                Text("COURSE SETUP")
                                    .font(.caption)
                                    .foregroundColor(.secondaryText)
                                Text("What will you ")
                                    .font(.system(size: 28, weight: .bold))
                                    .foregroundColor(.primaryText) +
                                Text("study?")
                                    .font(.system(size: 28, weight: .bold))
                                    .foregroundColor(.purpleAccent)
                                Text("Select your language and topics. The AI will build your personal quiz plan.")
                                    .font(.subheadline)
                                    .foregroundColor(.secondaryText)
                            }
                            .padding(.horizontal, 20)
                            
                            // Language Selection
                            VStack(alignment: .leading, spacing: 12) {
                                Text("LANGUAGE")
                                    .font(.caption)
                                    .foregroundColor(.secondaryText)
                                    .padding(.horizontal, 20)
                                HStack(spacing: 10) {
                                    ForEach(languages, id: \.self) { lang in
                                        Button(action: { selectedLanguage = lang }) {
                                            Text(lang)
                                                .font(.callout)
                                                .foregroundColor(selectedLanguage == lang ? .white : .primaryText)
                                                .frame(height: 44)
                                                .frame(maxWidth: .infinity)
                                                .background(selectedLanguage == lang ? Color.purpleAccent : Color.cardBg)
                                                .cornerRadius(12)
                                                .overlay(
                                                    RoundedRectangle(cornerRadius: 12)
                                                        .stroke(selectedLanguage == lang ? Color.purpleAccent : Color.clear, lineWidth: 1.5)
                                                )
                                        }
                                    }
                                }
                                .padding(.horizontal, 20)
                            }
                            
                            // Topics
                            VStack(alignment: .leading, spacing: 12) {
                                Text("TOPICS TO COVER")
                                    .font(.caption)
                                    .foregroundColor(.secondaryText)
                                    .padding(.horizontal, 20)
                                
                                VStack(spacing: 12) {
                                    ForEach(Array(topics.enumerated()), id: \.offset) { index, topic in
                                        let isSelected = selectedTopics.contains(topic.0)
                                        let isEnabled = index < 5
                                        
                                        Button(action: {
                                            if isEnabled {
                                                if isSelected {
                                                    selectedTopics.remove(topic.0)
                                                } else {
                                                    selectedTopics.insert(topic.0)
                                                }
                                            }
                                        }) {
                                            HStack(spacing: 12) {
                                                VStack(alignment: .leading, spacing: 4) {
                                                    Text(topic.0)
                                                        .font(.headline)
                                                        .foregroundColor(.primaryText)
                                                    Text(topic.1)
                                                        .font(.caption)
                                                        .foregroundColor(.secondaryText)
                                                }
                                                Spacer()
                                                
                                                if isSelected {
                                                    Image(systemName: "checkmark.circle.fill")
                                                        .foregroundColor(.purpleAccent)
                                                        .font(.system(size: 24))
                                                }
                                            }
                                            .padding(16)
                                            .background(isSelected ? Color.purpleAccent.opacity(0.15) : (isEnabled ? Color.cardBg : Color.borderColor.opacity(0.3)))
                                            .cornerRadius(12)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 12)
                                                    .stroke(isSelected ? Color.purpleAccent : Color.clear, lineWidth: 1.5)
                                            )
                                            .opacity(isEnabled ? 1 : 0.6)
                                        }
                                        .disabled(!isEnabled)
                                    }
                                }
                                .padding(.horizontal, 20)
                            }
                            
                            // Daily Goal
                            VStack(alignment: .leading, spacing: 12) {
                                Text("DAILY GOAL")
                                    .font(.caption)
                                    .foregroundColor(.secondaryText)
                                    .padding(.horizontal, 20)
                                
                                HStack(spacing: 12) {
                                    ForEach([5, 10, 20], id: \.self) { goal in
                                        Button(action: { selectedGoal = goal }) {
                                            VStack(spacing: 8) {
                                                Image(systemName: goal == 5 ? "bolt.fill" : goal == 10 ? "flame.fill" : "rocket.fill")
                                                    .font(.system(size: 20))
                                                    .foregroundColor(selectedGoal == goal ? .purpleAccent : .secondaryText)
                                                Text("\(goal)")
                                                    .font(.headline)
                                                    .foregroundColor(.primaryText)
                                                Text("questions")
                                                    .font(.caption)
                                                    .foregroundColor(.secondaryText)
                                            }
                                            .frame(maxWidth: .infinity)
                                            .frame(height: 100)
                                            .background(selectedGoal == goal ? Color.purpleAccent.opacity(0.2) : Color.cardBg)
                                            .cornerRadius(12)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 12)
                                                    .stroke(selectedGoal == goal ? Color.purpleAccent : Color.clear, lineWidth: 1.5)
                                            )
                                        }
                                    }
                                }
                                .padding(.horizontal, 20)
                            }
                            
                            // AI Info Box
                            VStack(alignment: .leading, spacing: 12) {
                                HStack(alignment: .top, spacing: 12) {
                                    Image(systemName: "sparkles")
                                        .foregroundColor(.purpleAccent)
                                        .font(.system(size: 18))
                                    
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text("AI will personalise your path. ")
                                            .font(.system(.subheadline, design: .default))
                                            .foregroundColor(.primaryText) +
                                        Text("Based on your selections, it will generate fresh code snippets, detect weak spots, and focus questions where you need practice most.")
                                            .font(.system(.subheadline, design: .default))
                                            .foregroundColor(.secondaryText)
                                    }
                                }
                                .padding(16)
                                .background(Color.purpleAccent.opacity(0.1))
                                .cornerRadius(12)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color.purpleAccent.opacity(0.3), lineWidth: 1)
                                )
                            }
                            .padding(.horizontal, 20)
                        }
                        
                        // Buttons
                        VStack(spacing: 12) {
                            if isAuthorized {
                                Button(action: { showProfileScreen = true }) {
                                    HStack(spacing: 8) {
                                        Image(systemName: "arrow.right")
                                        Text("Continue")
                                    }
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 50)
                                    .background(Color.purpleAccent)
                                    .cornerRadius(12)
                                }
                            } else {
                                Button(action: {
                                    showRegistrationSheet = true
                                }) {
                                    HStack(spacing: 8) {
                                        Image(systemName: "play.fill")
                                        Text("Build my study plan")
                                    }
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 50)
                                    .background(Color.purpleAccent)
                                    .cornerRadius(12)
                                }

                                Button(action: { dismiss() }) {
                                    Text("Skip setup — go straight in")
                                        .font(.headline)
                                        .foregroundColor(.primaryText)
                                        .frame(maxWidth: .infinity)
                                        .frame(height: 50)
                                        .background(Color.transparent)
                                        .cornerRadius(12)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 12)
                                                .stroke(Color.borderColor.opacity(0.5), lineWidth: 1)
                                        )
                                }
                            }
                        }
                        .padding(20)
                    }
                }
            }
        }
        .preferredColorScheme(nil)
        .onAppear {
            recordAttemptStatsIfNeeded()
        }
        .navigationDestination(isPresented: $showProfileScreen) {
            ProfileView(
                name: registeredName,
                surname: registeredSurname,
                selectedLanguage: selectedLanguage,
                testAttempts: testAttempts,
                successPercent: successPercent
            )
        }
        .sheet(isPresented: $showRegistrationSheet) {
            RegisterUserView(onSave: { name, surname in
                registeredName = name
                registeredSurname = surname
                onUserRegistered(name, surname)
                showRegistrationSheet = false
                showProfileScreen = true
            })
            .presentationDetents([.fraction(0.5)])
            .presentationDragIndicator(.hidden)
            .presentationBackgroundInteraction(.disabled)
        }
        .overlay {
            if showRegistrationSheet {
                Color.black.opacity(0.30)
                    .ignoresSafeArea()
                    .allowsHitTesting(false)
            }
        }
    }
    
    private var successPercent: Int {
        guard totalAnsweredQuestions > 0 else { return 0 }
        let ratio = Double(totalCorrectAnswers) / Double(totalAnsweredQuestions)
        return Int((ratio * 100).rounded())
    }
    
    private var isAuthorized: Bool {
        !registeredName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !registeredSurname.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    private func recordAttemptStatsIfNeeded() {
        guard !hasRecordedAttempt else { return }
        guard totalQuestions > 0 else { return }
        
        let today = currentDayKey()
        if lastAttemptDate != today {
            attemptsToday = 0
            lastAttemptDate = today
        }
        
        hasRecordedAttempt = true
        testAttempts += 1
        attemptsToday += 1
        totalCorrectAnswers += correctCount
        totalAnsweredQuestions += totalQuestions
    }
    
    private func currentDayKey() -> String {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: Date())
    }
}
