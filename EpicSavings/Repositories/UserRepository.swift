//
//  UserRepository.swift
//  EpicSavings
//
//  Created by Ícaro Rangel on 17/08/25.
//

import Foundation

class UserRepository {
    // Uma chave única para salvar/buscar o usuário no UserDefaults.
    private let userKey = "currentUser"
    private let defaults = UserDefaults.standard
    
    // Padrão Singleton: Isso garante que teremos apenas UMA instância
    // do UserRepository em todo o app, evitando dados conflitantes.
    static let shared = UserRepository()
    private init() {}

    func getUser() -> User {
        // Tenta buscar os dados do UserDefaults usando a chave.
        if let data = defaults.data(forKey: userKey),
           // Tenta decodificar os dados (JSON) para um objeto User.
           let user = try? JSONDecoder().decode(User.self, from: data) {
            return user // Se tudo der certo, retorna o usuário salvo.
        }
        
        // Se não houver usuário salvo (ex: primeira vez que o app abre),
        // cria e retorna um usuário padrão.
        return User(name: "Você", level: 1, xp: 0, coins: 50)
    }

    func saveUser(_ user: User) {
        // Tenta codificar o objeto User para o formato JSON (data).
        if let data = try? JSONEncoder().encode(user) {
            // Salva os dados no UserDefaults.
            defaults.set(data, forKey: userKey)
        }
    }
}
