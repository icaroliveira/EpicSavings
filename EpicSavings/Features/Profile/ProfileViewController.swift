//
//  ProfileViewController.swift
//  EpicSavings
//
//  Created by Ícaro Rangel on 20/08/25.
//

import UIKit
import Combine

class ProfileViewController: UIViewController {

    private let viewModel: ProfileViewModel
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - UI Components
    private let nameLabel = UILabel()
    private let levelLabel = UILabel()
    private let nameTextField = UITextField()
    private let saveButton = UIButton(type: .system)

    init(viewModel: ProfileViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
        viewModel.loadUser()
    }
    
    private func bindViewModel() {
        // Observa mudanças no usuário e atualiza a UI.
        viewModel.$user
            .compactMap { $0 } // Ignora o valor 'nil' inicial
            .receive(on: RunLoop.main)
            .sink { [weak self] user in
                self?.nameLabel.text = "Nome: \(user.name)"
                self?.levelLabel.text = "Nível: \(user.level)"
                self?.nameTextField.placeholder = user.name
            }
            .store(in: &cancellables)
            
        // Observa o evento de salvamento bem-sucedido.
        viewModel.saveSuccessPublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] in
                self?.showAlert(title: "Sucesso!", message: "Seu nome foi salvo.")
                self?.nameTextField.text = "" // Limpa o campo
            }
            .store(in: &cancellables)
    }
    
    @objc private func saveButtonTapped() {
        viewModel.saveUserName(newName: nameTextField.text ?? "")
    }

    // MARK: - UI Setup
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        nameLabel.font = .systemFont(ofSize: 20)
        levelLabel.font = .systemFont(ofSize: 20)
        
        nameTextField.placeholder = "Digite seu novo nome"
        nameTextField.borderStyle = .roundedRect
        nameTextField.font = .systemFont(ofSize: 18)
        
        saveButton.setTitle("Salvar Nome", for: .normal)
        saveButton.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
        saveButton.backgroundColor = .systemBlue
        saveButton.tintColor = .white
        saveButton.layer.cornerRadius = 8
        saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        
        let infoStack = UIStackView(arrangedSubviews: [nameLabel, levelLabel])
        infoStack.axis = .vertical
        infoStack.spacing = 12
        
        let mainStack = UIStackView(arrangedSubviews: [infoStack, nameTextField, saveButton])
        mainStack.axis = .vertical
        mainStack.spacing = 24
        mainStack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(mainStack)
        
        NSLayoutConstraint.activate([
            mainStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            mainStack.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            mainStack.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            
            saveButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
