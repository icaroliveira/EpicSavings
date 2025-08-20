//
//  RankingViewModel.swift
//  EpicSavings
//
//  Created by Ícaro Rangel on 19/08/25.
//

import Foundation
import Combine

class RankingViewModel {
    private let rankingRepository: RankingRepository
    private let userRepository: UserRepository
    
    @Published var rankingEntries: [RankingEntry] = []
    
    init(rankingRepository: RankingRepository, userRepository: UserRepository) {
        self.rankingRepository = rankingRepository
        self.userRepository = userRepository
    }
    
    func loadRanking() {
        // 1. Pega o usuário atual para saber sua pontuação (XP total é um bom score inicial).
        let currentUser = userRepository.getUser()
        let userScore = currentUser.xp
        
        // 2. Pede ao repositório a lista do ranking, já incluindo o nosso usuário.
        self.rankingEntries = rankingRepository.getWeeklyRanking(currentUserScore: userScore)
    }
}
