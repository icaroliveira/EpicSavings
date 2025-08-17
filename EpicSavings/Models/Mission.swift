//
//  Mission.swift
//  EpicSavings
//
//  Created by Ícaro Rangel on 17/08/25.
//

import Foundation


struct Mission: Codable, Identifiable{
    let id: String // Usamos String para IDs mocados, mas UUID é bom para o futuro
        let title: String
        let description: String
        let rewardCoins: Int
        let rewardXP: Int
        let type: MissionType
        var isCompleted: Bool = false
    
        // Um enum para categorizar nossas missões.
        // Ser 'String' e 'Codable' ajuda na persistência.
        enum MissionType: String, Codable {
            case daily = "Diária"
            case weekly = "Semanal"
        }
}
