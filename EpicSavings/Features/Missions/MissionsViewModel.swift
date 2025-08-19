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
        // 1. Verifica se a missão já não foi completada.
        guard !mission.isCompleted else { return }
        
        // 2. Marca a missão como completa no repositório.
        missionRepository.completeMission(id: mission.id)
        
        // 3. Pega os dados atuais do usuário.
        var currentUser = userRepository.getUser()
        
        // 4. Adiciona as recompensas.
        currentUser.coins += mission.rewardCoins
        currentUser.xp += mission.rewardXP
        
        // 5. Salva o usuário atualizado.
        userRepository.saveUser(currentUser)
        
        // 6. Recarrega a lista de missões para refletir o estado "completa".
        loadMissions()
        
        // 7. Envia uma mensagem de sucesso para a ViewController (para um alerta, por exemplo).
        missionCompletionPublisher.send("Missão Concluída! +\(mission.rewardXP) XP, +\(mission.rewardCoins) Moedas!")
    }
}
