import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    // Precisamos manter uma referência forte ao coordinator, ou ele será descartado da memória.
    var appCoordinator: AppCoordinator?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }

        let window = UIWindow(windowScene: windowScene)
        self.window = window
        
        // 1. Cria um Navigation Controller que será a base de toda a navegação.
        let navigationController = UINavigationController()
        
        // 2. Cria o nosso AppCoordinator, entregando a ele o controle do Navigation Controller.
        appCoordinator = AppCoordinator(navigationController: navigationController)
        
        // 3. Inicia o fluxo de navegação do AppCoordinator.
        appCoordinator?.start()

        // 4. Define o Navigation Controller gerenciado pelo coordinator como a tela raiz.
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
}
