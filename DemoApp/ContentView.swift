//
//  ContentView.swift
//  DemoApp
//
//  Created by Lazzat Seiilova on 27.05.2026.
//

import SwiftUI

struct ContentView: View {
    @State private var answeredCards = 0
    @State private var correctCount = 0
    @State private var currentQuestionIndex = 0
    @State private var selectedAnswer: String?
    @State private var showResult = false
    @State private var quizResults: [QuizResult] = []
    
    private let questions = [
        QuizQuestion(
            title: "What does this closure output? Fill in the blank:",
            codeBlock: "let arr = [1, 2, 3, 4, 5]\nlet result = arr.filter { $0 % 2 == 0 }\nprint(result)",
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
            codeBlock: "let numbers = [1, 2, 3]\nlet doubled = numbers.map { $0 * 2 }",
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
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    HeaderView()
                    StatsRowView()
                    QuestionProgressView(current: answeredCards + 1, total: questions.count)
                    if let question = currentQuestion {
                        QuestionCardView(question: question)
                    }
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
                }
                .padding(.horizontal, 20)
                .padding(.top, 16)
                .padding(.bottom, 40)
            }
            .background(Color.appBackground.ignoresSafeArea())
            .preferredColorScheme(.dark)
            .overlay(alignment: .bottom) {
                if answeredCards > 0 && currentQuestionIndex >= questions.count {
                    VStack(spacing: 0) {
                        Divider()
                            .background(Color.gray.opacity(0.2))
                        
                        NavigationLink(destination: StudyPlanView(quizResults: quizResults, correctCount: correctCount, totalQuestions: questions.count)) {
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
}

#Preview {
    ContentView()
}
