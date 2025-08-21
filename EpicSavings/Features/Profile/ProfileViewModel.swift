//
//  ProfileViewModel.swift
//  EpicSavings
//
//  Created by Ícaro Rangel on 20/08/25.
//

import Foundation
import Combine

class ProfileViewModel {
    private let userRepository: UserRepository
    
    // Publica o usuário atual para a ViewController observar.
    @Published var user: User?
    
    // Publicador para notificar a View de que o nome foi salvo com sucesso.
    let saveSuccessPublisher = PassthroughSubject<Void, Never>()

    init(userRepository: UserRepository) {
        self.userRepository = userRepository
    }

    func loadUser() {
        self.user = userRepository.getUser()
    }
    
    // Função para salvar o novo nome do usuário.
    func saveUserName(newName: String) {
        guard var currentUser = user, !newName.trimmingCharacters(in: .whitespaces).isEmpty else {
            return
        }
        
        currentUser.name = newName
        userRepository.saveUser(currentUser)
        
        // Atualiza a propriedade local e notifica a View do sucesso.
        self.user = currentUser
        saveSuccessPublisher.send()
    }
    
    // Futuramente, podemos implementar essa função.
    func resetProgress() {
        // Aqui, criaríamos um usuário padrão novo e o salvaríamos.
        // let defaultUser = User(name: "Você", level: 1, xp: 0, coins: 50)
        // userRepository.saveUser(defaultUser)
        // self.user = defaultUser
    }
}
