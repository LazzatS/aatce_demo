//
//  QuizModels.swift
//  DemoApp
//

import Foundation

struct QuizQuestion: Codable, Identifiable {
    let id: UUID = UUID()
    let title: String
    let codeBlock: String
    let difficulty: String
    let tag: String
    let options: [QuizOption]
    
    enum CodingKeys: String, CodingKey {
        case title
        case codeBlock
        case difficulty
        case tag
        case options
    }
    
    init(
        title: String,
        codeBlock: String,
        difficulty: String = "Medium",
        tag: String = "Swift",
        options: [QuizOption]
    ) {
        self.title = title
        self.codeBlock = codeBlock
        self.difficulty = difficulty
        self.tag = tag
        self.options = options
    }
}

struct QuizOption: Codable {
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
