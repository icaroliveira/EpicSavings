//
//  RankingRepository.swift
//  EpicSavings
//
//  Created by Ícaro Rangel on 18/08/25.
//

import Foundation

class RankingRepository {
    // Ranking mock para o MVP.
    func getWeeklyRanking(currentUserScore: Int) -> [RankingEntry] {
        var ranking: [RankingEntry] = [
            RankingEntry(userName: "Investidor PRO", score: 1250, isCurrentUser: false),
            RankingEntry(userName: "Ana Poupadora", score: 1100, isCurrentUser: false),
            RankingEntry(userName: "Carlos Finanças", score: 980, isCurrentUser: false),
            RankingEntry(userName: "Julia C.", score: 750, isCurrentUser: false),
            RankingEntry(userName: "Você", score: currentUserScore, isCurrentUser: true)
        ]
        
        // Ordena o ranking da maior para a menor pontuação antes de retornar.
        ranking.sort { $0.score > $1.score }
        return ranking
    }
}
