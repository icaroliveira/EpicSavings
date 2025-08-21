//
//  MissionRepository.swift
//  EpicSavings
//
//  Created by Ícaro Rangel on 18/08/25.
//

import Foundation

class MissionRepository {
    private let completedMissionsKey = "completedMissionIDs"
    
    // No MVP, as missões são fixas e definidas aqui no código.
    private var missions: [Mission] = [
        Mission(id: "D001", title: "Orçamento Diário", description: "Anote todos os seus gastos de hoje.", rewardCoins: 10, rewardXP: 20, type: .daily),
        Mission(id: "D002", title: "Leitura Financeira", description: "Leia um artigo sobre investimentos por 15 minutos.", rewardCoins: 15, rewardXP: 25, type: .daily),
        Mission(id: "W001", title: "Economizar no Almoço", description: "Leve comida de casa em vez de comprar fora.", rewardCoins: 50, rewardXP: 80, type: .weekly),
        
        // --> VERIFIQUE ESTA LINHA COM ATENÇÃO <--
        Mission(id: "W002", title: "Planejar a Semana", description: "Defina um orçamento detalhado para a próxima semana.", rewardCoins: 80, rewardXP: 120, type: .weekly)
    ]

    func getMissions() -> [Mission] {
        let completedIDs = UserDefaults.standard.stringArray(forKey: completedMissionsKey) ?? []
        
        return missions.map { mission in
            var mutableMission = mission
            if completedIDs.contains(mission.id) {
                mutableMission.isCompleted = true
            }
            return mutableMission
        }
    }

    func completeMission(id: String) {
        var completedIDs = UserDefaults.standard.stringArray(forKey: completedMissionsKey) ?? []
        
        if !completedIDs.contains(id) {
            completedIDs.append(id)
            UserDefaults.standard.set(completedIDs, forKey: completedMissionsKey)
        }
    }
}
