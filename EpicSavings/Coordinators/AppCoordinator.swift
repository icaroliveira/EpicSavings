//
//  AppCoordinator.swift
//  EpicSavings
//
//  Created by Ícaro Rangel on 18/08/25.
//

import UIKit

class AppCoordinator: Coordinator {
    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        // Vamos esconder a barra de navegação padrão, pois usaremos uma TabBar.
        self.navigationController.navigationBar.isHidden = true
    }

    func start() {
        // A única tarefa do AppCoordinator no nosso MVP é criar e iniciar
        // o MainCoordinator, que controla a parte principal do app.
        let mainCoordinator = MainCoordinator(navigationController: navigationController)
        mainCoordinator.start()
    }
}
