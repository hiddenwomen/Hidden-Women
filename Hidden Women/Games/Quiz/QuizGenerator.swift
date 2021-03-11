//
//  QuizGenerator.swift
//  Hidden Women
//
//  Created by Claudia Marzal on 2021-03-11.
//

import Foundation

struct QuizAnswers {
    let answers: [String]
    let correct: Int
}

// Picks one correctAnswer and (count - 1) incorrectAnswers
func answersSelector(correctAnswers: [String], manyAnswers: [String], count: Int) -> QuizAnswers {
    let incorrect: Set<String> = Set(manyAnswers).subtracting(correctAnswers)
    let shuffledIncorrect: [String] = Array(incorrect).shuffled()

    var result = [correctAnswers.randomElement() ?? "Aaaah!"]
    for i in 0..<min(count-1, shuffledIncorrect.count) {
        result.append(shuffledIncorrect[i])
    }

    let newCorrectPosition = (0..<result.count).randomElement()!
    result.swapAt(0, newCorrectPosition)

    return QuizAnswers(answers: result, correct: newCorrectPosition)
}

func birthYearQuizGenerator(woman: Woman, women: [Woman]) -> Quiz {
    let candidates: [String] = [woman.birthYear]
    let all: [String] = women.map( { woman in woman.birthYear } )
    let quizAnswers = answersSelector(correctAnswers: candidates, manyAnswers: all, count: 4)

    return Quiz(
        picture: woman.pictures.randomElement() ?? "",
        question: "When was \(woman.name) born?",
        answers: quizAnswers.answers,
        correctAnswer: quizAnswers.correct
    )
}

func fieldQuizGenerator(woman: Woman, women: [Woman]) -> Quiz {
    let candidates: [String] = woman.fields.localized
    let all: [String] = women.flatMap( { woman in woman.fields.localized } )
    let quizAnswers = answersSelector(correctAnswers: candidates, manyAnswers: all, count: 4)

    return Quiz(
        picture: woman.pictures.randomElement() ?? "",
        question: "\(woman.name) was a(n)...",
        answers: quizAnswers.answers,
        correctAnswer: quizAnswers.correct
    )
}

func fullQuizGenerator(women: [Woman], count: Int) -> [Quiz] {
    var result: [Quiz] = []
    let selectedWomen = women.shuffled().prefix(count)
    
    for woman in selectedWomen {
        var quiz: Quiz
        let quizType = (0..<2).randomElement()
        if quizType == 0 {
            quiz = fieldQuizGenerator(woman: woman, women: women)
        } else {
            quiz = birthYearQuizGenerator(woman: woman, women: women)
        }
        result.append(quiz)
    }
    return result
}
