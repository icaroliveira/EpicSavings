//
//  MainCoordinator.swift
//  EpicSavings
//
//  Created by Ícaro Rangel on 18/08/25.
//

import UIKit

class MainCoordinator: Coordinator {
    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        // Este ViewController será a base que conterá nossas abas.
        let tabBarController = UITabBarController()
        
        // --- Repositórios ---
        // Criamos as instâncias que serão compartilhadas entre as ViewModels.
        let userRepository = UserRepository.shared
        let missionRepository = MissionRepository()
        let rankingRepository = RankingRepository()

        // --- Configuração da Aba Dashboard ---
        // 1. ViewModel é criada com suas dependências (o repositório).
        // let dashboardVM = DashboardViewModel(userRepository: userRepository)
        // 2. ViewController é criado com sua dependência (a ViewModel).
        // let dashboardVC = DashboardViewController(viewModel: dashboardVM)
        // 3. O item da barra de abas é configurado.
        let dashboardVC = UIViewController() // Temporário
        dashboardVC.view.backgroundColor = .systemBackground
        dashboardVC.tabBarItem = UITabBarItem(title: "Dashboard", image: UIImage(systemName: "house.fill"), tag: 0)
        
        // --- Configuração da Aba Missões ---
        // let missionsVM = MissionsViewModel(missionRepository: missionRepository, userRepository: userRepository)
        // let missionsVC = MissionsViewController(viewModel: missionsVM)
        let missionsVC = UIViewController() // Temporário
        missionsVC.view.backgroundColor = .systemBackground
        missionsVC.tabBarItem = UITabBarItem(title: "Missões", image: UIImage(systemName: "checklist"), tag: 1)
        
        // --- Configuração da Aba Ranking ---
        // let rankingVM = RankingViewModel(rankingRepository: rankingRepository, userRepository: userRepository)
        // let rankingVC = RankingViewController(viewModel: rankingVM)
        let rankingVC = UIViewController() // Temporário
        rankingVC.view.backgroundColor = .systemBackground
        rankingVC.tabBarItem = UITabBarItem(title: "Ranking", image: UIImage(systemName: "rosette"), tag: 2)

        // Define a lista de ViewControllers que a TabBar irá gerenciar.
        tabBarController.viewControllers = [dashboardVC, missionsVC, rankingVC]
        tabBarController.tabBar.backgroundColor = .secondarySystemBackground
        
        // Coloca a TabBarController na pilha de navegação para ser exibida.
        navigationController.pushViewController(tabBarController, animated: false)
    }
}
