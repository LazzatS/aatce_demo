//
//  ContentView.swift
//  DemoApp
//
//  Created by Lazzat Seiilova on 27.05.2026.
//

import SwiftUI

private enum AppRole {
    case student
    case teacher
}

struct ContentView: View {
   
    // MARK: -
    
    @State private var answeredCards = 0
    @State private var correctCount = 0
    @State private var currentQuestionIndex = 0
    @State private var selectedAnswer: String?
    @State private var showResult = false
    @State private var quizResults: [QuizResult] = []
    @AppStorage("user.name") private var registeredName = ""
    @AppStorage("user.surname") private var registeredSurname = ""
    @AppStorage("user.role") private var storedRole = ""
    @AppStorage("user.selectedLanguage") private var selectedLanguage = "Swift"
    @AppStorage("stats.attempts") private var testAttempts = 0
    @AppStorage("stats.streakDays") private var storedStreakDays = 0
    @AppStorage("stats.lastAttemptDate") private var lastAttemptDate = ""
    @AppStorage("stats.totalCorrectAnswers") private var totalCorrectAnswers = 0
    @AppStorage("stats.totalAnsweredQuestions") private var totalAnsweredQuestions = 0
    @AppStorage("dailyAccuracyData") private var dailyAccuracyDataString = "[]"
    @AppStorage("dailyAccuracyDays") private var dailyAccuracyDaysString = "[]"
    @State private var showRoleSelectionSheet = false
    @State private var showProfileScreen = false
    @State private var showStudyPlanView = false
    
    private var appearanceMode = UserDefaults.standard.string(forKey: "appearanceMode")
    
    
    // MARK: -
    
    @State private var questions: [QuizQuestion] = []
    
    private var dailyAccuracyData: [Int] {
        (try? JSONDecoder().decode([Int].self, from: Data(dailyAccuracyDataString.utf8))) ?? []
    }

    private var dailyAccuracyDays: [String] {
        (try? JSONDecoder().decode([String].self, from: Data(dailyAccuracyDaysString.utf8))) ?? []
    }
    
    private func saveDailyAccuracy(correct: Int, total: Int) {
        guard total > 0 else { return }

        let accuracy = Int(Double(correct) / Double(total) * 100)
        let day = DateFormatter.shortWeekday.string(from: Date())

        var data = dailyAccuracyData
        var days = dailyAccuracyDays

        if days.last == day {
            data[data.count - 1] = accuracy
        } else {
            days.append(day)
            data.append(accuracy)
        }

        data = Array(data.suffix(7))
        days = Array(days.suffix(7))

        dailyAccuracyDataString = String(data: try! JSONEncoder().encode(data), encoding: .utf8) ?? "[]"
        dailyAccuracyDaysString = String(data: try! JSONEncoder().encode(days), encoding: .utf8) ?? "[]"
    }
    
    private func updateStreakIfNeeded() {
        let today = currentDayKey()

        print("storedStreakDays =", storedStreakDays)
        print("lastAttemptDate =", lastAttemptDate)
        print("today =", today)

        // Recover from broken state:
        if storedStreakDays == 0 {
            storedStreakDays = 1
            lastAttemptDate = today
            print("Initialized streak to 1")
            return
        }

        guard lastAttemptDate != today else { return }

        if lastAttemptDate == yesterdayDayKey() {
            storedStreakDays += 1
        } else {
            storedStreakDays = 1
        }

        lastAttemptDate = today
        print("Streak updated:", storedStreakDays)
    }
    
    var currentQuestion: QuizQuestion? {
        guard currentQuestionIndex < questions.count else { return nil }
        return questions[currentQuestionIndex]
    }
    
    func loadNextQuestion() {
        currentQuestionIndex += 1
        selectedAnswer = nil
        showResult = false
        navigateToStudyPlanIfNeeded()
    }

    private func navigateToStudyPlanIfNeeded() {
        guard !questions.isEmpty,
              currentQuestionIndex >= questions.count,
              answeredCards >= questions.count else { return }

        showStudyPlanView = true
    }
    
