//
//  MissionsViewModel.swift
//  EpicSavings
//
//  Created by Ícaro Rangel on 18/08/25.
//

import Foundation
import Combine

class MissionsViewModel {
    private let missionRepository: MissionRepository
    private let userRepository: UserRepository
    
    // Publica um array de missões. A View vai se inscrever nisso.
    @Published var missions: [Mission] = []
    
    // Este PassthroughSubject funciona como um canal para enviar
    // "eventos" da ViewModel para a View, como uma mensagem de sucesso.
    let missionCompletionPublisher = PassthroughSubject<String, Never>()

    init(missionRepository: MissionRepository, userRepository: UserRepository) {
        self.missionRepository = missionRepository
        self.userRepository = userRepository
    }

    func loadMissions() {
        self.missions = missionRepository.getMissions()
    }

    func completeMission(mission: Mission) {
        guard !mission.isCompleted else { return }
        missionRepository.completeMission(id: mission.id)
        
        var currentUser = userRepository.getUser()
        currentUser.coins += mission.rewardCoins
        currentUser.xp += mission.rewardXP
        
        // 5. --- LÓGICA DE LEVEL UP APRIMORADA ---
        while currentUser.xp >= currentUser.xpToNextLevel {
            // Guarda o XP necessário para o nível ATUAL antes de mudá-lo.
            let xpRequired = currentUser.xpToNextLevel
            
            // Aumenta o nível primeiro.
            currentUser.level += 1
            
            // Subtrai o valor que guardamos (COM O "Q" MAIÚSCULO).
            currentUser.xp -= xpRequired
        }
        
        userRepository.saveUser(currentUser)
        loadMissions()
        missionCompletionPublisher.send("Missão Concluída! +\(mission.rewardXP) XP, +\(mission.rewardCoins) Moedas!")
    }
}
