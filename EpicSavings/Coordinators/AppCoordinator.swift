import UIKit
import FirebaseAuth // Importe o FirebaseAuth

class AppCoordinator: Coordinator {
    var navigationController: UINavigationController
    
    // Serviço para verificar o estado de autenticação
    private let authService = AuthService.shared

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.navigationController.navigationBar.isHidden = true
    }

    func start() {
        // Agora o AppCoordinator tem uma decisão a tomar:
        // O usuário está logado?
        if authService.getCurrentUser() != nil {
            // Se sim, mostre a tela principal.
            showMainApp()
        } else {
            // Se não, mostre a tela de login.
            showLogin()
        }
    }
    
    // Mostra a tela de Login
    func showLogin() {
        let loginVM = LoginViewModel()
        let loginVC = LoginViewController(viewModel: loginVM)
        // Damos à LoginViewController uma referência a este coordinator
        // para que ela possa nos notificar sobre o sucesso do login.
        loginVC.coordinator = self
        
        // Exibe a tela de login.
        // O `setViewControllers` limpa a pilha de navegação.
        navigationController.setViewControllers([loginVC], animated: true)
    }
    
    // Mostra a tela principal do App (a TabBar)
    func showMainApp() {
        // Este é o mesmo código que já tínhamos, mas agora está em sua própria função.
        let mainCoordinator = MainCoordinator(navigationController: navigationController, appCoordinator: self)
        mainCoordinator.start()
    }
    
    // ESTA É A FUNÇÃO QUE FALTAVA!
    // A LoginViewController vai chamar esta função quando o login for bem-sucedido.
    func userDidLogin() {
        showMainApp()
    }
    
    func userDidLogout() {
        // Leva o usuário de volta para a tela de login.
        showLogin()
    }
}
