//
//  Dashboard.swift
//  EpicSavings
//
//  Created by Ícaro Rangel on 18/08/25.
//
import Foundation
import Combine // Importe o framework Combine da Apple

class DashboardViewModel {
    private let userRepository: UserRepository
    
    // @Published é um "Property Wrapper" do Combine.
    // Ele transforma a propriedade 'user' em um "Publisher",
    // que notifica automaticamente qualquer um que esteja "ouvindo"
    // (no nosso caso, a ViewController) sempre que seu valor mudar.
    @Published var user: User
    
    init(userRepository: UserRepository) {
        self.userRepository = userRepository
        // Carrega o usuário inicial ao ser criada.
        self.user = userRepository.getUser()
    }

    // Esta função será útil para atualizar os dados quando o usuário
    // navegar de volta para o Dashboard depois de completar uma missão.
    func refreshUserData() {
        self.user = userRepository.getUser()
    }
}
