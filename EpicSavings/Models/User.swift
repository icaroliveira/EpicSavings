//
//  User.swift
//  EpicSavings
//
//  Created by Ícaro Rangel on 17/08/25.
//

import Foundation

// O protocolo 'Codable' é um atalho para Encodable e Decodable.
// Ele nos permite converter facilmente este objeto para um formato
// como JSON, que é ideal para salvar no UserDefaults.


struct User: Codable{
    var name: String
    var level: Int
    var xp: Int // pontos de experiencia
    var coins: Int  // moedas do jogo
    
    //logica para calcular o Xp necessarios para o proximo level
    var xptonextlevel: Int{
        // Exemplo: Nível 1 -> 100 XP, Nível 2 -> 200 XP, etc.
        return 100 * level
    }
    // Propriedade computada: Determina qual imagem/ícone usar com base no nível.
    var characterSpriteName: String{
        if level < 5 {
            return "pessoa.preencher"  // Ícone do sistema para Nível 1-4
        } else if level < 10{
            return "pessoa.cortar.círculo.preencher.emblema.marca de seleção" // Nível 5-9
        } else {
            return "coroa.preenchimento" // Nível 10+

        }
    }
}
