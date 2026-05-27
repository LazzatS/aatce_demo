//
//  QuizModels.swift
//  DemoApp
//

import Foundation

struct QuizQuestion {
    let id: UUID
    let title: String
    let codeBlock: String
    let difficulty: String
    let tag: String
    let options: [QuizOption]
    
    init(
        title: String,
        codeBlock: String,
        difficulty: String = "Medium",
        tag: String = "Swift",
        options: [QuizOption]
    ) {
        self.id = UUID()
        self.title = title
        self.codeBlock = codeBlock
        self.difficulty = difficulty
        self.tag = tag
        self.options = options
    }
}

struct QuizOption {
    let letter: String
    let text: String
    let isCorrect: Bool
}

struct QuizResult {
    let questionId: UUID
    let selectedOption: String
    let isCorrect: Bool
    let timestamp: Date
}
