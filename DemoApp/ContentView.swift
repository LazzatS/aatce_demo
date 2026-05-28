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
    @AppStorage("stats.attemptsToday") private var attemptsToday = 0
    @AppStorage("stats.lastAttemptDate") private var lastAttemptDate = ""
    @AppStorage("stats.totalCorrectAnswers") private var totalCorrectAnswers = 0
    @AppStorage("stats.totalAnsweredQuestions") private var totalAnsweredQuestions = 0
    @State private var showRoleSelectionSheet = false
    @State private var showProfileScreen = false
    
    private var appearanceMode = UserDefaults.standard.string(forKey: "appearanceMode")
    
    
    // MARK: -
    
    @State private var questions: [QuizQuestion] = []
    
    var currentQuestion: QuizQuestion? {
        guard currentQuestionIndex < questions.count else { return nil }
        return questions[currentQuestionIndex]
    }
    
    func loadNextQuestion() {
        currentQuestionIndex += 1
        selectedAnswer = nil
        showResult = false
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
        guard lastAttemptDate == currentDayKey() else { return 0 }
        return attemptsToday
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
                        total: questions.count
                    )
                    if let question = currentQuestion {
                        QuestionCardView(question: question)
                        AnswerSectionView(
                            answeredCards: $answeredCards,
                            correctCount: $correctCount,
                            currentQuestion: question,
                            selectedAnswer: $selectedAnswer,
                            showResult: $showResult,
                            onSwapCard: {
                                // Store result before loading next
                                if let selected = selectedAnswer, let question = currentQuestion {
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
                    testAttempts: testAttempts,
                    successPercent: successPercent
                )
            }
            .overlay(alignment: .bottom) {
                if answeredCards > 0 && currentQuestionIndex >= questions.count {
                    VStack(spacing: 0) {
                        Divider()
                            .background(Color.gray.opacity(0.2))
                        
                        NavigationLink(destination: StudyPlanView(quizResults: quizResults, correctCount: correctCount, totalQuestions: questions.count, onUserRegistered: { name, surname in
                            registeredName = name
                            registeredSurname = surname
                        })) {
                            Text("Submit Answers")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: 48)
                                .background(Color.purpleAccent)
                                .cornerRadius(12)
                        }
                        .padding(16)
                    }
                    .background(Color.appBackground)
                }
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
}

#Preview {
    ContentView()
}
