//
//  LoginViewModel.swift
//  EpicSavings
//
//  Created by Ícaro Rangel on 21/08/25.
//

import Foundation
import Combine

class LoginViewModel {
    
    enum AuthState {
        case signedIn
        case signedOut
    }
    
    private let authService: AuthService
    
    // Publicadores para a View observar
    let authStatePublisher = PassthroughSubject<AuthState, Never>()
    let errorPublisher = PassthroughSubject<String, Never>()
    
    init(authService: AuthService = .shared) {
        self.authService = authService
    }
    
    func login(email: String, pass: String) {
        authService.loginUser(withEmail: email, password: pass) { [weak self] result in
            switch result {
            case .success:
                self?.authStatePublisher.send(.signedIn)
            case .failure(let error):
                self?.errorPublisher.send(error.localizedDescription)
            }
        }
    }
    
    func register(email: String, pass: String) {
        authService.registerUser(withEmail: email, password: pass) { [weak self] result in
            switch result {
            case .success:
                // Após o registro, o Firebase já loga o usuário automaticamente.
                self?.authStatePublisher.send(.signedIn)
            case .failure(let error):
                self?.errorPublisher.send(error.localizedDescription)
            }
        }
    }
}
