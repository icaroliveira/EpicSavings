//
//  AuthService.swift
//  EpicSavings
//
//  Created by Ícaro Rangel on 21/08/25.
//

import Foundation
import FirebaseAuth

class AuthService {
    
    // Singleton para garantir uma única instância.
    static let shared = AuthService()
    
    private init() {}
    
    // Retorna o usuário atualmente logado, se houver.
    public func getCurrentUser() -> FirebaseAuth.User? {
        return Auth.auth().currentUser
    }
    
    // Função para registrar um novo usuário.
    // Usamos @escaping (Result<Bool, Error>) -> Void para retornar o resultado
    // de forma assíncrona (já que é uma chamada de rede).
    public func registerUser(withEmail email: String, password pass: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        Auth.auth().createUser(withEmail: email, password: pass) { result, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard result?.user != nil else {
                let contextError = NSError(domain: "AuthService", code: 0, userInfo: [NSLocalizedDescriptionKey: "User creation failed but no error was returned."])
                completion(.failure(contextError))
                return
            }
            
            completion(.success(true))
        }
    }
    
    // Função para logar um usuário existente.
    public func loginUser(withEmail email: String, password pass: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        Auth.auth().signIn(withEmail: email, password: pass) { result, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            completion(.success(true))
        }
    }
    
    // Função para fazer logout.
    public func logout(completion: @escaping (Error?) -> Void) {
        do {
            try Auth.auth().signOut()
            completion(nil)
        } catch let error {
            completion(error)
        }
    }
}
