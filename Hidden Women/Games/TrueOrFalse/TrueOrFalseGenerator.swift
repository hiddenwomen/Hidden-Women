//
//  TrueOrFalseGenerator.swift
//  Hidden Women
//
//  Created by Mireia Belinchón Castillo on 12/3/21.
//

import Foundation

func birthYearTrueOrFalseGenerator (women: [Woman]) -> TrueOrFalse {
    let selectedWomen = women.filter{$0.birthYear != ""}.shuffled()
    let questionWoman = selectedWomen[0]
    let otherWoman = selectedWomen[1]
    let answer = (0...1).randomElement() == 0 ? questionWoman.birthYear : otherWoman.birthYear
    
    return TrueOrFalse(
        picture: questionWoman.pictures.randomElement() ?? "",
        question: String.localizedStringWithFormat(
            NSLocalizedString("%@ was born in: ", comment: ""), questionWoman.name
        ),
        answer: answer,
        correct: questionWoman.birthYear == answer
    )
}

func deathYearTrueOrFalseGenerator (women: [Woman]) -> TrueOrFalse {
    let selectedWomen = women.filter{$0.deathYear != ""}.shuffled()
    let questionWoman = selectedWomen[0]
    let otherWoman = selectedWomen[1]
    let answer = (0...1).randomElement() == 0 ? questionWoman.deathYear : otherWoman.deathYear

    return TrueOrFalse(
        picture: questionWoman.pictures.randomElement() ?? "",
        question: String.localizedStringWithFormat(
            NSLocalizedString("%@ passed away in: ", comment: ""),
            questionWoman.name),
        answer: answer,
        correct: questionWoman.deathYear == otherWoman.deathYear
    )
}

func fieldsTrueOrFalseGenerator (women: [Woman]) -> TrueOrFalse {
    let selectedWomen = women.filter{$0.fields.localized.count > 0}.shuffled()
    let questionWoman = selectedWomen[0]
    let otherWoman = selectedWomen[1]
    let answer = ((0...1).randomElement() == 0 ? questionWoman : otherWoman).fields.localized.randomElement()!

    return TrueOrFalse(
        picture: questionWoman.pictures.randomElement() ?? "",
        question: String.localizedStringWithFormat(
            NSLocalizedString("%@ is a: ", comment: ""),
            questionWoman.name),
        answer: answer,
        correct: questionWoman.fields.localized.contains(answer)
    )
}

func achievementsTrueOrFalseGenerator (women: [Woman]) -> TrueOrFalse {
    let selectedWomen = women.filter{$0.achievements.localized.count > 0}.shuffled()
    let questionWoman = selectedWomen[0]
    let otherWoman = selectedWomen[1]
    let answer = ((0...1).randomElement() == 0 ? questionWoman : otherWoman).achievements.localized.randomElement()!

    return TrueOrFalse(
        picture: questionWoman.pictures.randomElement() ?? "",
        question: String.localizedStringWithFormat(
            NSLocalizedString("One of %@'s achievements is: ", comment: ""),
            questionWoman.name),
        answer: answer,
        correct: questionWoman.achievements.localized.contains(answer)
    )
}

func awardsTrueOrFalseGenerator (women: [Woman]) -> TrueOrFalse {
    let selectedWomen = women.filter{$0.awards.localized.count > 0}.shuffled()
    let questionWoman = selectedWomen[0]
    let otherWoman = selectedWomen[1]
    let answer = ((0...1).randomElement() == 0 ? questionWoman : otherWoman).awards.localized.randomElement()!

    return TrueOrFalse(
        picture: questionWoman.pictures.randomElement() ?? "",
        question: String.localizedStringWithFormat(
            NSLocalizedString("%@ was awarded with the: ", comment: ""),
            questionWoman.name),
        answer: answer,
        correct: questionWoman.awards.localized.contains(answer))
}

func fullTrueOrFalseGenerator(women: [Woman], numberOfQuestions: Int) -> [TrueOrFalse] {
    var result: Set<TrueOrFalse> = Set()
    
    while result.count < numberOfQuestions {
        var trueOrFalse: TrueOrFalse
        let trueOrFalseType = (0..<5).randomElement()
        if trueOrFalseType == 0 {
            trueOrFalse = fieldsTrueOrFalseGenerator(women: women)
        } else if trueOrFalseType == 1 {
            trueOrFalse = birthYearTrueOrFalseGenerator(women: women)
        } else if trueOrFalseType == 2 {
            trueOrFalse = deathYearTrueOrFalseGenerator(women: women)
        } else if trueOrFalseType == 3 {
            trueOrFalse = awardsTrueOrFalseGenerator(women: women)
        } else {
            trueOrFalse = achievementsTrueOrFalseGenerator(women: women)
        }
        result.insert(trueOrFalse)
    }
    return Array(result)
}