    private var isUserRegistered: Bool {
        !registeredName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !registeredSurname.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    private var successPercent: Int {
        guard totalAnsweredQuestions > 0 else { return 0 }
        let ratio = Double(totalCorrectAnswers) / Double(totalAnsweredQuestions)
        return Int((ratio * 100).rounded())
    }
    
    private var streakDays: Int {
        storedStreakDays
    }
    
    private var xpTotal: Int {
        totalCorrectAnswers * 10
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    if isUserRegistered {
                        HeaderView(
                            firstName: registeredName,
                            surname: registeredSurname,
                            onProfileTap: { showProfileScreen = true }
                        )
                        StatsRowView(streakDays: streakDays, xp: xpTotal, rankText: "-")
                    }
                    QuestionProgressView(
                        current: questions.isEmpty ? 0 : min(currentQuestionIndex + 1, questions.count),
                        total: questions.count,
                        completed: min(currentQuestionIndex, questions.count)
                    )
                    if let question = currentQuestion {
                        QuestionCardView(question: question, onSkip: {
                            if let question = currentQuestion {
                                updateStreakIfNeeded()
                                quizResults.append(QuizResult(
                                    questionId: question.id,
                                    selectedOption: nil,
                                    isCorrect: false,
                                    timestamp: Date()
                                ))
                                answeredCards += 1
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                loadNextQuestion()
                            }
                        })
                        AnswerSectionView(
                            answeredCards: $answeredCards,
                            correctCount: $correctCount,
                            currentQuestion: question,
                            selectedAnswer: $selectedAnswer,
                            showResult: $showResult,
                            onSwapCard: {
                                // Store result before loading next
                                if let selected = selectedAnswer, let question = currentQuestion {
                                    updateStreakIfNeeded()
                                    let option = question.options.first { $0.letter == selected }
                                    quizResults.append(QuizResult(
                                        questionId: question.id,
                                        selectedOption: selected,
                                        isCorrect: option?.isCorrect ?? false,
                                        timestamp: Date()
                                    ))
                                }
                                
                                // Load next question
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                    loadNextQuestion()
                                }
                            }
                        )
                    } else {
                        Spacer()
                        ContentUnavailableView("No other questions left", systemImage: "flask")
                            .padding(.vertical, 50)
                   
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 16)
                .padding(.bottom, 40)
            }
            .background(Color.appBackground.ignoresSafeArea())
            .sheet(isPresented: $showRoleSelectionSheet) {
                RoleSelectionView(onSelectStudent: {
                    storedRole = "student"
                    showRoleSelectionSheet = false
                })
                .presentationDetents([.fraction(0.42)])
                .presentationDragIndicator(.hidden)
                .presentationBackgroundInteraction(.disabled)
                .interactiveDismissDisabled()
            }
            .overlay {
                if showRoleSelectionSheet {
                    Color.black.opacity(0.30)
                        .ignoresSafeArea()
                        .allowsHitTesting(false)
                }
            }
            .onAppear {
                if storedRole.isEmpty {
                    showRoleSelectionSheet = true
                }
            }
            .navigationDestination(isPresented: $showProfileScreen) {
                ProfileView(
                    name: registeredName,
                    surname: registeredSurname,
                    selectedLanguage: selectedLanguage,
                    totalAttempts: testAttempts,
                    accuracy: successPercent,
                    dayStreak: streakDays,
                    missedAnswers: max(totalAnsweredQuestions - totalCorrectAnswers, 0),
                    accuracyData: dailyAccuracyData,
                    days: dailyAccuracyDays
                )
            }
            .navigationDestination(isPresented: $showStudyPlanView) {
                StudyPlanView(
                    streakDays: streakDays,
                    quizResults: quizResults,
                    correctCount: correctCount,
                    totalQuestions: questions.count,
                    onUserRegistered: { name, surname in
                        registeredName = name
                        registeredSurname = surname
                    }
                )
            }
            .navigationTitle("Home")
            .navigationBarHidden(true)
        }
        .task {
            await loadQuestions()
        }
    }
    
    @MainActor
    private func loadQuestions() async {
        guard let url = URL(string: "https://dummyjson.com/c/dfa8-ce79-4ada-8bea") else {
            questions = []
            return
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            guard let httpResponse = response as? HTTPURLResponse,
                  200...299 ~= httpResponse.statusCode else {
                questions = []
                return
            }
            
            let decodedQuestions = try JSONDecoder().decode([QuizQuestion].self, from: data)
            questions = decodedQuestions
        } catch {
            questions = []
        }
    }
    
    private func currentDayKey() -> String {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: Date())
    }
    
    private func yesterdayDayKey() -> String {
        let calendar = Calendar(identifier: .gregorian)
        let yesterday = calendar.date(byAdding: .day, value: -1, to: Date()) ?? Date()
        let formatter = DateFormatter()
        formatter.calendar = calendar
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: yesterday)
    }
}

private extension DateFormatter {
    static let shortWeekday: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "E"
        return formatter
    }()
}

#Preview {
    ContentView()
}
