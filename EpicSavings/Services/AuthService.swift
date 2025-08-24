import Foundation
import FirebaseAuth
import FirebaseCore // 1. Adiciona o import que faltava
import GoogleSignIn

class AuthService {
    
    // Singleton para garantir uma única instância.
    static let shared = AuthService()
    
    private init() {}
    
    // Retorna o usuário atualmente logado, se houver.
    public func getCurrentUser() -> FirebaseAuth.User? {
        return Auth.auth().currentUser
    }
    
    // Função para registrar um novo usuário.
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
    
    // 2. Função signInWithGoogle no lugar correto (fora de 'logout')
    // 3. E com a chamada da função do Google corrigida.
    public func signInWithGoogle(viewController: UIViewController, completion: @escaping (Result<Bool, Error>) -> Void) {
        guard let clientID = FirebaseApp.app()?.options.clientID else {
            let error = NSError(domain: "AuthService", code: 1, userInfo: [NSLocalizedDescriptionKey: "Firebase client ID não encontrado."])
            completion(.failure(error))
            return
        }
        
        // A configuração é criada, mas não é passada diretamente na função signIn.
        // A função signIn usa a configuração global.
        let config = GIDConfiguration(clientID: clientID)
        
        // ESTA É A CHAMADA CORRETA DA FUNÇÃO
        GIDSignIn.sharedInstance.signIn(withPresenting: viewController) { signInResult, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let user = signInResult?.user,
                  let idToken = user.idToken?.tokenString else {
                let error = NSError(domain: "AuthService", code: 2, userInfo: [NSLocalizedDescriptionKey: "Token de ID do Google não encontrado."])
                completion(.failure(error))
                return
            }
            
            let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                             accessToken: user.accessToken.tokenString)
            
            Auth.auth().signIn(with: credential) { authResult, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                completion(.success(true))
            }
        }
    }
}
