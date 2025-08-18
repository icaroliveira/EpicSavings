//
//  RankingEntry.swift
//  EpicSavings
//
//  Created by Ícaro Rangel on 17/08/25.
//

import Foundation

struct RankingEntry {
    let userName: String
    let score: Int
    let isCurrentUser: Bool // Para podermos destacar o usuário na lista
}

// Nota: Este modelo não precisa ser 'Codable' no MVP, pois vamos
// gerar dados de ranking mocados (falsos) toda vez, sem salvá-los.
