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

func birthYearQuizGenerator(women: [Woman]) -> Quiz {
    let selected: [Woman] = women.filter{ $0.birthYear != "" }
    let woman = selected.randomElement()!
    let all = selected.map( { $0.birthYear } )
    let candidate: [String] = [woman.birthYear]
    let quizAnswers = answersSelector(correctAnswers: candidate, manyAnswers: all, count: 4)

    return Quiz(
        picture: woman.pictures.randomElement() ?? "",
        question: String.localizedStringWithFormat(NSLocalizedString("When was %@ born?", comment: ""), woman.name),
        answers: quizAnswers.answers,
        correctAnswer: quizAnswers.correct
    )
}

func deathYearQuizGenerator(women: [Woman]) -> Quiz {
    let selected: [Woman] = women.filter{ $0.deathYear != "" }
    let woman = selected.randomElement()!
    let all = selected.map( { $0.deathYear } )
    let candidate: [String] = [woman.deathYear]
    let quizAnswers = answersSelector(correctAnswers: candidate, manyAnswers: all, count: 4)

    return Quiz(
        picture: woman.pictures.randomElement() ?? "",
        question: String.localizedStringWithFormat(NSLocalizedString("When did %@ pass away?", comment: ""), woman.name),
        answers: quizAnswers.answers,
        correctAnswer: quizAnswers.correct
    )
}


func fieldQuizGenerator(women: [Woman]) -> Quiz {
    let selected: [Woman] = women.filter{ $0.fields.localized.count > 0 }
    let woman = selected.randomElement()!
    let all = selected.flatMap( { $0.fields.localized } )
    let candidates: [String] = woman.fields.localized
    let quizAnswers = answersSelector(correctAnswers: candidates, manyAnswers: all, count: 4)
    
    return Quiz(
        picture: woman.pictures.randomElement() ?? "",
        question: String.localizedStringWithFormat(NSLocalizedString("%@ was a...", comment: ""), woman.name),
        answers: quizAnswers.answers,
        correctAnswer: quizAnswers.correct
    )
}

func awardsQuizGenerator(women: [Woman]) -> Quiz {
    let selected: [Woman] = women.filter{ $0.awards.localized.count > 0 }
    let woman = selected.randomElement()!
    let all = selected.flatMap( { $0.awards.localized } )
    let candidates: [String] = woman.awards.localized
    let quizAnswers = answersSelector(correctAnswers: candidates, manyAnswers: all, count: 4)
    
    return Quiz(
        picture: woman.pictures.randomElement() ?? "",
        question: String.localizedStringWithFormat(NSLocalizedString("%@ won the...", comment: ""), woman.name),
        answers: quizAnswers.answers,
        correctAnswer: quizAnswers.correct
    )
}

func achievementsQuizGenerator(women: [Woman]) -> Quiz {
    let selected: [Woman] = women.filter{ $0.achievements.localized.count > 0 }
    let woman = selected.randomElement()!
    let all = selected.flatMap( { $0.achievements.localized } )
    let candidates: [String] = woman.achievements.localized
    let quizAnswers = answersSelector(correctAnswers: candidates, manyAnswers: all, count: 4)
    
    return Quiz(
        picture: woman.pictures.randomElement() ?? "",
        question: String.localizedStringWithFormat(NSLocalizedString("One of %@'s achievements is...", comment: ""), woman.name),
        answers: quizAnswers.answers,
        correctAnswer: quizAnswers.correct
    )
}

func fullQuizGenerator(women: [Woman], numberOfQuestions: Int) -> [Quiz] {
    var result: Set<Quiz> = Set()
    
    while result.count < numberOfQuestions {
        var quiz: Quiz
        let quizType = (0..<5).randomElement()
        if quizType == 0 {
            quiz = fieldQuizGenerator(women: women)
        } else if quizType == 1 {
            quiz = birthYearQuizGenerator(women: women)
        } else if quizType == 2 {
            quiz = deathYearQuizGenerator(women: women)
        } else if quizType == 3 {
            quiz = awardsQuizGenerator(women: women)
        } else {
            quiz = achievementsQuizGenerator(women: women)
        }
        result.insert(quiz)
    }
    return Array(result)
}
