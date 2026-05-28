//
//
// User.swift
// DemoApp
//
// Created by sturdytea on 28.05.2026.
//
// GitHub: https://github.com/sturdytea
//
    

import SwiftData
import Foundation

enum Technology {
    case swift, python, java, web
}

protocol User {
    var name: String { get }
    var surname: String { get }
}

class Student {
    var name: String
    var surname: String
    var choosenTechnology: Technology
    
    init(name: String, surname: String, technology choosenTechnology: Technology) {
        self.name = name
        self.surname = surname
        self.choosenTechnology = choosenTechnology
    }
}

//class Teacher: User {
//    var name: String
//    var surname: String
//    
//    init(name: String, surname: String, technology choosenTechnology: Technology) {
//        self.name = name
//        self.surname = surname
//    }
//
//}
