import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // 1. Garante que a cena é do tipo UIWindowScene.
        guard let windowScene = (scene as? UIWindowScene) else { return }

        // 2. Cria uma nova UIWindow usando a windowScene.
        let window = UIWindow(windowScene: windowScene)

        // 3. Define o ViewController inicial (a primeira tela do app).
        //    Estamos usando o `ViewController` que já vem no projeto por enquanto.
        let initialViewController = ViewController()
        
        // 4. Define o ViewController como a tela "raiz" da janela.
        window.rootViewController = initialViewController

        // 5. Atribui a janela à propriedade `window` da SceneDelegate.
        self.window = window

        // 6. Torna a janela visível na tela.
        window.makeKeyAndVisible()
    }

    // ... (mantenha os outros métodos que já estão aqui)
}
