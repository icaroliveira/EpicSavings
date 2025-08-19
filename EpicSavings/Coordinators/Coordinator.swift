//
//  Coordinator.swift
//  EpicSavings
//
//  Created by Ícaro Rangel on 18/08/25.
//

import UIKit

// Define o que todo Coordinator precisa ter para funcionar.
protocol Coordinator {
    // Todo coordinator vai gerenciar uma pilha de navegação.
    var navigationController: UINavigationController { get set }
    
    // Todo coordinator precisa de um método para iniciar seu fluxo.
    func start()
}
