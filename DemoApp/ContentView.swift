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
    
    private let questions = [
        QuizQuestion(
            title: "What does this closure output? Fill in the blank:",
            codeBlock: "let arr = [1, 2, 3, 4, 5]\nlet result = arr.filter {\n    $0 % 2 == 0\n}\nprint(result)",
            difficulty: "Medium",
            tag: "Swift",
            options: [
                QuizOption(letter: "A", text: "[1, 2, 3, 4, 5]", isCorrect: false),
                QuizOption(letter: "B", text: "[2, 4]", isCorrect: true),
                QuizOption(letter: "C", text: "[1, 3, 5]", isCorrect: false),
                QuizOption(letter: "D", text: "[2, 4, 6]", isCorrect: false)
            ]
        ),
        QuizQuestion(
            title: "What is the output of this optional binding?",
            codeBlock: "let value: Int? = 42\nif let val = value {\n    print(val)\n}",
            difficulty: "Easy",
            tag: "Swift",
            options: [
                QuizOption(letter: "A", text: "nil", isCorrect: false),
                QuizOption(letter: "B", text: "42", isCorrect: true),
                QuizOption(letter: "C", text: "Optional(42)", isCorrect: false),
                QuizOption(letter: "D", text: "Error", isCorrect: false)
            ]
        ),
        QuizQuestion(
            title: "What does map do in this context?",
            codeBlock: "let numbers = [1, 2, 3]\nlet doubled = numbers\n    .map { $0 * 2 }",
            difficulty: "Medium",
            tag: "Swift",
            options: [
                QuizOption(letter: "A", text: "[2, 4, 6]", isCorrect: true),
                QuizOption(letter: "B", text: "[1, 2, 3]", isCorrect: false),
                QuizOption(letter: "C", text: "[2, 4, 6, 8]", isCorrect: false),
                QuizOption(letter: "D", text: "[1, 4, 9]", isCorrect: false)
            ]
        )
    ]
    
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
                    QuestionProgressView(current: answeredCards + 1, total: questions.count)
                    if let question = currentQuestion {
                        QuestionCardView(question: question)
                        AnswerSectionView(
                            answeredCards: $answeredCards,
                            correctCount: $correctCount,
                            currentQuestion: .constant(currentQuestion),
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
