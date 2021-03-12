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
    
    if (0...1).randomElement() == 0{
        return TrueOrFalse(
            picture: questionWoman.pictures.randomElement() ?? "",
            question: String.localizedStringWithFormat(
                NSLocalizedString("%@ was born in %@.", comment: ""),
                questionWoman.name,
                questionWoman.birthYear),
            correct: true)
    } else {
        return TrueOrFalse(
            picture: questionWoman.pictures.randomElement() ?? "",
            question: String.localizedStringWithFormat(
                NSLocalizedString("%@ was born in %@.", comment: ""),
                questionWoman.name,
                otherWoman.birthYear),
            correct: questionWoman.birthYear == otherWoman.birthYear)
    }
}

func deathYearTrueOrFalseGenerator (women: [Woman]) -> TrueOrFalse {
    let selectedWomen = women.filter{$0.deathYear != ""}.shuffled()
    let questionWoman = selectedWomen[0]
    let otherWoman = selectedWomen[1]
    
    if (0...1).randomElement() == 0{
        return TrueOrFalse(
            picture: questionWoman.pictures.randomElement() ?? "",
            question: String.localizedStringWithFormat(
                NSLocalizedString("%@ passed away in %@.", comment: ""),
                questionWoman.name,
                questionWoman.deathYear),
            correct: true)
    } else {
        return TrueOrFalse(
            picture: questionWoman.pictures.randomElement() ?? "",
            question: String.localizedStringWithFormat(
                NSLocalizedString("%@ passed away in %@.", comment: ""),
                questionWoman.name,
                otherWoman.deathYear),
            correct: questionWoman.deathYear == otherWoman.deathYear)
    }
}

func fieldsTrueOrFalseGenerator (women: [Woman]) -> TrueOrFalse {
    let selectedWomen = women.filter{$0.fields.localized.count > 0}.shuffled()
    let questionWoman = selectedWomen[0]
    let otherWoman = selectedWomen[1]
    
    if (0...1).randomElement() == 0{
        return TrueOrFalse(
            picture: questionWoman.pictures.randomElement() ?? "",
            question: String.localizedStringWithFormat(
                NSLocalizedString("%@ was a %@.", comment: ""),
                questionWoman.name,
                questionWoman.fields.localized.randomElement()!),
            correct: true)
    } else {
        let answer = otherWoman.fields.localized.randomElement()!
        return TrueOrFalse(
            picture: questionWoman.pictures.randomElement() ?? "",
            question: String.localizedStringWithFormat(
                NSLocalizedString("%@ was a %@.", comment: ""),
                questionWoman.name,
                answer),
            correct: questionWoman.fields.localized.contains(answer))
    }
}

func achievementsTrueOrFalseGenerator (women: [Woman]) -> TrueOrFalse {
    let selectedWomen = women.filter{$0.achievements.localized.count > 0}.shuffled()
    let questionWoman = selectedWomen[0]
    let otherWoman = selectedWomen[1]
    
    if (0...1).randomElement() == 0{
        return TrueOrFalse(
            picture: questionWoman.pictures.randomElement() ?? "",
            question: String.localizedStringWithFormat(
                NSLocalizedString("One of %@'s achievements is: %@.", comment: ""),
                questionWoman.name,
                questionWoman.achievements.localized.randomElement()!),
            correct: true)
    } else {
        let answer = otherWoman.achievements.localized.randomElement()!
        return TrueOrFalse(
            picture: questionWoman.pictures.randomElement() ?? "",
            question: String.localizedStringWithFormat(
                NSLocalizedString("One of %@'s achievements is: %@.", comment: ""),
                questionWoman.name,
                answer),
            correct: questionWoman.achievements.localized.contains(answer))
    }
}

func awardsTrueOrFalseGenerator (women: [Woman]) -> TrueOrFalse {
    let selectedWomen = women.filter{$0.awards.localized.count > 0}.shuffled()
    let questionWoman = selectedWomen[0]
    let otherWoman = selectedWomen[1]
    
    if (0...1).randomElement() == 0{
        return TrueOrFalse(
            picture: questionWoman.pictures.randomElement() ?? "",
            question: String.localizedStringWithFormat(
                NSLocalizedString("%@ was awarded with the %@.", comment: ""),
                questionWoman.name,
                questionWoman.awards.localized.randomElement()!),
            correct: true)
    } else {
        let answer = otherWoman.awards.localized.randomElement()!
        return TrueOrFalse(
            picture: questionWoman.pictures.randomElement() ?? "",
            question: String.localizedStringWithFormat(
                NSLocalizedString("%@ was awarded with the %@.", comment: ""),
                questionWoman.name,
                answer),
            correct: questionWoman.awards.localized.contains(answer))
    }
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



