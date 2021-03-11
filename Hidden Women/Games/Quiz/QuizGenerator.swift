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
func answersSelector(correctAnswers: [String], incorrectAnswers: [String], count: Int) -> QuizAnswers {
    let incorrect = Set(incorrectAnswers).subtracting(correctAnswers)
    let shuffledIncorrect = Array(incorrect).shuffled()

    var result = [correctAnswers.randomElement()!]
    for i in 0..<min(count-1, shuffledIncorrect.count) {
        result.append(shuffledIncorrect[i])
    }

    let newCorrectPosition = (0..<result.count).randomElement()!
    result.swapAt(0, newCorrectPosition)

    return QuizAnswers(answers: result, correct: newCorrectPosition)
}

func birthYearQuizGenerator(woman: Woman, women: [Woman]) -> Quiz {
    let candidates = [woman.birthYear]
    let incorrect = women.map({woman in woman.birthYear})
    let quizAnswers = answersSelector(correctAnswers: candidates, incorrectAnswers: incorrect, count: 4)

    return Quiz(
        picture: woman.pictures.randomElement() ?? "",
        question: "When was \(woman.name) born?",
        answers: quizAnswers.answers,
        correctAnswer: quizAnswers.correct
    )
}

func fieldQuizGenerator(woman: Woman, women: [Woman]) -> Quiz {
    let candidates = woman.fields.localized
    let incorrect = women.flatMap({woman in woman.fields.localized})
    let quizAnswers = answersSelector(correctAnswers: candidates, incorrectAnswers: incorrect, count: 4)

    return Quiz(
        picture: woman.pictures.randomElement() ?? "",
        question: "\(woman.name) was a(n)...",
        answers: quizAnswers.answers,
        correctAnswer: quizAnswers.correct
    )
}
