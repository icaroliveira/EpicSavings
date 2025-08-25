import UIKit

class MainCoordinator: Coordinator {
    var navigationController: UINavigationController
    // 1. Propriedade para guardar a referência do AppCoordinator
    weak var appCoordinator: AppCoordinator?

    // 2. O init é modificado para RECEBER a referência do AppCoordinator
    init(navigationController: UINavigationController, appCoordinator: AppCoordinator?) {
        self.navigationController = navigationController
        self.appCoordinator = appCoordinator
    }

    func start() {
        let tabBarController = UITabBarController()
        
        // --- Repositórios ---
        let userRepository = UserRepository.shared
        let missionRepository = MissionRepository()
        let rankingRepository = RankingRepository()

        // --- Configuração da Aba Dashboard ---
        let dashboardVM = DashboardViewModel(userRepository: userRepository)
        let dashboardVC = DashboardViewController(viewModel: dashboardVM)
        dashboardVC.tabBarItem = UITabBarItem(title: "Dashboard", image: UIImage(systemName: "house.fill"), tag: 0)
        
        // --- Configuração da Aba Missões ---
        let missionsVM = MissionsViewModel(missionRepository: missionRepository, userRepository: userRepository)
        let missionsVC = MissionsViewController(viewModel: missionsVM)
        missionsVC.tabBarItem = UITabBarItem(title: "Missões", image: UIImage(systemName: "checklist"), tag: 1)
        
        // --- Configuração da Aba Ranking ---
        let rankingVM = RankingViewModel(rankingRepository: rankingRepository, userRepository: userRepository)
        let rankingVC = RankingViewController(viewModel: rankingVM)
        rankingVC.tabBarItem = UITabBarItem(title: "Ranking", image: UIImage(systemName: "rosette"), tag: 2)

        // --- Configuração da Aba Perfil ---
        let profileVM = ProfileViewModel(userRepository: userRepository)
        let profileVC = ProfileViewController(viewModel: profileVM)
        // 3. A referência é PASSADA para a ProfileViewController
        profileVC.coordinator = self.appCoordinator
        profileVC.tabBarItem = UITabBarItem(title: "Perfil", image: UIImage(systemName: "person.fill"), tag: 3)

        // --- ATUALIZA A LISTA DE VIEWCONTROLLERS ---
        tabBarController.viewControllers = [dashboardVC, missionsVC, rankingVC, profileVC]
        
        tabBarController.tabBar.backgroundColor = .secondarySystemBackground
        
        navigationController.setViewControllers([tabBarController], animated: false)
    }
}
