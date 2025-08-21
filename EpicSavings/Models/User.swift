import Foundation

struct User: Codable {
    var name: String
    var level: Int
    var xp: Int
    var coins: Int
    
    // --> ESTA PARTE PROVAVELMENTE ESTÁ FALTANDO <--
    // Propriedade computada: Lógica para calcular o XP necessário para o próximo nível.
    // Ela não armazena um valor, mas calcula um toda vez que é acessada.
    // Em User.swift
    var xpToNextLevel: Int {
        return 100 * level
    }
    
    var characterSpriteName: String {
        if level < 5 {
            return "person.fill"
        } else if level < 10 {
            return "person.crop.circle.fill.badge.checkmark"
        } else {
            return "crown.fill"
        }
    }
}
